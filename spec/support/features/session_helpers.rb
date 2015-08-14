# spec/support/features/session_helpers.rb
module Features
  module SessionHelpers

    def sign_in(who = :user)
      user = who.instance_of?(User) ? who : FactoryGirl.create(who)
      visit new_user_session_path
      fill_in 'Username', with: user.username
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end
  end
end
