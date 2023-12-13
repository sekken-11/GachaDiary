class Api::UserPossesStonesController < ApplicationController
  before_action :authenticate!
  before_action :set_user_posses_stone, only: %i[show update destroy]

  def index
    @user_posses_stones = current_user.user_posses_stones.all
    render json: @user_posses_stones, include: [:currency_package]
  end

  def show
    if current_user.id == @user_posses_stone.user_id
      render json: @user_posses_stone, include: [:currency_package]
    end
  end

  def create
    @user_posses_stone = current_user.user_posses_stones.build(user_posses_stone_params)
    if @user_posses_stone.save
      render json: @user_posses_stone
    else
      render json: @user_posses_stone.errors, status: :bad_request
    end
  end

  def update
    return if current_user.id != @user_posses_stone.user_id
    if @user_posses_stone.update(user_posses_stone_params)
      render json: @user_posses_stone
    else
      render json: @user_posses_stone.errors, status: :bad_request
    end
  end

  def destroy
    @user_posses_stone.destroy!
    render json: @user_posses_stone
  end

  private
  def user_posses_stone_params
    params.require(:user_posses_stone).permit(:quantity, :currency_package_id)
  end

  def set_user_posses_stone
    @user_posses_stone = current_user.user_posses_stones.find(params[:id])
  end
end
