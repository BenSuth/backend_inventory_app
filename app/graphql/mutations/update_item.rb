module Mutations 
  class UpdateItem < Mutations::BaseMutation
    argument :item_id, ID, required: true
    argument :name, String, required: false, default: ""
    argument :description, String, required: false, default: ""
    argument :count, Integer, required: false, default: -1
    argument :tags, [String], required: false, default: []

    field :item, Types::ItemType, null: false

    def resolve(item_id:, name:, description:, count:, tags:) 
      
    end
  end
end