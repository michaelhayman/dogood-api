class DoGood::WillPaginateCollectionDecorator < Draper::CollectionDecorator
  # support for will_paginate
  delegate :current_page, :total_entries, :total_pages, :per_page, :offset

  def meta
    {
      pagination: {
        current_page: object.current_page,
        total_pages: object.total_pages,
        total_entries: object.total_entries,
        per_page: object.per_page,
        offset: object.offset
      }
    }
  end
end
