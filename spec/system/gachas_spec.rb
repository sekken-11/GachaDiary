require 'rails_helper'
RSpec.describe 'ガチャ記録機能', type: :system do
  before do
    @login_user = create(:user)
    login_as(@login_user)
    @package1 = create(:currency_package, name: 'ゲーム', need_one_gacha_stones: '150', price: '160', quantity: '100', user: @login_user)
    @package2 = create(:currency_package, name: 'ゲーム2', need_one_gacha_stones: '300', price: '100', quantity: '100', user: @login_user)
    click_link 'ガチャ記録'
  end

  context 'ガチャ記録が存在する状態' do

    before do
      create(:gacha, date: '2023-06-15', count: '10', user: @login_user, currency_package: @package1)
      create(:gacha, date: '2023-07-15', count: '10', user: @login_user, currency_package: @package1)
      create(:gacha, date: '2023-08-15', count: '10', description: 'test', user: @login_user, currency_package: @package2)
      visit current_path
    end

    it '複数のゲームのガチャ記録が合計に反映されている' do
      within '#totalrecord-1' do
        expect(page).to have_content('4800円'), '換算履歴に現金換算が表示されていない'
        expect(page).to have_content('ゲーム'), '換算履歴にゲーム名が表示されていない'
        expect(page).to have_content('20回'), '換算履歴に回数が表示されていない'
      end
      within '#totalrecord-2' do
        expect(page).to have_content('3000円'), '換算履歴に2つ目の現金換算が表示されていない'
        expect(page).to have_content('ゲーム2'), '換算履歴に2つ目のゲーム名が表示されていない'
        expect(page).to have_content('10回'), '換算履歴に2つ目の回数が表示されていない'
      end
      expect(page).to have_content('7800円'), '換算履歴の合計の現金換算が表示されていない'
    end
  
    it 'ガチャ記録の詳細を正しく確認できる' do
      within '#gacharecord-1' do
        click_button '詳細'
      end
      within '#gacha_modal' do
        expect(page).to have_content('2023-08-15'), '詳細に日付が表示されていない'
        expect(page).to have_content('ゲーム2'), '詳細にゲーム名が表示されていない'
        expect(page).to have_content('3000円'), '詳細に現金換算が表示されていない'
        expect(page).to have_content('10回'), '詳細にガチャ回数が表示されていない'
        expect(page).to have_content('test'), '詳細に備考が表示されていない'
      end
    end
  
    it 'ガチャ記録を削除できる' do
      within '#gacharecord-1' do
        click_button '削除'
      end
      find('#delete-button').click
      expect(page).not_to have_selector('#gacharecord-3'), 'ガチャ記録が削除されていない'
      expect(page).to have_selector('#gacharecord-2'), 'ガチャ記録が削除されていない'
      expect(page).to have_selector('#gacharecord-1'), 'ガチャ記録が削除されていない'
    end
  
    it 'ガチャ記録を編集する時、元の内容が入力されている' do
      within '#gacharecord-1' do
        click_button '編集'
      end
      within '#gacha-edit-form' do
        expect(find_field('ガチャ回数').value).to eq '10'
        expect(find_field('ガチャを引いた日付').value).to eq '2023-08-15'
        expect(find_field('換算用データ').value).to eq '2'
        expect(find_field('備考').value).to eq 'test'
      end
    end
  
    it 'ガチャ記録を編集できる' do
      within '#gacharecord-1' do
        click_button '編集'
      end
      within '#gacha-edit-form' do
        fill_in 'ガチャ回数', with: '20'
        fill_in 'ガチャを引いた日付', with: Date.new(2023, 7, 15)
        find("option[value='2']").select_option
        fill_in '備考', with: 'テスト'
        click_button '変更'
      end
      within '#gacharecord-1' do
        expect(page).to have_content('2023-07-15'), '日付が表示されていない'
        expect(page).to have_content('6000円'), '現金換算が表示されていない'
        expect(page).to have_content('ゲーム2'), 'ゲーム名が表示されていない'
        expect(page).to have_content('20回'), '回数が表示されていない'
      end
      within '#totalrecord-2' do
        expect(page).to have_content('6000円'), '換算履歴に現金換算が表示されていない'
        expect(page).to have_content('ゲーム2'), '換算履歴にゲーム名が表示されていない'
        expect(page).to have_content('20回'), '換算履歴に回数が表示されていない'
      end
    end

    it 'ガチャ記録を備考から絞り込める' do
      fill_in 'search', with: 'test'
      within '#gacharecord-1' do
        expect(page).to have_content('2023-08-15'), '検索結果が正しくない'
        expect(page).to have_content('3000円'), '検索結果が正しくない'
        expect(page).to have_content('ゲーム2'), '検索結果が正しくない'
        expect(page).to have_content('10回'), '検索結果が正しくない'
      end
      expect(page).not_to have_selector('#gacharecord-2'), '検索結果が正しくない'
    end

    it 'ガチャ記録を換算用データから絞り込める' do
      find("option[value='2']").select_option
      within '#gacharecord-1' do
        expect(page).to have_content('2023-08-15'), '検索結果が正しくない'
        expect(page).to have_content('3000円'), '検索結果が正しくない'
        expect(page).to have_content('ゲーム2'), '検索結果が正しくない'
        expect(page).to have_content('10回'), '検索結果が正しくない'
      end
      expect(page).not_to have_selector('#gacharecord-2'), '検索結果が正しくない'
    end

    it 'ガチャ記録を日付から絞り込める' do
      fill_in 'from_date', with: Date.new(2023, 7, 15)
      within '#gacharecord-1' do
        expect(page).to have_content('2023-08-15'), '検索結果が正しくない'
        expect(page).to have_content('3000円'), '検索結果が正しくない'
        expect(page).to have_content('ゲーム2'), '検索結果が正しくない'
        expect(page).to have_content('10回'), '検索結果が正しくない'
      end
      within '#gacharecord-2' do
        expect(page).to have_content('2023-07-15'), '検索結果が正しくない'
        expect(page).to have_content('2400円'), '検索結果が正しくない'
        expect(page).to have_content('ゲーム'), '検索結果が正しくない'
        expect(page).to have_content('10回'), '検索結果が正しくない'
      end
      expect(page).not_to have_selector('#gacharecord-3'), '検索結果が正しくない'
      fill_in 'to_date', with: Date.new(2023, 7, 15)
      within '#gacharecord-1' do
        expect(page).to have_content('2023-07-15'), '検索結果が正しくない'
        expect(page).to have_content('2400円'), '検索結果が正しくない'
        expect(page).to have_content('ゲーム'), '検索結果が正しくない'
        expect(page).to have_content('10回'), '検索結果が正しくない'
      end
      expect(page).not_to have_selector('#gacharecord-2'), '検索結果が正しくない'
    end

  end

  context 'ガチャ記録が存在しない状態' do

    it 'ガチャ記録を作成できる' do
      click_button 'ガチャ記録 新規作成'
      within '#gacha-form' do
        fill_in 'ガチャ回数', with: '10'
        fill_in 'ガチャを引いた日付', with: Date.new(2023, 6, 15)
        find("option[value='1']").select_option
        fill_in '備考', with: ''
        click_button '作成'
      end
      within '#gacharecord-1' do
        expect(page).to have_content('2023-06-15'), '日付が表示されていない'
        expect(page).to have_content('2400円'), '現金換算が表示されていない'
        expect(page).to have_content('ゲーム'), 'ゲーム名が表示されていない'
        expect(page).to have_content('10回'), '回数が表示されていない'
      end
    end

    it 'ガチャ記録作成時、当日の日付が入力されている' do
      click_button 'ガチャ記録 新規作成'
      expect(find_field('ガチャを引いた日付').value).to eq Date.today.strftime("%F")
    end

  end

end