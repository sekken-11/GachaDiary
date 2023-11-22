module RecordMacros
  def package_create(package)
    visit '/conversions'
    click_button '換算用データ 作成'
    within '#currency_package-form' do
      fill_in 'ゲーム名', with: package.name
      fill_in 'ガチャ一回に必要なガチャ石', with: package.need_one_gacha_stones
      fill_in 'stone_price', with: package.price
      fill_in 'stone_quantity', with: package.quantity
      click_button '作成'
    end
  end

  def gacha_create(gacha, package)
    visit '/gachas'
    click_button 'ガチャ記録作成'
    within '#gacha-form' do
      fill_in 'ガチャ回数', with: gacha.count
      fill_in 'ガチャを引いた日付', with: gacha.date
      select "#{package.name}", from: 'currency_package_id'
      fill_in '備考', with: gacha.description
      click_button '作成'
    end
  end

  def posses_stone_create(posses_stone, package)
    visit '/posses'
    click_button 'ゲームごとの石の所持データ 作成'
    within '#posses-form' do
      fill_in '石の所持数', with: posses_stone.quantity
      select "#{package.name}", from: 'currency_package_id'
      click_button '作成'
    end
  end
end