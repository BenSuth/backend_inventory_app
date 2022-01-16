module Mutations 
  class UpdateItem < Mutations::BaseMutation
    argument :params, Types::Input::ItemUpdateType, required: true
    argument :item_id, ID, required: true
    field :item, Types::ItemType, null: false

    def resolve(item_id:, params:)  
      {item: Item.modify(item_id, Hash(params))}
    end
  end
end