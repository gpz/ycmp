class AddDefaultUser < ActiveRecord::Migration
  
  def self.up
    if !User.find_by_login('webmaster')
      User.create(:login => 'webmaster', :email => 'webmaster@yourcmphotos.com',
                  :password => 'changeme', :password_confirmation => 'changeme')
    end
  end

  def self.down
  end
end
