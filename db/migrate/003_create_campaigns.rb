class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.string :strategy1
      t.string :strategy2
      t.integer :ratio1
      t.integer :ratio2
      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end
