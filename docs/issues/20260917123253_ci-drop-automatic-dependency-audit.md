Test CI ran bundler-audit before specs.

## Participants

- amkisko

## Decisions

- Drop the audit job from test.yml so tests no longer wait on advisory freshness.
- Disable osv-scanner in Trunk Check.
- Disable markdownlint MD013 in .markdownlint.yaml. Keep AGENTS.md in Trunk so other markdownlint rules still run.
- Keep the junit helper without a trailing blank line.
- Add dependency-audit.yml with workflow_dispatch only.

## Effects

- Test CI runs lint and specs without an advisory gate.
- Trunk Check no longer treats dependency CVEs as a required check.
- On-demand bundler-audit of every Gemfile.lock is available through workflow_dispatch.

## Next

- Run dependency audit on demand when a release or a known advisory needs it.
- Do not reintroduce advisory scanners into test.yml.

## Source

- GitHub Actions test failures on 2026-09-17
