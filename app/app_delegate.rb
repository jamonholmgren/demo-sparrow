class AppDelegate
  attr_accessor :window, :sparrow_view
  
  def initialize
    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.sparrow_view = SPView.alloc.initWithFrame(self.window.bounds)
    self.window.addSubview self.sparrow_view
    self.window
  end
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    SPStage.setSupportHighResolutions true
    SPAudioEngine.start
    
    game = Game.alloc.init
    
    self.sparrow_view.stage = game
    self.sparrow_view.frameRate = 30.0
    
    self.window.makeKeyAndVisible
    
    self.sparrow_view.start
    
    true
  end
  
  def applicationWillResignActive(application)
    self.sparrow_view.stop
  end

  def applicationDidBecomeActive(application)
    self.sparrow_view.start
  end
end
