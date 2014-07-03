begin
  require "jshintrb/jshinttask"
  Jshintrb::JshintTask.new :jshint do |t|
    t.pattern = 'app/assets/javascripts/**/*.js'
    t.options = {
      bitwise: true,
      curly: true,
      eqeqeq: true,
      forin: true,
      immed: true,
      latedef: true,
      newcap: true,
      noarg: true,
      noempty: true,
      nonew: true,
      plusplus: true,
      regexp: true,
      undef: false,
      strict: false,
      trailing: true,
      browser: true
    }
  end
rescue LoadError
  puts 'WARNING: jshintrb not loaded -- tasks not available'
end
