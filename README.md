# DDEV Example for Magento 2

This repository demonstrates a Magento 2 setup running on DDEV.

## Prerequisites

- Docker
- DDEV
- Magento Marketplace keys (public/private)

## Installation

```bash
git clone git@github.com:vlecluse/magento2-ddev.git
cd magento2-ddev
ddev start
ddev setup-magento
```

## Start and Stop

```bash
ddev start
ddev stop
```

If this is your first run after pulling changes to `.ddev/web-build/Dockerfile.magerun`, rebuild the web image:

```bash
ddev restart
```

## `ddev setup-magento`

`ddev setup-magento` is idempotent by default:

- Creates `auth.json` only if missing
- Keeps existing `auth.json` unless explicitly reset
- Runs `ddev composer install -v`
- Creates `app/etc/env.php` only if missing
- Runs `setup:config:set` when config is missing or DB connection values are not set to DDEV defaults (`db`/`db`/`db`)
- Sets deploy mode to `developer` only if needed
- Prints a setup summary at the end

Idempotency behavior:

| Operation | Runs when |
|---|---|
| Create `auth.json` | `auth.json` is missing or `--reset-auth` is provided |
| `composer install` | Every run |
| `config:env:create` | `app/etc/env.php` is missing |
| `setup:config:set` | `app/etc/config.php` is missing, or DB host/name/user are not `db` |
| DB reset from dump | `--reset-db-from-base` is provided |
| `setup:upgrade` | `--run-upgrade` is provided, or automatically with `--reset-db-from-base` |
| Set deploy mode to developer | Current mode is not `developer` |
| Change admin password | `--set-admin-password` is provided or `MAGENTO_ADMIN_PASSWORD` is set |

### Interactive usage

```bash
ddev setup-magento
```

If `auth.json` does not exist, it prompts for Magento Marketplace keys and writes `auth.json` with restrictive file permissions.

Recommended first run:

```bash
MAGENTO_ADMIN_PASSWORD='ChangeMeNow' ddev setup-magento
```

### Non-interactive usage

```bash
MAGENTO_PUBLIC_KEY=your_public_key \
MAGENTO_PRIVATE_KEY=your_private_key \
ddev setup-magento --non-interactive
```

In `--non-interactive` mode, missing required values fail fast.
When required key env vars are provided, the script does not prompt for keys.

### CI usage example

```bash
MAGENTO_PUBLIC_KEY="$MAGENTO_PUBLIC_KEY" \
MAGENTO_PRIVATE_KEY="$MAGENTO_PRIVATE_KEY" \
MAGENTO_ADMIN_PASSWORD="$MAGENTO_ADMIN_PASSWORD" \
ddev setup-magento --non-interactive --run-upgrade
```

## `setup-magento` options

```text
--reset-db-from-base      Reset database from db/base.sql.gz
--run-upgrade             Run setup:upgrade
--reset-auth              Recreate auth.json even if it exists
--non-interactive         Do not prompt; require values from env
--set-admin-password VAL  Set admin user password
-h, --help                Show help
```

Notes:

- `--reset-db-from-base` also runs `setup:upgrade` automatically.
- `--run-upgrade` can be used independently after code changes that require DB schema/data updates.
- Admin password is no longer hardcoded. Use `--set-admin-password` or `MAGENTO_ADMIN_PASSWORD`.
- `--reset-db-from-base` is destructive and replaces current local DB data.
- With `--reset-auth --non-interactive`, both `MAGENTO_PUBLIC_KEY` and `MAGENTO_PRIVATE_KEY` must be set.

Examples:

```bash
# Reset Magento auth credentials
ddev setup-magento --reset-auth

# Reset DB from base dump (also runs setup:upgrade)
ddev setup-magento --reset-db-from-base

# Set admin password via env var (safer for shell history)
MAGENTO_ADMIN_PASSWORD='StrongPasswordHere' ddev setup-magento
```

### Setup summary status values

At the end of `ddev setup-magento`, the script prints these status values:

- `auth.json`: `created`, `kept-existing`, `skipped`
- `env.php`: `created`, `kept-existing`, `skipped`
- `setup config`: `created`, `kept-existing`, `skipped`
- `db`: `reset-from-base`, `skipped`
- `deploy mode`: `set-developer`, `already-developer`, `skipped`
- `admin password`: `updated`, `skipped`
- `setup:upgrade`: `ran`, `skipped`

Example summary:

```text
Setup summary:
  auth.json: kept-existing
  env.php: kept-existing
  setup config: kept-existing
  db: skipped
  deploy mode: already-developer
  admin password: updated
  setup:upgrade: skipped
```

## Troubleshooting

- `Error: Missing MAGENTO_PUBLIC_KEY or MAGENTO_PRIVATE_KEY in non-interactive mode.`
  - Cause: `--non-interactive` was used without required env vars.
  - Fix: export both variables, then re-run:
    ```bash
    MAGENTO_PUBLIC_KEY=... MAGENTO_PRIVATE_KEY=... ddev setup-magento --non-interactive
    ```

- DB reset fails with `--reset-db-from-base`
  - Cause: `db/base.sql.gz` missing or invalid.
  - Fix: ensure `db/base.sql.gz` exists and is a valid dump before running:
    ```bash
    ddev setup-magento --reset-db-from-base
    ```

## Sample Data
  
If you want Magento sample data:

```bash
ddev magento sampledata:deploy
ddev magento setup:upgrade
```
