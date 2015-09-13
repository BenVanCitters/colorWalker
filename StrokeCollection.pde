class StrokeCollection
{
  PImage scrImage;
  PGraphics drawBuffer;
  private ArrayList<ColorStroke> strokes;
  
  public StrokeCollection()
  {
    
  }
  
  void clearStrokesAndBuffer()
  {
    
  }
  
  void addStroke(int x, int y)
  {
    ColorStroke cs = new ColorStroke();
    cs.constructLine(drawBuffer, scrImg, new int[] {x,y});
    strokes.add(cs);
  }
  
  void drawStrokes()
  {
    for(ColorStroke cs : strokes)
    {
      cs.draw(drawBuffer, scrImg, new int[] {x,y});
    }
  }
}