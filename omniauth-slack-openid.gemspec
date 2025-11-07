# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name = "omniauth-slack-openid"
  gem.version = File.read(File.expand_path('../lib/omniauth/slack_openid.rb', __FILE__)).match(/VERSION\s*=\s*"(.*?)"/)[1]

  root_files = %w(CHANGELOG.md LICENSE.md README.md)
  root_files << "#{gem.name}.gemspec"

  gem.license = "MIT"

  gem.platform = Gem::Platform::RUBY

  gem.authors = ["Andrei Makarov"]
  gem.email = ["contact@kiskolabs.com"]
  gem.homepage = "https://github.com/amkisko/omniauth-slack-openid.rb"
  gem.summary = %q{An OmniAuth strategy for implementing Sign-in with Slack using OpenID Connect}
  gem.description = gem.summary
  gem.metadata = {
    "homepage" => "https://github.com/amkisko/omniauth-slack-openid.rb",
    "source_code_uri" => "https://github.com/amkisko/omniauth-slack-openid.rb",
    "bug_tracker_uri" => "https://github.com/amkisko/omniauth-slack-openid.rb/issues",
    "changelog_uri" => "https://github.com/amkisko/omniauth-slack-openid.rb/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  gem.executables = Dir.glob("bin/*").map{ |f| File.basename(f) }
  gem.files = Dir.glob("lib/**/*.rb") + Dir.glob("bin/**/*") + Dir.glob("sig/**/*.rbs") + root_files
  gem.test_files = Dir.glob("spec/**/*_spec.rb")

  gem.required_ruby_version = ">= 2.5.0"
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'omniauth', '~> 2'
  gem.add_runtime_dependency 'omniauth-oauth2', '~> 1'
  gem.add_runtime_dependency 'base64'

  gem.add_development_dependency 'bundler', '~> 2'
  gem.add_development_dependency 'rake', '~> 13'
  gem.add_development_dependency 'rspec', '~> 3'
  gem.add_development_dependency 'pry', '~> 0.15'
  gem.add_development_dependency 'simplecov', '~> 0.22'
  gem.add_development_dependency 'simplecov-cobertura', '~> 3'
  gem.add_development_dependency 'rspec_junit_formatter', '~> 0.6'
  gem.add_development_dependency 'bigdecimal'
  gem.add_development_dependency 'standard', '~> 1'
  gem.add_development_dependency 'appraisal', '~> 2'
  gem.add_development_dependency 'rbs', '~> 3'
end
