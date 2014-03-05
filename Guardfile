
Bundler.require(:guard)

ignore /~$/
ignore /\/?\.\#/
ignore /^(?:.*[\\\/])?\.[^\\\/]+\.sw[p-z]$/
ignore /\.orig$/
ignore /\.(BACKUP|BASE|LOCAL|REMOTE)\.\d+/

rails_test_set = proc {
  watch(%r{^test/(.+)_test\.rb})

  watch(%r{^test/test_helper.rb}) {
    'test'
  }

  watch(%r{^app/models/(.+)\.rb$}) { |m|
    "test/unit/models/#{m[1]}_test.rb"
  }

  watch(%r{^lib/(.+)\.rb$}) { |m|
    "test/unit/lib/#{m[1]}_test.rb"
  }

  watch(%r{^app/controllers/(.+)\.rb$}) { |m|
    "test/functional/controllers/#{m[1]}_test.rb"
  }

  watch(%r{^app/decorators/(.+)\.rb$}) { |m|
    "test/unit/decorators/#{m[1]}_test.rb"
  }

  watch(%r{^app/helpers/(.+)\.rb$}) { |m|
    "test/unit/helpers/#{m[1]}_test.rb"
  }

  watch(%r{^app/serializers/(.+)\.rb$}) { |m|
    "test/unit/serializers/#{m[1]}_test.rb"
  }

  watch(%r{^app/mailers/(.+)\.rb$}) { |m|
    "test/unit/mailers/#{m[1]}_test.rb"
  }

  watch('config/routes.rb') {
    ['test/functional', 'test/integration']
  }
}

DEFAULT_OPTIONS = {
  :rspec => false,
  :test_unit => true,
  :run_all => true,
  :bundler => true,
  :test_folders => 'test'
}

guard 'minitest', DEFAULT_OPTIONS.merge(
  :zeus => !!ENV['USE_ZEUS']
) do
  self.instance_eval(&rails_test_set)
end unless ENV['NO_MINITEST'] || ENV['USE_SPIN']

guard 'jasmine', {
  :timeout => 30,
  :server_timeout => 30,
  :port => 3333
} do
  watch(%r{spec/javascripts/spec\.js$}) {
    'spec/javascripts'
  }

  watch(%r{spec/javascripts/.+_spec\.js$})

  watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)(?:\.\w+)*$}) { |m|
    "spec/javascripts/#{m[1]}_spec.js"
  }
end if ENV['USE_JASMINE']

guard 'spin', DEFAULT_OPTIONS do
  self.instance_eval(&rails_test_set)
end if ENV['USE_SPIN']

if File.exists?('Guardfile.local')
  instance_eval File.read('Guardfile.local')
end

