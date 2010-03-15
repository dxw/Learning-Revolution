class CreateEmailSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :email_subscriptions do |t|
      t.string :email
      t.string :secret

      t.text :filter

      t.timestamp :confirmed_at
      t.timestamp :last_sent_at

      t.timestamps
    end
  end

  def self.down
    drop_table :email_subscriptions
  end
end
