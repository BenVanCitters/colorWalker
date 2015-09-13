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
    drawBuffer.beginDraw();
    drawBuffer.clear();
    drawBuffer.endDraw();
  }
  
  void addStroke(int x, int y)
  {
    ColorStroke cs = new ColorStroke();
    cs.constructLine(drawBuffer, scrImage, new float[] {x,y});
    strokes.add(cs);
  }
  
  void drawStrokes()
  {
    for(ColorStroke cs : strokes)
    {
      cs.draw(drawBuffer);
    }
//    image(scrImage,0,0);
  }
  
}
