#!/bin/bash
# Sample script to use the test runner to use XcodeTest

if [ ! -f libXcodeTest.a ]; then
    echo "libXcodeTest.a does not exist in the current directory"
    echo "use \"make xcodetest\" to build it"
    exit 1
fi

# To use the script, feed in the scheme names (which are also assumed to match the build target names)
./build_and_run_unit_tests.sh XcodeTestSample XcodeTestSampleTests
