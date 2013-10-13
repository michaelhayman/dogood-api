class Point < ActiveRecord::Base
  ALLOWABLE_TYPES = %w{
    Good
    User
    ClaimedReward
  }

  ALLOWABLE_SUB_TYPES = %w{
    Post
    Report
    Like
    Unlike
    Claim
    Refund
  }

  RANKS = HashWithIndifferentAccess.new({
    0 => "-",
    100 => "E",
    1000 => "D",
    3000 => "C",
    5000 => "B",
    10000 => "A"
  })

  belongs_to :pointable,
    :polymorphic => true

  belongs_to :to_user,
    :foreign_key => "to_user_id",
    :class_name => "User"
  belongs_to :from_user,
    :foreign_key => "from_user_id",
    :class_name => "User"

  validates_uniqueness_of :to_user_id,
    :scope => [
      :pointable_id,
      :pointable_type,
      :pointable_sub_type
    ]

  validates_presence_of :to_user_id,
    :pointable_id,
    :pointable_type,
    :pointable_sub_type,
    :points

  def self.remove_points(pointable_type,
    pointable_id,
    pointable_sub_type, to_user_id,
    from_user_id = nil, points)

    point = Point.where(
      :pointable_type => pointable_type,
      :pointable_id => pointable_id,
      :pointable_sub_type => pointable_sub_type,
      :to_user_id => to_user_id,
      :from_user_id => from_user_id).first

    if point
      if !ALLOWABLE_TYPES.include?(pointable_type)
        point.log("That type is not allowed.")
        return
      end

      if !ALLOWABLE_SUB_TYPES.include?(pointable_sub_type)
        point.log("That subtype is not allowed.")
        return
      end

      if point.destroy
      else
        point.log("Couldn't destroy that point.")
      end
    else
      log("Couldn't find that point.")
    end
  end

  def self.record_points(pointable_type,
    pointable_id,
    pointable_sub_type, to_user_id,
    from_user_id = nil, points)

    point = Point.new(
      :pointable_type => pointable_type,
      :pointable_id => pointable_id,
      :pointable_sub_type => pointable_sub_type,
      :to_user_id => to_user_id,
      :from_user_id => from_user_id,
      :points => points)

    if !ALLOWABLE_TYPES.include?(pointable_type)
      point.log("That type is not allowed.")
      return
    end

    if !ALLOWABLE_SUB_TYPES.include?(pointable_sub_type)
      point.log("That subtype is not allowed.")
      return
    end

    if to_user_id == from_user_id
      point.log("Can't give yourself the points.")
      return
    end

    if !point.cap_reached?
      if point.valid?
        point.save
      else
        point.log("Point invalid, not saving. #{point}")
      end
    else
      point.log("Point cap reached for that type. #{point}")
    end
  end

  def cap_reached?
    Point.points_for(self.pointable_type, self.pointable_id) > 99
  end

  def self.points_for_user(user_id)
    Point.where(:to_user_id => user_id).sum(:points)
  end

  def self.score_for_user(user_id)
    @points = Point.where(:to_user_id => user_id)

    weight = 1.0
    score = 0.0
    @points.each do |p|
      if p.created_at > 7.days.ago
        weight = 1
      elsif p.created_at > 30.days.ago
        weight = 0.8
      elsif p.created_at > 60.days.ago
        weight = 0.6
      elsif p.created_at > 90.days.ago
        weight = 0.3
      else
        weight = 0.1
      end
      score += (p.points * weight)
    end

    return score
  end

  def self.rank_for_user(user_id)
    score = self.score_for_user(user_id)

    RANKS.each { |key, value|
      if score <= key
        return value
      end
    }
  end

  def self.points_for(pointable_type, pointable_id)
    Point.where(
      :pointable_id => pointable_id,
      :pointable_type => pointable_type).
      sum(:points)
  end

  private

    def log(msg)
      p "Point: #{self} #{msg}"
    end
end

