module LoginMacros
  def login_as(user)
    visit '/signin'
    within "#signin-form" do
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: '12345678'
      click_button 'ログイン'
    end
  end

  def sign_up_us(user)
    visit '/signup'
    within "#signup-form" do
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: '12345678'
      fill_in 'パスワード（再入力）', with: '12345678'
      click_button '登録'
    end
  end
  
end