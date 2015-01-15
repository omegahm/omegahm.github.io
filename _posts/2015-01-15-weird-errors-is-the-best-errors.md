---
layout: post
title:  "Weird Errors == Best Errors"
tags: ruby rails irb
last_modified_at: 2015-01-15
---

I :heart: weird errors. No really. I love having to dig into a system to discover why a certain function or method acts in a certain way.

Today I was doing Rails work and came upon a weird error, where I would load the image `/images/h`.
I couldn't quite see from the data, where I got that `h` from, so the hunt began.

The code, which I had fiddled with was this

```ruby
private

def photos
  return property.photos.first['list_image_url'] if !property.is_a?(Property) && property.respond_to?(:photos)

  PhotoAsset.for_property(property).map do |photo|
    ImageResizer.resize_url_for(photo, 700, 490)
  end
end
```

After having found the error, I can see that I did a hell of a job rewriting the above method.
Of course the `#map` returns an array and my `return` on the first line does not.

The reason I got `/images/h` out was that we were using the `#photos` method in `#first_image`

```ruby
def first_image
  return '' unless photos.first.present?
  h.image_tag photos.first, class: 'property-thumb-box-images-image'
end
```

Here `photos` is the first method.
It checks if the array contains an element and then uses that first element to create the image tag.

However(!) in Rails we have a `String#first` method, which just takes the first character out of the string

```ruby
"hello".first # => "h"
```

My image URLs were of course starting with `"http"`, so I kept getting `"h"` out.

This is a weird problem to have in my mind.
I simply love it.

When trying to figure out the problem, I launched an `irb` (not `rails console`) and fired some commands at it.

```bash
$ irb
irb(main):001:0> "hello".first
NoMethodError: undefined method `first' for "hello":String
               from (irb):1
               from /Users/ohm/.rbenv/versions/1.9.3-p547/bin/irb:12:in `<main>'
irb(main):002:0>
```

I should of course have used the Rails console (but our Rails environment is sooo slow to boot):

```bash
$ rails c
irb(main):001:0> "hello".first
=> "h"
irb(main):002:0>
```

Oh well.
Lesson learned I guess.

I quickly fixed my err in the first snippet and changed the second to be nicer:

```ruby
def first_image
  return '' unless photos.any?
  h.image_tag photos.first, class: 'property-thumb-box-images-image'
end

private

def photos
  return Array(property.photos.first['list_image_url']) if !property.is_a?(Property) && property.respond_to?(:photos)

  PhotoAsset.for_property(property).map do |photo|
    ImageResizer.resize_url_for(photo, 700, 490)
  end
end
```
