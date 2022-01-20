require "csv"

class Export < ApplicationRecord
  validates :external_name, presence: true, length: {minimum:1, maximum:80}
  validates :size, presence: true, format: {with: /\d+\sbytes/}
  
  def self.fetchAll
    Export.all
  end

  def self.fetchId(export_id)
    self.fetchAll.find(export_id)
  end

  def self.insert(params)
    export = Export.create!(params)
    params["id"] = export["id"]
    params
  end

  def self.generateCSV(external_name)
    internal_name = "#{Time.now}_export.csv";
    if Rails.env.development? || Rails.env.test?
      return self.generateCSVLocalStorage(external_name, internal_name)
    end
    client = Aws::S3::Client.new(
      region: "us-east-2",
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    obj = Aws::S3::Object.new(ENV['AWS_BUCKET'], "/#{internal_name}", client: client)

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

  def self.generateCSVLocalStorage(external_name, internal_name) 
    CSV.open("tmp/storage/#{internal_name}", "a+") do |csv|
      csv << ["ID", "Name", "Description", "Count", "Date Created", "Date Last Updated"]
      Item.fetchAll.each do |line|
        csv << [line.id, line.name, line.description, line.count, line.created_at, line.updated_at]
      end
    end
    params = {}
    params["external_name"] = external_name
    params["internal_name"] = internal_name
    params["path"] = "backend_inventory_app/tmp/storage/#{internal_name}"
    params["size"] = "0 bytes"
    params["file_type"] = "csv"
    self.insert(params)
    return params["path"]
  end
end
