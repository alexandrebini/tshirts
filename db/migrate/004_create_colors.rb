class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.references :t_shirt
      t.string :hex
      t.integer :percentage
    end
    add_index :colors, :t_shirt_id
    add_index :colors, :hex
    add_index :colors, :percentage
    add_index :colors, [:hex, :percentage]
  end
end
