# Makefile to build and run the static library and sample test project

default: clean build test

##################################
# Parameters defined by the user #
##################################
# The path to libTriumph.a if it's not in your search path
PATH_TO_TR_LIB=lib

# Name of unit test scheme and target (assumes the scheme and target have the same name)
UNIT_TEST_TARGET=TriumphSampleTests

# Name of the host application for the unit tests
MAIN_APP_TARGET=TriumphSample
##################################

# Calculate build settings to feed in
OUTPUT_DIR=/tmp/xcodetest/$(MAIN_APP_TARGET)
TR_ABS_LIB_PATH=`pwd`/$(PATH_TO_TR_LIB)
TR_UNIT_TEST_PATH=$(OUTPUT_DIR)/$(UNIT_TEST_TARGET).octest/$(UNIT_TEST_TARGET)
TR_LDFLAGS="-all_load -ObjC -framework SenTestingKit -lTriumph -L \"$(TR_ABS_LIB_PATH)\" -F \"$$\(SDKROOT\)/Developer/Library/Frameworks\""

.PHONY: clean
clean:
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme $(UNIT_TEST_TARGET) clean
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme $(MAIN_APP_TARGET) clean
	rm -rf $(OUTPUT_DIR)
	
.PHONY: triumph
triumph:
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme Triumph clean
	rm -rf $(PATH_TO_TR_LIB)
	# TODO: how to be know that the path from project to workspace is ..? (convert to relative path?)
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme Triumph build CONFIGURATION_BUILD_DIR=../$(PATH_TO_TR_LIB)

.PHONY: build
build:
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme $(MAIN_APP_TARGET) build

.PHONY: test
test:
	osascript -e 'tell app "iPhone Simulator" to quit'
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme $(UNIT_TEST_TARGET) build CONFIGURATION_BUILD_DIR=$(OUTPUT_DIR)
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme $(MAIN_APP_TARGET) build CONFIGURATION_BUILD_DIR=$(OUTPUT_DIR) OTHER_LDFLAGS=$(TR_LDFLAGS)
	TR_UNIT_TEST_PATH=$(TR_UNIT_TEST_PATH) waxsim $(OUTPUT_DIR)/$(MAIN_APP_TARGET).app -SenTest All
