class Api::CurrencyPackagesController < ApplicationController
    before_action :authenticate!

    def index
        @currency_packages = current_user.currency_packages.all
        render json: @currency_packages
    end

    def show
    end

    def create
        @currency_package = current_user.currency_packages.build(currency_package_params)
        if @currency_package.save
            render json: @currency_package
        else
            render json: @currency_package.errors, status: :bad_request
        end
    end

    def update
    end

    def destroy
    end

    private
    def currency_package_params
        params.require(:currency_package).permit(:name, :need_one_gacha_stones, :price, :quantity)
    end
end
