module Queries
    class FetchExports < Queries::BaseQuery
      type [Types::ExportType], null: false
  
      def resolve
        Export.fetchAll
      end
    end 
  end
  