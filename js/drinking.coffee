---
---

class Drinking
  constructor: (date) ->
    @target = Date.parse(date)

    @days     = ko.observable('clock-0')
    @hours0   = ko.observable('clock-0')
    @hours1   = ko.observable('clock-0')
    @minutes0 = ko.observable('clock-0')
    @minutes1 = ko.observable('clock-0')
    @seconds0 = ko.observable('clock-0')
    @seconds1 = ko.observable('clock-0')

    @done = ko.observable(false)

  startTimer: =>
    setInterval =>
      time_left = @target - Date.now()
      @done(time_left < 0)

      @days("clock-#{Math.floor(time_left / (24*60*60*1000))}")
      time_left = time_left % (24*60*60*1000)

      hours = Math.floor(time_left / (60*60*1000))
      hours = String("0" + hours).slice(-2)
      @hours0("clock-#{hours[0]}")
      @hours1("clock-#{hours[1]}")
      time_left = time_left % (60*60*1000)

      minutes = Math.floor(time_left / (60*1000))
      minutes = String("0" + minutes).slice(-2)
      @minutes0("clock-#{minutes[0]}")
      @minutes1("clock-#{minutes[1]}")
      time_left = time_left % (60*1000)

      seconds = Math.floor(time_left / 1000)
      seconds = String("0" + seconds).slice(-2)
      @seconds0("clock-#{seconds[0]}")
      @seconds1("clock-#{seconds[1]}")
    , 1000

$ ->
  drinking = new Drinking("2016-01-02T18:00:00.000Z")
  drinking.startTimer()

  ko.applyBindings drinking, document.getElementById('drinking')
