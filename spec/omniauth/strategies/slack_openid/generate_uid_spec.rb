require "spec_helper"

describe OmniAuth::Strategies::SlackOpenid, :slack_openid do
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
end
