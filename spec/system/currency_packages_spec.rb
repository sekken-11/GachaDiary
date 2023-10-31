require 'rails_helper'
RSpec.describe '換算用データ機能', type: :system do
  let(:currency_package) { create(:currency_package) }
  let(:user) { create(:user) }

  before do
    @login_user = create(:user)
    login_as(@login_user)
    visit root_path
    click_link '換算用データ'
  end

  it '換算用データが作成できる' do
    click_button '換算用データ 作成'
    within '#currency_package-form' do
      fill_in 'ゲーム名', with: 'ゲーム'
      fill_in 'ガチャ一回に必要なガチャ石', with: '150'
      fill_in 'stone_price', with: '160'
      fill_in 'stone_quantity', with: '100'
      click_button '作成'
    end
    expect(page).to have_selector('#package-1'), '換算用データが存在しない'
    expect(page).to have_selector('#totalrecord-1'), '換算合計に換算用データが存在しない'
  end

  it '換算用データのバリデーションが機能している' do
    click_button '換算用データ 作成'
    within '#currency_package-form' do
      fill_in 'ゲーム名', with: ''
      fill_in 'ガチャ一回に必要なガチャ石', with: ''
      fill_in 'stone_price', with: 'aa'
      fill_in 'stone_quantity', with: 'aa'
      click_button '作成'
    end
    expect(find('#name_error')).to have_content('入力してください'), 'エラーメッセージがありません'
    expect(find('#need_one_gacha_stones_error')).to have_content('入力してください'), 'エラーメッセージがありません'
    expect(find('#stone_price_error')).to have_content('半角数字で入力してください'), 'エラーメッセージがありません'
    expect(find('#stone_quantity_error')).to have_content('半角数字で入力してください'), 'エラーメッセージがありません'
    within '#currency_package-form' do
      fill_in 'ガチャ一回に必要なガチャ石', with: 'aa'
      fill_in 'stone_price', with: ''
      fill_in 'stone_quantity', with: ''
      click_button '作成'
    end
    expect(find('#need_one_gacha_stones_error')).to have_content('半角数字で入力してください'), 'エラーメッセージがありません'
    expect(find('#stone_price_error')).to have_content('入力してください'), 'エラーメッセージがありません'
    expect(find('#stone_quantity_error')).to have_content('入力してください'), 'エラーメッセージがありません'
  end

  it '換算用データの詳細を確認できる' do
    create(:currency_package, name: 'ゲーム', need_one_gacha_stones: '150', price: '160', quantity: '100', user: @login_user)
    visit current_path
    within '#package-1' do
      click_button '詳細'
    end
    expect(page).to have_content('ゲーム'), 'ゲーム名が表示されていない'
    expect(page).to have_content('160円 ／ 100個'), '購入価格が表示されていない'
    expect(page).to have_content('150個'), 'ガチャ1回に必要なガチャ石数が表示されていない'
  end

  it '換算用データを削除できる' do
    create(:currency_package, name: 'ゲーム', need_one_gacha_stones: '150', price: '160', quantity: '100', user: @login_user)
    visit current_path
    within '#package-1' do
      click_button '削除'
    end
    find('#delete-button').click
    expect(page).not_to have_selector('#package-1'), '換算用データが削除されていない'
    expect(page).not_to have_selector('#totalrecord-1'), '換算用データが削除されていない'
  end

  it '換算用データを編集できる' do
    create(:currency_package, name: 'ゲーム', need_one_gacha_stones: '150', price: '160', quantity: '100', user: @login_user)
    visit current_path
    within '#package-1' do
      click_button '編集'
    end
    within '#currency_package-form' do
      fill_in 'ゲーム名', with: 'ゲーム2'
      fill_in 'ガチャ一回に必要なガチャ石', with: '300'
      fill_in 'stone_price', with: '320'
      fill_in 'stone_quantity', with: '200'
      click_button '変更'
    end
    within '#package-1' do
      click_button '詳細'
    end
    expect(page).to have_content('ゲーム2'), '変更後のゲーム名が表示されていない'
    expect(page).to have_content('320円 ／ 200個'), '変更後の購入価格が表示されていない'
    expect(page).to have_content('300個'), '変更後のガチャ1回に必要なガチャ石数が表示されていない'
  end

end