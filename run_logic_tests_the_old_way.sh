#!/bin/sh
# This is how I used to run the unit tests. Worked pre-Xcode 4.5

xcodebuild -sdk iphonesimulator -scheme XcodeTestSampleNonUITests build ONLY_ACTIVE_ARCH=NO TEST_AFTER_BUILD=YES
