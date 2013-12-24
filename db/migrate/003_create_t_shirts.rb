class CreateTShirts < ActiveRecord::Migration
  def change
    create_table :t_shirts, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.references :source
      t.string :slug
      t.string :gender
      t.string :title
      t.string :description
      t.string :source_url
      t.timestamps
    end
    add_index :t_shirts, :source_id
    add_index :t_shirts, :slug
    add_index :t_shirts, :created_at
  end
end
