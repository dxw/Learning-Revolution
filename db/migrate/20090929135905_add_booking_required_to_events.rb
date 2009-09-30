class AddBookingRequiredToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :booking_required, :boolean
  end

  def self.down
    remove_column :events, :booking_required
  end
end
