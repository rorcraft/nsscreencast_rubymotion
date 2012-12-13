class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    AFMotion::HTTP.get("http://google.com") do |result|
      puts result.body
    end

    true
  end
end
