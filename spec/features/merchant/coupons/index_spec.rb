require 'rails_helper'

RSpec.describe 'As a merchant' do
  before :each do
    @phone_shop = Merchant.create(name: "Daniel's Phone Shop", address: '456 Doggo St.', city: 'Denver', state: 'CO', zip: 80220)
    @danny= User.create(name: 'Phone Merchant Admin', address: '197 lake St', city: 'Denver', state: 'CO', zip_code: '80210', email: 'phonemerchant@gmail.com', password: 'password', password_confirmation: 'password', role: 2, merchant_id: @phone_shop.id)
    @cheapphone = @phone_shop.coupons.create!(name:"CheapPhone" , code:"CODE10" , percentage_off:10)
    @cheaperphone = @phone_shop.coupons.create!(name:"CheaperPhone" , code:"CODE15" , percentage_off:15)
  end

  it "Can see all of my coupons" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@danny)

    visit '/merchant/coupons'

    expect(page).to have_link("Create New Coupon")

    within "#coupon-#{@cheapphone.id}" do
      expect(page).to have_content(@cheapphone.name)
      expect(page).to have_content(@cheapphone.code)
      expect(page).to have_content("#{@cheapphone.percentage_off}%")
    end

    within "#coupon-#{@cheaperphone.id}" do
      expect(page).to have_content(@cheaperphone.name)
      expect(page).to have_content(@cheaperphone.code)
      expect(page).to have_content("#{@cheaperphone.percentage_off}%")
    end
  end
end
