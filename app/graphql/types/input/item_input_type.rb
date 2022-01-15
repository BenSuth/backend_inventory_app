module Types
  module Input
    class ItemInputType < Types::BaseInputObject
      argument :name, String, required: true
      argument :description, String, required: false
      argument :count, Integer, required: true
      argument :tags, [String], required: true    
    end
  end
end