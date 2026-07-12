// Serverless proxy: keeps provider API keys out of the public JS bundle.
// The Flutter web app is built with OPENAI_BASE_URL=/api/openai/v1 and calls
// this exact route; the keys live only in Vercel env vars.
//
// Provider is chosen MANUALLY via the LLM_PROVIDER env var (nvidia|openai),
// default "nvidia" — set it in the Vercel dashboard. There is NO automatic
// cross-provider fallback: the selected provider is the only one called, and
// its response (success or error) is returned verbatim. Switch providers by
// changing LLM_PROVIDER and redeploying.
//
// The Flutter client always sends an OpenAI-shaped chat/completions request
// (vision, base64 images, response_format json_object). NVIDIA's VLMs commonly
// reject response_format and don't know the client's model name, so when
// LLM_PROVIDER=nvidia we rewrite the model to a NVIDIA vision model and drop
// response_format (the system prompt already demands a bare JSON object).
// The file path itself pins the only endpoint this proxy can reach per provider.

export const config = { maxDuration: 60 };

const NVIDIA_URL = 'https://integrate.api.nvidia.com/v1/chat/completions';
const OPENAI_URL = 'https://api.openai.com/v1/chat/completions';

// NVIDIA vision model (OpenAI-compatible image_url). Overridable via env.
const NVIDIA_MODEL =
  process.env.NVIDIA_MODEL || 'meta/llama-3.2-90b-vision-instruct';

function selectedProvider() {
  return (process.env.LLM_PROVIDER || 'nvidia').toLowerCase();
}

async function callUpstream(url, key, body) {
  return fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${key}`,
    },
    body: JSON.stringify(body),
  });
}

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  const provider = selectedProvider();
  const requested = req.body;

  // NVIDIA NIM (LLM_PROVIDER=nvidia). Rewrite the model to a NVIDIA vision
  // model and drop response_format, which NVIDIA VLMs commonly reject.
  if (provider === 'nvidia') {
    const key = process.env.NVIDIA_API_KEY;
    if (!key) {
      res.status(500).json({
        error: 'LLM_PROVIDER=nvidia but NVIDIA_API_KEY is not set',
      });
      return;
    }
    try {
      const { response_format, ...rest } = requested ?? {};
      const nvidiaBody = { ...rest, model: NVIDIA_MODEL };
      const upstream = await callUpstream(NVIDIA_URL, key, nvidiaBody);
      const text = await upstream.text();
      res
        .status(upstream.status)
        .setHeader('Content-Type', 'application/json')
        .send(text);
    } catch (error) {
      res.status(502).json({ error: `NVIDIA request failed: ${error.message}` });
    }
    return;
  }

  // OpenAI (LLM_PROVIDER=openai). Forward the original request verbatim,
  // including response_format json_object and the client's model.
  if (provider === 'openai') {
    const key = process.env.OPENAI_API_KEY;
    if (!key) {
      res.status(500).json({
        error: 'LLM_PROVIDER=openai but OPENAI_API_KEY is not set',
      });
      return;
    }
    try {
      const upstream = await callUpstream(OPENAI_URL, key, requested);
      const text = await upstream.text();
      res
        .status(upstream.status)
        .setHeader('Content-Type', 'application/json')
        .send(text);
    } catch (error) {
      res.status(502).json({ error: `OpenAI request failed: ${error.message}` });
    }
    return;
  }

  res.status(500).json({
    error: `Unknown LLM_PROVIDER "${provider}": expected "nvidia" or "openai"`,
  });
}
