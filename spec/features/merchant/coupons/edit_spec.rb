require 'rails_helper'

RSpec.describe 'As a merchant' do
  before :each do
    @phone_shop = Merchant.create(name: "Daniel's Phone Shop", address: '456 Doggo St.', city: 'Denver', state: 'CO', zip: 80220)
    @danny= User.create(name: 'Phone Merchant Admin', address: '197 lake St', city: 'Denver', state: 'CO', zip_code: '80210', email: 'phonemerchant@gmail.com', password: 'password', password_confirmation: 'password', role: 2, merchant_id: @phone_shop.id)
    @cheapphone = @phone_shop.coupons.create!(name:"CheapPhone" , code:"CODE10" , percentage_off:10)
    @cheaperphone = @phone_shop.coupons.create!(name:"CheaperPhone" , code:"CODE15" , percentage_off:15)
  end

  it "Can edit each coupons" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@danny)
    original_name = @cheapphone.name

    visit "/merchant/coupons"

    within "#coupon-#{@cheapphone.id}" do
      click_link "#{@cheapphone.name}"
    end

    expect(current_path).to eq("/merchant/coupons/#{@cheapphone.id}")

    click_link "Edit Coupon"

    expect(current_path).to eq("/merchant/coupons/#{@cheapphone.id}/edit")
    expect(find_field("Name").value).to eq(original_name)
    expect(find_field("Code").value).to eq(@cheapphone.code)
    expect(find_field("percentage_off").value).to eq("#{@cheapphone.percentage_off}")

    fill_in "Name", with: " "
    click_button "Update Coupon"
    expect(page).to have_content("Name can't be blank")

    fill_in "Name", with: "CheapestPhone"
    click_button "Update Coupon"

    expect(current_path).to eq("/merchant/coupons")
    expect(page).to have_content("Your coupon has been updated!")
  end

  it "Coupon name must be unique" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@danny)
    original_name = @cheapphone.name

    visit "/merchant/coupons/#{@cheapphone.id}"

    click_link "Edit Coupon"

    expect(find_field("Name").value).to eq(original_name)
    expect(find_field("Code").value).to eq(@cheapphone.code)
    expect(find_field("percentage_off").value).to eq("#{@cheapphone.percentage_off}")


    fill_in "Name", with: @cheaperphone.name
    click_button "Update Coupon"
    expect(page).to have_content("Name has already been taken")

    fill_in "Name", with: "CheapestPhone"
    click_button "Update Coupon"

    expect(current_path).to eq("/merchant/coupons")
    expect(page).to have_content("Your coupon has been updated!")
  end

  it "Coupon code must be unique" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@danny)
    original_code = @cheapphone.code

    visit "/merchant/coupons/#{@cheapphone.id}"

    click_link "Edit Coupon"

    expect(find_field("Name").value).to eq(@cheapphone.name)
    expect(find_field("Code").value).to eq(original_code)
    expect(find_field("percentage_off").value).to eq("#{@cheapphone.percentage_off}")


    fill_in "Code", with: @cheaperphone.code
    click_button "Update Coupon"
    expect(page).to have_content("Code has already been taken")

    fill_in "Code", with: "CODE11"
    click_button "Update Coupon"

    expect(current_path).to eq("/merchant/coupons")
    expect(page).to have_content("Your coupon has been updated!")
  end
end
