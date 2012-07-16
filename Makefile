# Makefile to build and run the static library and sample test project

default: clean test

.PHONY: clean
clean:
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme TriumphSample clean
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme Triumph clean
	rm -rf output

.PHONY: build
build:
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme TriumphSample build

.PHONY: test
test:
	osascript -e 'tell app "iPhone Simulator" to quit'
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme Triumph build CONFIGURATION_BUILD_DIR=../output
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme TriumphSampleTests build CONFIGURATION_BUILD_DIR=../output
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme TriumphSample -xcconfig Triumph.xcconfig build CONFIGURATION_BUILD_DIR=../output
	waxsim output/TriumphSample.app -SenTest All
