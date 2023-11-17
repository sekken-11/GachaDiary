class Api::CurrencyPackagesController < ApplicationController
    before_action :authenticate!
    before_action :set_currency_package, only: %i[show update destroy]

    def index
        @currency_packages = current_user.currency_packages.all
        render json: @currency_packages
    end

    def show
        render json: @currency_package
    end

    def create
        @currency_package = CurrencyPackage.new(currency_package_params)
        if package_check(@currency_package)
            @currency_package_exist = CurrencyPackage.find_by(name: @currency_package.name, need_one_gacha_stones: @currency_package.need_one_gacha_stones, price: @currency_package.price, quantity: @currency_package.quantity)
            if current_user.currency_package_ids.include?(@currency_package_exist.id)
                render json: @currency_package_exist
            else
                if ids = current_user.currency_package_ids.push(@currency_package_exist.id)
                    current_user.update(currency_package_ids: ids)
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
            if current_user.currency_packages.find_by(id: @currency_package_exist.id)
                render json: @currency_package_exist
            else
                # 使用できなかった場合、使用できるデータとして登録
                if ids = current_user.currency_package_ids.push(@currency_package_exist.id)
                    current_user.update(currency_package_ids: ids)
                    render json: @currency_package_exist
                else
                    render json: @currency_package_exist.errors, status: :bad_request
                end
            end
            # 元データを換算用データに設定していたガチャ記録の換算用データを、変更後のデータ（既に存在したデータ）に変更
            gachas = current_user.gachas.where(currency_package_id: @currency_package.id)
            gachas.each { |gacha| 
                gacha.update(currency_package_id: @currency_package_exist.id)
            }
        else
            # 存在しなかった場合、新しく登録
            if @currency_package_update.save
                gachas = current_user.gachas.where(currency_package_id: @currency_package.id)
                gachas.each { |gacha| 
                    gacha.update(currency_package_id: @currency_package_update.id)
                }
                render json: @currency_package_update
            else
                render json: @currency_package_update.errors, status: :bad_request
            end
        end
        # 変更元のデータを使用できるデータから外す
        current_user.currency_package_ids.delete(@currency_package.id)
        current_user.update(currency_package_ids: current_user.currency_package_ids)
        # 変更元のデータが誰にも使用されていない場合、削除する
        unless UserPackage.find_by(currency_package_id: @currency_package.id)
            @currency_package.destroy!
        end
    end

    def destroy
        current_user.currency_package_ids.delete(@currency_package.id)
        current_user.update(currency_package_ids: current_user.currency_package_ids)
        unless UserPackage.find_by(currency_package_id: @currency_package.id)
            @currency_package.destroy!
        end
        render json: @currency_package
    end

    def initial_packages
        @initial_packages = CurrencyPackage.limit(11)
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
end
