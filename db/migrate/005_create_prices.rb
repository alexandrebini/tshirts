class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.references :t_shirt
      t.integer :value
      t.datetime :created_at
    end
    add_index :prices, :t_shirt_id
    add_index :prices, :value
    add_index :prices, :created_at
    add_index :prices, [:t_shirt_id, :value]
    add_index :prices, [:t_shirt_id, :value, :created_at]
  end
end