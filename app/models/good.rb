class Good < ActiveRecord::Base
  include DoGood::Reportable

  GOOD_POINTS = 4

  mount_uploader :evidence, EvidenceUploader

  acts_as_commentable

  acts_as_followable

  acts_as_votable

  acts_as_mappable

  before_save :scrub_nominee

  reportable!

  attr_accessor :current_user_voted,
    :current_user_commented,
    :current_user_followed

  belongs_to :category
  belongs_to :user
  has_many :entities, as: :entityable, dependent: :destroy

  belongs_to :nominee, dependent: :destroy

  validates :nominee,
    presence: {
      message: "is required.",
      if: Proc.new { |good| good.done === true }
    }

  validates :nominee, :'validators/nominee' => true

  validates :caption,
    presence: { message: "Enter a name." },
    length: { maximum: 500, message: "Please enter a shorter caption." }

  validates :user_id,
    presence: { message: "Goods must be associated with a user." }

  accepts_nested_attributes_for :entities, limit: 10

  accepts_nested_attributes_for :nominee, limit: 1

  scope :standard, -> { limit(20) }

  scope :done, ->(bool) {
    where(done: bool)
  }

  scope :popular, -> {
    order('
      cached_comments_count * 3 +
      cached_followers_count * 1.5 +
      cached_votes_up desc').
    where('created_at > ?', 2.weeks.ago)
  }

  scope :with_location, -> {
    where('lat <> ? and lng <> ?', 0, 0)
  }

  scope :newest_first, -> {
    order("goods.created_at desc")
  }

  def scrub_nominee
    if !self.done
      self.nominee = nil
    end
  end

  def send_notification
    if self && self.done && self.nominee.user_id
      message = "#{self.user.full_name} nominated you!"
      url = "dogood://goods/#{self.id}"
      NotifierWorker.perform_async(message, self.nominee.user_id, { url: url })
    end
  end

  def send_invite?
    false
  end

  def self.in_category(id)
    where(category_id: id)
  end

  def self.most_relevant
    limit(10)
  end

  def self.specific(id)
    where("id = ?", id)
  end

  def self.nearby(lat, lng)
    with_location.within(
      30,
      units: :kms,
      origin: [ lat , lng])
  end

  def self.nominations_for_user(user_id)
    where("nominees.user_id = ?", user_id).
      joins(:nominee)
  end

  def self.followed_by_user(user_id)
    follows_table = Follow.arel_table

    includes(:followings).
      where(follows_table[:follower_id].eq(user_id)).
      references(:followings)
  end

  def self.voted_by_user(user_id)
    if user_id
      @user = User.find(user_id)
      @user.get_voted Good
    end
  end

  def self.nominations_by_user(user_id)
    where("done = ? AND user_id = ?", true, user_id)
  end

  def self.help_wanted_by_user(user_id)
    where("done = ? AND user_id = ?", false, user_id)
  end

  def self.just_created_by(user_id)
    good = self.where("user_id = ? AND created_at > ?", user_id, 60.seconds.ago)
    good.present?
  end

  def self.extra_info
    includes(:user, :nominee, :category, :entities, comments: [ :user, :entities ])
  end
end

