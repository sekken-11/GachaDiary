require 'rails_helper'
RSpec.describe 'マイページ機能', type: :system do

  before do
    @login_user = create(:user)
    login_as(@login_user)
    visit root_path
    find('#sidebar').click
    find('#mypage-button').click
  end

  it 'ログインユーザー自身のマイページに遷移する' do
    expect(page).to have_content("#{@login_user.email} 様 の マイページ")
    expect(find('#user-info')).to have_content(@login_user.email)
    expect(find('#user-info')).to have_content(@login_user.created_at.strftime("%F"))
  end

  context '換算用データが存在しないとき' do

    it 'データがないと表示される' do
      expect(find('#total')).to have_content('0円')
      expect(find('#chart')).to have_content('ガチャ記録がありません')
      expect(find('#totalrecords')).to have_content('データがありません')
    end

  end

  context '換算用データ・ガチャ記録が存在するとき' do

    before do
      @package1 = create(:currency_package, name: 'ゲーム', need_one_gacha_stones: '300', price: '100', quantity: '100', user: @login_user)
      @package2 = create(:currency_package, name: 'ゲーム2', need_one_gacha_stones: '300', price: '100', quantity: '100', user: @login_user)

      create(:gacha, count: '10', user: @login_user, currency_package: @package1)
      create(:gacha, count: '10', user: @login_user, currency_package: @package2)
      visit current_path
    end

    it '円グラフが表示されている' do
      expect(find('#chart')).to have_selector('#pie-chart')
    end

    it '合計が正しく表示されている' do
      expect(find('#total')).to have_content('6000円')
    end

    it 'ゲームごとの割合が表示されている' do
      expect(find('#game-1')).to have_content('50.0%')
      expect(find('#game-2')).to have_content('50.0%')
    end

    it '換算合計一覧が表示されている' do
      within '#totalrecords' do
        expect(page).to have_selector('#record-1')
        expect(page).to have_selector('#record-2')
      end
    end

  end

end