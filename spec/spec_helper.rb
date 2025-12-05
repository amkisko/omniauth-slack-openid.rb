require "simplecov"
require "simplecov-cobertura"
require "simplecov_json_formatter"

SimpleCov.start do
  track_files "{lib,app}/**/*.rb"
  add_filter "/lib/tasks/"
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::CoberturaFormatter,
    SimpleCov::Formatter::JSONFormatter
  ])
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "omniauth-slack-openid"

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require_relative f }

RSpec.configure do |config|
end
