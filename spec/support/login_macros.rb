module LoginMacros
  def login_as(user)
    visit '/signin'
    within "#signin-form" do
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: '12345678'
      click_button 'ログイン'
      page.accept_confirm
    end
  end
end