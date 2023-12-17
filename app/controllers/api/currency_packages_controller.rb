class Api::CurrencyPackagesController < ApplicationController
  before_action :authenticate!
  skip_before_action :authenticate!, only: [:initial_packages]
  before_action :set_currency_package, only: %i[show update destroy]
  before_action :set_currency_package_exist, only: %i[create update]

  def index
    @currency_packages = current_user.currency_packages.all
    render json: @currency_packages
  end

  def show
    return if @currency_package.category == "initial"
    if current_user.currency_package_ids.include?(@currency_package.id)
      render json: @currency_package
    end
  end

  def create
    @currency_package = CurrencyPackage.new(currency_package_params)
    @form = PackageChangeForm.new(currency_package_params)
    if @form.create_package(@currency_package) == "exist_and_available"
      render json: @currency_package.errors, status: :bad_request
    elsif @form.create_package(@currency_package) == "exist_and_unavailable"
      render json: @currency_package_exist
    elsif @form.create_package(@currency_package) == "not_exist"
      render json: @currency_package
    elsif @form.create_package(@currency_package) == false
      render json: @currency_package.errors, status: :bad_request
    end
  end

  def update
    return if @currency_package.category == "initial"
    @currency_package_update = CurrencyPackage.new(currency_package_params)
    @form = PackageChangeForm.new(currency_package_params)
    if @form.change_package(@currency_package) == "exist_and_available"
      render json: @currency_package_exist.errors, status: :bad_request
    elsif @form.change_package(@currency_package) == "exist_and_unavailable"
      @currency_package_exist.id = @currency_package.id
      render json: @currency_package_exist
    elsif @form.change_package(@currency_package) == "not_exist"
      render json: @currency_package_update
    elsif @form.change_package(@currency_package) == false
      render json: @currency_package.errors, status: :bad_request
    end
    user_package_delete
  end

  def destroy
    current_user.currency_packages.delete(@currency_package)
    current_user.gachas.where(currency_package_id: @currency_package.id).each { |gacha|
      gacha.update(currency_package_id: nil)
    }
    current_user.user_posses_stones.where(currency_package_id: @currency_package.id).each { |posses_stone|
      posses_stone.update(currency_package_id: nil)
    }
    user_package_delete
    render json: @currency_package
  end

  def initial_packages
    @initial_packages = CurrencyPackage.where(category: 1)
    render json: @initial_packages
  end

  private
  def currency_package_params
    params.require(:currency_package).permit(:name, :need_one_gacha_stones, :price, :quantity).merge(user_ids: [current_user.id])
  end

  def set_currency_package
    @currency_package = CurrencyPackage.find(params[:id])
  end

  def set_currency_package_exist
    currency_package = CurrencyPackage.new(currency_package_params)
    @currency_package_exist = CurrencyPackage.find_by(
      name: currency_package.name, 
      need_one_gacha_stones: currency_package.need_one_gacha_stones, 
      price: currency_package.price, 
      quantity: currency_package.quantity
    )
  end

  def user_package_delete
    unless UserPackage.find_by(currency_package_id: @currency_package.id)
      @currency_package.destroy!
    end
  end

end
