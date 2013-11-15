class CreateSelections < ActiveRecord::Migration
  def self.up
    create_table :selections do |t|
      t.belongs_to :campaign
      t.belongs_to :banner
      t.integer :weight
      t.timestamps
    end
  end

  def self.down
    drop_table :selections
  end
end
