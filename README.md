# labz-docker

The Docker stack for Lab'z, the public lab by Laden AS. Two containers and two named volumes:

- `api`: the Lab'z API (`api/server.py`, Python 3.13, SQLite). It keeps its database and mail outbox in the named volume `labz_data`.
- `web`: nginx 1.27 alpine. It serves the Lab'z pages under `/docker/llz/` from the named volume `labz_www` (seeded from `web/html/` on first start) and proxies `/docker/llz/labs/api/` to the `api` container.

Live Docker copy: [https://laden.no/docker/llz/](https://laden.no/docker/llz/) (the live lab itself is [https://laden.no/llz/](https://laden.no/llz/)). The site source on its own is in [kim-laden/labz](https://github.com/kim-laden/labz).

Copyright Laden AS (Org.nr. 937 285 833). The code is open source under the MIT License. See [LICENSE](LICENSE). The Laden name, mark and brand are trademarks of Laden AS and are not given away by that licence.

## Run it

```bash
cp .env.example .env
# set LADEN_JWT_SECRET in .env to a long random string
docker compose up -d --build
```

Open [http://127.0.0.1:18080/docker/llz/](http://127.0.0.1:18080/docker/llz/).

- Port: `18080` on `127.0.0.1` (the `web` container listens on `8080` inside). The API listens on `18790` inside the Compose network only and is not published.
- `.env` is required. Compose reads it for the API.
- On first start the API creates an empty database from `schema.sql` and seeds four demo accounts (`laden`, `grok`, `caleb`, `admin`). Set their passwords with `LADEN_SEED_PW_<USERNAME>` in `.env`, or leave them empty and read the generated passwords from `docker compose logs api`.
- The page CSS and JS under `/docker/llz/css/` and `/docker/llz/js/` are proxied from `https://laden.no/`, so the host needs outbound HTTPS.

Stop it with `docker compose down`. Add `-v` to also delete the database volume.

## Host proxy

The `web` container speaks plain HTTP and binds to localhost. In production the host web server (Apache on the Laden VPS) owns the domain and the HTTPS certificate and proxies `https://laden.no/docker/llz/` to this stack on port `18080`. Put your own Nginx, Apache or Caddy in front the same way. Do not publish the port to `0.0.0.0` without a proxy in front.

## Not in this repo

Secrets and user data are not here: no `.env`, no JWT secret, no Resend or GitHub token, no user database (`laden.db`), no mail outbox. `.env.example` only names the settings. The demo seed passwords that used to be in `server.py` now come from `.env`.
