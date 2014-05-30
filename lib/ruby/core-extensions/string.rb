# encoding: UTF-8

class ::String
  def to_natcmp(nocase = false)
    x = if nocase
      self.downcase
    else
      self
    end

    i = true
    x.split(/(\d+)/).collect { |z| (i = !i) ? z.to_i : z }
  end

  # A "natural" sorting comparison. natcmp splits the String into an Array
  # and compares arrays, i.e.
  #
  #  "foo100".natcmp "foo20"
  #
  # Normally, a regular ol' <=> comparison would return -1 because the 1 in
  # "foo100" is compared against the 2 in "foo20" without regard to the
  # actual trailing zeroes, which would have more meaning to a human than
  # the standard comparison or sorting algorithm would.
  #
  # With natcmp, 1 is returned, so the final sorting order would be "foo20",
  # "foo100".
  #
  # So, like the standard <=> method in String, -1, 0 and 1 are returned,
  # but consideration for numerical values is taken into account. Basically,
  # the String is broken up into an Array and the Array method <=> is used
  # for the comparison.
  def natcmp y, nocase = false
    self.to_natcmp(nocase) <=> y.to_natcmp(nocase)
  end

  begin
    raise ArgumentError if ("a %{x}" % {:x=>'b'}) != 'a b'
  rescue ArgumentError
    alias :_old_format :% # :nodoc:
    # An enhanced sprintf, partially borrowed from the Ruby GetText extension.
    def %(args)
      if args.kind_of?(Hash)
        ret = self.dup
        args.each { |key, value| ret.gsub!(/\%\{#{key}\}/, value.to_s) }
        ret
      else
        ret = gsub(/%\{/, '%%{')
        ret._old_format(args)
      end
    end
  end

  # Remove accents such and return just the ASCII string.
  def strip_accents
    self.mb_chars.is_a?(String) ? self : self.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/u, '').to_s
  end

  # In-place version of strip_accents.
  def strip_accents!
    self.replace self.strip_accents
  end

  # Remove accents, strange characters, gratuitous whitespace and other such
  # nonsense to give us our "normalized" string for easier comparisons.
  def normalize
    self.strip_accents.upcase.gsub(/[']+/, '').gsub(/[^A-Z0-9\s]+/, ' ').gsub(/\s+/, ' ').strip.to_s
  end

  # In-place version of normalize.
  def normalize!
    self.replace self.normalize
  end

  # Splits up an SQL array string and makes it a Ruby Array. This is only
  # useful for PostgreSQL's array types, and it's only one dimensional at
  # the moment, so if you happen to have a multi-dimensional array you'll
  # have to do some extra magic to make it work.
  #
  # This method was partially inspired by a similar function in phpPgAdmin.
  #
  # See Array#to_sql_array for the opposite.
  def from_sql_array
    retval = Array.new
    quotes = false

    # Chop off the leading and trailing braces...
    str = self[1..-2]
    j = 0

    # Scan through the characters, looking for quotes and grabbing Array
    # elements when we find them.
    str.split(//).each_with_index do |c, i|
      if c == '"' && (i == 0 || str[i - 1].chr != '\\')
        quotes = !quotes
      elsif c == ',' && !quotes
        retval << str[j, i - j]
        j = i + 1
      end
    end

    # Plop on the rest of the string that wasn't accounted for above.
    retval << str[j..-1]

    # Get rid of escapes on quotes and backslashes.
    retval.each_with_index do |v, i|
      retval[i] = v.gsub(/^\"(.*)\"$/, '\1').gsub(/\\\"/, '"').gsub(/\\\\/, '\\')
    end
  end

  def to_tsquery(options = {})
    options = {
      type: :and
    }.merge(options)

    search_function = case options[:type]
      when :and
        'plainto_tsquery'
      when :or
        'plainto_or_tsquery'
      when :boolean
        'to_tsquery'
      else
        raise ArgumentError.new("Expected one of :and, :or or :boolean for option :type")
    end

    "#{search_function}(%s)" %
      [ (options[:locale].to_s if options[:locale]), self ].compact.collect { |s|
        "'#{s.gsub("'", "''")}'"
      }.join(', ')
  end

  # Constant-time comparison algorithm to prevent timing attacks. Borrowed
  # from ActiveSupport::MessageVerifier and made public on String.
  def secure_compare(other)
    return false unless self.bytesize == other.bytesize

    l = self.unpack "C#{self.bytesize}"

    res = 0
    other.each_byte { |byte| res |= byte ^ l.shift }
    res == 0
  end

  # Strip `str` from both sides of the String destructively. Returns nil if
  # no change was made.
  def sstrip!(str)
    str = Regexp.quote(str)
    self.gsub!(/^(#{str})+|(#{str})+$/, '')
  end

  # Non-destructive version of #sstrip!.
  def sstrip(str)
    self.dup.tap { |duped|
      duped.sstrip!(str)
    }
  end

  # Strip `str` from the left side of the String destructively. Returns nil if
  # no change was made.
  def lsstrip!(str)
    str = Regexp.quote(str)
    self.gsub!(/^(#{str})+/, '')
  end

  # Non-destructive version of #lsstrip!.
  def lsstrip(str)
    self.dup.tap { |duped|
      duped.lsstrip!(str)
    }
  end

  # Strip `str` from the right side of the String destructively. Returns nil if
  # no change was made.
  def rsstrip!(str)
    str = Regexp.quote(str)
    self.gsub!(/(#{str})+$/, '')
  end

  # Non-destructive version of #rsstrip!.
  def rsstrip(str)
    self.dup.tap { |duped|
      duped.rsstrip!(str)
    }
  end

  # :call-seq:
  #   indent(multiplier = 2, options = {})
  #   indent(options = {})
  #
  # Indent each line of a String.
  #
  # Options:
  #
  # * `:string` - the string to use for indentation. The default is a single
  #   space.
  # * `:multiplier` - the level of indentation to use. The default is 2. This
  #   option can be given directly as the first argument to the method.
  # * `:under` - another String that can be used to extract the indentation
  #   multiplier. When using the `:under` option, we look at the last line of
  #   the `:under` String and determine its level of indentation based on the
  #   `:string` option and use it to adjust the multiplier as necessary. We
  #   will always take the floor'd value in the case of a fractional values,
  #   so if precision is necessary you should set the values manually. The
  #   `:multiplier` option is ignored when using the `:under` option.
  # * `:after` - use the `:after` option when you want the indentation to
  #   come after the String specified in `:under` rather than indented
  #   within the `:under` String itself, i.e. unindent the string one level.
  def indent(*args)
    options = {
      string: ' '
    }.merge(args.extract_options!)

    indentation = ''

    if options[:under]
      regexp = /^((?:#{Regexp.quote(options[:string])})+)/

      under_a = options[:under].lines.to_a[-2][regexp].length rescue 0
      under_b = options[:under].lines.to_a[-1][regexp].length
      under = (under_a - under_b).abs

      multiplier = (under / options[:string].length.to_f).floor
      multiplier = multiplier - 1 if options[:after]

      indentation << $1
    else
      multiplier = options[:multiplier] || args.first || 2
    end

    multiplier = 0 if multiplier < 0
    indentation << options[:string] * multiplier

    self.lines.collect { |line|
      "#{indentation}#{line}"
    }.join
  end

  def indent!(*args)
    self.replace(self.indent(*args))
  end
end
