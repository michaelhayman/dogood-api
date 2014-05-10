# encoding: UTF-8

class ::Module
  [ :private, :protected, :public ].each do |type|
    self.class_eval <<-EOF
      def include_#{type}(*args)
        args.each do |mdl|
          include(mdl)
          mdl.instance_methods.each do |mthd|
            #{type}(mthd)
          end
        end
      end
    EOF
  end
end

