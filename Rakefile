require 'rake'
require 'yaml'
require 'parallel'
require 'browserstack/local'
require './specs/single_test.rb'
require './specs/local_test.rb'

def run_tests(config, invoke_method=SingleTest)
  config["browser_caps"].each do |browser_caps|
    caps = config["common_caps"].clone
    caps.merge!(browser_caps)
    config[:caps] = caps
    test = invoke_method.new(config)
    test.google_test
  end
end

task :single do |t, args|
  puts "Running Single Tests"
  config = YAML.load_file('config/single.config.yml')
  run_tests(config, SingleTest)
end

task :local do |t, args|
  puts "Running Local Tests"
  bs_local = BrowserStack::Local.new
  config = YAML.load_file('config/local.config.yml')

  bs_local = BrowserStack::Local.new
  bs_local_args = { "key" => ENV['BROWSERSTACK_ACCESS_KEY'] || config['key'] }
  bs_local.start(bs_local_args)

  begin
    run_tests(config, LocalTest)
  ensure
    bs_local.stop
  end
end

task :parallel do |t, args|
  puts "Running Parallel Tests"
  num_parallel = 4

  config = YAML.load_file('config/parallel.config.yml')

  Parallel.map([*0..(config["browser_caps"].size - 1)], :in_processes => num_parallel) do |task_id|
    temp_conf = config.clone
    temp_conf["browser_caps"] = [ config["browser_caps"][task_id] ]
    run_tests(temp_conf, SingleTest)
  end
end

task :test do |t, args|
  Rake::Task["single"].invoke
  Rake::Task["local"].invoke
  Rake::Task["parallel"].invoke
end
