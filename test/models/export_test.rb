require "test_helper"

class ExportTest < ActiveSupport::TestCase
  def setup
    @export = Export.new({external_name: "Sample Name", internal_name: "Sample.csv", path: "https://backend-inventory-app.s3.us-east-2.amazonaws.com/", size:"555 bytes", file_type: "csv"})
    @export_hash = {}
    @export_hash[:external_name] = "Sample Name"
    @export_hash[:internal_name] = "Sample.csv"
    @export_hash[:path] = "https://backend-inventory-app.s3.us-east-2.amazonaws.com/" 
    @export_hash[:size] = "555 bytes"
    @export_hash[:file_type] = "csv"
    
  end

  test "item should be valid" do
    assert @export.valid?
  end

  test "external_name should be present" do
    @export.external_name = " "
    assert_not @export.valid?
  end

  test "name cannot be empty" do
    @export.external_name = ""
    assert_not @export.valid?
  end

  test "external_name cannot be longer than 80 characters" do
    @export.external_name = "s"*81
    assert_not @export.valid?
  end

  test "external_name can be less than 80 characters" do
    @export.external_name = "s"*80
    assert @export.valid?
  end

  test "external_name can be more than 0 characters" do
    @export.external_name = "s"
    assert @export.valid?
  end

  test "insert method should create database entry" do
    res = Export.insert(@export_hash)
    assert Export.find(res["id"])
  end

  test "insert method should return database hash" do
    res = Export.insert(@export_hash)
    find = Export.find(res["id"])

    res.each do |key, value|
      assert res["key"] == find["key"]
    end
  end

  test "size must be formatted in bytes" do
    @export.size = "500 gb"
    assert_not @export.valid?
  end
end
