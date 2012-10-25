#!/bin/sh
# This is how I used to run the unit tests. Worked pre-Xcode 4.5
# It was supported for logic tests, so it should still work (unlike the UI tests)

xcodebuild -sdk iphonesimulator -scheme XcodeTestSampleNonUITests build TEST_AFTER_BUILD=YES
