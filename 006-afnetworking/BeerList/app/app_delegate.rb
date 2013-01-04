class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    AFMotion::Client.build_shared("http://search.twitter.com") do
      header "Accept", "application/json"

      operation :json
    end

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    view_controller = ViewController.alloc.init
    @window.rootViewController = view_controller
    @window.makeKeyAndVisible
    true
  end
end
