# Makefile to build the XcodeTest static library and sample test project

default: xcodetest

.PHONY: clean
clean:
	xcodebuild -sdk iphonesimulator -scheme XcodeTest clean
	rm -rf libXcodeTest.a

.PHONY: xcodetest
xcodetest:
	xcodebuild -sdk iphonesimulator -scheme XcodeTest install
