module Queries
  class FetchExport < Queries::BaseQuery
    type Types::ExportType, null: false
    argument :export_id, ID, required: true

    def resolve(export_id:)
      Export.fetchId(item_id)
    end
  end 
end