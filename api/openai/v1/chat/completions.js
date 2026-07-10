// Serverless proxy: keeps the OpenAI API key out of the public JS bundle.
// The Flutter web app is built with OPENAI_BASE_URL=/api/openai/v1 and calls
// this exact route; the key lives only in the Vercel env var OPENAI_API_KEY.
// The file path itself pins the only OpenAI endpoint this proxy can reach.

export const config = { maxDuration: 60 };

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  const key = process.env.OPENAI_API_KEY;
  if (!key) {
    res.status(500).json({ error: 'OPENAI_API_KEY is not configured' });
    return;
  }

  try {
    const upstream = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${key}`,
      },
      body: JSON.stringify(req.body),
    });
    const text = await upstream.text();
    res
      .status(upstream.status)
      .setHeader('Content-Type', 'application/json')
      .send(text);
  } catch (error) {
    res.status(502).json({ error: `Upstream request failed: ${error.message}` });
  }
}
