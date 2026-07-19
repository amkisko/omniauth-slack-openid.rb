.PHONY: release lint test audit

release:
	ruby usr/bin/release.rb

lint:
	bundle exec rubocop
	bundle exec rbs validate

audit:
	bundle exec bundle audit check --update
	@set -e; for gemfile in gemfiles/{ruby,ruby40}.gemfile; do \
		echo "==> $$gemfile"; \
		BUNDLE_GEMFILE="$$gemfile" bundle install; \
		BUNDLE_GEMFILE="$$gemfile" bundle exec bundle audit check; \
	done

test:
	bundle exec polyrun parallel-rspec --workers 5 --merge-failures -c polyrun.yml
