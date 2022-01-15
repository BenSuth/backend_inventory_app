module Queries
  class FetchItem < Queries::BaseQuery
    type Types::ItemType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      Item.find(id)
    end
  end 
end