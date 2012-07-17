# Makefile to build and run the static library and sample test project

default: clean build test

UNIT_TEST_TARGET=TriumphSampleTests
MAIN_APP_TARGET=TriumphSample
OUTPUT_DIR=output
TR_UNIT_TEST_PATH=`pwd`/$(OUTPUT_DIR)/$(UNIT_TEST_TARGET).octest/$(UNIT_TEST_TARGET)

.PHONY: clean
clean:
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme $(UNIT_TEST_TARGET) clean
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme $(MAIN_APP_TARGET) clean
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme Triumph clean
	rm -rf $(OUTPUT_DIR)

.PHONY: build
build:
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme $(MAIN_APP_TARGET) build

.PHONY: test
test:
	osascript -e 'tell app "iPhone Simulator" to quit'
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme Triumph build CONFIGURATION_BUILD_DIR=../$(OUTPUT_DIR)
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme $(UNIT_TEST_TARGET) build CONFIGURATION_BUILD_DIR=../$(OUTPUT_DIR)
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme $(MAIN_APP_TARGET) -xcconfig Triumph.xcconfig build CONFIGURATION_BUILD_DIR=../$(OUTPUT_DIR)
	TR_UNIT_TEST_PATH=$(TR_UNIT_TEST_PATH) waxsim $(OUTPUT_DIR)/$(MAIN_APP_TARGET).app -SenTest All
