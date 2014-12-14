module GoodsHelper
  def good_collection(goods)
    render partial: 'goods/individual', collection: goods, as: :good
  end
end
