require 'rubygems'
require 'xcoder'

report = Xcode::Test::Report.new
report.add_formatter :stdout
parser = Xcode::Test::Parsers::OCUnitParser.new report

begin
  Xcode::Shell.execute("cat #{ARGV.first}", false) do |line|
    parser << line
  end
rescue Xcode::Shell::ExecutionError => e
  puts "Test platform exited: #{e.message}"
ensure
  parser.flush
end

exit 1 if report.failed?
