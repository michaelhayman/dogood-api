
Bundler.require(:guard)

ignore /~$/
ignore /\/?\.\#/
ignore /^(?:.*[\\\/])?\.[^\\\/]+\.sw[p-z]$/
ignore /\.orig$/
ignore /\.(BACKUP|BASE|LOCAL|REMOTE)\.\d+/

guard :minitest, spring: 'rake test', all_on_start: false do
  watch(%r{^test/(.+)_test\.rb})

  watch(%r{^test/test_helper.rb}) {
    'test'
  }

  watch(%r{^app/models/(.+)\.rb$}) { |m|
    "test/unit/models/#{m[1]}_test.rb"
  }

  watch(%r{^app/models/validators/(.+)\.rb$}) { |m|
    "test/unit/models/validators/#{m[1]}_test.rb"
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
end

