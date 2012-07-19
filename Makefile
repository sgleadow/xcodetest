# Makefile to build the XcodeTest static library and sample test project

default: clean xcodetest

.PHONY: clean
clean:
	xcodebuild -sdk iphonesimulator -scheme XcodeTest clean
	rm -rf libXcodeTest.a

.PHONY: xcodetest
xcodetest:
	xcodebuild -sdk iphonesimulator -scheme XcodeTest install

.PHONY: bundle
bundle: xcodetest
	zip -r xcodetest.zip libXcodeTest.a build_and_run_unit_tests.sh

