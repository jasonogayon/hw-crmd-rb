Feature: Filter Catalog By Price

    Catalog can be filtered by price


    @carmudi @match
    Scenario: Filter catalog by price via desktop, Php 800K to Php 801K
        Given guest visits the catalog page
        When guest filters the catalog for vehicles ranging from Php 800,000 to Php 801,000
        Then guest can see that there are vehicles for sale

    @carmudi @nomatch
    Scenario: Filter catalog by price via desktop, at least Php 1M
        Given guest visits the catalog page
        When guest filters the catalog for vehicles which sell for at least Php 1,000,000,000
        Then guest is notified that there aren't any matches found in the catalog
