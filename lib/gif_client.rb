# frozen_string_literal: true

require 'GiphyClient'

# GifClient ...
class GifClient
  def gif_for(term)
    # raise 'ajjajj'
    api_key = 'dc6zaTOxFJmzC'
    resp = GiphyClient::DefaultApi.new.gifs_search_get(api_key, term)
    resp.data.sample.embed_url
  end
end
