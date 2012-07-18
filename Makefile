# Makefile to build and run the static library and sample test project

##################################
# Parameters defined by the user #
##################################
# Name of unit test scheme and target (assumes the scheme and target have the same name)
UNIT_TEST_TARGET=TriumphSampleTests

# Name of the host application for the unit tests
MAIN_APP_TARGET=TriumphSample
##################################

# Calculate build settings to feed in
OUTPUT_DIR=/tmp/xcodetest/$(MAIN_APP_TARGET)
TR_ABS_LIB_PATH=`pwd`/$(PATH_TO_TR_LIB)
XCODE_TEST_PATH=$(OUTPUT_DIR)/$(UNIT_TEST_TARGET).octest/$(UNIT_TEST_TARGET)
TR_LDFLAGS="-all_load -ObjC -framework SenTestingKit -lXcodeTest -L \"$(TR_ABS_LIB_PATH)\" -F \"$$\(SDKROOT\)/Developer/Library/Frameworks\""

default: clean build test

.PHONY: clean
clean:
	xcodebuild -sdk iphonesimulator -scheme $(UNIT_TEST_TARGET) clean
	xcodebuild -sdk iphonesimulator -scheme $(MAIN_APP_TARGET) clean
	rm -rf $(OUTPUT_DIR)
	
.PHONY: xcodetest
xcodetest:
	xcodebuild -sdk iphonesimulator -scheme XcodeTest clean
	rm -rf libXcodeTest.a
	xcodebuild -sdk iphonesimulator -scheme XcodeTest install

.PHONY: build
build:
	xcodebuild -sdk iphonesimulator -scheme $(MAIN_APP_TARGET) build

.PHONY: test
test:
	@osascript -e 'tell app "iPhone Simulator" to quit'
	xcodebuild -sdk iphonesimulator -scheme $(UNIT_TEST_TARGET) build CONFIGURATION_BUILD_DIR=$(OUTPUT_DIR)
	xcodebuild -sdk iphonesimulator -scheme $(MAIN_APP_TARGET) build CONFIGURATION_BUILD_DIR=$(OUTPUT_DIR) OTHER_LDFLAGS=$(TR_LDFLAGS)
	XCODE_TEST_PATH=$(XCODE_TEST_PATH) waxsim $(OUTPUT_DIR)/$(MAIN_APP_TARGET).app -SenTest All
	@osascript -e 'tell app "iPhone Simulator" to quit'
