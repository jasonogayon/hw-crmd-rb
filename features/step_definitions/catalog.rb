# Catalog Page
# ------------

Given(/^guest visits the catalog page(?: via desktop| via mobile)?$/) do
    begin
        tries ||= 3
        visit CatalogPage
    rescue Net::ReadTimeout
        (tries -= 1).zero? ? fail("Internet connection is slow at the moment. Try again later.") : retry
    end
end

When(/^guest filters the catalog for vehicles ranging from (.*?) to (.*?)$/) do |min_price, max_price|
    on(CatalogPage).filter_by_price(min_price, max_price)
end

When(/^guest filters the catalog for vehicles which sell for at least (.*?)$/) do |min_price|
    on(CatalogPage).filter_by_price(min_price)
end

Then(/^guest can see that there are vehicles for sale$/) do
    matches = on(CatalogPage).get_total_number_of_matches
    expect(matches).to be > 0
end

Then(/^the vehicle prices in the filtered catalog is within the price filter$/) do
    filtered_catalog_item_prices = on(CatalogPage).get_filtered_catalog_item_prices
    filtered_catalog_item_prices.each do |price|
        expect(price).to be_between(CatalogPage.min_price, CatalogPage.max_price).inclusive
    end
end

Then(/^guest is notified that there aren't any matches found in the catalog$/) do
    matches = on(CatalogPage).get_total_number_of_matches
    expect(matches).to eq 0
    expect(on(CatalogPage).catalog_list_elements.size).to eq 0
    expect(on(CatalogPage).notification_element.text).to include "Sorry, no matches found. Suggested alternatives:"
end

Then(/^guest can see that the inputted maximum price changes to the same value as the minimum price$/) do
    expect(on(CatalogPage).get_max_price).to eq(CatalogPage.min_price)
end
