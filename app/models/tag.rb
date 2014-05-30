class Tag < SimpleHashtag::Hashtag
  def self.popular
    @popular = SimpleHashtag::Hashtagging.group(:hashtag_id).
      order(count: :desc).
      limit(10).
      count
    @popular = @popular.collect {|ind| ind[0]}
    Tag.where(id: @popular)
  end
end

