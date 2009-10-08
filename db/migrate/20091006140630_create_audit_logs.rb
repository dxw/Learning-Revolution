class CreateAuditLogs < ActiveRecord::Migration
  def self.up
    create_table :audit_logs do |t|
      t.string :description
      t.text :object_yml
      t.timestamps
    end
  end

  def self.down
    drop_table :audit_logs
  end
end
