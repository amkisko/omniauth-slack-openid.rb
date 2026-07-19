require "spec_helper"

describe OmniAuth::Strategies::SlackOpenid, :slack_openid do
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

    context "when Slack returns ok false without an error field" do
      let(:parsed_body) { {"ok" => false} }

      it "fails closed with CallbackError" do
        expect { strategy.raw_info }.to raise_error(
          OmniAuth::Strategies::OAuth2::CallbackError,
          /invalid_credentials \| Slack userInfo failed\z/
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

    context "when Slack returns a non-Hash body" do
      let(:parsed_body) { "upstream failure" }

      it "fails closed with CallbackError" do
        expect { strategy.raw_info }.to raise_error(
          OmniAuth::Strategies::OAuth2::CallbackError,
          /Slack userInfo failed/
        )
      end
    end
  end
end
