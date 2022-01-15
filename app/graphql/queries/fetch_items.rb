module Queries
  class FetchItems < Queries::BaseQuery
    type [Types::ItemType], null: false

    def resolve
      Item.all.order(created_at: :desc)
    end
  end 
end
