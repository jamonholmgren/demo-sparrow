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