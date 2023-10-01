class Api::CurrencyPackagesController < ApplicationController
    before_action :authenticate!

    def index
        @currency_packages = current_user.currency_packages.all
        render json: @currency_packages
    end

    def show
    end

    def create
    end

    def update
    end

    def destroy
    end
end
