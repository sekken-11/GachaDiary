module ConversionMacros
  def conversions
    visit root_path
    within '#top-form' do
      fill_in 'ガチャ石の個数', with: '1000'
      fill_in 'ガチャ石の価格', with: '105'
      fill_in 'stone_quantity', with: '100'
      fill_in 'ゲーム名*任意', with: 'ゲーム'
      click_button '追加'
    end
    within '#top-form' do
      fill_in 'ガチャ石の個数', with: '2000'
      fill_in 'ガチャ石の価格', with: '200'
      fill_in 'stone_quantity', with: '100'
      fill_in 'ゲーム名*任意', with: 'ゲーム2'
      click_button '追加'
    end
  end
end