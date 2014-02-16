
module DoGood::ARBCHelper
  def arbc
    if block_given?
      yield ActiveRecord::Base.connection
    end

    ActiveRecord::Base.connection
  end
end

