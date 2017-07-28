class CatalogPage

    include PageObject

    page_url FigNewton.page_catalog

    # Element Locators
    div(:update_loading, :xpath => "//div[@class='loading-overlay']")
    div(:price_filter, :id => "facet_price")
    div(:notification, :xpath => "//div[@class='alert-box notification']")
    link(:clear_filters, :xpath => "//a[@class='black reset-results']")
    link(:apply_filters, :xpath => "//a[@class='button refresh-results expand']")
    link(:refresh_filters, :xpath => "//a[@class='button expand refresh-results']")
    link(:refine_search, :xpath => "//a[@class='button refine-search-trigger']")
    span(:save_search, :xpath => "//span[contains(.,'Save Search')]")
    span(:results_mobile, :xpath => "//span[@class='breadcrumbs--white__total']")
    elements(:catalog_list, :xpath => "//div[contains(@class,'catalog-listing-item row')]")
    element(:breadcrumb, :xpath => "//ol[contains(@class,'breadcrumbs ')]")
    text_field(:min_price, :xpath => "//div[@id='facet_price']//input[@placeholder='From:']")
    text_field(:max_price, :xpath => "//div[@id='facet_price']//input[@placeholder='To:']")
    paragraph(:results_desktop, :xpath => "//div[@class='filters-header']/p")


    # Methods
    def filter_by_price(min_price=nil, max_price=nil)
        if mobile == :true
            self.refine_search_element.wait_until_present(timeout:30)
            self.refine_search
        end
        self.price_filter_element.wait_until_present(timeout:30)
        @browser.execute_script("window.scrollBy(0,600)")
        self.price_filter_element.focus
        self.price_filter_element.click
        self.min_price = get_number(min_price) unless min_price.nil?
        self.max_price = get_number(max_price) unless max_price.nil?
        @browser.execute_script("window.scrollTo(0,0)")
        mobile == :true ? self.refresh_filters : self.apply_filters
        wait_until_breadcrumb_contains_price_filters(min_price, max_price)
        self.save_search_element.wait_until_present(timeout:30)
    end

    def get_total_number_of_matches
        if mobile == :true
            self.results_mobile_element.wait_until_present(timeout:30)
            return (get_number(self.results_mobile)).to_i
        else
            self.results_desktop_element.wait_until_present(timeout:30)
            return (get_number(self.results_desktop)).to_i
        end
    end

    private
    def get_number(number)
        return number.nil? ? '' : number.gsub(/[^0-9]/, '')
    end

    def wait_until_breadcrumb_contains_price_filters(min_price, max_price)
        min_price = get_number(min_price)
        max_price = get_number(max_price)
        loop do
            self.breadcrumb_element.wait_until_present(timeout:30)
            breadcrumb_text = self.breadcrumb_element.text
            break if breadcrumb_text.include?(min_price) && breadcrumb_text.include?(max_price)
        end
    end

end
