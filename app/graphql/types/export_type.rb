module Types
  class ExportType < Types::BaseObject
    field :id, ID, null: false
    field :external_name, String, null: false
    field :internal_name, String, null: false
    field :path, String, null: false
    field :size, String, null: false
    field :file_type, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    # field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
