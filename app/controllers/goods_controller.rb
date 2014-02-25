class GoodsController < ApplicationController
  before_filter :check_auth, only: :create
  before_filter :check_auth_silently,
    only: [
      :index,
      :tagged,
      :popular,
      :nearby,
      :liked_by,
      :posted_or_followed_by
    ]

  def index
    if params[:category_id]
      @goods = Good.in_category(params[:category_id]).
        page(params[:page]).
        newest_first.
        extra_info
    elsif params[:good_id]
      @goods = Good.specific(params[:good_id]).
        page(params[:page]).
        newest_first.
        extra_info
    else
      @goods = Good.most_relevant.
        page(params[:page]).
        newest_first.
        extra_info
    end

    @goods = Good.meta_stream(@goods, current_user)

    respond_with @goods
  end

  def tagged
    if params[:id] && params[:id] != "(null)"
      hashtag = SimpleHashtag::Hashtag.find(params[:id])
    elsif params[:name]
      hashtag = SimpleHashtag::Hashtag.find_by_name(params[:name])
    end

    hashtagged_elements = hashtag.hashtagged_ids_for_type("Good") if hashtag

    @goods = Good.where(:id => hashtagged_elements).
      page(params[:page]).
      extra_info.
      newest_first

    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  def popular
    @goods = Good.
      popular.
      page(params[:page]).
      extra_info

    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  def nearby
    @goods = Good.
      nearby(params[:lat], params[:lng]).
      page(params[:page]).
      extra_info

    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  def liked_by
    @goods = Good.
      page(params[:page]).
      newest_first.
      liked_by_user(params[:user_id])

    @goods = Good.meta_stream(@goods, current_user)
    respond_with @goods
  end

  def posted_or_followed_by
    @goods = Good.
      page(params[:page]).
      newest_first.
      posted_or_followed_by(params[:user_id]).
      extra_info

    if current_user
      @goods = Good.meta_stream(@goods, current_user)
    end
    respond_with @goods
  end

  def nominations
    @goods = Good.
      page(params[:page]).
      newest_first.
      nominations(params[:user_id]).
      extra_info

    if current_user
      @goods = Good.meta_stream(@goods, current_user)
    end
    respond_with @goods
  end

  def create
    begin
      raise DoGood::Api::Unauthorized.new if !logged_in?
      raise DoGood::Api::TooManyQueries.new if Good.just_created_by(dg_user)

      @good = Good.new(resource_params)
      @good.user_id = current_user.id
      @good.evidence = resource_params[:evidence]

      if !@good.save
        if @good.errors
          message = @good.errors.full_messages
        else
          message = "Couldn't save the good."
        end
        raise DoGood::Api::RecordNotSaved.new(message)
      end

    rescue DoGood::Api::TooManyQueries => error
      @status_code = D_STATUS[:unauthorized]
      render_error(error)
      return
    rescue DoGood::Api::Unauthorized => error
      @status_code = D_STATUS[:unauthorized]
      render_error(error)
      return
    rescue DoGood::Api::ParametersInvalid => error
      @status_code = D_STATUS[:bad_request]
      render_error(error)
      return
    rescue ActionController::ParameterMissing => error
      @status_code = D_STATUS[:bad_request]
      render_error(DoGood::Api::ParametersInvalid.new)
      return
    rescue DoGood::Api::RecordNotSaved => error
      @status_code = D_STATUS[:error]
      render_error(error)
      return
    end

    render :json => dapi_callback_wrapper_new_style(:status => :ok)
  end

  def resource_params
    params.require(:good).permit(:caption, :evidence, :user_id, :category_id, :lat, :lng, :location_name, :location_image, :done, :nominee_attributes => [ :full_name, :email, :phone, :user_id, :twitter_id, :facebook_id ], :entities_attributes => [ :entityable_id, :entityable_type, :link, :link_id, :link_type, :title, :range => [] ])
  end
  private :resource_params

end

