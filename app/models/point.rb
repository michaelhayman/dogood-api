class Point < ActiveRecord::Base
  ALLOWABLE_TYPES = [
    "Good",
    "User"
  ]

  ALLOWABLE_SUB_TYPES = [
    "Post",
    "Report",
    "Like",
    "Unlike"
  ]

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

  def self.points_for(pointable_type, pointable_id)
    Point.where(
      :pointable_id => pointable_id,
      :pointable_type => pointable_type).
      sum(:points)
  end

  def log(msg)
    p "Point: #{self} #{msg}"
  end
end

