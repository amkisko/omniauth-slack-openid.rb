require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class SlackOpenid < OmniAuth::Strategies::OAuth2
      AUTH_OPTIONS = %i[scope user_scope team team_domain].freeze

      INFO_DATA =
        Data.define(
          :user_id,
          :team_id,
          :email,
          :email_verified,
          :name,
          :picture,
          :given_name,
          :family_name,
          :locale,
          :team_name,
          :team_domain
        )

      option :name, "slack_openid"
      option :client_options,
             {
               site: "https://slack.com",
               authorize_url: "/openid/connect/authorize",
               token_url: "/api/openid.connect.token"
             }

      option :redirect_uri

      def self.generate_uid(team_id, user_id)
        "#{team_id}-#{user_id}"
      end

      uid do
        self.class.generate_uid(
          raw_info["https://slack.com/team_id"],
          raw_info["https://slack.com/user_id"]
        )
      end

      info do {
        name: raw_info["name"],
        email: raw_info["email"],
        image: raw_info["picture"]
      } end

      extra do
        {
          data:
            INFO_DATA.new(
              user_id: raw_info["https://slack.com/user_id"],
              team_id: raw_info["https://slack.com/team_id"],
              email: raw_info["email"],
              email_verified: raw_info["email_verified"],
              name: raw_info["name"],
              picture: raw_info["picture"],
              given_name: raw_info["given_name"],
              family_name: raw_info["family_name"],
              locale: raw_info["locale"],
              team_name: raw_info["https://slack.com/team_name"],
              team_domain: raw_info["https://slack.com/team_domain"]
            ),
          raw_info: raw_info
        }
      end

      def callback_url
        options.redirect_uri || (full_host + script_name + callback_path)
      end

      def raw_info
        @raw_info ||= access_token.get("/api/openid.connect.userInfo").parsed
      end
    end
  end
end
