require "spec_helper"

describe OmniAuth::Strategies::SlackOpenid do
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

  describe "options" do
    subject { strategy.options }

    it { expect(subject.client_options.site).to eq("https://slack.com") }
    it { expect(subject.client_options.authorize_url).to eq("/openid/connect/authorize") }
    it { expect(subject.client_options.token_url).to eq("/api/openid.connect.token") }
    it { expect(subject.authorize_options).to eq(%i[scope team]) }
  end

  describe ".generate_uid" do
    it "joins team and user ids" do
      expect(described_class.generate_uid("T0R7GR", "U0R7JM")).to eq("T0R7GR-U0R7JM")
    end

    it "rejects blank team_id" do
      expect { described_class.generate_uid(nil, "U0R7JM") }.to raise_error(ArgumentError, /required/)
    end

    it "rejects blank user_id" do
      expect { described_class.generate_uid("T0R7GR", "") }.to raise_error(ArgumentError, /required/)
    end
  end

  describe "#info" do
    before do
      allow(strategy).to receive(:raw_info) { raw_info }
    end

    subject { strategy.info }

    it { expect(subject[:name]).to eq(user_name) }
    it { expect(subject[:email]).to eq(user_email) }
    it { expect(subject[:image]).to eq(raw_info["picture"]) }
  end

  describe "#uid" do
    before do
      allow(strategy).to receive(:raw_info) { raw_info }
    end

    subject { strategy.uid }

    it { expect(subject).to eq("T0R7GR-U0R7JM") }
  end

  describe "#extra" do
    before do
      allow(strategy).to receive(:raw_info) { raw_info }
    end

    subject(:extra) { strategy.extra }

    it "exposes typed data from userInfo" do
      expect(extra[:data].user_id).to eq("U0R7JM")
      expect(extra[:data].team_id).to eq("T0R7GR")
      expect(extra[:data].email).to eq(user_email)
      expect(extra[:data].team_name).to eq("kraneflannel")
      expect(extra[:data].team_domain).to eq("kraneflannel")
    end

    it "includes the raw userInfo payload" do
      expect(extra[:raw_info]).to eq(raw_info)
    end
  end

  describe "#callback_url" do
    it "uses redirect_uri when configured" do
      strategy = described_class.new(
        dummy_rack_app,
        redirect_uri: "https://example.test/auth/slack_openid/callback"
      )
      expect(strategy.callback_url).to eq("https://example.test/auth/slack_openid/callback")
    end

    it "falls back to host and callback path" do
      allow(strategy).to receive_messages(
        full_host: "https://app.example.test",
        script_name: "",
        callback_path: "/auth/slack_openid/callback"
      )
      expect(strategy.callback_url).to eq("https://app.example.test/auth/slack_openid/callback")
    end
  end

  describe "#authorize_params" do
    before do
      OmniAuth.config.test_mode = true
      allow(strategy).to receive(:session).and_return({})
    end

    after do
      OmniAuth.config.test_mode = false
    end

    it "passes team from strategy options" do
      strategy = described_class.new(dummy_rack_app, team: "TOPTION")
      allow(strategy).to receive(:session).and_return({})
      allow(strategy).to receive(:request).and_return(instance_double(Rack::Request, params: {}))
      expect(strategy.authorize_params[:team]).to eq("TOPTION")
    end

    it "passes team from the authorize request" do
      allow(strategy).to receive(:request).and_return(
        instance_double(Rack::Request, params: {"team" => "TREQUEST"})
      )
      expect(strategy.authorize_params[:team]).to eq("TREQUEST")
    end
  end

  describe "#raw_info" do
    let(:access_token) { instance_double(OAuth2::AccessToken) }
    let(:response) { instance_double(OAuth2::Response, parsed: parsed_body) }

    before do
      allow(strategy).to receive(:access_token).and_return(access_token)
      allow(access_token).to receive(:get).with("/api/openid.connect.userInfo").and_return(response)
    end

    context "when Slack returns ok" do
      let(:parsed_body) { raw_info }

      it "returns the parsed userInfo hash" do
        expect(strategy.raw_info).to eq(raw_info)
      end
    end

    context "when Slack returns ok false" do
      let(:parsed_body) { {"ok" => false, "error" => "invalid_auth"} }

      it "fails closed with CallbackError" do
        expect { strategy.raw_info }.to raise_error(
          OmniAuth::Strategies::OAuth2::CallbackError,
          /Slack userInfo failed: invalid_auth/
        )
      end
    end

    context "when team_id or user_id is blank" do
      let(:parsed_body) {
        raw_info.merge(
          "https://slack.com/team_id" => nil,
          "https://slack.com/user_id" => "U0R7JM"
        )
      }

      it "fails closed with CallbackError" do
        expect { strategy.raw_info }.to raise_error(
          OmniAuth::Strategies::OAuth2::CallbackError,
          /missing team_id or user_id/
        )
      end
    end
  end
end
