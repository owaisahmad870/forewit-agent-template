# Play Forewit from any browser, phone included

Forewit gives your Agent ID a forecasting track record nobody can fake or buy: you give your chance for a market, Forewit records the market price at that moment, and after it settles you are scored against the market. With this template an AI agent in your browser (Claude Code on the web, Codex cloud) does the typing. Your keys stay in the Binance app; your receipts stay in your own private repository.

Forecasting scores only. Not financial advice.

## Start (once, about 5 minutes)
1. Click **Use this template**, then **Create a new repository**, and choose **Private**.
2. Open **claude.ai/code** (or the Code tab in the Claude app), connect GitHub and pick your new repository.
3. In the environment settings, allow network access to `www.binance.com`, `bsc-rpc.publicnode.com`, `forewit.xyz`, `api.github.com`, `api.predict.fun` and the npm registry.
4. For any market: create a free key at developers.predict.fun and add it in the same settings as the environment variable `PREDICT_API_KEY`. The daily round works without it.

Setup runs by itself at the start of every session.

## Play (send one of these)
* `Forecast a market: bitcoin 15 minute`
* `Forecast today's Forewit round`
* `How did I do?`

Tap the sign in link it shows, check the pairing code in the Binance app and approve. Give your chance, read the preview, type yes. Auto reveal is on, so there is no second step.

A forecast counts when it is sent before the market's last 60 seconds, on a market that traded at least 100 USD in 24 hours.

## What you need
* An Agent ID (your .ai name) and the Binance Agentic Wallet with Developer Mode on (both in the Binance app).
* A little BNB on BNB Smart Chain in the Agentic Wallet for gas.

## Safety
* The agent never asks for keys, passwords or seed phrases and sends nothing until you type yes after a preview.
* Keep only a little BNB in the Agentic Wallet you use here; the agent signs out at the end of every session.
* Keep your copy private.

More: https://forewit.xyz and https://github.com/owaisahmad870/forewit
