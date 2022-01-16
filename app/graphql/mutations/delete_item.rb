module Mutations 
  class DeleteItem < Mutations::BaseMutation
    argument :item_id, ID, required: true
    field :item, Types::ItemType, null: false

    def resolve(item_id:)  
      {item: Item.softDelete(item_id)}
    end
  end
end