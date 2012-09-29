#!/bin/sh
# This is how I used to run the unit tests. Worked pre-Xcode 4.5

xcodebuild -sdk iphonesimulator -scheme XcodeTestSamplePassingTests build TEST_AFTER_BUILD=YES
