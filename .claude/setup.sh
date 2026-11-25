#!/usr/bin/env bash
# Runs at every session start (.claude/settings.json): installs the wallet CLI, restores saved receipts, checks the
# Predict.fun key and the repository's privacy. Prints one short status block. Never prints a key, salt or receipt.
export NODE_USE_ENV_PROXY=1
echo "Forewit setup:"
if npm i -g @binance/agentic-wallet@1.12.0 >/dev/null 2>&1; then echo "* wallet CLI (baw): ready"; else echo "* wallet CLI (baw): install failed; allow the npm registry in the environment's network settings"; fi
mkdir -p ~/.forewit
git fetch -q origin '+refs/heads/*:refs/remotes/origin/*' 2>/dev/null
for ref in $(git for-each-ref --format='%(refname)' refs/remotes/origin); do
  git ls-tree -r --name-only "$ref" receipts/ 2>/dev/null | grep '\.json$' | while read -r f; do git show "$ref:$f" > ~/.forewit/"$(basename "$f")"; done
done
chmod 600 ~/.forewit/*.json 2>/dev/null
echo "* receipts restored: $(ls ~/.forewit/*.json 2>/dev/null | wc -l)"
if [ -z "$PREDICT_API_KEY" ]; then
  echo "* PREDICT_API_KEY: missing (needed for any market; the daily round works without it)"
else
  code=$(curl -s -o /dev/null -w '%{http_code}' -H "x-api-key: $PREDICT_API_KEY" "https://api.predict.fun/v1/search?query=bitcoin&limit=1")
  case "$code" in
    200) echo "* PREDICT_API_KEY: ok" ;;
    401|403) echo "* PREDICT_API_KEY: refused by Predict.fun (HTTP $code); make a new key at developers.predict.fun" ;;
    *) echo "* PREDICT_API_KEY: not checked (HTTP $code); allow api.predict.fun in network settings" ;;
  esac
fi
origin=$(git remote get-url origin 2>/dev/null | sed -E 's#\.git$##; s#.*github\.com[:/]##')
pub=$(curl -s -o /dev/null -w '%{http_code}' "https://api.github.com/repos/$origin")
case "$pub" in
  404) echo "* repository: private (receipts can be backed up here)" ;;
  200) echo "* repository: PUBLIC (never commit receipts here; make it private)" ;;
  *) echo "* repository: privacy unknown (HTTP $pub); do not commit receipts" ;;
esac
