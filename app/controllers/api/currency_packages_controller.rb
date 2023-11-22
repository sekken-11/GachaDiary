class Api::CurrencyPackagesController < ApplicationController
    before_action :authenticate!
    skip_before_action :authenticate!, only: [:initial_packages]
    before_action :set_currency_package, only: %i[show update destroy]

    def index
        @currency_packages = current_user.currency_packages.all
        render json: @currency_packages
    end

    def show
        if current_user.currency_package_ids.include?(@currency_package.id)
            render json: @currency_package
        end
    end

    def create
        @currency_package = CurrencyPackage.new(currency_package_params)
        if package_check(@currency_package)
            @currency_package_exist = CurrencyPackage.find_by(name: @currency_package.name, need_one_gacha_stones: @currency_package.need_one_gacha_stones, price: @currency_package.price, quantity: @currency_package.quantity)
            if current_user.currency_packages.include?(@currency_package_exist)
                render json: @currency_package_exist
            else
                if current_user.currency_packages.push(@currency_package_exist)
                    render json: @currency_package_exist
                else
                    render json: @currency_package_exist.errors, status: :bad_request
                end
            end
        else
            if @currency_package.save
                render json: @currency_package
            else
                render json: @currency_package.errors, status: :bad_request
            end
        end
    end

    def update
        return if @currency_package.category == "initial"
        @currency_package_update = CurrencyPackage.new(currency_package_params)
        # 変更後のデータと同じ内容のデータが存在するか確認
        @currency_package_exist = CurrencyPackage.find_by(
            name: @currency_package_update.name, 
            need_one_gacha_stones: @currency_package_update.need_one_gacha_stones, 
            price: @currency_package_update.price, 
            quantity: @currency_package_update.quantity
        )
        if @currency_package_exist
            # 存在した場合、それがすでに自分が使用できるデータか確認
            if current_user.currency_packages.include?(@currency_package_exist)
                render json: @currency_package_exist
            else
                # 存在し、使用できなかった場合、使用できるデータとして登録
                if current_user.currency_packages.push(@currency_package_exist)
                    # vuex用のid変更
                    currency_package_exist_id = @currency_package_exist.id
                    @currency_package_exist.id = @currency_package.id
                    render json: @currency_package_exist
                    # vuex用のid変更を元に戻す
                    @currency_package_exist.id = currency_package_exist_id
                    # 変更元のデータを使用できるデータから外す
                    current_user.currency_packages.delete(@currency_package)
                    # 元データを換算用データに設定していたガチャ記録の換算用データを、変更後のデータ（既に存在したデータ）に変更
                    gacha_package_change(@currency_package, @currency_package_exist)
                    # 元データを換算用データに設定していた所持ガチャ石の換算用データを、変更後のデータ（既に存在したデータ）に変更
                    posses_stone_package_change(@currency_package, @currency_package_exist)
                else
                    render json: @currency_package_exist.errors, status: :bad_request
                end
            end
        else
            # 存在しなかった場合、新しく登録
            if @currency_package_update.save
                gacha_package_change(@currency_package, @currency_package_update)
                posses_stone_package_change(@currency_package, @currency_package_update)
                # 変更元のデータを使用できるデータから外す
                current_user.currency_packages.delete(@currency_package)
                render json: @currency_package_update
            else
                render json: @currency_package_update.errors, status: :bad_request
            end
        end
        # 変更元のデータが誰にも使用されていない場合、削除する
        unless UserPackage.find_by(currency_package_id: @currency_package.id)
            @currency_package.destroy!
        end
    end

    def destroy
        current_user.currency_packages.delete(@currency_package)
        current_user.gachas.where(currency_package_id: @currency_package.id).each { |gacha|
            gacha.update(currency_package_id: nil)
        }
        current_user.user_posses_stones.where(currency_package_id: @currency_package.id).each { |posses_stone|
            posses_stone.update(currency_package_id: nil)
        }
        unless UserPackage.find_by(currency_package_id: @currency_package.id)
            @currency_package.destroy!
        end
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

    def package_check(package)
        if CurrencyPackage.find_by(name: package.name, need_one_gacha_stones: package.need_one_gacha_stones, price: package.price, quantity: package.quantity)
          return true
        else
          return false
        end
    end

    def gacha_package_change(currency_package, currency_package_exist)
        if current_user.gachas.where(currency_package_id: currency_package.id)
            current_user.gachas.where(currency_package_id: currency_package.id).each { |gacha| 
                gacha.update(currency_package_id: currency_package_exist.id)
            }
        end
    end

    def posses_stone_package_change(currency_package, currency_package_exist)
        if current_user.user_posses_stones.where(currency_package_id: currency_package.id)
            current_user.user_posses_stones.where(currency_package_id: currency_package.id).each { |posses_stone| 
                posses_stone.update(currency_package_id: currency_package_exist.id)
            }
        end
    end
end
