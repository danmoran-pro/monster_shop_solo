require 'rails_helper'

RSpec.describe 'As a merchant' do
    before :each do
        @phone_shop = Merchant.create(name: "Daniel's Phone Shop", address: '456 Doggo St.', city: 'Denver', state: 'CO', zip: 80220)
        @danny= User.create(name: 'Phone Merchant Admin', address: '197 lake St', city: 'Denver', state: 'CO', zip_code: '80210', email: 'phonemerchant@gmail.com', password: 'password', password_confirmation: 'password', role: 2, merchant_id: @phone_shop.id)
        @iphone = @phone_shop.items.create(name: "Iphone XR", description: "Oldest new phone!", price: 800, image: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone8-gold-select-2018?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1550795416637", inventory: 32)
        @android = @phone_shop.items.create(name: "Android 1", description: "Slowest new phone!", price: 400, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgi4uWht9jhk0EwSp5TYpELMGNgtSW1L9QLNdJTOFuPV18xQVrAA&s", inventory: 34)
        @flip_phone = @phone_shop.items.create(name: "Flip", description: "Not your grandma's phone!", price: 40, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8nPXoZcZDMspHo9vxUf2f9lXVbNv1Y7UlFTMKieA_WURkoIiD&s", inventory: 35)
        @nokia = @phone_shop.items.create(name: "Nokia", description: "World's toughest phone!", price: 45, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0w9g0LfbdHVJnfoL8Svw2vgXo1YXUOxr_Bvr_sDa3JEMfCI__Lw&s", inventory:100)
    end

    it "Can create a new coupon" do

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@danny)

        expect(@danny.role).to eq("merchant_admin")

        visit '/merchant'
        click_link "Manage Coupons"

        expect(current_path).to eq("/merchant/coupons")
        click_link "Create New Coupon"

        expect(current_path).to eq("/merchant/coupons/new")

        coupon_name = "CheapPhone"
        coupon_code = "CODE10"
        percentage_off = 10

        fill_in :coupon_name, with: coupon_name
        fill_in :coupon_code, with: coupon_code
        fill_in :percentage_off, with: percentage_off
        click_button "Submit"

        flash = "Coupon #{coupon_name} has been created!"

        expect(current_path).to eq("/merchant/coupons")
        expect(page).to have_content(flash)

        within "#coupon-#{coupon.id}" do
          expect(page).to have_content(coupon_name)
          expect(page).to have_content(coupon_code)
          expect(page).to have_content("#{number_to_percentage(percentage_off)}")
        end
      end
  end
