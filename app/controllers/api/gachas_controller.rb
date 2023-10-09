class Api::GachasController < ApplicationController
    before_action :authenticate!
    before_action :set_gacha, only: %i[show update destroy]


    def index
        @gachas = current_user.gachas.all
        render json: @gachas, include: [:currency_package]
    end

    def show
        render json: @gacha, include: [:currency_package]
    end

    def create
        @gacha = current_user.gachas.build(gacha_params)
        if @gacha.save
            render json: @gacha
        else
            render json: @gacha.errors, status: :bad_request
        end
    end

    def update
        if @gacha.update(gacha_params)
            render json: @gacha
        else
            render json: @gacha.errors, status: :bad_request
        end
    end

    def destroy
        @gacha.destroy!
        render json: @gacha
    end

    private
    def gacha_params
        params.require(:gacha).permit(:date, :count, :description, :currency_package_id)
    end

    def set_gacha
        @gacha = Gacha.find(params[:id])
    end
end
