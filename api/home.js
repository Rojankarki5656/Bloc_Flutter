const HOME_KEY = 'home:data';

function sendJson(response, status, body) {
  response.status(status).setHeader('Content-Type', 'application/json');
  response.setHeader('Access-Control-Allow-Origin', '*');
  response.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  response.setHeader('Cache-Control', 's-maxage=60, stale-while-revalidate=300');
  response.send(JSON.stringify(body));
}

module.exports = async function homeHandler(request, response) {
  if (request.method === 'OPTIONS') {
    return sendJson(response, 204, {});
  }
  if (request.method !== 'GET') {
    return sendJson(response, 405, { error: 'Method not allowed' });
  }

  const redisUrl = process.env.UPSTASH_REDIS_REST_URL;
  const redisToken = process.env.UPSTASH_REDIS_REST_TOKEN;
  if (!redisUrl || !redisToken) {
    return sendJson(response, 500, { error: 'Upstash environment variables are not configured' });
  }

  try {
    const redisResponse = await fetch(redisUrl, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${redisToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(['GET', HOME_KEY]),
    });

    if (!redisResponse.ok) {
      throw new Error(`Upstash returned HTTP ${redisResponse.status}`);
    }

    const redisBody = await redisResponse.json();
    if (typeof redisBody.result !== 'string') {
      return sendJson(response, 404, { error: `Redis key "${HOME_KEY}" was not found` });
    }

    const homeData = JSON.parse(redisBody.result);
    const sections = ['trending', 'popular', 'upcoming', 'top100'];
    if (!homeData || sections.some((section) => !Array.isArray(homeData[section]))) {
      return sendJson(response, 502, { error: 'Redis home data has an invalid shape' });
    }

    return sendJson(response, 200, homeData);
  } catch (error) {
    console.error('Home API error:', error);
    return sendJson(response, 502, { error: 'Could not read home data from Upstash' });
  }
};