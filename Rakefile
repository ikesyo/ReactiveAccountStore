# Originally from https://github.com/kishikawakatsumi/CollectionUtils/blob/bda0fdc6c92eedbc9332d80466b1260c7a1e8380/Rakefile

DESTINATIONS = [
                "name=iPhone Retina (3.5-inch),OS=7.1",
                "name=iPhone Retina (4-inch),OS=7.1",
                "name=iPhone Retina (4-inch 64-bit),OS=7.1"
               ]

task :default => [:clean, :build, :test]

desc "clean"
task :clean do |t|
  schemes = get_schemes.gsub(/'/, '').split(' ')
  schemes.each do |scheme|
    options = {
      workspace: "#{get_workspace}",
      scheme: "#{scheme}"
    }
    options = join_option(options: options, prefix: "-", seperator: " ")
    settings = {
      CODE_SIGN_IDENTITY: "",
      CODE_SIGNING_REQUIRED: "NO"
    }
    settings = join_option(options: settings, prefix: "", seperator: "=")
    sh "xcodebuild #{options} #{settings} clean | xcpretty -c; exit ${PIPESTATUS[0]}"
  end
end

desc "build"
task :build do |t|
  schemes = get_schemes.gsub(/'/, "").split(" ")
  schemes.each do |scheme|
    options = {
      workspace: "#{get_workspace}",
      scheme: "#{scheme}"
    }
    options = join_option(options: options, prefix: "-", seperator: " ")
    settings = {
      CODE_SIGN_IDENTITY: "",
      CODE_SIGNING_REQUIRED: "NO"
    }
    settings = join_option(options: settings, prefix: "", seperator: "=")
    sh "xcodebuild #{options} #{settings} build | xcpretty -c; exit ${PIPESTATUS[0]}"
  end
end

desc "run unit tests"
task :test do |t|
  schemes = get_schemes.gsub(/'/, "").split(" ")
  schemes.each do |scheme|
    DESTINATIONS.each do |destination|
      options = {
        workspace: "#{get_workspace}",
        scheme: "#{scheme}",
        configuration: "Debug",
        sdk: "iphonesimulator",
        destination: "#{destination}"
      }
      options = join_option(options: options, prefix: "-", seperator: " ")
      settings = {
        OBJROOT: "build",
        GCC_INSTRUMENT_PROGRAM_FLOW_ARCS: "YES",
        GCC_GENERATE_TEST_COVERAGE_FILES: "YES"
      }
      settings = join_option(options: settings, prefix: "", seperator: "=")
      sh "xcodebuild test #{options} | xcpretty -tc; exit ${PIPESTATUS[0]}"
    end
  end
end

desc "send coverage reports to Coveralls"
task :send_coverage do |t|
  sh "coveralls -e External -e Pods -e ReactiveAccountStoreDemo"
end

def get_workspace
  ENV["WORKSPACE"]
end

def get_schemes
  ENV["SCHEMES"]
end

def join_option(options: {}, prefix: "", seperator: "")
  _options = options.map { |k, v| %(#{prefix}#{k}#{seperator}"#{v}") }
  _options = _options.join(" ")
end
