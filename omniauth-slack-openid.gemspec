# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name = "omniauth-slack-openid"
  gem.version = File.read(File.expand_path('../lib/omniauth/slack_openid.rb', __FILE__)).match(/VERSION\s*=\s*'(.*?)'/)[1]

  repository_url = "https://github.com/amkisko/omniauth-slack-openid.rb"
  root_files = %w(CHANGELOG.md LICENSE.md README.md)
  root_files << "#{gem.name}.gemspec"

  gem.license = "MIT"

  gem.platform = Gem::Platform::RUBY

  gem.authors = ["Andrei Makarov"]
  gem.email = ["andrei@kiskolabs.com"]
  gem.homepage = repository_url
  gem.summary = %q{An OmniAuth strategy for implementing Sign-in with Slack using OpenID Connect}
  gem.description = gem.summary
  gem.metadata = {
    "homepage" => repository_url,
    "source_code_uri" => repository_url,
    "bug_tracker_uri" => "#{repository_url}/issues",
    "changelog_uri" => "#{repository_url}/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  gem.executables = Dir.glob("bin/*").map{ |f| File.basename(f) }
  gem.files = Dir.glob("lib/**/*.rb") + Dir.glob("bin/**/*") + root_files
  gem.test_files = Dir.glob("spec/**/*_spec.rb")

  gem.required_ruby_version = ">= 2.5.0"
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'omniauth', '~> 2'
  gem.add_runtime_dependency 'omniauth-oauth2', '~> 1'

  gem.add_development_dependency 'bundler', '~> 2'
  gem.add_development_dependency 'rake', '~> 13'
  gem.add_development_dependency 'rspec', '~> 3'
  gem.add_development_dependency 'pry', '~> 0.14'
  gem.add_development_dependency 'simplecov', '~> 0.21'
  gem.add_development_dependency 'simplecov-cobertura', '~> 2'
end
