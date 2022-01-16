class Export < ApplicationRecord
  def self.fetchAll
    Export.all
  end

  def self.fetchId(export_id)
    self.fetchAll.find(export_id)
  end

  def self.insert(params)
    export = Export.create!(params)
    params
  end

  def self.generateCSV(external_name)
    client = Aws::S3::Client.new(
      region: "us-east-2",
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    internal_name = "#{Time.now}_export.csv";
    obj = Aws::S3::Object.new(ENV['AWS_BUCKET'], "/#{internal_name}", client: client)

    require "csv"
    obj.upload_stream(content_type: "text/csv; charset=UTF-8") do |write_stream|
      CSV(write_stream) do |csv|
        csv << ["ID", "Name", "Description", "Count", "Date Created", "Date Last Updated"]
        Item.fetchAll.each do |line|
          csv << [line.id, line.name, line.description, line.count, line.created_at, line.updated_at]
        end
      end
    end
    params = {}
    params["external_name"] = external_name
    params["internal_name"] = internal_name
    params["path"] = obj.public_url
    params["size"] = "#{obj.size} bytes"
    params["file_type"] = "csv"
    self.insert(params)
    obj.public_url
  end
end
