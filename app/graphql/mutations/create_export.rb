module Mutations
  class CreateExport < Mutations::BaseMutation
    argument :params, Types::Input::ExportInputType, required: true
    field :path, String

    def resolve(params:)
      {path: Export.generateCSV(params.external_name)}
    end
  end
end