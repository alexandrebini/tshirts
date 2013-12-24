class CreateSizes < ActiveRecord::Migration
  def change
    create_table :sizes, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.references :t_shirt
      t.integer :label
      t.string :gender
    end
    add_index :sizes, :t_shirt_id
    add_index :sizes, :label
    add_index :sizes, :gender
    add_index :sizes, [:t_shirt_id, :label]
    add_index :sizes, [:t_shirt_id, :gender]
    add_index :sizes, [:t_shirt_id, :label, :gender]
  end
end
