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
      p query
      if query
        query = query.sub(/^#/, '')
        where('title LIKE ?', "%#{query}%").limit(20)
      end
    end

    def link_ids_matching_name(name)
      where(entityable_type: "Good", title: name).map(&:link_id)
    end
  end
end

