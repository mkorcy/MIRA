class User < ActiveRecord::Base
# Connects this user object to Hydra behaviors. 
 include Hydra::User
# Connects this user object to Role behaviors. 
 include Hydra::RoleManagement::UserRoles
# Connects this user object to Blacklights Bookmarks. 
 include Blacklight::User
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
#  devise :ldap_authenticatable, :rememberable, :trackable
   devise :ldap_authenticatable, :trackable

  def to_s
    username
  end

  def registered?
    self.groups.include?('registered')
  end

  def display_name  #update this method to return the string you would like used for the user name stored in fedora objects.
    if Rails.env.test?
			self.username
    else
      Devise::LDAP::Adapter.get_ldap_param(self.username,"tuftsEduDisplayNameLF")[0]
    end
  end

end
