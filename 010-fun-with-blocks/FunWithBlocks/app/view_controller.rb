class ViewController < UIViewController

  def viewDidLoad
    super

    @wallpaper_view = UIImageView.alloc.initWithImage(nil)
    @wallpaper_view.frame = self.view.bounds
    @wallpaper_view.contentMode = UIViewContentModeScaleAspectFit
    self.view.addSubview(@wallpaper_view)

    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
    @indicator.hidesWhenStopped = true
    @indicator.center = self.view.center
    self.view.addSubview(@indicator)

    @wallpapers = [
      "http://imgur.com/download/7ZoTK/The%20beautiful%20Kate%20Upton",
      "http://imgur.com/download/EQgps/Pink%20[1920x1200]",
      "http://imgur.com/download/YFxsz/Asian%20Festival",
      "http://imgur.com/download/QNW2y/Sun%20Dress.%20(1920x1080)"
    ]

    @last_wallpaper_index = 0

    tapRecognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action: "load_wallpaper")
    self.view.addGestureRecognizer(tapRecognizer)

    self.load_wallpaper
  end

  def load_wallpaper
    @indicator.startAnimating

    UIView.animateWithDuration(0.5, animations:lambda {
        @wallpaper_view.alpha = 0
      })

    url = NSURL.URLWithString(@wallpapers[@last_wallpaper_index])
    @last_wallpaper_index += 1
    @last_wallpaper_index = 0 if @last_wallpaper_index >= @wallpapers.length

    fetch_image(url) do |image|
      Dispatch::Queue.main.async do
        @wallpaper_view.image = image
        @indicator.stopAnimating

        UIView.animateWithDuration(0.5, animations:lambda {
          @wallpaper_view.alpha = 1
        })

        self.bounce_image
      end
    end
  end

  def fetch_image(url, &completionBlock)
    Dispatch::Queue.concurrent.async do
      imagedata = NSData.alloc.initWithContentsOfURL(url)
      image = UIImage.alloc.initWithData(imagedata)
      puts "Image size: #{NSStringFromCGSize(image.size)}"

      resize_image(image, self.view.frame.size.width, &completionBlock)
    end
  end

  def resize_image(image, width, &completionBlock)
    Dispatch::Queue.concurrent.async do
      new_size = CGSizeMake(width, (width / image.size.width) * image.size.height)
      UIGraphicsBeginImageContext(new_size)
      image.drawInRect(CGRectMake(0,0,new_size.width, new_size.height))
      thumb_image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      completionBlock.call(thumb_image)
    end
  end

  def scale_image(scale, &completionBlock)
    duration = 0.20
    UIView.animateWithDuration(duration, animations: lambda {
      @wallpaper_view.transform = CGAffineTransformMakeScale(scale, scale)
    }, completion: lambda { |finished|
      if completionBlock
        completionBlock.call
      end
    })
  end

  def bounce_image
    scale_image(1.1) do
      scale_image(0.9) do
        scale_image(1.0)
      end
    end
  end
end
