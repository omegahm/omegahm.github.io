---
---

class WishList
  constructor: () ->
    @people = ko.observableArray([])

  addPerson: (person) =>
    @people.push(person)

class Person
  constructor: (data) ->
    @name           = data.gsx$name.$t.replace(/^## /, '')
    @icon           = "fa-#{data.gsx$image.$t}"
    @wishCategories = ko.observableArray([])
    @total_wishes   = ko.computed(() =>
      @wishCategories().reduce(
        (acc, category) => acc + category.wishes().length,
        0
      )
    )

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
    if @image == ""
      @image = "http://via.placeholder.com/1000/ffffff?text=Intet+billede"

$ ->
  wishList = new WishList
  ko.applyBindings wishList, document.getElementById('wishes')

  google_sheets_url = "https://spreadsheets.google.com/feeds/list/13ROGhTaYSxWIT509hgRsn1MGKRIKaRR7D6Pyiyv5O5M/od6/public/values?alt=json";

  person   = null
  category = null
  $.getJSON google_sheets_url, (data) =>
    for entry in data.feed.entry
      if entry.gsx$name.$t.match(/^##/)
        person = new Person(entry)
        wishList.addPerson(person)
      else if entry.gsx$name.$t.match(/^--/)
        category = new Category(entry)
        person.addCategory(category)
      else
        category.addWish(new Wish(entry))
