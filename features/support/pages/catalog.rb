class CatalogPage

    @@min_price = 0
    @@max_price = 0

    include PageObject

    page_url FigNewton.page_catalog

    # Element Locators
    div(:update_loading, :xpath => "//div[@class='loading-overlay']")
    div(:price_filter, :id => "facet_price")
    div(:notification, :xpath => "//div[@class='alert-box notification']")
    div(:nextpage, :xpath => "//div[@class='next-page']")
    link(:clear_filters, :xpath => "//a[@class='black reset-results']")
    link(:apply_filters, :xpath => "//a[@class='button refresh-results expand']")
    link(:refresh_filters, :xpath => "//a[@class='button expand refresh-results']")
    link(:refine_search, :xpath => "//a[@class='button refine-search-trigger']")
    span(:save_search, :xpath => "//span[contains(.,'Save Search')]")
    span(:results_mobile, :xpath => "//span[@class='breadcrumbs--white__total']")
    elements(:catalog_list, :xpath => "//div[contains(@class,'catalog-listing-item row')]")
    elements(:results_price, :xpath => "//h4[contains(@class,'item-price')]")
    element(:breadcrumb, :xpath => "//ol[contains(@class,'breadcrumbs ')]")
    element(:first_item_price_desktop, :xpath => "//div[@class='catalog-listing-item row image-loaded'][1]//h4")
    element(:first_item_price_mobile, :xpath => "//div[@class='catalog-listing-item row image-loaded'][1]//p[contains(@class,'item-price')]")
    text_field(:min_price, :xpath => "//div[@id='facet_price']//input[@placeholder='From:']")
    text_field(:max_price, :xpath => "//div[@id='facet_price']//input[@placeholder='To:']")
    paragraph(:results_desktop, :xpath => "//div[@class='filters-header']/p")

    # Methods
    def self.min_price
        return @@min_price
    end

    def self.max_price
        return @@max_price
    end

    def filter_by_price(min_price=nil, max_price=nil)
        @@min_price = get_value(min_price)
        @@max_price = get_value(max_price)
        open_mobile_filters if mobile == :true
        @browser.execute_script("window.scrollBy(0,600)")
        self.price_filter_element.wait_until_present(timeout:30)
        self.price_filter_element.focus
        self.price_filter_element.click
        self.min_price = get_value(min_price) unless min_price.nil?
        self.max_price = get_value(max_price) unless max_price.nil?
        @browser.execute_script("window.scrollTo(0,0)")
        mobile == :true ? self.refresh_filters : self.apply_filters
    end

    def open_mobile_filters
        self.refine_search_element.wait_until_present(timeout:30)
        self.refine_search
    end

    def get_total_number_of_matches
        wait_until_breadcrumb_contains_price_filters(min_price, max_price)
        self.save_search_element.wait_until_present(timeout:30)
        if mobile == :true
            self.results_mobile_element.wait_until_present(timeout:30)
            return (get_value(self.results_mobile)).to_i
        else
            self.results_desktop_element.wait_until_present(timeout:30)
            return (get_value(self.results_desktop)).to_i
        end
    end

    def get_max_price
        open_mobile_filters if mobile == :true
        self.max_price_element.wait_until_present(timeout:30)
        return (get_value(self.max_price))
    end

    def get_filtered_catalog_item_prices
        item_prices = Array.new
        loop do
            if mobile == :true
                self.first_item_price_mobile_element.wait_while_present(timeout:60)
                self.first_item_price_mobile_element.wait_until_present(timeout:60)
            else
                self.first_item_price_desktop_element.wait_while_present(timeout:60)
                self.first_item_price_desktop_element.wait_until_present(timeout:60)
            end
            no_items_on_page = self.catalog_list_elements.size
            (1..no_items_on_page).each do |i|
                if mobile == :true
                    @browser.execute_script("window.scrollBy(0,430)")
                    self.class.element(:catalog_item, :xpath => "//div[@class='catalog-listing-item row image-loaded'][#{i}]//p[contains(@class,'item-price')]")
                else
                    @browser.execute_script("window.scrollBy(0,200)") if i > 1
                    self.class.element(:catalog_item, :xpath => "//div[@class='catalog-listing-item row image-loaded'][#{i}]//h4")
                end
                item_prices.push(get_value(self.catalog_item_element.text))
            end
            break if !self.nextpage_element.present?
            self.nextpage_element.click
        end
        return item_prices
    end

    private
    def get_value(number)
        return number.nil? ? '' : number.gsub(/[^0-9]/, '')
    end

    def wait_until_breadcrumb_contains_price_filters(min_price, max_price)
        min_price = get_value(min_price)
        max_price = get_value(max_price)
        loop do
            self.breadcrumb_element.wait_until_present(timeout:30)
            breadcrumb_text = self.breadcrumb_element.text
            break if breadcrumb_text.include?(min_price) && breadcrumb_text.include?(max_price)
        end
    end

end
