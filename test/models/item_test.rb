require "test_helper"

class ItemTest < ActiveSupport::TestCase
  def setup
    @item = Item.new({name: "Sample Name", description: "Sample Description", count: 1})
    @tag = @item.build_tag({names: ["Sample", "Test"]})

    @item_hash = {}
    @item_hash[:name] = "Sample Name"
    @item_hash[:description] = "Sample Description"
    @item_hash[:count] = 1
  end

  test "item should be valid" do
    assert @item.valid?
  end

  test "name should be present" do
    @item.name = " "
    assert_not @item.valid?
  end

  test "name cannot be empty" do
    @item.name = ""
    assert_not @item.valid?
  end

  test "name cannot be longer than 80 characters" do
    @item.name = "s"*81
    assert_not @item.valid?
  end

  test "name can be less than 80 characters" do
    @item.name = "s"*80
    assert @item.valid?
  end

  test "name can be more than 0 characters" do
    @item.name = "s"
    assert @item.valid?
  end

  test "count should be present" do
    @item.count = nil
    assert_not @item.valid?
  end

  test "count cannot be negative" do
    @item.count = -1
    assert_not @item.valid?
  end

  test "count can be positive" do
    @item.count = 1
    assert @item.valid?
  end

  test "insert method should create database entry" do
    res = Item.insert(@item_hash)
    assert Item.find(res["id"])
    assert Tag.where("item_id = #{res["id"]}")
  end

  test "insert method should return database hash" do
    res = Item.insert(@item_hash)
    find = Item.find(res["id"])

    res.each do |key, value|
      assert res["key"] == find["key"]
    end
  end

  test "modify method should update database entry" do
    res = Item.insert(@item_hash)
    Item.modify(res["id"], description: "test")
    find = Item.find(res["id"])

    assert find["description"] == "test"
  end

  # Although I didn't have the time to implement these tests,
  # a seperate suite would need to be developed for the csv generation.
  # Generally, I would write some helper functions to grab the csv
  # and then parse it to ensure that data is being written, and that the data is correct.
  # This would also require more S3 buckets, so that test, development, and production have no overlap
end
