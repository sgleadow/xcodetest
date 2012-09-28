# XcodeTest

A way of running your application unit tests from the command line.


## How to use XcodeTest

- add `libXcodeTest.a` to the root of your project (either next to your `.xcworkspace` or main `.xcodeproj` file)
- add the shell script `build_and_run_unit_tests.sh` to the root of your project
- make sure you have a *scheme* that builds your app, and that both the scheme and your target app have the same name (eg. sche e MyApp builds the target MyApp)
- make sure you have a *scheme* that builds your unit test target (when you create a new unit test scheme, you need to edit the scheme and make sure it builds as part of the *run* action in Xcode so that it will build when using the command line `xcodebuild`)

Since there are peculiarities when feeding in linker flags from the command line, you have to edit your *target build settings* in Xcode, or in your *xcconfig* file so that it knows about all this magic:

- *In xcconfigs:* `OTHER_LDFLAGS = $(inherited) $(XCODE_TEST_LDFLAGS)`
- *In Xcode:* double-click on `Other Linker Flags` in the Xcode build settings, hit the `+` button in the editor and add an entry for `$(XCODE_TEST_LDFLAGS)`

Now try running the shell script:

`./build_and_run_unit_tests.sh MyApp MyAppTests`

That shell script should:
- build your unit tests using the provided scheme name (second argument)
- re-build your app with libXcodeTest.a compiled in
- load your app using waxsim


*NOTE: if you decide to add libXcodeTest.a to another directory, please provide the relative path as a third argument to the shell script, so we can tell the linker where to look.*

eg.
`./build_and_run_unit_tests.sh MyApp MyAppTests lib`


## Building libXcodeTest.a from source

Checkout the source from [the github project](http://havent/uploaded/yet) and type `make` in the root of the project to build the static library. To bundle up the library and associated shell scripts to distribute, type `make bundle`.


## Dependencies

This tool uses the [waxsim](https://github.com/square/WaxSim/) tool to run your app in the iOS Simulator. Since there have been a few bugfixes that are yet to be merged in, please use [Jonathan Penn's fork](https://github.com/jonathanpenn/WaxSim/). Build and install waxsim using the command:

`xcodebuild install DSTROOT=/ INSTALL_PATH=/usr/local/bin`


## How XcodeTest works

XcodeTest is distributed as a static library that can be linked into your main application. The library automatically hooks itself into your application when the class loads, and registers for the `applicationDidBecomeActive` notification. It dynamically loads the symbols from the unit test bundle, fed in using the environment variable `XCODE_TEST_PATH`.

If the `XCODE_TEST_PATH` variable is missing, it aborts. If the unit test object file cannot be dynamically loaded, it aborts. When both succeed, it runs your OCUnit/Kiwi tests using the same mechanism that Xcode uses, so the terminal output should be the same.


## Why XcodeTest exists

Apple differentiates between 'logic' unit tests and 'application' unit tests. Logic unit tests only depend on Foundation libraries that are common to both OS X and iOS and can run directly on your development machine. Logic tests run on the command line simply by specifying TEST_AFTER_BUILD=YES when running `xcodebuild`. Application unit tests depend on iOS frameworks, like UIKit, and must run in the context of a host app inside the iOS simulator. Running application tests on the command line is not supported by Apple. You used to be able to get it working by hacking the underlying shell script, which I [wrote up already](http://www.stewgleadow.com/blog/2012/02/09/running-ocunit-and-kiwi-tests-on-the-command-line/).

However, these hacks are flakey and don't work with the lastest versions of Xcode. There is a radar for the [bug running command line unit tests](http://openradar.appspot.com/12306879). This tool should get you going in the mean time. There is a [stackoverflow post](http://stackoverflow.com/questions/12557935/xcode-4-5-command-line-unit-testing) about the issue as well.


## Feedback

Please raise issues if you find defects or have a feature request.


## License

This library is licensed under the [MIT license](http://en.wikipedia.org/wiki/MIT_License).
