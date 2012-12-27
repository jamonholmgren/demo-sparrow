=begin
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
=end

class AppDelegate
  attr_accessor :mRootViewController
  
  def application(app, didFinishLaunchingWithOptions:launch_opts)
    #SP_CREATE_POOL(pool)
  	# Make use of a root view controller, which became mandatory in iOS5. The completion handler
  	# allows us to separate the view controller setup from the game.
    @mRootViewController = RootViewController.alloc.initWithMultipleTouchEnabled(false, frameRate:60)
    @mRootViewController.setupStageWithCompletionHandler do |stage, error|
      # Create the game class, rotate it to landscape mode
      # and add it to the stage.
       Game.alloc.init.tap do |game|
         game.rotation = Math::PI / 2
         game.x = stage.width
         stage.addChild(game)
      end
    end
    #SP_RELEASE_POOL(pool)
    true
  end
end