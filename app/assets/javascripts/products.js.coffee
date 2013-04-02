# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  $('#price-submit').click ->
    min_price = $('#price_min')
    max_price = $('#price_max')
    current_uri = URI()
    current_uri_query = current_uri.query(true)
    current_uri_query.min_price = min_price.val() if parseInt(min_price.val()) > 0
    current_uri_query.max_price = max_price.val() if parseInt(max_price.val()) > 0

    delete current_uri_query.page

    location.href = current_uri.search(current_uri_query).toString()
