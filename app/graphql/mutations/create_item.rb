module Mutations
  class CreateItem < Mutations::BaseMutation
    argument :params, Types::Input::ItemInputType, required: true
    field :item, Types::ItemType, null: false

    def resolve(params:)
      {item: Item.insert(Hash(params))}
    end
  end
end

