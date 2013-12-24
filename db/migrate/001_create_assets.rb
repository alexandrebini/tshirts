class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.references :assetable, polymorphic: true
      t.string :type
      t.string :source_url
      t.string :status
      t.string :data_file_name
      t.string :data_content_type
      t.string :data_file_size
      t.text :data_meta
      t.string :data_fingerprint
      t.timestamps
    end
    add_index :assets, :assetable_id
    add_index :assets, :assetable_type
    add_index :assets, :type
    add_index :assets, :status
    add_index :assets, [:assetable_id, :assetable_type]
  end
end