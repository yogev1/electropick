class CreateAmazonApis < ActiveRecord::Migration[5.1]
  def change
    create_table :amazon_apis do |t|

      t.timestamps
    end
  end
end
