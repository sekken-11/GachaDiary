require 'rails_helper'
RSpec.describe 'ゲーム記録機能', type: :system do

  before do
    @login_user = create(:user)
    login_as(@login_user)

    @package1 = create(:currency_package, name: 'ゲーム', need_one_gacha_stones: '200', price: '200', quantity: '200', user: @login_user)
    @package2 = create(:currency_package, name: 'ゲーム2', need_one_gacha_stones: '300', price: '100', quantity: '100', user: @login_user)

    click_link 'ガチャ記録'
  end

  it 'ゲーム名が表示されている' do
    find('#totalrecord-1').click
    expect(find('#gamename')).to have_content(@package1.name)
    find('#totalrecord-2').click
    expect(find('#gamename')).to have_content(@package2.name)
  end

  context 'ガチャ記録・石の所持記録が存在する' do

    before do
      create(:gacha, count: '10', user: @login_user, currency_package: @package1)
      create(:gacha, count: '10', user: @login_user, currency_package: @package1)
      create(:gacha, count: '10', user: @login_user, currency_package: @package2)
      create(:gacha, count: '10', user: @login_user, currency_package: @package2)
    end

    it '合計が正しく表示されている' do
      find('#totalrecord-1').click
      expect(find('#gamedata')).to have_content('4000円')
      find('#totalrecord-2').click
      expect(find('#gamedata')).to have_content('6000円')
    end

    it 'ガチャ記録が正しく表示される' do
      find('#totalrecord-1').click
      within '#gacharecords' do
        expect(page).to have_selector('#gacharecord-1'), 'ガチャ記録が表示されていない'
        expect(page).to have_selector('#gacharecord-2'), 'ガチャ記録が表示されていない'
      end
      find('#totalrecord-2').click
      within '#gacharecords' do
        expect(page).to have_selector('#gacharecord-1'), 'ガチャ記録が表示されていない'
        expect(page).to have_selector('#gacharecord-2'), 'ガチャ記録が表示されていない'
      end
    end

  end

  context 'ガチャ記録・石の所持記録が存在しない' do

    it 'ガチャ記録・石の所持記録が表示されていない' do
      find('#totalrecord-1').click
      expect(find('#gacharecords')).to have_content('データがありません')
      expect(find('#posses_stones')).to have_content('データがありません')
      find('#totalrecord-2').click
      expect(find('#gacharecords')).to have_content('データがありません')
      expect(find('#posses_stones')).to have_content('データがありません')
    end

    it '換算用データの情報が正しく表示されている' do
      find('#totalrecord-1').click
      within '#gamedata' do
        expect(page).to have_content('0円')
        expect(page).to have_content('200円／200個')
        expect(page).to have_content('200個／1回')
      end
      find('#totalrecord-2').click
      within '#gamedata' do
        expect(page).to have_content('0円')
        expect(page).to have_content('100円／100個')
        expect(page).to have_content('300個／1回')
      end
    end

  end

end