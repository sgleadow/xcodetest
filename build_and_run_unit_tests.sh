#!/bin/bash
# Script to compile and run unit tests from the command line

# The scheme and target name of the main app
MAIN_APP_TARGET=$1

# The scheme and target name of the unit tests
UNIT_TEST_TARGET=$2

# The path to libXcodeTest.a, if not in current directory
PATH_TO_TR_LIB=$3

# Output variable defaults to current directory of not specified
LINK_TO_TR_LIB=""
if [[ "${PATH_TO_TR_LIB}" != "" ]]; then
  TR_ABS_LIB_PATH=`pwd`/${PATH_TO_TR_LIB}
  LINK_TO_TR_LIB="-lXcodeTest -L \"${TR_ABS_LIB_PATH}\""
else
  CURRENT_PATH=`pwd`
  LINK_TO_TR_LIB="-lXcodeTest -L\"${CURRENT_PATH}\""
fi

OUTPUT_DIR=/tmp/xcodetest/${MAIN_APP_TARGET}
XCODE_TEST_PATH=${OUTPUT_DIR}/${UNIT_TEST_TARGET}.octest/${UNIT_TEST_TARGET}
TR_LDFLAGS="-all_load -ObjC -framework SenTestingKit ${LINK_TO_TR_LIB} -F \"$\(SDKROOT\)/Developer/Library/Frameworks\""

osascript -e 'tell app "iPhone Simulator" to quit'

xcodebuild -sdk iphonesimulator -scheme ${UNIT_TEST_TARGET} build CONFIGURATION_BUILD_DIR="${OUTPUT_DIR}"
if [[ $? != 0 ]]; then
  echo "Failed to build unit tests!"
  exit $?
fi

xcodebuild -sdk iphonesimulator -scheme ${MAIN_APP_TARGET} build CONFIGURATION_BUILD_DIR="${OUTPUT_DIR}" OTHER_LDFLAGS="${TR_LDFLAGS}"
if [[ $? != 0 ]]; then
  echo "Failed to build app!"
  exit $?
fi

which waxsim
if [[ $? != 0 ]]; then
  echo "Could not find 'waxsim', make sure it is installed and try again"
  exit 1
fi

XCODE_TEST_PATH=${XCODE_TEST_PATH} waxsim ${OUTPUT_DIR}/${MAIN_APP_TARGET}.app -SenTest All

osascript -e 'tell app "iPhone Simulator" to quit'
