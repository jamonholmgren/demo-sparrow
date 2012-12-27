=begin
class Game < SPStage
  def initWithWidth(width, height:height)
    if super
      quad = SPQuad.quadWithWidth(100, height: 100)
      quad.color = 0xff0000
      quad.x = 50
      quad.y = 50
      self.addChild quad
    end
    self
  end
end
=end
class Game < SPSprite
  SP_EVENT_TYPE_TOUCH = "touch"
  SP_EVENT_TYPE_ENTER_FRAME = "enterFrame"
  attr_accessor :background, :basket, :eggs
  
  def init
    super.tap do
      # load the background image first, add it to the display tree
      # and keep it for later use
      @background = SPImage.alloc.initWithContentsOfFile('background.png').tap { |bg| self.addChild(bg) }
      
  		# loads the basket, positions in the middle of the ground,
  		# adds a touch listener and adds it as a child
      @basket = SPImage.alloc.initWithContentsOfFile('basket.png').tap do |bsk|
        bsk.pivotX = bsk.width  / 2
        bsk.pivotY = bsk.height / 2
    		bsk.x = @background.width / 2 - bsk.width / 2
    		bsk.y = @background.height - bsk.height
        bsk.addEventListener('onBasketTouched:', atObject:self, forType:SP_EVENT_TYPE_TOUCH)
        self.addChild(bsk)
      end
      
  		# initializes the management array for the falling eggs
  		# as well as some informational floats
      @eggs = []
      
      @total_time = @creation_time_of_last_egg = 0
      @egg_creation_interval = 1
      
  		# adds an enter frame listener for the following purposes:
  		# * let the eggs fall
  		# * check for collisions
  		# * create new eggs
      self.addEventListener('onEnterFrame:', atObject:self, forType:SP_EVENT_TYPE_ENTER_FRAME)
    end
  end
    
  def onBasketTouched(event)
    # fetch the first touch (from the first finger on the device)
    touch = event.touches.allObjects.first
      
    # find the touch position
    local_touch_position = touch.locationInSpace(self)
      
    # apply the new x-coordinate to the basket
    @basket.x = local_touch_position.x
  end
    
  def onEnterFrame(event)
    passed_time   = event.passedTime
    falling_speed = 100 + 5 * @total_time 
    falling_distance = falling_speed * passed_time
      
    @eggs.map do |egg|
      # move the egg
      egg.y += falling_distance
      egg.rotation += passed_time
        
      # check for collisions with the ground and the basket
      did_break = egg.y >= @background.height - egg.height / 2
      did_get_caught = @basket.bounds.intersectsRectangle(egg.bounds)
      
      if did_break
        # break the egg: replace the egg with a yolk texture
        yolk = SPImage.imageWithContentsOfFile('yolk.png')
        yolk.pivotX, yolk.pivotY = yolk.width/2, yolk.height/2
        yolk.x, yolk.y = egg.x, egg.y
        self.addChild(yolk)
        
        # animate the yolk
        SPTween.tweenWithTarget(yolk, time:1).tap do |tween|
          tween.animateProperty('y', targetValue:yolk.y + yolk.height)
          tween.animateProperty('height', targetValue:2*yolk.height)
          tween.animateProperty('alpha', targetValue:0)
        end
        
        self.removeChild(egg)
        @eggs.removeObject(egg)
      elsif did_get_caught
        # just remove the egg
        self.removeChild(egg)
        @eggs.removeObject(egg)
      end
    end
    # create and add new eggs if necessary
    @total_time += passed_time
    if @total_time - @creation_time_of_last_egg >= @egg_creation_interval
      @eggs << SPImage.imageWithContentsOfFile('egg.png').tap do |egg|
    		egg.pivotX = egg.width/2
    		egg.pivotY = egg.height/2
    		egg.y = -egg.height
    		egg.x = Random.new.rand(0..@background.width)
        self.addChild(egg)
        @creation_time_of_last_egg = @total_time
      end
    end
  end
  
  def dealloc
    # event listeners must be removed in the dealloc phase
    self.removeEventListenersAtObject(self, forType:SP_EVENT_TYPE_ENTER_FRAME)
    @basket.removeEventListenersAtObject(self, forType:SP_EVENT_TYPE_TOUCH)
  end
end