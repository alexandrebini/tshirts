class CreateSizes < ActiveRecord::Migration
  def change
    create_table :sizes, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.references :t_shirt
      t.string :label, limit: 100
      t.string :gender, limit: 100
    end
    add_index :sizes, :t_shirt_id
    add_index :sizes, :label
    add_index :sizes, :gender
    add_index :sizes, [:t_shirt_id, :label]
    add_index :sizes, [:t_shirt_id, :gender]
    add_index :sizes, [:t_shirt_id, :label, :gender]
  end
end
