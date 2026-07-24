# Runs unit tests with coverage and samples for every supported language in isolated Docker containers.
# Use `make test` or `make run-samples` to run all languages, and use targets such as
# `make test-go` or `make run-sample-go` to run a single language. Image variables can
# be overridden from the command line for internal registries or custom toolchains.
# Samples default to non-production credentials and must not use customer secrets.

SHELL := /bin/sh

ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DOCKER ?= docker
DOCKER_RUN = $(DOCKER) run --rm --init -v "$(ROOT_DIR):/workspace:ro"

# Prints the current test target before execution.
TEST_START = @printf '\n========== [START] %s ==========\n' "$@"
# Prints the current test target after successful execution.
TEST_PASS = @printf '========== [PASS]  %s ==========\n\n' "$@"
# Prints the current sample target before execution.
SAMPLE_START = @printf '\n========== [START] %s ==========\n' "$@"
# Prints the current sample target after successful execution.
SAMPLE_PASS = @printf '========== [PASS]  %s ==========\n\n' "$@"

# Base image for building and testing C++ code.
CPP_IMAGE ?= ubuntu:22.04
# .NET SDK image for building and testing C# code.
CSHARP_IMAGE ?= mcr.microsoft.com/dotnet/sdk:8.0
# Flutter SDK image for running Dart tests and examples.
DART_IMAGE ?= ghcr.io/cirruslabs/flutter:3.27.2
# Deno runtime image for testing and running JavaScript modules.
DENO_IMAGE ?= denoland/deno:1.45.3
# Go toolchain image for testing and running Go packages.
GO_IMAGE ?= golang:1.22
# Maven and Java 8 image for building and testing Java code.
JAVA_IMAGE ?= maven:3.9.9-eclipse-temurin-8
# Lua and LuaRocks image for installing dependencies and running Lua code.
LUA_IMAGE ?= nickblah/lua:5.4.7-luarocks-ubuntu
# Node.js runtime image for installing dependencies and running Node.js code.
NODEJS_IMAGE ?= node:22.4
# Perl runtime image for installing CPAN dependencies and running Perl code.
PERL_IMAGE ?= perl:5.40
# PHP runtime image for testing and running PHP scripts.
PHP_IMAGE ?= php:8.3
# Legacy Python 2 image for testing and running Python 2 code.
PYTHON_IMAGE ?= python:2.7
# Python 3 image for testing and running Python 3 code.
PYTHON3_IMAGE ?= python:3.12
# Ruby runtime image for installing gems and running Ruby code.
RUBY_IMAGE ?= ruby:3.3
# Rust toolchain image for testing crates and running examples.
RUST_IMAGE ?= rust:1.79

# Samples read Agora credentials from the environment and fall back to non-production values.
SAMPLE_APP_ID ?= $(or $(AGORA_APP_ID),aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)
SAMPLE_APP_CERTIFICATE ?= $(or $(AGORA_APP_CERTIFICATE),bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb)
SAMPLE_ENV = -e AGORA_APP_ID=$(SAMPLE_APP_ID) -e AGORA_APP_CERTIFICATE=$(SAMPLE_APP_CERTIFICATE)

TEST_TARGETS := \
	test-cpp \
	test-csharp \
	test-dart \
	test-deno \
	test-go \
	test-java \
	test-lua \
	test-nodejs \
	test-perl \
	test-php \
	test-python \
	test-python3 \
	test-ruby \
	test-rust

RUN_SAMPLE_TARGETS := \
	run-sample-cpp \
	run-sample-csharp \
	run-sample-dart \
	run-sample-deno \
	run-sample-go \
	run-sample-java \
	run-sample-lua \
	run-sample-nodejs \
	run-sample-perl \
	run-sample-php \
	run-sample-python \
	run-sample-python3 \
	run-sample-ruby \
	run-sample-rust

.PHONY: \
	help parse check-docker test run-samples \
	$(TEST_TARGETS) $(RUN_SAMPLE_TARGETS)

# Lists the available Make commands.
help:
	@printf '%s\n' \
		'make test                   Run all language unit tests with coverage in Docker' \
		'make test-<language>        Run one language unit test suite with coverage in Docker' \
		'make run-samples            Run all language samples with test credentials' \
		'make run-sample-<language>  Run one language sample suite with test credentials' \
		'make parse token=...        Parse a token locally'

# Parses the token supplied through the token variable.
parse:
	@echo ">> parse token"
	python3 parse.py $(token)
	@echo ">> done"

# Verifies that the Docker CLI and daemon are available.
check-docker:
	@command -v $(DOCKER) >/dev/null 2>&1 || { echo "docker is required"; exit 1; }
	@$(DOCKER) info >/dev/null 2>&1 || { echo "docker daemon is not available"; exit 1; }

# Runs unit tests with coverage for all supported languages.
test: $(TEST_TARGETS)

# Runs samples for all supported languages.
run-samples: $(RUN_SAMPLE_TARGETS)

# Requires Docker before running any language-specific target.
$(TEST_TARGETS) $(RUN_SAMPLE_TARGETS): check-docker

# Builds and runs the C++ unit tests with gcovr coverage.
test-cpp:
	$(TEST_START)
	$(DOCKER_RUN) -w /workspace/cpp $(CPP_IMAGE) sh -ec '\
		apt-get update >/dev/null; \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends clang cmake gcovr libgtest-dev libssl-dev llvm make zlib1g-dev >/dev/null; \
		cmake -S . -B /tmp/agora-cpp-build -DCMAKE_CXX_FLAGS=--coverage -DCMAKE_EXE_LINKER_FLAGS=--coverage; \
		cmake --build /tmp/agora-cpp-build --target test.exe --parallel; \
		/tmp/agora-cpp-build/test/test.exe; \
		gcovr --root /workspace/cpp --filter /workspace/cpp/src/ --object-directory /tmp/agora-cpp-build --gcov-executable "llvm-cov gcov" --txt --print-summary'
	$(TEST_PASS)

# Runs the C# unit tests with Coverlet coverage.
test-csharp:
	$(TEST_START)
	$(DOCKER_RUN) -w /workspace/csharp $(CSHARP_IMAGE) sh -ec '\
		cp -R . /tmp/agora-csharp; \
		cd /tmp/agora-csharp; \
		dotnet add test/AgoraIO.Tests/AgoraIO.Tests.csproj package coverlet.msbuild --version 6.0.4; \
		dotnet test test/AgoraIO.Tests/AgoraIO.Tests.csproj \
			/p:CollectCoverage=true \
			/p:CoverletOutput=/tmp/csharp-coverage/ \
			/p:CoverletOutputFormat=cobertura'
	$(TEST_PASS)

# Runs the Dart and Flutter unit tests with line coverage.
test-dart:
	$(TEST_START)
	$(DOCKER_RUN) -w /workspace/dart $(DART_IMAGE) sh -ec '\
		cp -R . /tmp/agora-dart; \
		cd /tmp/agora-dart; \
		flutter test --coverage; \
		awk -F: '\''/^LF:/{lines += $$2} /^LH:/{covered += $$2} END { if (lines == 0) exit 1; printf "Dart line coverage: %.2f%% (%d/%d)\n", covered * 100 / lines, covered, lines }'\'' coverage/lcov.info'
	$(TEST_PASS)

# Runs the Deno unit tests with native coverage.
test-deno:
	$(TEST_START)
	$(DOCKER_RUN) --entrypoint sh -w /workspace/deno $(DENO_IMAGE) -ec '\
		deno test --allow-net --coverage=/tmp/deno-coverage test/*.js; \
		deno coverage --include="/src/" /tmp/deno-coverage'
	$(TEST_PASS)

# Runs all Go unit tests and reports total statement coverage.
test-go:
	$(TEST_START)
	$(DOCKER_RUN) -w /workspace/go/src $(GO_IMAGE) sh -ec '\
		go test -covermode=atomic -coverprofile=/tmp/go-coverage.out ./...; \
		coverage=$$(go tool cover -func=/tmp/go-coverage.out); \
		total=$$(printf "%s\n" "$$coverage" | awk '\''/^total:/ { print $$NF }'\''); \
		test -n "$$total"; \
		printf "Total statement coverage: %s\n" "$$total"'
	$(TEST_PASS)

# Runs the Java unit tests with JaCoCo coverage.
test-java:
	$(TEST_START)
	$(DOCKER_RUN) -w /workspace/java $(JAVA_IMAGE) sh -ec '\
		cp -R . /tmp/agora-java; \
		cd /tmp/agora-java; \
		mvn -B org.jacoco:jacoco-maven-plugin:0.8.12:prepare-agent test org.jacoco:jacoco-maven-plugin:0.8.12:report; \
		awk -F, '\''NR > 1 { missed += $$8; covered += $$9 } END { total = missed + covered; if (total == 0) exit 1; printf "Java line coverage: %.2f%% (%d/%d)\n", covered * 100 / total, covered, total }'\'' target/site/jacoco/jacoco.csv'
	$(TEST_PASS)

# Installs Lua dependencies and runs the Lua unit tests with LuaCov coverage.
test-lua:
	$(TEST_START)
	$(DOCKER_RUN) -w /workspace/lua $(LUA_IMAGE) sh -ec '\
		apt-get update >/dev/null; \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential git libssl-dev lua-unit zlib1g-dev >/dev/null; \
		cp -R . /tmp/agora-lua; \
		cd /tmp/agora-lua; \
		export LUA_PATH="/usr/share/lua/5.4/?.lua;/usr/share/lua/5.4/?/init.lua;;"; \
		luarocks install base64; \
		luarocks install luaossl; \
		luarocks install lua-zlib; \
		luarocks install md5; \
		luarocks make --deps-mode=none agora-token-0.1.0-1.rockspec; \
		luarocks install luafilesystem 1.8.0-1; \
		luarocks install luacov 0.15.0-1; \
		for test_file in tests/*.lua; do lua -lluacov "$$test_file"; done; \
		luacov; \
		tail -n 20 luacov.report.out'
	$(TEST_PASS)

# Installs Node.js dependencies and runs the Node.js unit tests with c8 coverage.
test-nodejs:
	$(TEST_START)
	$(DOCKER_RUN) -w /workspace/nodejs $(NODEJS_IMAGE) sh -ec '\
		cp -R . /tmp/agora-nodejs; \
		cd /tmp/agora-nodejs; \
		npm ci; \
		npx --yes c8@10.1.3 \
			--all \
			--include="src/**/*.js" \
			--include=index.js \
			--temp-directory=/tmp/nodejs-c8 \
			--reports-dir=/tmp/nodejs-coverage \
			--reporter=text \
			npm test'
	$(TEST_PASS)

# Installs Perl dependencies and runs the Perl unit tests with Devel::Cover coverage.
test-perl:
	$(TEST_START)
	$(DOCKER_RUN) -w /workspace/perl $(PERL_IMAGE) sh -ec '\
		cp -R . /tmp/agora-perl; \
		cd /tmp/agora-perl; \
		cpanm --quiet --notest --installdeps .; \
		cpanm --quiet --notest Devel::Cover; \
		HARNESS_PERL_SWITCHES=-MDevel::Cover prove -I src test/*.t; \
		cover -select_re "^src/"'
	$(TEST_PASS)

# Runs the PHP tests with Xdebug line coverage.
test-php:
	$(TEST_START)
	$(DOCKER_RUN) -w /workspace/php/test $(PHP_IMAGE) sh -ec '\
		apt-get update >/dev/null; \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $${PHPIZE_DEPS} >/dev/null; \
		pecl install xdebug-3.3.2 >/dev/null; \
		docker-php-ext-enable xdebug >/dev/null; \
		php -d xdebug.mode=coverage CoverageRunner.php'
	$(TEST_PASS)

# Runs the legacy Python 2 unit tests with coverage.py.
test-python:
	$(TEST_START)
	$(DOCKER_RUN) -e COVERAGE_FILE=/tmp/python-coverage -e PYTHONDONTWRITEBYTECODE=1 -w /workspace/python $(PYTHON_IMAGE) sh -ec '\
		pip install --quiet coverage==5.5; \
		coverage run --source=src -m unittest discover -v -s test -p "*[tT]est*.py"; \
		coverage report --show-missing'
	$(TEST_PASS)

# Runs the Python 3 unit tests with coverage.py.
test-python3:
	$(TEST_START)
	$(DOCKER_RUN) -e COVERAGE_FILE=/tmp/python3-coverage -e PYTHONDONTWRITEBYTECODE=1 -w /workspace/python3 $(PYTHON3_IMAGE) sh -ec '\
		python3 -m pip install --quiet coverage==7.6.1; \
		python3 -m coverage run --source=src -m unittest discover -v -s test -p "*[tT]est*.py"; \
		python3 -m coverage report --show-missing'
	$(TEST_PASS)

# Installs Ruby dependencies and runs the Ruby unit tests with SimpleCov coverage.
test-ruby:
	$(TEST_START)
	$(DOCKER_RUN) -v /usr/local/bundle -w /workspace/ruby $(RUBY_IMAGE) sh -ec '\
		cp -R . /tmp/agora-ruby; \
		cd /tmp/agora-ruby; \
		bundle install --quiet; \
		gem install simplecov --version 0.22.0 --no-document; \
		ruby -rsimplecov -e "SimpleCov.start { add_filter \"/test/\" }; load Gem.bin_path(\"rspec-core\", \"rspec\")" -- test'
	$(TEST_PASS)

# Runs the Rust unit tests with cargo-llvm-cov coverage.
test-rust:
	$(TEST_START)
	$(DOCKER_RUN) -e CARGO_TARGET_DIR=/tmp/agora-rust-target -w /workspace/rust $(RUST_IMAGE) \
		sh -ec '\
			rustup component add llvm-tools-preview; \
			cargo install cargo-llvm-cov --version 0.6.10 --locked; \
			cargo llvm-cov --locked --summary-only'
	$(TEST_PASS)

# Builds and runs all configured C++ samples.
run-sample-cpp:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/cpp $(CPP_IMAGE) sh -ec '\
		apt-get update >/dev/null; \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends clang cmake g++ libssl-dev make zlib1g-dev >/dev/null; \
		cmake -S sample -B /tmp/agora-cpp-samples; \
		cmake --build /tmp/agora-cpp-samples --parallel; \
		for sample_file in /tmp/agora-cpp-samples/*.exe; do "$$sample_file"; done'
	$(SAMPLE_PASS)

# Runs the C# sample scenarios maintained in the referenced test classes.
run-sample-csharp:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/csharp $(CSHARP_IMAGE) sh -ec '\
		cp -R . /tmp/agora-csharp; \
		cd /tmp/agora-csharp; \
		dotnet test test/AgoraIO.Tests/AgoraIO.Tests.csproj \
			--filter "FullyQualifiedName~RtcTokenBuilderTest|FullyQualifiedName~RtmTokenBuilderTest|FullyQualifiedName~AccessToken2Test"'
	$(SAMPLE_PASS)

# Runs all Dart sample applications.
run-sample-dart:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/dart $(DART_IMAGE) sh -ec '\
		cp -R . /tmp/agora-dart; \
		cd /tmp/agora-dart; \
		flutter pub get; \
		for sample_file in sample/*_sample.dart; do dart run "$$sample_file"; done'
	$(SAMPLE_PASS)

# Runs all Deno samples.
run-sample-deno:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) --entrypoint sh -w /workspace/deno $(DENO_IMAGE) -ec '\
		for sample_file in sample/*.js; do deno run --allow-env "$$sample_file"; done'
	$(SAMPLE_PASS)

# Runs all Go samples.
run-sample-go:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/go/sample $(GO_IMAGE) sh -ec '\
		for sample_dir in */; do go run "./$$sample_dir"; done'
	$(SAMPLE_PASS)

# Runs the Java RTC Token Builder 2 sample.
run-sample-java:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/java $(JAVA_IMAGE) sh -ec '\
		cp -R . /tmp/agora-java; \
		cd /tmp/agora-java; \
		mvn -B -DskipTests compile org.codehaus.mojo:exec-maven-plugin:3.5.0:java \
			-Dexec.mainClass=io.agora.sample.RtcTokenBuilder2Sample'
	$(SAMPLE_PASS)

# Installs Lua dependencies and runs all Lua samples.
run-sample-lua:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/lua $(LUA_IMAGE) sh -ec '\
		apt-get update >/dev/null; \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential git libssl-dev lua-unit zlib1g-dev >/dev/null; \
		cp -R . /tmp/agora-lua; \
		cd /tmp/agora-lua; \
		export LUA_PATH="/usr/share/lua/5.4/?.lua;/usr/share/lua/5.4/?/init.lua;;"; \
		luarocks install base64; \
		luarocks install luaossl; \
		luarocks install lua-zlib; \
		luarocks install md5; \
		luarocks make --deps-mode=none agora-token-0.1.0-1.rockspec; \
		for sample_file in sample/*.lua; do lua "$$sample_file"; done'
	$(SAMPLE_PASS)

# Installs Node.js dependencies and runs all Node.js samples.
run-sample-nodejs:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/nodejs $(NODEJS_IMAGE) sh -ec '\
		cp -R . /tmp/agora-nodejs; \
		cd /tmp/agora-nodejs; \
		npm ci; \
		for sample_file in sample/*.js; do node "$$sample_file"; done'
	$(SAMPLE_PASS)

# Installs Perl dependencies and runs all Perl samples.
run-sample-perl:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/perl $(PERL_IMAGE) sh -ec '\
		cpanm --quiet --notest --installdeps .; \
		for sample_file in sample/*.pl; do perl -I src "$$sample_file"; done'
	$(SAMPLE_PASS)

# Runs all PHP samples.
run-sample-php:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/php/sample $(PHP_IMAGE) sh -ec '\
		for sample_file in *.php; do php "$$sample_file"; done'
	$(SAMPLE_PASS)

# Runs all legacy Python 2 samples.
run-sample-python:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -e PYTHONDONTWRITEBYTECODE=1 -w /workspace/python $(PYTHON_IMAGE) sh -ec '\
		for sample_file in sample/*.py; do python "$$sample_file"; done'
	$(SAMPLE_PASS)

# Runs all Python 3 samples.
run-sample-python3:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -e PYTHONDONTWRITEBYTECODE=1 -w /workspace/python3 $(PYTHON3_IMAGE) sh -ec '\
		for sample_file in sample/*.py; do python3 "$$sample_file"; done'
	$(SAMPLE_PASS)

# Installs Ruby dependencies and runs all Ruby samples.
run-sample-ruby:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -v /usr/local/bundle -w /workspace/ruby $(RUBY_IMAGE) sh -ec '\
		cp -R . /tmp/agora-ruby; \
		cd /tmp/agora-ruby; \
		bundle install --quiet; \
		for sample_file in sample/*.rb; do bundle exec ruby "$$sample_file"; done'
	$(SAMPLE_PASS)

# Runs all Rust examples with the locked dependency versions.
run-sample-rust:
	$(SAMPLE_START)
	$(DOCKER_RUN) $(SAMPLE_ENV) -e CARGO_TARGET_DIR=/tmp/agora-rust-target -w /workspace/rust $(RUST_IMAGE) sh -ec '\
		for sample_file in examples/*.rs; do \
			sample_name=$$(basename "$$sample_file" .rs); \
			cargo run --locked --example "$$sample_name"; \
		done'
	$(SAMPLE_PASS)
