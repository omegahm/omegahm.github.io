---
---

class WishList
  constructor: (language) ->
    @wishCategories = ko.observableArray([])
    @languages = ['en', 'da']
    @language = ko.observable(language.replace('#', ''))

    @language.subscribe (language) ->
      location.hash = language

    @headline = ko.pureComputed =>
      @i18n('wishlist')

    @changeLanguage = ko.pureComputed =>
      @i18n('change_language')

    ko.computed =>
      $(document).prop('title', @headline() + " | ohm.sh")

  i18n: (key) =>
    {
      "en": {
        "wishlist": "Wish-list",
        "change_language": "Change language:"
      },
      "da": {
        "wishlist": "Ønskeseddel",
        "change_language": "Skift sprog:"
      }
    }[@language()][key]

class Category
  constructor: (data, language) ->
    @title = ko.pureComputed =>
      data.title[language()] || data.title['en']
    @wishes = ko.observableArray([])

    @initWishes(data.wishes, language)

  initWishes: (wishesData, language) ->
    wishesData.forEach (data) =>
      @wishes.push(new Wish(data, language))

class Wish
  constructor: (data, language) ->
    @title = ko.pureComputed =>
      data.title[language()] || data.title['en']
    @url = data.url
$ ->
  viewModel = new WishList(location.hash || 'en')
  ko.applyBindings viewModel, document.getElementById('wishes')

  $.getJSON '/js/wishes.json', (data) ->
    data.forEach (category) ->
      viewModel.wishCategories.push(new Category(category, viewModel.language))
