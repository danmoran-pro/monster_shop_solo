class Merchant::CouponsController < Merchant::BaseController

  def index
    @coupons = Coupon.all
  end

  def new
    @coupon = Coupon.new
  end

  def create
    merchant = current_user.merchant
    @coupon = merchant.coupons.create(coupon_params)
    if @coupon.save
      redirect_to "/merchant/coupons"
    else
      flash[:error] = @coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  private
    def coupon_params
      params.permit(:name, :code, :percentage_off, :merchant_id)
    end
end
