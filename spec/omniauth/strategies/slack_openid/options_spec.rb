require "spec_helper"

describe OmniAuth::Strategies::SlackOpenid, :slack_openid do
  describe "options" do
    subject { strategy.options }

    it { expect(subject.client_options.site).to eq("https://slack.com") }
    it { expect(subject.client_options.authorize_url).to eq("/openid/connect/authorize") }
    it { expect(subject.client_options.token_url).to eq("/api/openid.connect.token") }
    it { expect(subject.authorize_options).to eq(%i[scope team]) }
  end
end
