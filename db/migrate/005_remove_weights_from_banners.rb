csdlass RemoveWeightsFromBanners < ActiveRecord::Migration
  def self.up
    change_table :banners do |t|
      t.remove :weight
    end
  end

  def self.down
    change_table :banners do |t|
      t.id :weight
    end
  end
end
