
module DoGood::TestHelper
  def jsonify(response)
    HashWithIndifferentAccess.new(JSON.load(response.body))
  end

  extend self
end

