class CreateProviderLinks < ActiveRecord::Migration
  def change
    create_table :provider_links do |t|
      t.string       :provider
      t.string       :uid
      t.text         :credentials
      t.references   :user

      t.timestamps
    end
  end
end
