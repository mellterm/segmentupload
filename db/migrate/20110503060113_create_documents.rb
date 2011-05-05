class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :document_name
      t.integer :provider_id
      t.integer :uploaded_by_id
      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
