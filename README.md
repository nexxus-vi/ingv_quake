# IngvQuake

### 🫨 Get details about Earthquake events.

[![Tests Status](https://img.shields.io/github/actions/workflow/status/nexxus-vi/ingv_quake/ci.yml?label=rspec)](https://github.com/nexxus-vi/temp_test/actions) [![Gem Version](https://badge.fury.io/rb/ingv_quake.svg)](https://badge.fury.io/rb/ingv_quake) [![Coverage Status](https://coveralls.io/repos/github/nexxus-vi/ingv_quake/badge.svg?branch=master)](https://coveralls.io/github/nexxus-vi/ingv_quake?branch=master)

### ⚠ Requirements
- Ruby 2.5+

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

You can also provide a custom adapter for the underlying Faraday connection:

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
  This response is parsed as a `BasicInfoEvent`

- #### Xml response

  The `xml` response has all the information about an event.
  [Here an example](https://webservices.ingv.it/fdsnws/event/1/query?starttime=2023-04-25T00:00:00&endtime=2023-05-01T23:59:59&limit=5).

  This response is parsed as a `FullInfoEvent`

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

### For a full list of methods and params, take a look at the [documentation](https://rubydoc.info/gems/ingv_quake)

## 🛟 Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ingv_quake. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## 📃 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## ☣️ Code of Conduct

Everyone interacting in the IngvQuake project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ingv_quake/blob/master/CODE_OF_CONDUCT.md).
