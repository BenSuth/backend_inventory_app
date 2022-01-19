require "test_helper"

class TagTest < ActiveSupport::TestCase
  def setup
    @item = Item.new({name: "Sample Name", description: "Sample Description", count: 1})
    @item_id = @item.id
    @tag = @item.build_tag({names: ["Sample", "Test"]})
  end

  test "tag should be valid" do
    assert @tag.valid?
  end
end
