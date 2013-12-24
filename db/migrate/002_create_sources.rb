class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.string :name
      t.string :slug
      t.string :url
      t.string :start_url
      t.string :verification_matcher
      t.timestamps
    end
    add_index :sources, :name, unique: true
    add_index :sources, :slug, unique: true
  end
end
