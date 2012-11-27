#!/usr/bin/env ruby
# Run the unit tests in this test bundle.
# Use ios-sim to trigger the unit test
# Reference: http://stackoverflow.com/questions/5403991/xcode-4-run-tests-from-the-command-line-xcodebuild
# Thanks to Tony Arnold for the basis of this script: https://gist.github.com/a46a3efe90544b6a8873

puts "** Running Kiwi Tests **"
if ENV['TEST_AFTER_BUILD'] != 'YES'
  puts "** Not running tests, TEST_AFTER_BUILD is #{ENV['TEST_AFTER_BUILD']}. Set to 'YES' to run tests. **"
  exit 0
end

system %Q{osascript -e 'tell app "iPhone Simulator" to quit'}

launcher_path = `which ios-sim`.strip
if launcher_path.nil?
  puts "Could not find ios-sim on your system."
end

test_bundle_path = File.join(ENV['BUILT_PRODUCTS_DIR'], "#{ENV['PRODUCT_NAME']}.#{ENV['WRAPPER_EXTENSION']}")
test_output_path = File.join(ENV['BUILD_DIR'], "kiwi-tests.out")

environment = {
    'DYLD_INSERT_LIBRARIES' => "/../../Library/PrivateFrameworks/IDEBundleInjection.framework/IDEBundleInjection",
    'XCInjectBundle' => test_bundle_path,
    'XCInjectBundleInto' => ENV["TEST_HOST"]
}

environment_args = environment.collect { |key, value| "--setenv #{key}=\"#{value}\""}.join(" ")

app_test_host = File.dirname(ENV["TEST_HOST"])

cmd = %Q{#{launcher_path} launch "#{app_test_host}" #{environment_args} --args -SenTest All 2>&1 | tee "#{test_output_path}" }
cmd.gsub! "iphoneos", "iphonesimulator"
puts "** Running command: #{cmd}"
system(cmd)

check_cmd = %Q{grep -Fq "[FAILED]" "#{test_output_path}"}
found_failures = system check_cmd
completion_status = found_failures ? "FAILED" : "PASSED"

puts "** Kiwi Tests #{completion_status} **"
unless completion_status
  puts "Failures:\n"
  system %Q{grep -F "[FAILED]" "#{test_output_path}"}
end

exit !found_failures
