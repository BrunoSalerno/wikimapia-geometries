# Wikimapia::Geometries

Fetchs geometries from Wikimapia in the specified format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wikimapia-geometries'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wikimapia-geometries

## Usage

First you have to get a key from Wikimapia.

Then, you can do something like this:
```ruby
require 'wikimapia-geometries'

config = {
    :key => 'my_wikimapia_key',
    :tags_or => '4621,45057' #some category tags (UNION)
    :format =>'json',
    :results_per_page => 100,
    :lat => ENV['LAT'].to_f || -34.6096717,
    :lon => ENV['LON'].to_f || -58.429007
}

wikimapia = Wikimapia::Geometries::API.new(config)

page = 1
first_request = wikimapia.fetch(:page => page)

abort "Error in first_request" if not first_request

total_results = first_request[:found].to_i
polygons = first_request[:places]

logger.info "Initial request completed. Total results: #{total_results}"

while polygons.count < total_results do
  page += 1
  request = wikimapia.fetch(:page => page)
  abort "Error in HTTP request ##{config[:page]}" if not request
  polygons += request[:places]
  logger.info "Request ##{page} succeeded"
end
```

Options
------
```
key               Wikimapia key. 
tag               String. Comma separated tags (INTERSECT).
tags_or           String. Comma separated tags (UNION).
results_per_page  Integer.
format            String. Can be: xml, kml, json, jsonp.
page              Integer. Page number.
lat               Float.
lon               Float.
```

## Useful data

* [Wikimapia API](http://wikimapia.org/api)
* [Create a Wikimapia Key](http://wikimapia.org/api?action=create_key)
* All Wikimapia categories: `http://api.wikimapia.org/?function=category.getall&key=your_key`

## Contributing

1. Fork it ( https://github.com/[my-github-username]/wikimapia-geometries/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
