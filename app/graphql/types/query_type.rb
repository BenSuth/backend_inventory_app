module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :fetch_items, resolver: Queries::FetchItems
    field :fetch_item, resolver: Queries::FetchItem
  end
end
