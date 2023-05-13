bats:
	@echo "[test] Running BATS Tests"
	@cd test && ./helpers/bats/bin/bats install.bats --print-output-on-failure
