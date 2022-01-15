module Queries
  class FetchItems < Queries::BaseQuery
    type [Types::ItemType], null: false

    def resolve
      Item.fetchAll
    end
  end 
end
