class Tag < Entity
  default_scope { where(link_type: "tag") }

  class << self
    def full_list
      select(:title).
        group(:title).
        order(count: :desc)
    end

    def popular
      select(:title).
        group(:title).
        limit(10).
        order(count: :desc)
    end

    def matching(query)
      if query.present?
        query = query.sub(/^#/, '')
        where('title LIKE ?', "_#{query}%").
          select(:title).
          uniq.
          limit(10)
      else
        self.popular
      end
    end

    def link_ids_matching_name(name)
      where(title: name).map(&:link_id)
    end
  end
end

