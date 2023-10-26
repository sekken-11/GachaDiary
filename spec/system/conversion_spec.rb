require 'rails_helper'
RSpec.describe '現金換算機能', type: :system do
  before do
    visit root_path
    create(:user)
  end

  context '未ログイン' do

    it '現金換算の履歴が残る' do
      conversions
      expect(find('#total')).to have_content('5050円'), '換算履歴の合計金額が表示されていない'
      expect(find('#record-0')).to have_content('1050円'), '換算履歴が表示されていない'
      expect(find('#record-0')).to have_content('1000個'), '換算履歴が表示されていない'
      expect(find('#record-0')).to have_content('ゲーム'), '換算履歴が表示されていない'
      expect(find('#record-1')).to have_content('4000円'), '換算履歴の2つ目が表示されていない'
      expect(find('#record-1')).to have_content('2000個'), '換算履歴の2つ目が表示されていない'
      expect(find('#record-1')).to have_content('ゲーム2'), '換算履歴の2つ目が表示されていない'
    end

    it '現金換算の履歴を削除できる' do
      conversions
      find('#delete-1').click
      expect(find('#total')).to have_content('1050円'), '換算履歴の合計金額が変化していない'
      expect(page).not_to have_selector('#record-1'), '換算履歴の2つ目が消えていない'
      find('#delete-0').click
      expect(find('#total')).to have_content('0円'), '換算履歴の合計金額が変化していない'
      expect(page).not_to have_selector('#record-0'), '換算履歴の1つ目が消えていない'
    end

    it '現金換算のバリデーションが機能している' do
      within '#top-form' do
        fill_in 'ガチャ石の個数', with: ''
        fill_in 'ガチャ石の価格', with: ''
        fill_in 'stone_quantity', with: ''
        fill_in 'ゲーム名*任意', with: ''
        click_button '追加'
      end
      expect(find('#posses_stone_error')).to have_content('入力してください'), 'エラーメッセージがありません'
      expect(find('#stone_price_error')).to have_content('入力してください'), 'エラーメッセージがありません'
      expect(find('#stone_quantity_error')).to have_content('入力してください'), 'エラーメッセージがありません'
      within '#top-form' do
        fill_in 'ガチャ石の個数', with: 'aaa'
        fill_in 'ガチャ石の価格', with: 'aaa'
        fill_in 'stone_quantity', with: 'aaa'
        fill_in 'ゲーム名*任意', with: ''
        click_button '追加'
      end
      expect(find('#posses_stone_error')).to have_content('半角数字で入力してください'), 'エラーメッセージがありません'
      expect(find('#stone_price_error')).to have_content('半角数字で入力してください'), 'エラーメッセージがありません'
      expect(find('#stone_quantity_error')).to have_content('半角数字で入力してください'), 'エラーメッセージがありません'
    end

  end

end