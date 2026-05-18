# Magento 2 on DDEV

A Magento 2 development environment powered by DDEV.

## Prerequisites

- [Docker](https://docs.docker.com/get-started/get-docker/)
- [DDEV](https://ddev.com/get-started/) — install docs [here](https://docs.ddev.com/en/stable/users/install/ddev-installation/)
- [Magento Marketplace keys](https://experienceleague.adobe.com/en/docs/commerce-operations/installation-guide/prerequisites/authentication-keys) (public + private)

## Quick Start

```bash
git clone git@github.com:vlecluse/magento2-ddev.git
cd magento2-ddev
ddev start
MAGENTO_ADMIN_PASSWORD='Chang3MeN0w' ddev setup-magento
ddev launch
```

## Common Commands

```bash
ddev start                                   # Start the environment
ddev stop                                    # Stop the environment
ddev restart                                 # Rebuild web image (needed after Dockerfile changes)
ddev setup-magento                           # Interactive setup
ddev setup-magento --reset-auth              # Reset Marketplace credentials
ddev setup-magento --reset-db-from-base      # Reset DB from dump
```

## `ddev setup-magento`

This command is safe to re-run — it only performs steps that are needed (e.g. skips DB import if tables already exist, skips `auth.json` creation if it's already there).

**Options:**

| Flag | What it does |
|------|--------------|
| `--reset-auth` | Recreate `auth.json` |
| `--reset-db-from-base` | Replace DB from `db/base.sql.gz` (also runs `setup:upgrade`) |
| `--run-upgrade` | Run `setup:upgrade` after code changes |
| `--set-admin-password VAL` | Set the admin password |
| `--non-interactive` | Skip prompts; requires env vars |

**CI / non-interactive usage:**

```bash
MAGENTO_PUBLIC_KEY="$MAGENTO_PUBLIC_KEY" \
MAGENTO_PRIVATE_KEY="$MAGENTO_PRIVATE_KEY" \
MAGENTO_ADMIN_PASSWORD="$MAGENTO_ADMIN_PASSWORD" \
ddev setup-magento --non-interactive --run-upgrade
```

## Sample Data

```bash
ddev magento sampledata:deploy
ddev magento setup:upgrade
```

## Troubleshooting

**Missing keys in non-interactive mode:**
```bash
MAGENTO_PUBLIC_KEY=... MAGENTO_PRIVATE_KEY=... ddev setup-magento --non-interactive
```

**DB reset fails:** Make sure `db/base.sql.gz` exists and is a valid dump before running `--reset-db-from-base`.
