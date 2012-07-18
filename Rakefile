require 'rubygems'
require 'xcodebuild'
require 'xcoder'

# User entered parameters
MAIN_APP_TARGET = "TriumphSample"
UNIT_TEST_TARGET = "TriumphSampleTests"
PATH_TO_XCODE_TEST_LIB = "."

# Build settings
OUTPUT_DIR = "/tmp/xcodetest/#{MAIN_APP_TARGET}"
XCODE_TEST_ABS_LIB_PATH = File.expand_path PATH_TO_XCODE_TEST_LIB
XCODE_TEST_PATH = "#{OUTPUT_DIR}/#{UNIT_TEST_TARGET}.octest/#{UNIT_TEST_TARGET}"
TEST_SDK_PATH = "\"'$(SDKROOT)/Developer/Library/Frameworks'\""
XCODE_TEST_LDFLAGS="\"-all_load -ObjC -framework SenTestingKit -lXcodeTest -L \"#{XCODE_TEST_ABS_LIB_PATH}\" -F #{TEST_SDK_PATH}\""

XcodeBuild::Tasks::BuildTask.new(:test) do |task|
  task.scheme = UNIT_TEST_TARGET
  
  task.sdk = "iphonesimulator"
  task.formatter = XcodeBuild::Formatters::ProgressFormatter.new
  task.add_build_setting "CONFIGURATION_BUILD_DIR", OUTPUT_DIR
end

XcodeBuild::Tasks::BuildTask.new(:app) do |task|
  task.scheme = MAIN_APP_TARGET
  
  task.sdk = "iphonesimulator"
  task.formatter = XcodeBuild::Formatters::ProgressFormatter.new
  task.add_build_setting("CONFIGURATION_BUILD_DIR", OUTPUT_DIR)
  
  task.add_build_setting "OTHER_LDFLAGS", XCODE_TEST_LDFLAGS
  puts task.build_opts
end

desc "Build and run the unit tests"
task :run => ["test:build", "app:build"] do
  %x{osascript -e 'tell app \"iPhone Simulator\" to quit'}
  
  cmd = "XCODE_TEST_PATH=\"#{XCODE_TEST_PATH}\" waxsim #{OUTPUT_DIR}/#{MAIN_APP_TARGET}.app -SenTest All"
  report = Xcode::Test::Report.new
  report.add_formatter :stdout
  parser = Xcode::Test::Parsers::OCUnitParser.new report
  
  begin
    Xcode::Shell.execute(cmd, false) do |line|
      parser << line
    end
  rescue Xcode::Shell::ExecutionError => e
    puts "Test platform exited: #{e.message}"
  ensure
    parser.flush
  end
  
  %x{osascript -e 'tell app \"iPhone Simulator\" to quit'}
end
