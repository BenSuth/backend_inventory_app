module Types
  module Input
    class ExportInputType < Types::BaseInputObject
      argument :external_name, String, required: true  
    end
  end
end