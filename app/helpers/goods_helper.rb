module GoodsHelper
  def show_page?
    params[:action] = "show" && params[:controller] == "goods"
  end

  def comments_to_show
    if show_page?
      100
    else
      5
    end
  end

  def comment_box_display
    if show_page?
      "block"
    else
      "none"
    end
  end

  def good_collection(goods)
    render partial: 'goods/individual', collection: goods, as: :good
  end
end
