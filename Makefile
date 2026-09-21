.PHONY: test build run clean

test:
	swift test

build:
	swift build

run:
	swift run

clean:
	swift package clean
