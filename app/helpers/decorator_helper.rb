module DecoratorHelper
  private
    def paginated_entries(entries)
      entries.paginate(@pagination_options).decorate
    end
end

