ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: generate test gen_main gen_modules gen_test_main gen_test_modules

space :=
MODULES =  $(subst /, $(space),$(sort $(dir $(wildcard */))))

# Adjust your delimiter here or overwrite via make arguments
DELIM_START = <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
DELIM_CLOSE = <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

generate: gen_main gen_modules

test: gen_test_main gen_test_modules

gen_main:
	@if docker run --rm \
		-v $(shell pwd):/data \
		-e DELIM_START='$(DELIM_START)' \
		-e DELIM_CLOSE='$(DELIM_CLOSE)' \
		cytopia/terraform-docs:0.6.0 \
		terraform-docs-replace-012 --sort-inputs-by-required --with-aggregate-type-defaults md README.md ; then \
		echo "OK"; \
	else \
		echo "Failed"; \
		exit 1; \
	fi;

gen_modules: SHELL := /bin/bash
gen_modules:
	@$(foreach module,\
			$(MODULES),\
			DOCKER_PATH="$(notdir $(patsubst %/,%,$(module)))"; \
			echo $${DOCKER_PATH};\
			if docker run --rm \
				-v $(shell pwd):/data \
				cytopia/terraform-docs \
				terraform-docs md $(module)/ > $(module)/README.md; then\
				echo "OK";\
			else \
				echo "Failed"; \
				exit 1; \
			fi; \
	)

gen_test_main: SHELL := /bin/bash
gen_test_main:
	@echo "# Copy README file"
	@cp README.md TESTREADME.md;
	@echo "# Generate test README file"
	@docker run --rm \
		-v $(shell pwd):/data \
		-e DELIM_START='$(DELIM_START)' \
		-e DELIM_CLOSE='$(DELIM_CLOSE)' \
		cytopia/terraform-docs:0.6.0 \
		terraform-docs-replace-012 --sort-inputs-by-required --with-aggregate-type-defaults md TESTREADME.md;
	@echo "# Compare README files";
	@DIFF=$(shell diff "README.md" "TESTREADME.md");
	@(if [ -z $(DIFF) ]; then\
		echo "## The README is up to date";\
	else\
		echo "######################################";\
		echo "## The REAMDME has not been updated ##";\
		echo "## The differences are:			 ##";\
		echo $(DIFF);\
		echo "######################################";\
		echo "# Remove test README file";\
		rm TESTREADME.md;\
		exit 1;\
	fi;)
	@echo "# Remove test README file";
	@rm TESTREADME.md;

gen_test_modules: SHELL := /bin/bash
gen_test_modules:
	@$(foreach module,\
			$(MODULES),\
			echo "BEGIN";\
			if docker run --rm \
				-v $(shell pwd):/data\
				cytopia/terraform-docs\
				terraform-docs md $(module)/ > $(module)/TESTREADME.md; then\
				echo "# Test README generated.";\
			else\
				echo "# Failed to generate test README";\
			fi;\
			DIFF=${diff "$(module)/README.md" "$(module)/TESTREADME.md"};\
			if [ -z "$(DIFF)" ]; then\
				echo "## The README is up to date";\
			else\
				echo "######################################";\
				echo "## The REAMDME has not been updated ##";\
				echo "## The differences are:			 ##";\
				echo " $(DIFF)";\
				echo "######################################";\
				echo "# Remove test README file";\
				rm "$(module)/TESTREADME.md"\
				exit 1;\
			fi;\
			echo "# Remove test README file";\
			rm "$(module)/TESTREADME.md";\
	)