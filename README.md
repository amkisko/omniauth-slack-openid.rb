# omniauth-slack-openid.rb

[![Gem Version](https://badge.fury.io/rb/omniauth-slack-openid.svg)](https://badge.fury.io/rb/omniauth-slack-openid) [![Test Status](https://github.com/amkisko/omniauth-slack-openid.rb/actions/workflows/test.yml/badge.svg)](https://github.com/amkisko/omniauth-slack-openid.rb/actions/workflows/test.yml) [![codecov](https://codecov.io/gh/amkisko/omniauth-slack-openid.rb/graph/badge.svg?token=HIOT78D47F)](https://app.codecov.io/github/amkisko/omniauth-slack-openid.rb)

An OmniAuth strategy for implementing Sign-in with Slack using OpenID Connect.

Official Slack API documentation: https://api.slack.com/authentication/sign-in-with-slack

## Identity model

This strategy exchanges the OAuth authorization code for an access token, then loads identity from Slack `openid.connect.userInfo`. Slack's `id_token` JWT is left unchecked (signature, `aud`, `iss`, `exp`, and `nonce`). Treat the OmniAuth AuthHash as session identity from Slack's token and userInfo endpoints. It is not a fully verified OIDC ID token.

`info[:email]` is set when Slack reports `email_verified: true`. Unverified addresses stay on `extra[:data].email` and `extra[:raw_info]` for display or support flows.

## Install

Using Bundler:
```sh
bundle add omniauth-slack-openid
```

Using RubyGems:
```sh
gem install omniauth-slack-openid
```

## Gemfile

```ruby
gem 'omniauth-slack-openid'
```

## Usage with Devise

Create Slack app and configure OAuth & Permissions to have the following Redirect URLs:
- https://localhost:3000/user/auth/slack_openid/callback

Copy `Client ID` and `Client Secret` to your environment (e.g. `.env.local` file):
```sh
SLACK_CLIENT_ID=1234567890.1234567890
SLACK_CLIENT_SECRET=1234567890abcdef1234567890abcdef
```

Add the following to your `config/initializers/devise.rb`:

```ruby
  config.omniauth(
    :slack_openid,
    ENV.fetch("SLACK_CLIENT_ID"),
    ENV.fetch("SLACK_CLIENT_SECRET"),
    {
      scope: "openid,email,profile",
      redirect_uri: Rails.env.development? ? "https://localhost:3000/user/auth/slack_openid/callback" : nil
    }
  )
```

Leave OmniAuth CSRF state checks on (`provider_ignores_state` unset or `false`). Fix local TLS or `redirect_uri` when callbacks fail in development. For local testing against an HTTPS redirect registered in Slack, finish the authorize step, then adjust the callback host or scheme only as needed while state verification stays enabled.

## Generating uid

The gem provides `generate_uid`, which joins `team_id` and `user_id`. Call it with your own parameters when you need the same compound id:

```ruby
def resolve_user_session(team_id, user_id)
  uid = OmniAuth::Strategies::SlackOpenid.generate_uid(team_id, user_id)
  UserSession.find_by(uid: uid, provider: "slack-openid")
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amkisko/omniauth-slack-openid.rb

## Publishing

Maintainers cut a release from a clean worktree with:

```sh
make release
```

That path runs lint, tests, changelog and confirmation gates, then `gem push`, tags, and a GitHub release.

## Links

- [GitHub](https://github.com/amkisko/omniauth-slack-openid.rb)
- [GitLab](https://gitlab.com/amkisko/omniauth-slack-openid.rb)
- [RubyGems](https://rubygems.org/gems/omniauth-slack-openid)
- [Versions Atom](https://rubygems.org/gems/omniauth-slack-openid/versions.atom) (feed id `5816970036548`)
- [libraries.io](https://libraries.io/rubygems/omniauth-slack-openid)
- [Deps.dev](https://deps.dev/rubygems/omniauth-slack-openid)
- [SonarCloud](https://sonarcloud.io/project/overview?id=amkisko_omniauth-slack-openid.rb)
- [Snyk](https://snyk.io/test/github/amkisko/omniauth-slack-openid.rb)
- [Codecov](https://app.codecov.io/github/amkisko/omniauth-slack-openid.rb)
- [OpenSSF Scorecard](https://scorecard.dev/viewer/?uri=github.com/amkisko/omniauth-slack-openid.rb)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Sponsors

Sponsored by [Kisko Labs](https://www.kiskolabs.com).

<a href="https://www.kiskolabs.com">
  <img src="kisko.svg" width="200" alt="Sponsored by Kisko Labs" />
</a>
