// Serverless proxy: keeps provider API keys out of the public JS bundle.
// The Flutter web app is built with OPENAI_BASE_URL=/api/openai/v1 and calls
// this exact route; the keys live only in Vercel env vars.
//
// Provider order: NVIDIA NIM (default) -> OpenAI (fallback).
// The Flutter client always sends an OpenAI-shaped chat/completions request
// (vision, base64 images, response_format json_object). We first try NVIDIA's
// OpenAI-compatible endpoint with a vision model, then fall back to OpenAI if
// NVIDIA errors OR returns content the client's strict JSON parser can't read
// (NVIDIA VLMs may ignore response_format or reject oversized inline images).
// The file path itself pins the only endpoint this proxy can reach per provider.

export const config = { maxDuration: 60 };

const NVIDIA_URL = 'https://integrate.api.nvidia.com/v1/chat/completions';
const OPENAI_URL = 'https://api.openai.com/v1/chat/completions';

// NVIDIA vision model (OpenAI-compatible image_url). Overridable via env.
const NVIDIA_MODEL =
  process.env.NVIDIA_MODEL || 'meta/llama-3.2-90b-vision-instruct';

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

// True only when the response is an OpenAI-shaped completion whose assistant
// message content is a clean JSON object with an "items" array — exactly what
// the Flutter parser (OpenAiResponseParser) requires. Anything else means the
// provider's output is unusable, so we should fall back.
function isUsableInventoryJson(rawText) {
  try {
    const data = JSON.parse(rawText);
    const content = data?.choices?.[0]?.message?.content;
    if (typeof content !== 'string' || content.length === 0) return false;
    const parsed = JSON.parse(content);
    return parsed !== null && typeof parsed === 'object' && Array.isArray(parsed.items);
  } catch {
    return false;
  }
}

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  const nvidiaKey = process.env.NVIDIA_API_KEY;
  const openaiKey = process.env.OPENAI_API_KEY;
  if (!nvidiaKey && !openaiKey) {
    res
      .status(500)
      .json({ error: 'No provider configured: set NVIDIA_API_KEY and/or OPENAI_API_KEY' });
    return;
  }

  const requested = req.body;

  // 1) NVIDIA NIM (primary). Rewrite the model to a NVIDIA vision model and
  //    drop response_format, which NVIDIA VLMs commonly reject; the system
  //    prompt already demands a bare JSON object.
  if (nvidiaKey) {
    try {
      const { response_format, ...rest } = requested ?? {};
      const nvidiaBody = { ...rest, model: NVIDIA_MODEL };
      const upstream = await callUpstream(NVIDIA_URL, nvidiaKey, nvidiaBody);
      const text = await upstream.text();
      if (upstream.ok && isUsableInventoryJson(text)) {
        res
          .status(upstream.status)
          .setHeader('Content-Type', 'application/json')
          .send(text);
        return;
      }
      // Non-2xx or unusable output -> fall through to OpenAI.
    } catch {
      // Network/transport failure -> fall through to OpenAI.
    }
  }

  // 2) OpenAI (fallback). Forward the original request verbatim, including
  //    response_format json_object and the client's model.
  if (openaiKey) {
    try {
      const upstream = await callUpstream(OPENAI_URL, openaiKey, requested);
      const text = await upstream.text();
      res
        .status(upstream.status)
        .setHeader('Content-Type', 'application/json')
        .send(text);
      return;
    } catch (error) {
      res.status(502).json({ error: `Upstream request failed: ${error.message}` });
      return;
    }
  }

  res
    .status(502)
    .json({ error: 'NVIDIA request failed and no OpenAI fallback is configured' });
}
