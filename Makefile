.DEFAULT_GOAL := help

.PHONY: help test build run clean

help:
	@echo "Available targets:"
	@echo "  make test   - run Swift tests"
	@echo "  make build  - build the package"
	@echo "  make run    - run the executable"
	@echo "  make clean  - clean build artifacts"

test:
	xcodebuild test -scheme didYouReallyWriteIt-Package -destination 'platform=macOS,arch=arm64'

build:
	swift build

run:
	swift run

clean:
	swift package clean
