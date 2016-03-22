---
layout: post
title:  "Convert UTM to WGS84 in Elixir"
tags: elixir work coordinate wgs84 utm32
last_modified_at: 2015-08-04
---

We are currently in the midst of integrating with a Norwegian company at work.
They supply the Norwegian bus- and trainstops with coordinates.
We want to show this to our customers at [MatchOffice.no](http://www.matchoffice.no/) so that they can see how far a location is to public transportation.

This third party company supplies the coordinates in the UTM coordinate system.
We want to work with WGS84, because that is how most of our system works.
In order to do this, we want to convert the coordinate.

I initially thought: "Okay, so that's probably something along the lines of `lat * zone + lng`".
Boom! Done.

Ahhh... no...

There's a lot of complicated math involved.

I copied most of @mortonfox's code from the YouTime repo.
Thanks!

Below is the code to do this, if anybody is interested. :heart:

{% highlight elixir %}
defmodule Geoex.Coord do
  require Logger
  import :math, only: [pi: 0, pow: 2, sin: 1, sinh: 1, asin: 1, cos: 1, cosh: 1, tan: 1, atan: 1, atanh: 1, sqrt: 1]

  ####
  # Inspiration gotten from:
  # https://github.com/mortonfox/YouTim/blob/master/utmconv.js
  ####
  @a    6378137.0
  @f    1/298.2572236
  @drad pi/180
  @k_0  0.9996
  @b    @a * (1 - @f)
  @e    sqrt(1 - pow(@b/@a, 2))
  @esq  pow(@e, 2)
  @e0sq @esq / (1 - @esq)
  @e_1  (1 - sqrt(1 - @esq)) / (1 + sqrt(1 - @esq))

  @doc """
  Converts from WGS84 to UTM32

  ## Examples:

      iex> Geoex.Coord.wgs84_to_utm32(59.805241567229885, 11.40618711509996)
      %{e: 634980.0, n: 6632172.0}

      iex> Geoex.Coord.wgs84_to_utm32(63.50614385818526, 9.200909996819014)
      %{e: 510000.0, n: 7042000.0}

  """
  def wgs84_to_utm32(lat, lng) do
    phi = lat * @drad
    zcm = 3 + 6*(utmz(lng)-1) - 180

    n = @a / (sqrt(1 - pow(@e * sin(phi), 2)))
    t = pow(tan(phi), 2)
    c = @e0sq * pow(cos(phi), 2)
    a = (lng - zcm) * @drad * cos(phi)

    x = @k_0 * n * a * (1 + pow(a, 2) * ((1 - t + c)/6 + pow(a, 2) * (5 - 18*t + pow(t, 2) + 72 *c - 58*@e0sq)/120)) + 500_000

    m = phi * (1 - @esq * (1/4 + @esq * (3/64 + 5/256 * @esq)))
    m = m - sin(2*phi) * @esq * (3/8 + @esq * (3/32 + 45/1024 * @esq))
    m = m + sin(4*phi) * pow(@esq, 2) * (15/256 + @esq * 45/1204)
    m = m - sin(6*phi) * pow(@esq, 3) * 35/3072
    m = m * @a

    y = @k_0 * (m + n * tan(phi) * (pow(a, 2) * (1/2 + pow(a, 2) * ((5 - t + 9*c + 4*pow(c, 2))/24 + pow(a, 2) * (61 - 58*t + pow(t, 2) + 600*c - 330 * @e0sq)/720))))

    %{e: Float.floor(x), n: Float.floor(y)}
  end

  @doc """
  Converts from UTM32 to WGS84

  ## Examples:

      iex> Geoex.Coord.utm32_to_wgs84(634980.0, 6632172.0)
      %{lat: 59.805241567229885, lng: 11.40618711509996}

      iex> Geoex.Coord.utm32_to_wgs84(510000, 7042000)
      %{lat: 63.50614385818526, lng: 9.200909996819014}

  """
  def utm32_to_wgs84(e, n),      do: utm32_to_wgs84(e, n, 32)
  def utm32_to_wgs84(e, n, zone) do
    m = n / @k_0

    mu    = m / (@a * (1 - @esq * (1/4 + @esq * (3/64 + 5/256 * @esq))))
    phi_1 = mu + @e_1 * (3/2 - 27/32 * pow(@e_1, 2)) * sin(2*mu)
    phi_1 = phi_1 + pow(@e_1, 2) * (21/16 - 55/32 * pow(@e_1, 2)) * sin(4*mu)
    phi_1 = phi_1 + pow(@e_1, 3) * (sin(6*mu) * 151/96 + @e_1 * sin(8*mu) * 1097/512)

    c_1 = @e0sq * pow(cos(phi_1), 2)
    t_1 = pow(tan(phi_1), 2)
    n_1 = @a / (sqrt(1 - pow(@e * sin(phi_1), 2)))
    r_1 = n_1 * (1 - @esq) / (1 - pow(@e * sin(phi_1), 2))
    d   = (e - 500_000) / (n_1 * @k_0)

    phi = pow(d, 2) * (1/2 - pow(d, 2) * (5 + 3*t_1 + 10*c_1 - 4*pow(c_1, 2) - 9*@e0sq)/24)
    phi = phi + pow(d, 6) * (61 + 90*t_1 + 298*c_1 + 45*pow(t_1, 2) - 252*@e0sq - 3*pow(c_1, 2))/720
    phi = phi_1 - (n_1 * tan(phi_1)/ r_1) * phi

    lng = d * (1 + pow(d, 2) * ((-1 - 2*t_1 - c_1)/6 + pow(d, 2) * (5 - 2*c_1 + 28*t_1 - 3*pow(c_1, 2) + 8*@e0sq + 24*pow(t_1, 2))/120)) / cos(phi_1)

    zcm = 3 + 6*(zone-1) - 180
    %{lat: phi / @drad, lng: zcm + lng/@drad}
  end

  defp utmz(lng), do: 1 + Float.floor((lng + 180) / 6)
end
{% endhighlight %}

Note: I strugged with this code for a long time (~2 hours), thinking I had misplaced a parenthesis.
I had not, but instead I had the following code:


{% highlight elixir %}
def utm32_to_wgs84(e, n),      do: utm32_to_wgs84(n, e, 32)
def utm32_to_wgs84(e, n, zone) do
  ...
end
{% endhighlight %}

Why would I switch the arguments - and more importantly: WHY DIDN'T I SEE THIS?

Also: :heart: to Elixir.
I love being able to test my code in the documentation!
