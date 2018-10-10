---
---

class WishList
  constructor: () ->
    @wishCategories = ko.observableArray([])

  addCategory: (category) =>
    @wishCategories.push(category)

class Category
  constructor: (data) ->
    @title  = data.gsx$name.$t.replace(/^-- /, '')
    @icon   = "fa-#{data.gsx$image.$t}"
    @wishes = ko.observableArray([])

  addWish: (wish) =>
    @wishes.push(wish)

class Wish
  constructor: (data) ->
    @title = data.gsx$name.$t
    @url   = data.gsx$link.$t
    @image = data.gsx$image.$t

$ ->
  wishList = new WishList
  ko.applyBindings wishList, document.getElementById('wishes')

  google_sheets_url = "https://spreadsheets.google.com/feeds/list/13ROGhTaYSxWIT509hgRsn1MGKRIKaRR7D6Pyiyv5O5M/od6/public/values?alt=json";

  category = null
  $.getJSON google_sheets_url, (data) =>
    for entry in data.feed.entry
      if entry.gsx$name.$t.match(/^--/)
        category = new Category(entry)
        wishList.addCategory(category)
      else
        category.addWish(new Wish(entry))
