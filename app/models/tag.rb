class Tag < Entity
  default_scope { where(link_type: "tag") }

  class << self
    def popular
      select(:title).
        group(:title).
        limit(10).
        order(count: :desc)
    end

    def matching(query)
      if query.present?
        query = query.sub(/^#/, '')
        where('title LIKE ?', "%#{query}%").
          select(:title).
          uniq.
          limit(10)
      else
        self.popular
      end
    end

    def link_ids_matching_name(name)
      where(entityable_type: "Good", title: name).map(&:link_id)
    end
  end
end

