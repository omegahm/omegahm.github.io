---
---

class WishList
  constructor: (language, @i18n) ->
    @wishCategories = ko.observableArray([])
    @languages = ['en', 'da']
    @language = ko.observable(language)

    @language.subscribe (lang) ->
      location.hash = lang

    @headline       = @t('wishlist')
    @changeLanguage = @t('change_language')
    @info           = @t('info')

    ko.computed =>
      $(document).prop('title', @headline() + " | {{ site.website }}")

  addCategory: (category) =>
    @wishCategories.push(new Category(category, @language))

  t: (key) =>
    ko.pureComputed => @i18n[@language()][key]

class Category
  constructor: (data, language) ->
    @title  = ko.pureComputed => data.title[language()] || data.title['en']
    @icon   = "fa-#{data.icon}"
    @wishes = ko.observableArray([])

    @initWishes(data.wishes, language)

  initWishes: (wishesData, language) ->
    wishesData.forEach (data) =>
      @wishes.push(new Wish(data, language))

class Wish
  constructor: (data, language) ->
    @title = ko.pureComputed => data.title[language()] || data.title['en'] || data.title
    @url   = data.url

$ ->
  wistList = new WishList(
    (location.hash || 'en').replace('#', ''),
    {
      "en": {
        "wishlist": "Wish-list",
        "change_language": "Change language:",
        "info": "Wishes are sorted by preference."
      },
      "da": {
        "wishlist": "Ønskeseddel",
        "change_language": "Skift sprog:",
        "info": "Ønskerne er sorteret efter præference."
      }
    }
  )
  ko.applyBindings wistList, document.getElementById('wishes')

  $.getJSON '/js/wishes.json', (data) ->
    data.forEach (category) -> wistList.addCategory(category)
