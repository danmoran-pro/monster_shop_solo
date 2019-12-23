require 'rails_helper'

RSpec.describe "As an admin" do
  it "can login and be redirected to admin dashboard" do
    user = create(:random_user, role: 1)

    visit '/'

    click_link "Login"
    expect(current_path).to eq('/login')

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Login"

    expect(current_path).to eq("/admin/dashboard")
    expect(page).to have_content("Welcome, #{user.name}, you are logged in!")
  end

  it "can see all orders, their id, date created and status" do
    user = create(:random_user, role: 1)
    user_2 = create(:random_user, role: 1)
    order = create(:random_order, user_id: user.id, current_status: 0)
    order_2 = create(:random_order, user_id: user.id, current_status: 1)
    order_3 = create(:random_order, user_id: user_2.id, current_status: 2)
    order_4 = create(:random_order, user_id: user_2.id, current_status: 3)
    merchant = create(:random_merchant)
    item_1 = create(:random_item)
    item_2 = create(:random_item)
    item_order = ItemOrder.create!(item: item_1, order: order, price: item_1.price, quantity: 1)
    item_order_2 = ItemOrder.create!(item: item_2, order: order_2, price: item_2.price, quantity: 2, status: 1)
    item_order_3 = ItemOrder.create!(item: item_1, order: order_3, price: item_1.price, quantity: 3, status: 1)
    item_order_4 = ItemOrder.create!(item: item_2, order: order_4, price: item_order_2.price, quantity: 4)


    visit '/'

    click_link "Login"
    expect(current_path).to eq('/login')

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Login"

    within "#order-packaged" do
    expect(page).to have_content(user.name)
    expect(page).to have_content(order.id)
    expect(page).to have_content(order.created_at)
    end
    within "#order-pending" do
    expect(page).to have_content(user.name)
    expect(page).to have_content(order_2.id)
    expect(page).to have_content(order_2.created_at)
    end
    within "#order-shipped" do
    expect(page).to have_content(user_2.name)
    expect(page).to have_content(order_3.id)
    expect(page).to have_content(order_3.created_at)
    end
    within "#order-cancelled" do
    expect(page).to have_content(user_2.name)
    expect(page).to have_content(order_4.id)
    expect(page).to have_content(order_4.created_at)
    end
  end
end
