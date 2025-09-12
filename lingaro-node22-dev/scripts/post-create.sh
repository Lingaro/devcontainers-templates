#!/bin/bash
echo '🧱 Node 22 Dev Container Created!'

# TODO npm ci -> npm install
if [ -f "yarn.lock" ]; then \
      npm install -g --force yarn \
      && yarn install --frozen-lockfile; \
    elif [ -f "pnpm-lock.yaml" ]; then \
      npm install -g --force pnpm \
      && pnpm install --frozen-lockfile; \
    else \
      npm install; \
    fi

if [ -f "yarn.lock" ]; then \
      yarn build; \
    elif [ -f "pnpm-lock.yaml" ]; then \
      pnpm run build; \
    else \
      npm run build; \
    fi

exec "$@"
