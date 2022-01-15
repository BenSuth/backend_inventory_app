module Queries
  class FetchItem < Queries::BaseQuery
    type Types::ItemType, null: false
    argument :item_id, ID, required: true

    def resolve(item_id:)
      Item.fetchId(item_id)
    end
  end 
end