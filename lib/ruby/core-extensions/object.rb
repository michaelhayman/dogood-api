# encoding: UTF-8

class ::Object
  def to_sql_array options = {}
    options = {
      type: :text
    }.merge options

    if self.nil?
      'NULL'
    else
      case options[:type]
        when :integer
          self.to_i.to_s
        when :float, :double, :real
          self.to_f.to_s
        else
          "'#{self.to_s.gsub("'", "''")}'"
      end
    end
  end

  def try_quietly(method, *args, &block)
    self.try(method, *args, &block) if self.respond_to?(method)
  end
end
