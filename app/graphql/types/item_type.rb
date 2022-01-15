module Types
  class ItemType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: true
    field :count, Integer, null: false
    field :tags, [String], null: true
    # field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    # field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    # field :deleted_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
