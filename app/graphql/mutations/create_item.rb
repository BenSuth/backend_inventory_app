module Mutations
  class CreateItem < Mutations::BaseMutation
    argument :params, Types::Input::ItemInputType, required: true
    
    field :item, Types::ItemType, null: false

    def resolve(params:)
      item_params = Hash params
      begin 
        item = Item.create!(item_params)
        {item: item}
      end 
    end
  end
end

