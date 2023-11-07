require 'rails_helper'
RSpec.describe 'サイドメニュー機能', type: :system do

  context '未ログイン状態' do

    before do
      visit root_path
    end

    it 'ページ選択ができない' do
      find('#sidebar').click
      find('#page-choice').click
      expect(page).to have_content('ログイン後に利用できます'), 'ページ選択ができる'
    end

    it 'ゲーム選択ができない' do
      find('#sidebar').click
      find('#game-choice').click
      expect(page).to have_content('ログイン後に利用できます'), 'ページ選択ができる'
    end

    it 'インフォメーションページに遷移できる' do
      find('#sidebar').click
      find('#information-button').click
      expect(page).to have_current_path('/info'), 'インフォメーションページに遷移できなていない'
      expect(page).to have_content('このサイトでできること'), 'インフォメーションページに遷移できていない'
    end

  end

  context 'ログイン状態' do

    before do
      @login_user = create(:user)
      login_as(@login_user)
      visit root_path
    end

    it 'サイドメニューから各機能ページに遷移できる' do
      visit current_path
      find('#sidebar').click
      find('#page-choice').click
      find('#Gacha-button').click
      expect(page).to have_current_path('/gachas'), 'ガチャ記録ページに遷移できなていない'
      find('#sidebar').click
      find('#page-choice').click
      find('#Posses-button').click
      expect(page).to have_current_path('/posses'), '所持ガチャ石ページに遷移できなていない'
      find('#sidebar').click
      find('#page-choice').click
      find('#Conversion-button').click
      expect(page).to have_current_path('/conversions'), '換算用データページに遷移できなていない'
      find('#sidebar').click
      find('#page-choice').click
      find('#Calendar-button').click
      expect(page).to have_current_path('/calendars'), 'カレンダーページに遷移できなていない'
      find('#sidebar').click
      find('#page-choice').click
      find('#Top-button').click
      expect(page).to have_current_path('/'), '現金換算ページに遷移できなていない'
    end

    it '換算用データが存在するとき、サイドメニューから各ゲームページに遷移できる' do
      @package1 = create(:currency_package, user: @login_user)
      @package2 = create(:currency_package, user: @login_user)
      visit current_path
      click_link '換算用データ'
      find('#sidebar').click
      find('#game-choice').click
      find('#game-button-1').click
      expect(page).to have_current_path("/gamedata/#{@package1.id}"), 'ゲームデータページに遷移できていない'
      find('#sidebar').click
      find('#game-choice').click
      find('#game-button-2').click
      expect(page).to have_current_path("/gamedata/#{@package2.id}"), 'ゲームデータページに遷移できていない'
    end

    it '換算用データが存在しないとき、サイドメニューにその旨が表示される' do
      find('#sidebar').click
      find('#game-choice').click
      expect(page).to have_content('ゲームが登録されていません')
    end

    it 'マイページに遷移できる' do
      find('#sidebar').click
      find('#mypage-button').click
      expect(page).to have_current_path('/mypage'), 'マイページに遷移できていない'
    end

  end

end