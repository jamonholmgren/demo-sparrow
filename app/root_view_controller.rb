class RootViewController < UIViewController
  attr_reader :window, :sparrowView
  def initWithViewBounds(bounds, stageSize:st_size, supportHighResolutions:sup_hd, contentScaleFactor:scale, multipleTouchEnabled:multitouch, frameRate:rate)
    init.tap do
      @view_bounds = bounds
      @stage_size  = st_size
      @support_high_resolutions = sup_hd
      @content_scale_factor = scale
      @multiple_touch_enabled = multitouch
      @frame_rate = rate
    end
  end
  
  def initWithMultipleTouchEnabled(multitouch, frameRate:rate)
  	view_bounds = UIScreen.mainScreen.bounds
  	st_size = CGSize.new(view_bounds.size.width, view_bounds.size.height)
  	hd = true
  	scale = 1
  	self.initWithViewBounds(view_bounds, stageSize:st_size, supportHighResolutions:hd, contentScaleFactor:scale, multipleTouchEnabled:multitouch, frameRate:rate)
  end
  
  def dealloc
    @window.release
    @sparrowView.release
    super
  end
  
  def setupStageWithCompletionHandler(&handler)
    # init root view
    @window = UIWindow.alloc.initWithFrame(@view_bounds)
    self.view = @window
    
    # init sparrow view
    @sparrowView = SPView.alloc.initWithFrame(@view_bounds).tap do |sv|
      sv.setMultipleTouchEnabled(@multiple_touch_enabled)
      sv.setFrameRate(@frame_rate)
    end
    @window.addSubview(@sparrowView)
    
    # init stage environment
    SPStage.setSupportHighResolutions(@support_high_resolutions)
    
    # create sparrow stage
    sparrow_stage = SPStage.alloc.initWithWidth(@stage_size.width, height:@stage_size.height)
    @sparrowView.setStage(sparrow_stage)
    
    # let the app hook itself into the stage
    handler.call(sparrow_stage, nil) if handler
    
    # gentlemen, start your engines
    @window.rootViewController = UIViewController.alloc.init
    @window.makeKeyAndVisible
    @window.bringSubviewToFront(@sparrowView)
    @sparrowView.start
    
    # print some info about the current setup
  	NSLog("Setup: Window size is width=%@, height=%@.", @window.frame.size.width, @window.frame.size.height)
  	NSLog("Setup: Sparrow view size is width=%@, height=%@.", @sparrowView.frame.size.width, @sparrowView.frame.size.height)
  	NSLog("Setup: Sparrow stage size is width=%@, height=%@.", sparrow_stage.width, sparrow_stage.height)
  	NSLog("Setup: Sparrow content scale factor is %@.", @content_scale_factor)
  	NSLog("Setup: Sparrow framerate is %@.", @frame_rate)
  	NSLog("Setup: Sparrow support for high resolutions is set to %@.", @support_high_resolutions ? "YES" : "NO")
  	NSLog("Setup: Sparrow multitouch enabled is set to %@.", @multiple_touch_enabled ? "YES" : "NO")
  end
end