require "spec_helper"

describe OmniAuth::Strategies::SlackOpenid, :slack_openid do
  describe "#info" do
    before do
      allow(strategy).to receive(:raw_info) { raw_info }
    end

    subject { strategy.info }

    it { expect(subject[:name]).to eq(user_name) }
    it { expect(subject[:email]).to eq(user_email) }
    it { expect(subject[:image]).to eq(raw_info["picture"]) }

    it "omits email from info when email_verified is not true" do
      allow(strategy).to receive(:raw_info) {
        raw_info.merge("email_verified" => false)
      }
      expect(strategy.info[:email]).to be_nil
      expect(strategy.info[:name]).to eq(user_name)
    end
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

  describe "AuthHash fields from userInfo" do
    let(:access_token) { instance_double(OAuth2::AccessToken) }
    let(:response) { instance_double(OAuth2::Response, parsed: raw_info) }

    before do
      allow(strategy).to receive(:access_token).and_return(access_token)
      allow(access_token).to receive(:get).with("/api/openid.connect.userInfo").and_return(response)
    end

    it "builds uid and info from the userInfo response" do
      expect(strategy.uid).to eq("T0R7GR-U0R7JM")
      expect(strategy.info[:email]).to eq(user_email)
      expect(strategy.extra[:data].team_id).to eq("T0R7GR")
    end
  end
end
