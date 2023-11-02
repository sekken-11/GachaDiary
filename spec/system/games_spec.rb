require 'rails_helper'
RSpec.describe '所持ガチャ石機能', type: :system do

  before do
    @login_user = create(:user)
    login_as(@login_user)
    @package1 = create(:currency_package, name: 'ゲーム', need_one_gacha_stones: '150', price: '160', quantity: '100', user: @login_user)
    @package2 = create(:currency_package, name: 'ゲーム2', need_one_gacha_stones: '300', price: '100', quantity: '100', user: @login_user)
    click_link '所持ガチャ石'
  end

  context '石の所持データが存在する状態' do

    before do
      create(:user_posses_stone, quantity: '10000', user: @login_user, currency_package: @package1)
      create(:user_posses_stone, quantity: '20000', user: @login_user, currency_package: @package2)
      visit current_path
    end

    it '所持データが一覧表示されている' do
      expect(page).to have_selector('#posses_stone_record-1'), '所持データ1が作成されていない'
      expect(page).to have_selector('#posses_stone_record-2'), '所持データ2が作成されていない'
    end

    it '所持データを削除できる' do
      within '#posses_stone_record-1' do
        click_button '削除'
      end
      find('#delete-button').click
      expect(page).to have_selector('#posses_stone_record-1'), '所持データが削除されていない'
      expect(page).not_to have_selector('#posses_stone_record-2'), '所持データが削除されていない'
      expect(find('#posses_stone_record-1')).to have_content('ゲーム2'), '削除されたのが所持データ1ではない'
    end

    it '所持データを編集するとき、元のデータが入力されている' do
      within '#posses_stone_record-1' do
        click_button '編集'
      end
      within '#posses-edit-form' do
        expect(find_field('石の所持数').value).to eq '10000'
        expect(find_field('換算用データ').value).to eq "#{@package1.id}"
      end
    end

    it '所持データを編集できる' do
      within '#posses_stone_record-1' do
        click_button '編集'
      end
      within '#posses-edit-form' do
        fill_in '石の所持数', with: '20000'
        select 'ゲーム2', from: 'currency_package_id'
        click_button '変更'
      end
      expect(find('#posses-total')).to have_content('40000円'), '変更データが合計に反映されていない'
      within '#posses_stone_record-1' do
        expect(page).to have_content('ゲーム2'), '変更が反映されていない'
        expect(page).to have_content('20000円'), '変更が反映されていない'
        expect(page).to have_content('20000円'), '変更が反映されていない'
      end
    end

  end

  context '石の所持データが存在しない状態' do

    it 'データを作成できる' do
      click_button 'ゲームごとの石の所持データ 作成'
      within '#posses-form' do
        fill_in '石の所持数', with: '10000'
        select 'ゲーム', from: 'currency_package_id'
        click_button '作成'
      end
      expect(find('#posses-total')).to have_content('16000円'), 'データが合計に反映されていない'
      expect(page).to have_selector('#posses_stone_record-1'), '所持データが作成されていない'
    end

    it '合計が0円で表示されている' do
      expect(find('#posses-total')).to have_content('0円'), 'データ未作成時の合計表示がおかしい'
    end

    it '所持データ一覧に「データがありません」と表示されている' do
      expect(find('#posses_stones')).to have_content('データがありません'), 'データ未作成時の一覧表示がおかしい'
    end

  end

end