# IngvQuake

### 🫨 Get details about Earthquake events.

This gem is a wrapper around the [fdsnws-event api](https://webservices.ingv.it/swagger-ui/dist/?url=https://ingv.github.io/openapi/fdsnws/event/0.0.1/event.yaml#) provided by the [INGV](https://www.ingv.it/) with some additions to improve the inspection of events and their data.

[![Gem](https://img.shields.io/gem/v/ingv_quake?color=blue&label=gem%20version&logo=rubygems)](https://rubygems.org/gems/ingv_quake)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/nexxus-vi/ingv_quake/ci.yml?label=rspec&logo=github)](https://github.com/nexxus-vi/ingv_quake/actions/workflows/ci.yml)
[![Coveralls](https://img.shields.io/coverallsCoverage/github/nexxus-vi/ingv_quake?logo=coveralls)](https://coveralls.io/github/nexxus-vi/ingv_quake?branch=master)
[![Rubydoc](https://img.shields.io/badge/doc-rubydoc.info-informational?logo=readthedocs)](https://rubydoc.info/gems/ingv_quake)

### ⚠ Requirements
- Ruby 2.6+

## ⚙️ Installation

Add this line to your application's Gemfile:

```ruby
gem 'ingv_quake'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ingv_quake

## 📝 Usage

- #### Initialize the Client

Create a new instance of the `IngvQuake::Client` class to interact with the INGV Earthquake web services API:

```ruby
client = IngvQuake::Client.new
```

You can also provide your preferred adapter for the underlying Faraday connection:

```ruby
client = IngvQuake::Client.new(adapter: httpx)
```
A curated list of supported adapters can be found in the [awesome-faraday](https://github.com/lostisland/awesome-faraday#adapters) repo

- #### Get Events Data

Use the get_events method to initialize an EventResource and then fetch earthquake events from the API:

```ruby
events = client.get_events
events.within_last_hour
```

#### The Ingv api can return 2 kinds of response format: `text` or `xml` (default).

- #### Text response

  The `text` response is a simplified representation of an event, containing basic information:
  
  ```
  #EventID|Time|Latitude|Longitude|Depth/Km|Author|Catalog|Contributor|ContributorID|MagType|Magnitude|MagAuthor|EventLocationName|EventType
  34726341|2023-04-19T14:50:48.640000|43.8972|11.9382|14.1|SURVEY-INGV||||ML|0.9|--|5 km NW Bagno di Romagna (FC)|earthquake
  ```
  This response is parsed as a [`BasicInfoEvent`](https://rubydoc.info/gems/ingv_quake/IngvQuake/BasicInfoEvent)

- #### Xml response

  The `xml` response has all the information about an event.
  [Here an example](https://webservices.ingv.it/fdsnws/event/1/query?starttime=2023-04-25T00:00:00&endtime=2023-05-01T23:59:59&limit=5).

  This response is parsed as a [`FullInfoEvent`](https://rubydoc.info/gems/ingv_quake/IngvQuake/FullInfoEvent)

You can choose which level of information to get by passing or omitting the `format: 'text'` param when querying for events.

### 🧐 Query Events with Filters

The EventResource class provides several methods for querying events with specific filters. Some examples:

#### 📆 By date range:
```ruby
events.between_dates(starttime: '2023-05-08', endtime: DateTime.now)
```

#### 🎚️ By magnitude range:
```ruby
events.between_magnitude(minmag: 3.5, maxmag: 6.0)
```

#### ⌚️ Within the last hour:
```ruby
events.within_last_hour
```

#### ☝🏼 Custom Query
Use the `where` method to create a custom query with specific parameters:

```ruby
events.where(starttime: '2023-04-25', endtime: '2023-05-01', minmag: 4.5, maxmag: 6.0)

events.where(address: 'Roma, Via Condotti', maxradiuskm: 400, maxmag: 6.0)
```

<b>Note</b>: the `address` param is an addition of the `ingv_quake` gem, you won't find it in the original api specifications.
Under the hood the string address is transformed into `lat` and `long` params by the [geocoder](https://github.com/alexreisner/geocoder) gem.

### ShakeMap

ShakeMap attributes are images that provides near-time maps of ground shaking for Magnitude >= 3.0 earthquakes in Italy and neighbouring areas.
An example of intensity shake map is this:

<p class='img'>
  <img src="http://shakemap.rm.ingv.it/shake4/data/31299001/current/products/intensity.jpg" alt=“intensity map” width="600" height="800">
</p>

### For a full list of methods and params, take a look at the [full documentation](https://rubydoc.info/gems/ingv_quake/IngvQuake/EventResource)

## 🛟 Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/nexxus-vi/ingv_quake/issues).

## 📃 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
