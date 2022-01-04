.PHONY: audit uninstall install test publish bundle

FORMULA := bats-libs
TAP := j5pu/homebrew-$(FORMULA)
export HOMEBREW_NO_ENV_HINTS=1

audit:
	@brew audit --new --git --formula Formula/$(FORMULA).rb 2>&1 | grep -v "^Error: " || true

uninstall: audit
	@brew uninstall $(TAP)/$(FORMULA)  2>/dev/null || true
	@brew autoremove

install: uninstall
	@brew install --build-from-source --verbose $(TAP)/$(FORMULA)

test: install
	@brew test Formula/$(FORMULA).rb

publish: test
	@git config remote.origin.url git@github.com:$(TAP).git
	@git all

bundle: publish
	@brew bundle --quiet --no-lock
