Gem::Specification.new do |gem|
  gem.name = "omniauth-slack-openid"
  gem.version = OmniAuth::Slack::VERSION

  repository_url = "https://github.com/amkisko/omniauth_slack_openid.rb"
  root_files = %w(CHANGELOG.md LICENSE.md README.md)
  root_files += "#{gem.name}.gemspec"

  gem.license = "MIT"

  gem.platform = Gem::Platform::RUBY

  gem.authors = ["Andrei Makarov"]
  gem.email = ["andrei@kiskolabs.com"]
  gem.homepage = repository_url
  gem.summary = %q{Slack OAuth2 strategy for OmniAuth}
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

  gem.required_ruby_version = ">= 1.9.3"
  gem.require_paths = ["lib"]

  spec.add_runtime_dependency 'omniauth', '~> 2'
  spec.add_runtime_dependency 'omniauth-oauth2', '~> 1'

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec', '~> 3'
end