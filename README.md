# omniauth-slack-openid.rb

[![Gem Version](https://badge.fury.io/rb/omniauth-slack-openid.svg)](https://badge.fury.io/rb/omniauth-slack-openid) [![Test Status](https://github.com/amkisko/omniauth-slack-openid.rb/actions/workflows/test.yml/badge.svg)](https://github.com/amkisko/omniauth-slack-openid.rb/actions/workflows/test.yml)

An OmniAuth strategy for implementing Sign-in with Slack using OpenID Connect.

Official documentation: https://api.slack.com/authentication/sign-in-with-slack

Sponsored by [Kisko Labs](https://www.kiskolabs.com).

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
      redirect_uri: Rails.env.development? ? "https://localhost:3000/user/auth/slack_openid/callback" : nil,
      provider_ignores_state: Rails.env.development?
    }
  )
```

In order to test the callback in development, try logging in and then manually update URL to use http instead of https.

## Generating uid

Gem has own `generate_uid` method that concatenates `team_id` and `user_id`, you can use it with custom parameters:

```ruby
def resolve_user_session(team_id, user_id)
  uid = OmniAuth::Strategies::SlackOpenid.generate_uid(team_id, user_id)
  UserSession.find_by(uid: uid, provider: "slack-openid")
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amkisko/omniauth-slack-openid.rb

## Publishing

```sh
rm omniauth-slack-openid-*.gem
gem build omniauth-slack-openid.gemspec
gem push omniauth-slack-openid-*.gem
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
