class Merchant::CouponsController < Merchant::BaseController

  def index
    @coupons = Coupon.all
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
      @coupon = Coupon.find(params[:id])
      if @coupon.update(coupon_params)
        flash[:success] = "Your coupon has been updated!"
        redirect_to "/merchant/coupons"
      else
        flash[:alert] = @coupon.errors.full_messages.to_sentence
        render :edit
      end
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
