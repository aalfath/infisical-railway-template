[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/infisical-1?utm_medium=integration&utm_source=button&utm_campaign=infisical)

# Infisical on Railway

A Railway template for [Infisical](https://infisical.com), the open-source platform for secrets,
certificates and privileged access. It deploys:

| Service | Source | Notes |
|---|---|---|
| **Infisical** | this repo (`Dockerfile`) | `infisical/infisical:v0.167.10`, pinned by digest. Public web UI and API on port 8080, health check `/api/status` |
| **Postgres** | Railway Postgres | All Infisical data (encrypted secrets, projects, users), on a volume |
| **Redis** | Railway Redis | Queues and cache, on a volume |

Infisical runs its database migrations itself on every start, so a fresh deploy needs no setup step.

## Variables (Infisical service)

| Variable | Default | What it is |
|---|---|---|
| `ENCRYPTION_KEY` | `${{secret(32,"abcdef0123456789")}}` | 32 hex characters (16 bytes) that encrypt every secret in the database. **Back it up**: without it the data can't be decrypted |
| `AUTH_SECRET` | `${{secret(64,…)}}` | Signs login tokens |
| `DB_CONNECTION_URI` | `${{Postgres.DATABASE_URL}}` | Postgres over the private network |
| `REDIS_URL` | `${{Redis.REDIS_URL}}?family=0` | Redis over the private network (`family=0` lets ioredis use IPv6 or IPv4) |
| `SITE_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL used in links and emails. Change it if you add a custom domain |
| `PORT` | `8080` | Port the app listens on |

Nothing to fill in at deploy time.

## First start

Open the public URL and create the first account right away: on a new instance, the first person to
sign up at `/admin/signup` becomes the server admin. Infisical then closes sign-ups by itself; you can
reopen or restrict them under **Server Admin Console → General**.

Optional features, added as variables on the Infisical service: email (`SMTP_HOST`, `SMTP_PORT`,
`SMTP_USERNAME`, `SMTP_PASSWORD`, `SMTP_FROM_ADDRESS`, `SMTP_FROM_NAME`), SSO and telemetry
(`TELEMETRY_ENABLED=false`). See [Infisical's environment variables](https://infisical.com/docs/self-hosting/configuration/envars).

## Updates

The Infisical service builds from this repo. When a new Infisical version is pinned here and merged to
`main`, Railway shows an "update available" notice on your project, and you choose when to apply it.
Each version is described in [CHANGELOG.md](CHANGELOG.md). Back up Postgres before you apply an update:
the new version migrates the database on start.

## License

The wrapper files in this repo are MIT. Infisical itself is under its own
[license](https://github.com/Infisical/infisical/blob/main/LICENSE) (MIT core, with enterprise features under a separate license).
