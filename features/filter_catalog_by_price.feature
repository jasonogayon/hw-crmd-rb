Feature: Filter Catalog By Price

    Catalog can be filtered by price


    @carmudi @match
    Scenario: Filter catalog by price, Php 800K to Php 801K
        Given guest visits the catalog page
        When guest filters the catalog for vehicles ranging from Php 800,000 to Php 801,000
        Then guest can see that there are vehicles for sale
        And the vehicle prices in the filtered catalog is within the price filter

    @carmudi @nomatch
    Scenario: Filter catalog by price, at least Php 1B
        Given guest visits the catalog page
        When guest filters the catalog for vehicles which sell for at least Php 1,000,000,000
        Then guest is notified that there aren't any matches found in the catalog

    @carmudi @maxprice_autocorrect
    Scenario: Filter catalog by price, Php 1M to Php 800K
        Given guest visits the catalog page
        When guest filters the catalog for vehicles ranging from Php 1,000,000 to Php 800,000
        Then guest can see that the inputted maximum price changes to the same value as the minimum price

    @carmudi @zero
    Scenario: Filter catalog by price, Php 0 to Php 0
        Given guest visits the catalog page
        When guest filters the catalog for vehicles ranging from Php 0 to Php 0
        Then guest is notified that there aren't any matches found in the catalog
