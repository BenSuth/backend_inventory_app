require "test_helper"

class GraphqlItemTest < ActionDispatch::IntegrationTest
  def setup
    @item_hash = {}
    @item_hash[:name] = "Sample Name"
    @item_hash[:description] = "Sample Description"
    @item_hash[:count] = 1
    @item_hash[:tags] = ["Sample", "Tags"]
    @item_id = 0
    (1..5).each do 
      res = Item.insert(@item_hash)
      @item_id = res["id"]
    end

    @insert_res = Item.insert(@item_hash)
  end

  def insert_template(name, count) 
    mutation_string = <<-GRAPHQL
      mutation($name: String!, $description: String!, $count: Int!, $tags: [String!]!){
        createItem(input: {
          params: {
            name: $name
            description: $description
            count: $count
            tags: $tags
          }
        }) {
            item {
              id
              name
              description
              count
              tags
          }
        }
      }
    GRAPHQL
    BackendInventoryAppSchema.execute(mutation_string, variables:{name: name, description: "sample description", count: count, tags:["test", "sample"]})
  end

  def update_template(item_id, name, count, description, tags) 
    mutation_string = <<-GRAPHQL
      mutation($itemId: ID!, $name: String, $description: String, $count: Int, $tags: [String!]) {
        updateItem(input: {
            itemId: $itemId
            params:{
              name: $name
              description: $description
              count: $count
              tags: $tags
            }
          }) {
            item {
              id
              name
              description
              count
              tags
            }
        }
    }
    GRAPHQL
    BackendInventoryAppSchema.execute(mutation_string, variables:{itemId: item_id, name: name, description:description, count: count, tags: tags})
  end

  test "fetchItems query should return all items" do
    query_string = <<-GRAPHQL
      query {
        fetchItems {
          id
          name
          description
          tags
        }
      }
    GRAPHQL
    result = BackendInventoryAppSchema.execute(query_string)
    result.to_h["data"]["fetchItems"].each do |value|
      assert value["name"] == @item_hash[:name]
      assert value["tags"] == @item_hash[:tags]
    end
  end

  test "fetchItem query should return item with matching ID" do
    query_string = <<-GRAPHQL
      query($itemId: ID!) {
        fetchItem(itemId: $itemId) {
          id
          name
          description
          tags
          count
        }
      }
    GRAPHQL
    result = BackendInventoryAppSchema.execute(query_string, variables:{itemId: @item_id})
    res_hash = result.to_h["data"]["fetchItem"]
    assert res_hash["name"] == @item_hash[:name]
    assert res_hash["description"] == @item_hash[:description]
    assert res_hash["count"] == @item_hash[:count]
    assert res_hash["tags"] == @item_hash[:tags]
  end

  test "fetchItem query should not return item with incorrect ID" do
    query_string = <<-GRAPHQL
      query($itemId: ID!) {
        fetchItem(itemId: $itemId) {
          id
          name
          description
          tags
          count
        }
      }
    GRAPHQL
    assert_raise ActiveRecord::RecordNotFound do
      BackendInventoryAppSchema.execute(query_string, variables:{itemId: -1})
    end
  end

  test "createItem should not save a new record if name empty" do
    assert_raise ActiveRecord::RecordInvalid do
      insert_template("", 0)
    end
  end

  test "createItem should not save a new record if name more than 80" do
    assert_raise ActiveRecord::RecordInvalid do
      insert_template("s"*81, 0)
    end
  end

  test "createItem should save a new record if name less than / equal to 80" do
    result = insert_template("s"*80, 0)
    res_hash = result.to_h["data"]["createItem"]["item"]
    assert Item.find(res_hash["id"])
  end

  test "createItem should save a new record if name more than / equal to 1" do
    result = insert_template("s", 0)
    res_hash = result.to_h["data"]["createItem"]["item"]
    assert Item.find(res_hash["id"])
  end

  test "createItem should save a new record if count > 0" do
    result = insert_template("s", 55)
    res_hash = result.to_h["data"]["createItem"]["item"]
    assert Item.find(res_hash["id"])
  end

  test "createItem should save a new record if count = 0" do
    result = insert_template("s", 0)
    res_hash = result.to_h["data"]["createItem"]["item"]
    assert Item.find(res_hash["id"])
  end

  test "createItem should not save a new record if count < 0" do
    assert_raise ActiveRecord::RecordInvalid do
      insert_template("s"*81, -1)
    end
  end

  test "updateItem should modify values" do
    update_template(@insert_res["id"], "new_name", 55, "new_desc", @item_hash[:tags])
    item = Item.find(@insert_res["id"])
    assert item.name == "new_name"
    assert item.count == 55
  end

  test "updateItem should not modify illegal blank name" do
    assert_raise ActiveRecord::RecordInvalid do
      update_template(@insert_res["id"], "", 55, "new_desc", @item_hash[:tags])
    end
  end

  test "updateItem should not modify illegal name > 80" do
    assert_raise ActiveRecord::RecordInvalid do
      update_template(@insert_res["id"], "s"*81, 55, "new_desc", @item_hash[:tags])
    end
  end

  test "updateItem should modify name = 1" do
    update_template(@insert_res["id"], "n", 55, "new_desc", @item_hash[:tags])
    item = Item.find(@insert_res["id"])
    assert item.name == "n"
    assert item.count == 55
  end

  test "updateItem should modify name = 80" do
    update_template(@insert_res["id"], "s"*80, 55, "new_desc", @item_hash[:tags])
    item = Item.find(@insert_res["id"])
    assert item.name == "s"*80
    assert item.count == 55
  end

  test "updateItem should not modify count < 0" do
    assert_raise ActiveRecord::RecordInvalid do
      update_template(@insert_res["id"], "test", -55, "new_desc", @item_hash[:tags])
    end
  end
end
