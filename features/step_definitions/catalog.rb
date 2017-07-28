# Catalog Page
# ------------

Given(/^guest visits the catalog page(?: via desktop| via mobile)?$/) do
    visit CatalogPage
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
    expect(on(CatalogPage).catalog_list_elements.size).to eq 30
end

Then(/^guest is notified that there aren't any matches found in the catalog$/) do
    matches = on(CatalogPage).get_total_number_of_matches
    expect(matches).to eq 0
    expect(on(CatalogPage).catalog_list_elements.size).to eq 0
    expect(on(CatalogPage).notification_element.text).to include "Sorry, no matches found. Suggested alternatives:"
end
