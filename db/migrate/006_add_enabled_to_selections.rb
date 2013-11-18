class AddEnabledToSelections < ActiveRecord::Migration
  def self.up
    change_table :selections do |t|
      t.boolean :enabled
    end
  end

  def self.down
    change_table :selections do |t|
      t.remove :enabled
    end
  end
end
