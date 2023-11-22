require 'rails_helper'
RSpec.describe 'カレンダー機能', type: :system do

  before do
    @login_user = create(:user)
    login_as(@login_user)

    @package1 = create(:currency_package, name: 'ゲーム', need_one_gacha_stones: '300', price: '100', quantity: '100')
    @package2 = create(:currency_package, name: 'ゲーム2', need_one_gacha_stones: '300', price: '100', quantity: '100')

    create(:user_package, user: @login_user, currency_package: @package1)
    create(:user_package, user: @login_user, currency_package: @package2)

    create(:gacha, date: Date.today.last_month.beginning_of_month.change(day: 15).strftime("%F"), count: '10', user: @login_user, currency_package: @package1)
    create(:gacha, date: Date.today.beginning_of_month.change(day: 15).strftime("%F"), count: '20', user: @login_user, currency_package: @package1)
    create(:gacha, date: Date.today.beginning_of_month.change(day: 15).strftime("%F"), count: '30', user: @login_user, currency_package: @package2)
    create(:gacha, date: Date.today.next_month.beginning_of_month.change(day: 15).strftime("%F"), count: '40', user: @login_user, currency_package: @package1)
    click_link 'カレンダー'
  end

  it 'ガチャ記録のガチャ回数がカレンダー内に表示されている' do
    expect(find('#calendar')).to have_content('50回'), 'データがカレンダーに反映されていない'
  end

  it '特定の日付のガチャ回数をクリックするとその日のガチャ記録一覧が表示される' do
    find('.fc-event').click
    expect(page).to have_selector('#gacharecord-1'), 'ガチャ記録が表示されていない'
    expect(page).to have_selector('#gacharecord-2'), 'ガチャ記録が表示されていない'
  end

  it '日付のセルをクリックすると、その日付が入力されたガチャ記録作成画面へ遷移する' do
    # このテストの実行日でないことと、何らかの日付が入力されていることしか確認できていない
      # 日付のセルを個別に識別する方法がわからなかったため
    page.first('.fc-daygrid-day-frame').click
    within '#gacha-form' do
      expect(find_field('ガチャを引いた日付').value).not_to eq Date.today.strftime("%F")
      expect(find_field('ガチャを引いた日付').value).not_to eq ''
    end
  end

  it 'prevボタンをクリックすると先月のカレンダーが表示される' do
    find('.fc-prev-button').click
    expect(find('#calendar')).to have_content(Date.today.last_month.strftime("%Y年%-m月"))
  end

  it 'nextボタンをクリックすると先月のカレンダーが表示される' do
    find('.fc-next-button').click
    expect(find('#calendar')).to have_content(Date.today.next_month.strftime("%Y年%-m月"))
  end

  it '表示切替をするとガチャ回数が現金換算に切り替わる' do
    click_button '表示切替'
    expect(find('#calendar')).to have_content('15000円'), 'データの表示が変更されていない'
  end

  it 'イベントをクリックする前はガチャ記録一覧が表示されていない' do
    expect(page).to have_content('日付が選択されていません')
  end

end