#!/bin/bash
# Script to compile and run unit tests from the command line

# The scheme and target name of the main app
MAIN_APP_TARGET=$1

# The scheme and target name of the unit tests
UNIT_TEST_TARGET=$2

# The path to libXcodeTest.a, if not in current directory
PATH_TO_XCODE_TEST_LIB=$3

# Output variable defaults to current directory of not specified
LINK_TO_XCODE_TEST_LIB=""
if [[ "${PATH_TO_XCODE_TEST_LIB}" != "" ]]; then
  XCODE_TEST_ABS_LIB_PATH=`pwd`/${PATH_TO_XCODE_TEST_LIB}
  LINK_TO_XCODE_TEST_LIB="-lXcodeTest -L \"${XCODE_TEST_ABS_LIB_PATH}\""
else
  CURRENT_PATH=`pwd`
  LINK_TO_XCODE_TEST_LIB="-lXcodeTest -L\"${CURRENT_PATH}\""
fi

# Calculate the variables to feed into the build
OUTPUT_DIR=/tmp/xcodetest/${MAIN_APP_TARGET}
XCODE_TEST_PATH=${OUTPUT_DIR}/${UNIT_TEST_TARGET}.octest/${UNIT_TEST_TARGET}
XCODE_TEST_LDFLAGS="-all_load -ObjC -framework SenTestingKit ${LINK_TO_XCODE_TEST_LIB} -F \"$\(SDKROOT\)/Developer/Library/Frameworks\""

# Build the unit tests bundle, so it can be fed into waxsim
xcodebuild -sdk iphonesimulator -scheme ${UNIT_TEST_TARGET} build CONFIGURATION_BUILD_DIR="${OUTPUT_DIR}"
if [[ $? != 0 ]]; then
  echo "Failed to build unit tests!"
  exit $?
fi

# Build the main app, with libXcodeTest.a linked in
xcodebuild -sdk iphonesimulator -scheme ${MAIN_APP_TARGET} build CONFIGURATION_BUILD_DIR="${OUTPUT_DIR}" OTHER_LDFLAGS="${XCODE_TEST_LDFLAGS}"
if [[ $? != 0 ]]; then
  echo "Failed to build app!"
  exit $?
fi

# Check that waxsim is installed, used to run the app in the simulator
which waxsim
if [[ $? != 0 ]]; then
  echo "Could not find 'waxsim', make sure it is installed and try again"
  exit 1
fi

# Run the app in the simulator, will automatically load and run unit tests
XCODE_TEST_PATH=${XCODE_TEST_PATH} waxsim ${OUTPUT_DIR}/${MAIN_APP_TARGET}.app -SenTest All

# TODO: Parse output for success/failure so error code is right
