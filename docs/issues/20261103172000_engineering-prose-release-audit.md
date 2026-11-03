# Engineering, prose, and release audit

## Participants

Andrei Makarov (@amkisko)

## Decisions

- Do not cut a RubyGems release. Keep `VERSION` at 2.0.1; product `CHANGELOG.md` has no new section.
- Fail closed on release confirmation EOF; accept empty default and case-insensitive `y` via `confirmation_accepted?`.
- Require a CHANGELOG version heading before `gem build`; cover heading accept/reject and confirmation in executable specs.
- Treat untracked paths as a dirty worktree before release; push `HEAD` with the version tag in one command.
- Leave OpenID `id_token` JWT validation out of scope (documented identity model: userInfo + access token).
- ASCII and house-prose pass on README and the Polyrun coverage config comment.
- Product CHANGELOG lists only consumer-facing library notes; release-tooling repairs stay in this issue and the review.

## Effects

Pipeline: Rack OmniAuth callback -> OAuth2 token exchange -> Slack `openid.connect.userInfo` -> AuthHash (`uid` / `info` / `extra`) -> host app session. Boundary mode covered Slack userInfo shape (`ok`, team/user ids) and release CLI confirmation. Resource and identification modes: strategy returns identity claims from Slack; no new person identifiers in gem logs. Queue, worker, learned-system, physical plant, cloud deployment, and IPC modes skipped (absent).

Ranked fixes applied (maintainer / docs only; no gem cut):

1. Release confirmation EOF treated as decline (medium, observed).
2. Changelog heading gate before build (medium, observed).
3. Release confirmation and changelog executable specs (medium, observed).
4. Porcelain check includes untracked files (low, observed).
5. README identity, CSRF, uid, and publishing prose; ASCII hyphen in coverage config comment (house prose).

Deferred:

- Optional `id_token` JWT validation (signature, `aud`, `iss`, `exp`, `nonce`) as an opt-in beyond userInfo identity.

Checks: rubocop clean on touched files; rbs validate ok; rspec 30 examples, 0 failures; polyrun coverage 100.00% (45/45); cold-load and generate_uid smoke under budget. Details in the review note.

## Next

- Commit and merge tooling and docs. No `make release`.

## Source

docs/reviews/20261103172000_engineering-prose-release-audit.md
docs/changelogs/20261103172000_engineering-release-preparation.md
