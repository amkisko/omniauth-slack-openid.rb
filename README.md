# omniauth-slack-openid.rb

[![Gem Version](https://badge.fury.io/rb/omniauth-slack-openid.svg)](https://badge.fury.io/rb/omniauth-slack-openid) [![Test Status](https://github.com/amkisko/omniauth-slack-openid.rb/actions/workflows/test.yml/badge.svg)](https://github.com/amkisko/omniauth-slack-openid.rb/actions/workflows/test.yml)

An OmniAuth strategy for Slack's OAuth2 API.

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
