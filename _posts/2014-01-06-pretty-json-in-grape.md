---
layout: post
title:  "Pretty JSON in Grape API"
tags: ruby grape json
last_modified_at: 2014-01-06
---

So we're building this JSON API at [autobutler.dk](https://www.autobutler.dk), in which we want the JSON outputted to be human readable (pretty).
Nothing is worse than trying to debug a JSON service, and always having to parse it through e.g. `json_pp`.

Instead we just want the service to output the pretty JSON.
It doesn't consume a lot of resources to do so, and the pretty JSON is equivalent to the non-pretty one, that is the following are the same:

{% highlight javascript %}
{"this": "that"}
{% endhighlight %}

and

{% highlight javascript %}
{
  "this": "that"
}
{% endhighlight %}

In this simple example it doesn't really matter, but this JSON is entirely unreadable:

{% highlight javascript %}
{"id": 54,"created_at": "2013-12-13T13:33:53Z","updated_at": "2013-12-19T07:40:02Z","registration_number": "SY32554","data":{"chassis_number": "WVWZZZ6NZXW005709","registration_date": "1998-06-12","inspection_date": "2012-07-11","make": "VW","model": "Polo","variant": "1,6  ","vehicle_code": null},"country_id": 1,"car_id": 113232,"make_and_model_id": null,"make": "VW","model": "Polo","variant": "1,6  ","chassis_number": "WVWZZZ6NZXW005709","registration_date": "1998-06-12","inspection_date": "2012-07-11"}
{% endhighlight %}

while this is not

{% highlight javascript %}
{
  "id": 54,
  "created_at": "2013-12-13T13:33:53Z",
  "updated_at": "2013-12-19T07:40:02Z",
  "registration_number": "SY32554",
  "data": {
    "chassis_number": "WVWZZZ6NZXW005709",
    "registration_date": "1998-06-12",
    "inspection_date": "2012-07-11",
    "make": "VW",
    "model": "Polo",
    "variant": "1,6  ",
    "vehicle_code": null
  },
  "country_id": 1,
  "car_id": 113232,
  "make_and_model_id": null,
  "make": "VW",
  "model": "Polo",
  "variant": "1,6  ",
  "chassis_number": "WVWZZZ6NZXW005709",
  "registration_date": "1998-06-12",
  "inspection_date": "2012-07-11"
}
{% endhighlight %}

To create this JSON API we're using [Grape](https://github.com/intridea/grape/).
When defining the response format in Grape as `:json`, it automatically calls `to_json` on the objects returned by the controller.
So in our `app.rb` we just do

{% highlight ruby %}
class Autobutler
  format :json
  content_type :json, 'application/json'

  ...

  # Mount all APIs!
  constants.each do |c|
    mount const_get(c) if c.to_s =~ /^ApiV/
  end
end
{% endhighlight %}

Now everything is "ugly" JSON.
To get pretty JSON, we have to create our own formatter, overriding Grape's default.
The `PrettyJSON` formatter could look like:

{% highlight ruby %}
module PrettyJSON
  def self.call(object, env)
    JSON.pretty_generate(JSON.parse(object.to_json))
  end
end
{% endhighlight %}

and then to use it, all we have to do is tell Grape:

{% highlight ruby %}
class Autobutler
  format :json
  formatter :json, PrettyJSON

  ...

end
{% endhighlight %}

The trained programmer will notice something weird about the `PrettyJSON#call` method.
Why are we calling `object.to_json` and then parsing this as JSON, resulting in an hash again?
This is because we can have nested objects, which `JSON.pretty_generate` cannot seem to handle, however `JSON.parse(object.to_json)` will not give us nested objects, but rather nested hashes (yeah, hashes are objects too) which can be prettified by JSON.

Thus, with just 6 lines of extra code, we can have pretty JSON in our Grape API app.
