require "spec_helper"

describe OmniAuth::Strategies::SlackOpenid, :slack_openid do
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
end
