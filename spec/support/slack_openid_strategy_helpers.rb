module SlackOpenidStrategyHelpers
  extend RSpec::SharedContext

  let(:user_name) { "brent" }
  let(:user_email) { "bront@slack-corp.com" }
  let(:raw_info) {
    {
      "ok" => true,
      "sub" => "U0R7JM",
      "https://slack.com/user_id" => "U0R7JM",
      "https://slack.com/team_id" => "T0R7GR",
      "email" => user_email,
      "email_verified" => true,
      "date_email_verified" => 1622128723,
      "name" => user_name,
      "picture" => "https://secure.gravatar.com/....png",
      "given_name" => "Bront",
      "family_name" => "Labradoodle",
      "locale" => "en-US",
      "https://slack.com/team_name" => "kraneflannel",
      "https://slack.com/team_domain" => "kraneflannel",
      "https://slack.com/user_image_24" => "...",
      "https://slack.com/user_image_32" => "...",
      "https://slack.com/user_image_48" => "...",
      "https://slack.com/user_image_72" => "...",
      "https://slack.com/user_image_192" => "...",
      "https://slack.com/user_image_512" => "...",
      "https://slack.com/team_image_34" => "...",
      "https://slack.com/team_image_44" => "...",
      "https://slack.com/team_image_68" => "...",
      "https://slack.com/team_image_88" => "...",
      "https://slack.com/team_image_102" => "...",
      "https://slack.com/team_image_132" => "...",
      "https://slack.com/team_image_230" => "...",
      "https://slack.com/team_image_default" => true
    }
  }
  let(:dummy_rack_app) { [200, {}, ["dummy"]] }
  let(:options) { {} }
  subject(:strategy) { OmniAuth::Strategies::SlackOpenid.new(dummy_rack_app, options) }
end

RSpec.configure do |config|
  config.include SlackOpenidStrategyHelpers, slack_openid: true
end
