require "spec_helper"

describe OmniAuth::Strategies::SlackOpenid, :slack_openid do
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

    it "passes scope from the authorize request" do
      allow(strategy).to receive(:request).and_return(
        instance_double(Rack::Request, params: {"scope" => "openid,email"})
      )
      expect(strategy.authorize_params[:scope]).to eq("openid,email")
    end
  end
end
