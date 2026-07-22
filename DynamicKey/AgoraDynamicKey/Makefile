# Runs unit tests and samples for every supported language in isolated Docker containers.
# Use `make test` or `make run-samples` to run all languages, and use targets such as
# `make test-go` or `make run-sample-go` to run a single language. Image variables can
# be overridden from the command line for internal registries or custom toolchains.
# Samples use fixed non-production credentials and must not use customer secrets.

SHELL := /bin/sh

ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DOCKER ?= docker
DOCKER_RUN = $(DOCKER) run --rm --init -v "$(ROOT_DIR):/workspace:ro"

# Base image for building and testing C++ code.
CPP_IMAGE ?= ubuntu:22.04
# .NET SDK image for building and testing C# code.
CSHARP_IMAGE ?= mcr.microsoft.com/dotnet/sdk:8.0
# Flutter SDK image for running Dart tests and examples.
DART_IMAGE ?= ghcr.io/cirruslabs/flutter:3.27.1
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

# Samples use non-production credentials because they print credential values.
SAMPLE_APP_ID := AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
SAMPLE_APP_CERTIFICATE := BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
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
		'make test                   Run all language unit tests in Docker' \
		'make test-<language>        Run one language unit test suite in Docker' \
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

# Runs unit tests for all supported languages.
test: $(TEST_TARGETS)

# Runs samples for all supported languages.
run-samples: $(RUN_SAMPLE_TARGETS)

# Requires Docker before running any language-specific target.
$(TEST_TARGETS) $(RUN_SAMPLE_TARGETS): check-docker

# Builds and runs the C++ unit tests.
test-cpp:
	$(DOCKER_RUN) -w /workspace/cpp $(CPP_IMAGE) sh -ec '\
		apt-get update >/dev/null; \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends cmake g++ libgtest-dev libssl-dev zlib1g-dev >/dev/null; \
		cmake -S . -B /tmp/agora-cpp-build; \
		cmake --build /tmp/agora-cpp-build --parallel; \
		/tmp/agora-cpp-build/test/test.exe'

# Runs the C# unit tests.
test-csharp:
	$(DOCKER_RUN) -w /workspace/csharp $(CSHARP_IMAGE) sh -ec '\
		cp -R . /tmp/agora-csharp; \
		cd /tmp/agora-csharp; \
		dotnet test test/AgoraIO.Tests/AgoraIO.Tests.csproj'

# Runs the Dart and Flutter unit tests.
test-dart:
	$(DOCKER_RUN) -w /workspace/dart $(DART_IMAGE) sh -ec '\
		cp -R . /tmp/agora-dart; \
		cd /tmp/agora-dart; \
		flutter test'

# Runs the Deno unit tests.
test-deno:
	$(DOCKER_RUN) --entrypoint deno -w /workspace/deno $(DENO_IMAGE) \
		test --allow-net test

# Runs all Go unit tests.
test-go:
	$(DOCKER_RUN) -w /workspace/go/src $(GO_IMAGE) \
		go test ./...

# Runs the Java unit tests with Maven.
test-java:
	$(DOCKER_RUN) -v /workspace/java/target -w /workspace/java $(JAVA_IMAGE) \
		mvn -B test

# Installs Lua dependencies and runs the Lua unit tests.
test-lua:
	$(DOCKER_RUN) -w /workspace/lua $(LUA_IMAGE) sh -ec '\
		apt-get update >/dev/null; \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential libssl-dev zlib1g-dev >/dev/null; \
		luarocks make agora-token-0.1.0-1.rockspec; \
		for test_file in tests/*.lua; do lua "$$test_file"; done'

# Installs Node.js dependencies and runs the Node.js unit tests.
test-nodejs:
	$(DOCKER_RUN) -v /workspace/nodejs/node_modules -w /workspace/nodejs $(NODEJS_IMAGE) sh -ec '\
		npm ci; \
		npm test'

# Installs Perl dependencies and runs the Perl unit tests.
test-perl:
	$(DOCKER_RUN) -w /workspace/perl $(PERL_IMAGE) sh -ec '\
		cpanm --quiet --notest --installdeps .; \
		prove -I src test/*.t'

# Runs the PHP tests and fails when a custom assertion reports an error.
test-php:
	$(DOCKER_RUN) -w /workspace/php/test $(PHP_IMAGE) sh -ec '\
		output=$$(mktemp); \
		for test_file in *Test.php; do php "$$test_file"; done | tee "$$output"; \
		if grep -q "assert failed" "$$output"; then exit 1; fi'

# Runs the legacy Python 2 unit tests.
test-python:
	$(DOCKER_RUN) -e PYTHONDONTWRITEBYTECODE=1 -w /workspace/python $(PYTHON_IMAGE) \
		python -m unittest discover -v -s test -p '*[tT]est*.py'

# Runs the Python 3 unit tests.
test-python3:
	$(DOCKER_RUN) -e PYTHONDONTWRITEBYTECODE=1 -w /workspace/python3 $(PYTHON3_IMAGE) \
		python3 -m unittest discover -v -s test -p '*[tT]est*.py'

# Installs Ruby dependencies and runs the Ruby unit tests.
test-ruby:
	$(DOCKER_RUN) -v /usr/local/bundle -w /workspace/ruby $(RUBY_IMAGE) sh -ec '\
		bundle install --quiet; \
		bundle exec rspec test'

# Runs the Rust unit tests with the locked dependency versions.
test-rust:
	$(DOCKER_RUN) -e CARGO_TARGET_DIR=/tmp/agora-rust-target -w /workspace/rust $(RUST_IMAGE) \
		cargo test --locked

# Builds and runs all configured C++ samples.
run-sample-cpp:
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/cpp $(CPP_IMAGE) sh -ec '\
		apt-get update >/dev/null; \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends cmake g++ libssl-dev zlib1g-dev >/dev/null; \
		cmake -S sample -B /tmp/agora-cpp-samples; \
		cmake --build /tmp/agora-cpp-samples --parallel; \
		for sample_file in /tmp/agora-cpp-samples/*.exe; do "$$sample_file"; done'

# Builds and runs the executable C# samples.
run-sample-csharp:
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/csharp $(CSHARP_IMAGE) sh -ec '\
		cp -R . /tmp/agora-csharp; \
		for sample_file in RtcTokenBuilderSample.cs RtmTokenBuilderSample.cs; do \
			rm -rf /tmp/agora-csharp-runner; \
			dotnet new console --output /tmp/agora-csharp-runner --force >/dev/null; \
			dotnet add /tmp/agora-csharp-runner reference /tmp/agora-csharp/src/AgoraIO/AgoraIO.csproj >/dev/null; \
			cp "/tmp/agora-csharp/sample/$$sample_file" /tmp/agora-csharp-runner/Program.cs; \
			dotnet run --project /tmp/agora-csharp-runner; \
		done'

# Runs the Dart example application.
run-sample-dart:
	$(DOCKER_RUN) -w /workspace/dart $(DART_IMAGE) sh -ec '\
		cp -R . /tmp/agora-dart; \
		cd /tmp/agora-dart; \
		flutter pub get; \
		dart run example/example.dart'

# Runs all Deno samples.
run-sample-deno:
	$(DOCKER_RUN) $(SAMPLE_ENV) --entrypoint sh -w /workspace/deno $(DENO_IMAGE) -ec '\
		for sample_file in sample/*.js; do deno run --allow-env "$$sample_file"; done'

# Runs all Go samples.
run-sample-go:
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/go/sample $(GO_IMAGE) sh -ec '\
		for sample_dir in */; do go run "./$$sample_dir"; done'

# Runs the Java RTC Token Builder 2 sample.
run-sample-java:
	$(DOCKER_RUN) $(SAMPLE_ENV) -v /workspace/java/target -w /workspace/java $(JAVA_IMAGE) \
		mvn -B -DskipTests compile org.codehaus.mojo:exec-maven-plugin:3.5.0:java \
		-Dexec.mainClass=io.agora.sample.RtcTokenBuilder2Sample

# Installs Lua dependencies and runs all Lua samples.
run-sample-lua:
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/lua $(LUA_IMAGE) sh -ec '\
		apt-get update >/dev/null; \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential libssl-dev zlib1g-dev >/dev/null; \
		luarocks make agora-token-0.1.0-1.rockspec; \
		for sample_file in examples/*.lua; do lua "$$sample_file"; done'

# Installs Node.js dependencies and runs all Node.js samples.
run-sample-nodejs:
	$(DOCKER_RUN) $(SAMPLE_ENV) -v /workspace/nodejs/node_modules -w /workspace/nodejs $(NODEJS_IMAGE) sh -ec '\
		npm ci; \
		for sample_file in sample/*.js; do node "$$sample_file"; done'

# Installs Perl dependencies and runs all Perl samples.
run-sample-perl:
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/perl $(PERL_IMAGE) sh -ec '\
		cpanm --quiet --notest --installdeps .; \
		for sample_file in sample/*.pl; do perl -I src "$$sample_file"; done'

# Runs all PHP samples.
run-sample-php:
	$(DOCKER_RUN) $(SAMPLE_ENV) -w /workspace/php $(PHP_IMAGE) sh -ec '\
		for sample_file in sample/*.php; do php "$$sample_file"; done'

# Runs all legacy Python 2 samples.
run-sample-python:
	$(DOCKER_RUN) $(SAMPLE_ENV) -e PYTHONDONTWRITEBYTECODE=1 -w /workspace/python $(PYTHON_IMAGE) sh -ec '\
		for sample_file in sample/*.py; do python "$$sample_file"; done'

# Runs all Python 3 samples.
run-sample-python3:
	$(DOCKER_RUN) $(SAMPLE_ENV) -e PYTHONDONTWRITEBYTECODE=1 -w /workspace/python3 $(PYTHON3_IMAGE) sh -ec '\
		for sample_file in sample/*.py; do python3 "$$sample_file"; done'

# Installs Ruby dependencies and runs all Ruby samples.
run-sample-ruby:
	$(DOCKER_RUN) $(SAMPLE_ENV) -v /usr/local/bundle -w /workspace/ruby $(RUBY_IMAGE) sh -ec '\
		bundle install --quiet; \
		for sample_file in sample/*.rb; do bundle exec ruby "$$sample_file"; done'

# Runs all Rust examples with the locked dependency versions.
run-sample-rust:
	$(DOCKER_RUN) $(SAMPLE_ENV) -e CARGO_TARGET_DIR=/tmp/agora-rust-target -w /workspace/rust $(RUST_IMAGE) sh -ec '\
		for sample_file in examples/*.rs; do \
			sample_name=$$(basename "$$sample_file" .rs); \
			cargo run --locked --example "$$sample_name"; \
		done'
