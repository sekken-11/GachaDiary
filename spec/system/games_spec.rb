require 'rails_helper'
RSpec.describe '所持ガチャ石機能', type: :system do

  before do
    create_list(:currency_package, 12, category: "initial")
    @login_user = build(:user)
    sign_up_us(@login_user)
    login_as(@login_user)
    @package1 = build(:currency_package, name: 'ゲーム1', need_one_gacha_stones: '150', price: '160', quantity: '100')
    @package2 = build(:currency_package, name: 'ゲーム2', need_one_gacha_stones: '300', price: '100', quantity: '100')
    package_create(@package1)
    package_create(@package2)
    click_link '所持ガチャ石'
  end

  context '石の所持データが存在する状態' do

    before do
      @posses1 = build(:user_posses_stone, quantity: '10000')
      @posses2 = build(:user_posses_stone, quantity: '20000')
      posses_stone_create(@posses1, @package1)
      posses_stone_create(@posses2, @package2)
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
        expect(page).to have_content("#{@package1.name}")
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

    it '所持データに登録されている換算用データが削除されたとき、換算用データが未設定になる' do
      click_link '換算用データ'
      within '#package-1' do
        click_button '削除'
      end
      find('#delete-button').click
      click_link '所持ガチャ石'
      within '#posses_stone_record-2' do
        expect(page).to have_content('未設定'), '換算用データが未設定になっていない'
      end
    end

  end

  context '石の所持データが存在しない状態' do

    it 'データを作成できる' do
      click_button 'ゲームごとの石の所持データ 作成'
      within '#posses-form' do
        fill_in '石の所持数', with: '10000'
        select 'ゲーム1', from: 'currency_package_id'
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