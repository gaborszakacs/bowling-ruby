class FakeGifClient
  attr_reader :terms

  def initialize
    @terms = []
  end

  def gif_for(term)
    @terms << term
    'https://giphy.com/funny.gif'
  end
end
