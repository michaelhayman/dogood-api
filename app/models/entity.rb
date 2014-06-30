class Entity < ActiveRecord::Base
  belongs_to :entityable,
    polymorphic: true

  validates :link_type,
    presence: { message: "Entities must have a link type." }

  validates :title,
    presence: { message: "Entities must have a title." }

  validates :range,
    presence: { message: "Enter a range." }

  validates_associated :entityable

  before_save :add_link_id

  def add_link_id
    self.link_id = self.entityable_id unless link_id_present?
  end

  def link_id_present?
    if self.link_id.present?
      if self.link_id == 0
        false
      else
        true
      end
    else
      false
    end
  end

  def send_notification
    if user = User.find_by_id(link_id)

      if entityable_type == "Comment"
        if comment = Comment.find_by_id(entityable_id)
          if link_type == "user"
            message = "#{comment.user.full_name} mentioned you in a comment"
            url = "dogood://goods/#{comment.commentable_id}"
            if comment.good
              NotifierWorker.perform_async(message, user.id, { url: url })
            end
          end
        end
      end

      if entityable_type == "Good"
        if good = Good.find_by_id(entityable_id)
          if link_type == "user"
            message = "#{good.user.full_name} mentioned you in a good post"
            url = "dogood://goods/#{good.id}"
            NotifierWorker.perform_async(message, user.id, { url: url })
          end
        end
      end
    end
  end
end

