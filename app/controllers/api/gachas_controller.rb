class Api::GachasController < ApplicationController
    before_action :authenticate!

    def index
        @gachas = current_user.gachas.all
        render json: @gachas
    end

    def show
        render json: @gacha
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
    end

    def destroy
    end

    private
    def gacha_params
        params.require(:gacha).permit(:date, :count, :description, :conversion_id)
    end
end
