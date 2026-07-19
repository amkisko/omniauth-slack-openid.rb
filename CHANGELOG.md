# CHANGELOG

## 2.0.0 (2026-07-19)

- BREAKING: Require Ruby 3.4 or newer
- BREAKING: Fail authentication when Slack userInfo returns an error or omits team/user ids
- BREAKING: Raise `ArgumentError` from `generate_uid` when team or user id is blank
- Pass Slack `team` (and `scope`) through authorize params for workspace-scoped sign-in

## 1.2.0 (2023-08-30)

- Switch info payload helper from `Data` to `Struct`

## 1.1.0 (2023-08-30)

- Require Ruby 2.5 or newer

## 1.0.2 (2023-08-29)

- Update gem packaging configuration

## 1.0.1 (2023-08-28)

- Update gem description

## 1.0.0 (2023-08-28)

- Initial release
