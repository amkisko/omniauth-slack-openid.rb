require "omniauth/strategies/oauth2"

module OmniAuth
  module Strategies
    class SlackOpenid < OmniAuth::Strategies::OAuth2
      AUTH_OPTIONS = %i[scope team].freeze

      INFO_DATA = Struct.new(
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
        :team_domain,
        keyword_init: true
      )

      option :name, "slack_openid"
      option :client_options,
        {
          site: "https://slack.com",
          authorize_url: "/openid/connect/authorize",
          token_url: "/api/openid.connect.token"
        }

      option :redirect_uri
      option :authorize_options, AUTH_OPTIONS

      def self.generate_uid(team_id, user_id)
        team = team_id.to_s
        user = user_id.to_s
        if team.empty? || user.empty?
          raise ArgumentError, "team_id and user_id are required"
        end

        "#{team}-#{user}"
      end

      uid do
        self.class.generate_uid(
          raw_info["https://slack.com/team_id"],
          raw_info["https://slack.com/user_id"]
        )
      end

      info do
        {
          name: raw_info["name"],
          email: (raw_info["email"] if raw_info["email_verified"] == true),
          image: raw_info["picture"]
        }
      end

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

      def authorize_params
        super.tap do |params|
          AUTH_OPTIONS.each do |key|
            value = request.params[key.to_s]
            params[key] = value if value && !value.to_s.empty?
          end
        end
      end

      def callback_url
        options.redirect_uri || (full_host + script_name + callback_path)
      end

      def raw_info
        @raw_info ||= fetch_and_validate_user_info
      end

      private

      def fetch_and_validate_user_info
        response = access_token.get("/api/openid.connect.userInfo").parsed
        unless response.is_a?(Hash) && response["ok"] == true
          error = response.is_a?(Hash) ? response["error"] : nil
          raise CallbackError.new(
            :invalid_credentials,
            "Slack userInfo failed#{error ? ": #{error}" : ""}"
          )
        end

        team_id = response["https://slack.com/team_id"].to_s
        user_id = response["https://slack.com/user_id"].to_s
        if team_id.empty? || user_id.empty?
          raise CallbackError.new(
            :invalid_credentials,
            "Slack userInfo missing team_id or user_id"
          )
        end

        response
      end
    end
  end
end
