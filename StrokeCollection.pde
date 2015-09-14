class StrokeCollection
{
  PImage scrImage;
  PGraphics drawBuffer;
  private ArrayList<ColorStroke> strokes;
  
  public StrokeCollection(PImage img)
  {
    strokes = new ArrayList<ColorStroke>();
    scrImage = img;
    drawBuffer = createGraphics(img.width,img.height,P3D);
  }
  
  void clearStrokesAndBuffer()
  {
    strokes.clear();
    
  }
  
  void addStroke(float[] pos)
  {
    ColorStroke cs = new ColorStroke();
    cs.constructLine(drawBuffer, scrImage, pos);
    strokes.add(cs);
  }
  
  void drawStrokes()
  {
    drawBuffer.beginDraw();
    drawBuffer.clear();
    drawBuffer.endDraw();
    
    for(ColorStroke cs : strokes)
    {
      cs.draw(drawBuffer);
    }
  }
  
}
