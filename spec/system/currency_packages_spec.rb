require 'rails_helper'
RSpec.describe '換算用データ機能', type: :system do

  context 'ユーザー登録前' do

    it '初期登録の換算用データが使えるようになる' do
      create_list(:currency_package, 12, category: "initial")
      @login_user = build(:user)
      sign_up_us(@login_user)
      login_as(@login_user)
      click_link '換算用データ'
      find('#package-down').click
      expect(find('#initial-packages')).to have_selector('#initial-package-1'), '初期換算用データが存在しない'
      expect(find('#initial-packages')).to have_selector('#initial-package-2'), '初期換算用データが存在しない'
      expect(find('#initial-packages')).to have_selector('#initial-package-3'), '初期換算用データが存在しない'
      expect(find('#initial-packages')).to have_selector('#initial-package-4'), '初期換算用データが存在しない'
      expect(find('#initial-packages')).to have_selector('#initial-package-5'), '初期換算用データが存在しない'
      expect(find('#initial-packages')).to have_selector('#initial-package-6'), '初期換算用データが存在しない'
      expect(find('#initial-packages')).to have_selector('#initial-package-7'), '初期換算用データが存在しない'
      expect(find('#initial-packages')).to have_selector('#initial-package-8'), '初期換算用データが存在しない'
      expect(find('#initial-packages')).to have_selector('#initial-package-9'), '初期換算用データが存在しない'
      expect(find('#initial-packages')).to have_selector('#initial-package-10'), '初期換算用データが存在しない'
      expect(find('#initial-packages')).to have_selector('#initial-package-11'), '初期換算用データが存在しない'
      expect(find('#initial-packages')).to have_selector('#initial-package-12'), '初期換算用データが存在しない'
    end

  end

  context 'ユーザー登録済み' do

    before do
      @login_user2 = create(:user)
      login_as(@login_user2)
      click_link '換算用データ'
    end

    it '初期登録の換算用データを追加できる' do
      initial_package = create(:currency_package, category: "initial")
      create(:user_package, user: @login_user2, currency_package: initial_package)
      visit current_path
      click_link '換算用データ'
      find('#package-down').click
      expect(find('#initial-packages')).to have_selector('#initial-package-1'), '初期換算用データが追加できていない'
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
      expect(find('#packages')).to have_selector('#package-1'), '換算用データが存在しない'
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
      package = build(:currency_package)
      package_create(package)
      within '#package-1' do
        click_button '詳細'
      end
      expect(page).to have_content("#{package.name}"), 'ゲーム名が表示されていない'
      expect(page).to have_content("#{package.price}円 ／ #{package.quantity}個"), '購入価格が表示されていない'
      expect(page).to have_content("#{package.need_one_gacha_stones}個"), 'ガチャ1回に必要なガチャ石数が表示されていない'
    end

    it '換算用データを削除できる' do
      package = build(:currency_package)
      package_create(package)
      within '#package-1' do
        click_button '削除'
      end
      find('#delete-button').click
      expect(find('#packages')).not_to have_selector('#package-1'), '換算用データが削除されていない'
    end

    it '換算用データを編集できる' do
      package = build(:currency_package)
      package_create(package)
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
  
    it '初期登録データを編集・削除できない' do
      find('#package-down').click
      expect(find('#initial-packages')).to have_no_content('削除'), '初期換算用データに削除ボタンが存在する'
      expect(find('#initial-packages')).to have_no_content('編集'), '初期換算用データに編集ボタンが存在する'
    end

    it '初期登録データと同一内容の換算用データを作成しようとすると、作成されない' do
      initial_package = create(:currency_package, category: "initial")
      create(:user_package, user: @login_user2, currency_package: initial_package)
      click_button '換算用データ 作成'
      within '#currency_package-form' do
        fill_in 'ゲーム名', with: "#{initial_package.name}"
        fill_in 'ガチャ一回に必要なガチャ石', with: "#{initial_package.need_one_gacha_stones}"
        fill_in 'stone_price', with: "#{initial_package.price}"
        fill_in 'stone_quantity', with: "#{initial_package.quantity}"
        click_button '作成'
      end
      expect(page).to have_content('換算用データの作成に失敗しました'), '換算用データが作成されている'
    end

  end

  context '他ユーザーと換算用データを共有している場合' do

    before do
      @another_user = create(:user)
      @package1 = create(:currency_package)
      @login_user = create(:user)
      create(:user_package, user: @another_user, currency_package: @package1)
      create(:user_package, user: @login_user, currency_package: @package1)
      login_as(@login_user)
    end

    it '削除しても他ユーザーのデータは削除されない' do
      click_link '換算用データ'
      within '#package-1' do
        click_button '削除'
      end
      find('#delete-button').click
      expect(find('#packages')).to have_no_selector('#package-1'), '自分の換算用データが削除されていない'
      find('#sidebar').click
      click_button 'ログアウト'
      page.accept_confirm
      login_as(@another_user)
      click_link '換算用データ'
      expect(find('#packages')).to have_selector('#package-1'), '他ユーザーの換算用データが削除されている'
    end

    it '編集しても他ユーザーのデータは編集されない' do
      click_link '換算用データ'
      within '#package-1' do
        click_button '編集'
      end
      within '#currency_package-form' do
        fill_in 'ゲーム名', with: 'ゲーム1'
        fill_in 'ガチャ一回に必要なガチャ石', with: '300'
        fill_in 'stone_price', with: '100'
        fill_in 'stone_quantity', with: '100'
        click_button '変更'
      end
      within '#package-1' do
        click_button '詳細'
      end
      expect(page).to have_content('ゲーム1'), '変更後のゲーム名が表示されていない'
      expect(page).to have_content('100円 ／ 100個'), '変更後の購入価格が表示されていない'
      expect(page).to have_content('300個'), '変更後のガチャ1回に必要なガチャ石数が表示されていない'
      click_button '戻る'
      find('#sidebar').click
      click_button 'ログアウト'
      page.accept_confirm
      login_as(@another_user)
      click_link '換算用データ'
      within '#package-1' do
        click_button '詳細'
      end
      expect(page).to have_content("#{@package1.name}"), '変更後のゲーム名が変更されている'
      expect(page).to have_content("#{@package1.price}円 ／ #{@package1.quantity}個"), '購入価格が変更されている'
      expect(page).to have_content("#{@package1.need_one_gacha_stones}個"), '変更後のガチャ1回に必要なガチャ石数が変更されている'
    end

  end

end