default: clean build test

.PHONY: clean
clean:
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme TriumphSample clean

.PHONY: build
build:
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme TriumphSample build

.PHONY: test
test:
	xcodebuild -sdk iphonesimulator -configuration Debug -scheme TriumphSample TEST_AFTER_BUILD=YES
