class PackageChangeForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :need_one_gacha_stones, :integer
  attribute :price, :integer
  attribute :quantity, :integer
  attribute :user_ids

  validates :name, presence: :true
  validates :need_one_gacha_stones, presence: :true
  validates :price, presence: :true
  validates :quantity, presence: :true
  validates :user_ids, presence: :true

  def create_package(source_package)
    return false if invalid?
    set_current_user
    set_package_exist
    if @package_exist
      if @current_user.currency_packages.include?(@package_exist)
        return "exist_and_available"
      else
        if @current_user.currency_packages.push(@package_exist)
          return "exist_and_unavailable" 
        else
          return false
        end
      end
    else
      if source_package.save
        return "not_exist"
      else
        return false
      end
    end
  end
  
  def change_package(source_package)
    return false if invalid?
    set_current_user
    set_package_exist
    @package_update = CurrencyPackage.new(package_params)
    if @package_exist
      if @current_user.currency_packages.include?(@package_exist)
        return "exist_and_available"
      else
        if @current_user.currency_packages.push(@package_exist)
          change_records(source_package, @package_exist)
          @current_user.currency_packages.delete(source_package)
          return "exist_and_unavailable"
        else
          return false
        end
      end
    else
      if @package_update.save
        change_records(source_package, @package_update)
        @current_user.currency_packages.delete(source_package)
        return "not_exist"
      else
        return false
      end
    end
  end

  def change_records(source_package, new_package)
    set_current_user
    if @current_user.gachas.where(currency_package_id: source_package.id)
      @current_user.gachas.where(currency_package_id: source_package.id).each { |gacha| 
          gacha.update(currency_package_id: new_package.id)
      }
    end
    if @current_user.user_posses_stones.where(currency_package_id: source_package.id)
      @current_user.user_posses_stones.where(currency_package_id: source_package.id).each { |posses_stone| 
          posses_stone.update(currency_package_id: new_package.id)
      }
    end
  end

  private

  def package_params
    {
      name: name,
      need_one_gacha_stones: need_one_gacha_stones,
      price: price,
      quantity: quantity,
      user_ids: [user_ids.slice(0)]
    }
  end

  def set_current_user
    @current_user = User.find(user_ids.slice(0))
  end

  def set_package_exist
    @package_exist = CurrencyPackage.find_by(
      name: name, 
      need_one_gacha_stones: need_one_gacha_stones,
      price: price,
      quantity: quantity,
      category: "add"
    )
  end

end