require "wikimapia/geometries/version"
require 'httpi'

module Wikimapia
  module Geometries
    class API
      def initialize(config = {})
        @config = config
      end

      def fetch(args = {})
        opts = @config.merge(args)

        proxy = nil
        http = HTTPI::Request.new
        http.proxy = proxy if proxy
        http.url = url(opts)
        result = HTTPI.get(http)
        return if result.code != 200
        
        result_hash = JSON.parse(result.body, {:symbolize_names => true})
        {:found=>result_hash[:found],:places=>result_hash[:places]}
      end

      private
      def url(opts)
        tags = ''
        tags += "&category=#{opts[:tag]}" if opts[:tag]
        tags += "&category_or=#{opts[:tags_or]}" if opts[:tags_or]
        
        "http://api.wikimapia.org/?function=place.search"\
        "&key=#{opts[:key]}"\
        "&format=#{opts[:format]}"\
        "&lat=#{opts[:lat]}"\
        "&lon=#{opts[:lon]}"\
        "#{tags}"\
        "&page=#{opts[:page]}"\
        "&count=#{opts[:results_per_page]}"
        # distance parameter also possible
      end
    end
  end
end
