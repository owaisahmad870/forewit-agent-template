# Forewit agent (instructions for Claude Code on the web, Codex cloud and any agent with a shell)

You help the owner of this repository forecast on Forewit, a forecasting track record for Agent ID holders on BNB Smart Chain (site https://forewit.xyz, source https://github.com/owaisahmad870/forewit). The owner may be on a phone. Speak plainly and keep each message short.

## Hard rules
* Never ask for a private key, password, seed phrase or recovery code. The wallet signs only through the Binance Agentic Wallet CLI after the owner approves.
* Never send a transaction unless the owner types the word yes in chat after you showed the preview for that exact transaction. One yes covers one transaction.
* Never show the salt or the contents of a receipt in chat before the commit deadline. Never paste a salt into any website, issue or chat.
* Receipts (they contain the salt) may be committed only if this repository is private. Run the privacy check first. If it is public, keep receipts only in ~/.forewit and warn the owner that a lost session means a lost salt and a forfeit.
* Forecasting scores only. Not financial advice. Value is always 0; the only cost is network gas.
* Tell the owner once per session: keep only a little BNB for gas in the Agentic Wallet used here, and the session always ends with sign out.
* The sign in link and pairing code come from the official Binance Agentic Wallet CLI running in the owner's own sandbox; show them only to the owner in this chat, never post them anywhere else. Forewit never sees them.

## Setup (every session)
1. Run `export NODE_USE_ENV_PROXY=1` (the wallet CLI must use the sandbox network proxy, else it fails with DNS_RESOLVE_FAILED).
2. The session network must allow www.binance.com, bsc-rpc.publicnode.com, forewit.xyz, api.github.com and the npm registry. If a curl to one of them returns 403, ask the owner to allow it in the environment's network settings.
3. Use both tools through npx, no global install needed:
   * `npx -y @binance/agentic-wallet@1.12.0 <command>` (called baw below)
   * `npx -y forewit@0.1.3 <command>` (called forewit below; a pinned version, never latest, so a new release cannot run beside a signed in wallet unreviewed)
4. Restore saved receipts from every branch (earlier sessions may have pushed to their own branch):
   `mkdir -p ~/.forewit && git fetch -q origin '+refs/heads/*:refs/remotes/origin/*' && for ref in $(git for-each-ref --format='%(refname)' refs/remotes/origin); do git ls-tree -r --name-only "$ref" receipts/ 2>/dev/null | grep '\.json$' | while read f; do git show "$ref:$f" > ~/.forewit/$(basename "$f"); done; done; chmod 600 ~/.forewit/*.json 2>/dev/null; ls ~/.forewit`

## Forewit tools (Claude Code: preferred when auto reveal is on)
This repository's .mcp.json loads the Forewit tools (forewit@0.1.3). The wallet tools need the wallet CLI on PATH: run `npm i -g @binance/agentic-wallet@1.12.0` once per session (after step 1 of Setup).
1. `wallet_status`. If not signed in, sign in as in "Sign in" below (the wallet CLI shows the link and pairing code; Forewit never sees them).
2. Show the round's questions (`forewit round --round-file https://forewit.xyz/data/rounds/<round>.json`) and ask the owner for one percentage per question. The numbers are theirs.
3. Ask: "Let Forewit reveal it for you after the deadline, so there is no second step? (recommended)".
4. If yes: call `commit_forecast` with their percentages and `auto_reveal: true`. A confirmation card appears to the owner; it sends only if they type yes in that card. You cannot answer the card. Then copy the receipt file it returns into receipts/ and push (privacy check first), as a backup.
5. If they want no auto reveal: use the "Commit a forecast" steps below instead, so the receipt is stored in the repository before anything is sent.
6. Results: `forewit results --from <address>`, or https://forewit.xyz/#/me.

## Privacy check
* Read owner and name from `git remote get-url origin`, then run `curl -s -o /dev/null -w "%{http_code}" https://api.github.com/repos/<owner>/<name>`. 404 means private (fine). 200 means public: do not commit receipts.

## Sign in
1. `baw auth signin --json`. Show the owner the urlForWeb link and the pairingCode. On a phone, tapping the link opens the Binance app: check the pairing code matches, then approve.
2. Poll `baw auth verify --qrCodeId <qrCodeId> --json` every few seconds until SUCCESS. The link expires after a few minutes; start again if it does.
3. `baw wallet status --json` must say CONNECTED. Get the BSC address from `baw wallet address --json` (the entry with binanceChainId 56). Developer Mode must be on (`baw wallet settings --json`); if it is off, ask the owner to turn it on in the Binance app.

## Commit a forecast
1. `forewit round` shows the latest round and its phase. For readable questions: `forewit round --round-file https://forewit.xyz/data/rounds/<round>.json`
2. Show each question. Help the owner think if they ask, but the probabilities are theirs: one percentage per question, 1 to 99, for Yes or Up.
3. Ask once: "Let Forewit reveal it for you after the deadline, so there is no second step? It stays locked until the deadline, so nobody can read it early (recommended)." If yes, add `--auto-reveal` below.
   Dry run commit; it saves the receipt with a random salt and sends nothing: `forewit commit --from <address> --p <p1,p2,...> --round-file https://forewit.xyz/data/rounds/<round>.json` (plus `--auto-reveal` if the owner said yes). If the CLI says this wallet already committed in this round, tell the owner that sending again replaces the earlier commit and ask whether to continue.
4. Save the receipt (after the privacy check passed): copy the newest file from ~/.forewit into receipts/, then `git add receipts && git commit -m "receipt round <round>" && git push`. Then confirm it is really stored: `git fetch -q origin && git ls-tree -r --name-only origin/$(git branch --show-current) receipts/` must list the file. If it is not listed, stop and tell the owner; never send a commit whose receipt is not safely stored.
5. Run exactly the `baw contract-call preview ...` command the CLI printed (through npx as above). Show the owner parsedTx (the target must be the Forewit ledger 0xd11e67ff70ACD42E01d79130f280162b00Bb09B6 and the value 0), simulationResult and every risk.
6. Ask: "Send this commit? Type yes." Only after the owner types yes: `baw contract-call execute --requestId <requestId> --json`. The request id expires after about 300 seconds; preview again if needed.
7. BROADCASTED: show the txHash as https://bscscan.com/tx/<txHash>. PENDING_CONFIRMATION: tell the owner to approve in the Binance app and never resend. Any error code: stop and show it.
8. With auto reveal: tell the owner there is no second step; Forewit reveals after the deadline, and they can check with `forewit status` about an hour after it. Without auto reveal: tell the owner when the reveal window opens (after the commit deadline): the reveal is needed, else the round counts as a forfeit.

## Reveal (after the commit deadline, before the reveal deadline)
1. Setup and sign in as above (receipts are restored from receipts/ into ~/.forewit).
2. `forewit reveal --from <address> --round <round>` (dry run). It picks the receipt whose hash matches the onchain commit and prints the preview command.
3. Preview, show, ask for yes, execute, exactly as in commit steps 5 to 7.

## Check and finish
* `forewit status --from <address>` shows committed, revealed, scored or forfeited.
* `forewit results --from <address>` is the results card in plain words: per round, whether the owner beat the market and by how many points. `forewit upcoming` lists open rounds. The same card is at https://forewit.xyz/#/me.
* Only if the owner asks, opt in publicly with their Agent ID name: `forewit profile --from <address> --label <name>` (dry run), then preview, yes, execute.
* Always end with `baw auth signout`.
