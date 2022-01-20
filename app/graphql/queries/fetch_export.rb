module Queries
  class FetchExport < Queries::BaseQuery
    type Types::ExportType, null: false
    argument :export_id, ID, required: true

    def resolve(export_id:)
      Export.fetchId(export_id)
    end
  end 
end