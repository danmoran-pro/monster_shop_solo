require 'rails_helper'

RSpec.describe 'As a merchant' do
  before :each do
    @phone_shop = Merchant.create(name: "Daniel's Phone Shop", address: '456 Doggo St.', city: 'Denver', state: 'CO', zip: 80220)
    @danny= User.create(name: 'Phone Merchant Admin', address: '197 lake St', city: 'Denver', state: 'CO', zip_code: '80210', email: 'phonemerchant@gmail.com', password: 'password', password_confirmation: 'password', role: 2, merchant_id: @phone_shop.id)
  end

  it "Can create a new coupon" do

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@danny)

      expect(@danny.role).to eq("merchant_admin")

      visit '/merchant'
      click_link "Manage Coupons"

      expect(current_path).to eq("/merchant/coupons")
      click_link "Create New Coupon"

      expect(current_path).to eq("/merchant/coupons/new")

      name = "CheapPhone"
      code = "CODE10"
      percentage_off = 10

      fill_in :name, with: name
      fill_in :code, with: code
      fill_in :percentage_off, with: percentage_off
      click_button "Submit"

      flash = "Coupon #{name} has been created!"

      expect(current_path).to eq("/merchant/coupons")

      coupon  = Coupon.last

      within "#coupon-#{coupon.id}" do
        expect(page).to have_content(coupon.name)
        expect(page).to have_content(coupon.code)
        expect(page).to have_content("#{coupon.percentage_off}%")
      end
    end
end
