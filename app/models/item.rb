class Item < ApplicationRecord
  validates :name, presence: true, length: {minimum:1, maximum:80}
  validates :count, presence: true, numericality: {greater_than_or_equal_to: 0, only_integer: true}

  has_one :tag, dependent: :destroy

  def self.fetchAll
    Item.joins(:tag).select("items.*, tags.names as tags").where(deleted_at: nil)
  end

  def self.fetchId(item_id)
    self.fetchAll.find(item_id)
  end

  def self.insert(params)
    item = Item.create!(params.except(:tags))
    tag = item.create_tag!(names: params[:tags])
    item_hash = item.as_json
    item_hash[:tags] = tag.names
    item_hash
  end 

  def self.modify(id, params)
    item = Item.update!(id, params.except(:tags))
    if params[:tags] != nil
      item.tag.update!(names: params[:tags])
    end
    item = self.fetchId(id)
    createItemHash(item)
  end

  def self.softDelete(id)
    item = self.fetchId(id)
    Item.update!(id, deleted_at: Time.now)
    item.tag.update!(deleted_at: Time.now)
    createItemHash(item)
  end

  private 

  def self.createItemHash(item)
    item_hash = item.as_json
    item_hash[:tags] = item.tags
    item_hash
  end

end
