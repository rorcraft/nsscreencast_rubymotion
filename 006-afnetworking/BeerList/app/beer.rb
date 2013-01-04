class Beer
  attr_accessor :text, :image_url

  def initialize(attributes)
    self.text = attributes["text"]
    self.image_url = attributes["profile_image_url"]
  end

  def self.fetch_beers(&callback)
   AFMotion::Client.shared.get("search.json?q=Beer") do |result|
      if result.success?
        beers = []
        result.object["results"].each do |attributes|
          beers << Beer.new(attributes)
        end
        callback.call(beers, nil)
      else
        puts "errored"
        callback.call([], result.error)
      end
    end
  end
end
