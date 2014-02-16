# encoding: UTF-8

module DoGood::TestHelper
  ARBC = ActiveRecord::Base.connection
  DELTA_TOLERANCE = 0.000001

  def render_slim(source, options = {}, &block)
    options = options.dup
    scope = options.delete(:scope)
    locals = options.delete(:locals)

    Slim::Template.new(options[:file], options) {
      source
    }.render(scope || @env, locals, &block)
  end

  def join_slim(*args)
    options = args.extract_options!
    slim = args.first.strip_heredoc

    args.from(1).each do |b|
      b = b.strip_heredoc.indent({
        under: slim
      }.merge(options))

      slim = "#{slim}#{b}"
    end

    slim
  end

  extend self
end

