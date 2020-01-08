class Merchant::ItemsController < Merchant::BaseController

  def new
    @item = Item.new(item_params)
  end

  def edit
    @item = Item.find(params[:id])
  end

  def show
    @items = Merchant.find(current_user.merchant.id).items
  end 
  
  def create
    merchant = Merchant.find(current_user.merchant.id)
    @item = merchant.items.create(item_params)
      if @item.image == ""
        @item.image = "https://literalminded.files.wordpress.com/2010/11/image-unavailable1.png"
      end
      if @item.save
        flash[:success] = "You have successfully added an item!"
        redirect_to "/merchant/items"
      else
        flash[:error] = @item.errors.full_messages.to_sentence
        render :new
      end
  end

  def update
    item = Item.find(params[:id])
    item.toggle_active_status
    if item.active?
      flash[:success] = "#{item.name} is Activated"
    else
      flash[:success] = "#{item.name} is deactivated"
    end
    redirect_to '/merchant/items'
  end


  def destroy
    item = Item.find(params[:id])
    current_user.merchant.items.delete(item)
    item.destroy
    flash[:success] = "You deleted #{item.name}"
    redirect_to "/merchant/items"
  end

  def update
    @item = Item.find(params[:id])
    if params[:commit]
      @item.update(item_params)
      edit_item_info(@item)
    else
      @item.toggle_active_status
      toggle_active_with_flash(@item)
    end
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end

  def toggle_active_with_flash(item)
    if item.active?
      flash[:success] = "#{item.name} is Activated"
    else
      flash[:success] = "#{item.name} is deactivated"
    end
    redirect_to '/merchant/items'
  end

  def edit_item_info(item)
    if item.save
      flash[:success] = "Your item has been updated."
      redirect_to '/merchant/items'
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :edit
    end
  end
end
