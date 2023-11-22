require 'rails_helper'
RSpec.describe 'ユーザー機能', type: :system do
  let(:user) { create(:user) }

  before do
    visit root_path
    create_list(:currency_package, 12, category: "initial")
  end

  context '未ログイン' do

    it '未ログイン状態でヘッダーに「新規登録」、「ログイン」ボタンが表示されている' do
      expect(page).to have_content('新規登録'), '未ログイン状態でヘッダーに「新規登録」ボタンが表示されていません'
      expect(page).to have_content('ログイン'), '未ログイン状態でヘッダーに「ログイン」ボタンが表示されていません'
    end

    it '未ログイン状態でヘッダーに「ガチャ記録作成」ボタンが表示されていない' do
      expect(page).not_to have_content('ガチャ記録作成'), '未ログイン状態でヘッダーに「ガチャ記録作成」ボタンが表示されています'
    end

    it '新規登録ページで各フィールドを入力して「登録」をクリックしたらユーザーが登録されている' do
      click_button '新規登録'
      within "#signup-form" do
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（再入力）', with: 'password'
        click_button '登録'
      end
      expect(page).to have_current_path('/signin'), 'ログインページに遷移できていません'
    end

    it '登録済みユーザーでログインできる' do
      visit '/signin'
      within "#signin-form" do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '12345678'
        click_button 'ログイン'
      end
      expect(page).to have_current_path('/'), '現金換算ページに遷移できていません'
    end

    it '登録済みメールアドレスでユーザー登録できない' do
      visit '/signup'
      within "#signup-form" do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '12345678'
        fill_in 'パスワード（再入力）', with: '12345678'
        click_button '登録'
      end
      expect(page).to have_content('登録に失敗しました'), '新規登録できません'
    end

    it '未ログイン状態で現金換算ページ以外に遷移したら、ログインページにリダイレクトされる' do
      click_on 'ガチャ記録'
      expect(page).to have_selector('#signin-form'), 'ログインページに遷移できていません'
      click_on '所持ガチャ石'
      expect(page).to have_selector('#signin-form'), 'ログインページに遷移できていません'
      click_on '換算用データ'
      expect(page).to have_selector('#signin-form'), 'ログインページに遷移できていません'
      click_on 'カレンダー'
      expect(page).to have_selector('#signin-form'), 'ログインページに遷移できていません'
    end

    it 'ユーザー登録フォームでバリデーションが機能していること' do
      click_button '新規登録'
      within "#signup-form" do
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'aa'
        fill_in 'パスワード（再入力）', with: 'aa'
        click_button '登録'
        expect(page).to have_content('入力してください'), '必須チェックのバリデーションエラーが表示されていません'
        expect(page).to have_content('6文字以上16文字以下で入力してください'), '文字数チェックのバリデーションエラーが表示されていません'
        fill_in 'パスワード', with: 'aaaaaaaaaaaaaaaaa'
        click_button '登録'
        expect(page).to have_content('6文字以上16文字以下で入力してください'), '文字数チェックのバリデーションエラーが表示されていません'
      end
      within "#signup-form" do
        fill_in 'メールアドレス', with: '12345678'
        fill_in 'パスワード', with: ''
        fill_in 'パスワード（再入力）', with: 'aa'
        click_button '登録'
        expect(page).to have_content('登録できないメールアドレスの形式です'), 'フォーマットチェックのバリデーションエラーが表示されていません'
        expect(page).to have_content('入力してください'), '必須チェックのバリデーションエラーが表示されていません'
      end
      within "#signup-form" do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: '12345678'
        fill_in 'パスワード（再入力）', with: ''
        click_button '登録'
        expect(page).to have_content('入力してください'), '必須チェックのバリデーションエラーが表示されていません'
      end
    end
  
    it 'ログインフォームでバリデーションが機能していること' do
      click_button 'ログイン'
      within "#signin-form" do
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'aa'
        click_button 'ログイン'
        expect(page).to have_content('入力してください'), '必須チェックのバリデーションエラーが表示されていません'
        expect(page).to have_content('6文字以上16文字以下で入力してください'), '文字数チェックのバリデーションエラーが表示されていません'
        fill_in 'パスワード', with: 'aaaaaaaaaaaaaaaaa'
        click_button 'ログイン'
        expect(page).to have_content('6文字以上16文字以下で入力してください'), '文字数チェックのバリデーションエラーが表示されていません'
      end
      within "#signin-form" do
        fill_in 'メールアドレス', with: 'password'
        fill_in 'パスワード', with: ''
        click_button 'ログイン'
        expect(page).to have_content('登録できないメールアドレスの形式です'), 'フォーマットチェックのバリデーションエラーが表示されていません'
        expect(page).to have_content('入力してください'), '必須チェックのバリデーションエラーが表示されていません'
      end
    end

    it 'ログアウトボタンが表示されない' do
      find('#sidebar').click
      expect(page).to have_no_content('ログアウト'), 'ログアウトボタンが表示されている'
    end

    xit 'パスワード変更用メールが送信できる' do
      visit '/signin'
      click_on 'パスワードを忘れた方はこちら'
      fill_in 'メールアドレス', with: user.email
      click_button '送信'
      last_mail = ActionMailer::Base.deliveries.last
      expect(last_mail.subject).to eq 'パスワードリセット用メール'
    end
  
  end

  context 'ログイン済み' do

    it 'ログイン状態でログアウトできる' do
      login_as(user)
      find('#sidebar').click
      expect(page).to have_content('ログアウト'), 'ログイン状態でサイドバーに「ログアウト」ボタンが表示されていません'
      click_button 'ログアウト'
      page.accept_confirm
      expect(page).to have_content('新規登録'), '未ログイン状態でヘッダーに「新規登録」ボタンが表示されていません'
      expect(page).to have_content('ログイン'), '未ログイン状態でヘッダーに「ログイン」ボタンが表示されていません'
    end

    it 'ログイン状態で各ページに遷移したら、当該ページが表示される' do
      login_as(user)
      visit root_path
      click_on 'ガチャ記録'
      expect(page).to have_selector '#Gacha-link', class: 'here'
      click_on '所持ガチャ石'
      expect(page).to have_selector '#Posses-link', class: 'here'
      click_on '換算用データ'
      expect(page).to have_selector '#Conversion-link', class: 'here'
      click_on 'カレンダー'
      expect(page).to have_selector '#Calendar-link', class: 'here'
    end

  end

end