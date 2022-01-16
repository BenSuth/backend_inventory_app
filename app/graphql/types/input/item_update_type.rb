module Types
  module Input
    class ItemUpdateType < Types::BaseInputObject
      argument :name, String, required: false
      argument :description, String, required: false
      argument :count, Integer, required: false
      argument :tags, [String], required: false    
    end
  end
end
