# app_animeweebs

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:


For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Animeweebs

## Home data API

The Flutter app requests `GET /api/home` from `ApiEndpoints.baseUrl`. The
serverless handler is in `api/home.js` and reads the Upstash Redis key
`home:data` using the Upstash REST API.

Store this JSON document in Redis:

```json
{
	"trending": [],
	"popular": [],
	"upcoming": [],
	"top100": []
}
```

Each array item must use the fields expected by `AnimeModel`, including `id`
and `title`. Optional fields include `poster`, `bannerImage`, `format`,
`status`, `episodes`, `averageScore`, and `genres`.

### Deploying the API

Deploy this repository, or copy its `api` folder, to Vercel. Add these Vercel
environment variables:

- `UPSTASH_REDIS_REST_URL`
- `UPSTASH_REDIS_REST_TOKEN`

Never put either value in Flutter source code or another client app. After
deploying, set `ApiEndpoints.baseUrl` to the deployed API domain if it is not
already `https://api.animeweebs.app`.

The Redis value must be a JSON string stored under the exact key `home:data`.
