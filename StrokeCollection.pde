class StrokeCollection
{
  PImage scrImage;
  PGraphics drawBuffer;
  private ArrayList<ColorStroke> strokes;
  
  public StrokeCollection(PImage img)
  {
    strokes = new ArrayList<ColorStroke>();
    scrImage = img;
    drawBuffer = createGraphics(min(width,img.width),min(height,img.height),P3D);
  }
  
  void clearStrokesAndBuffer()
  {
    strokes.clear();
    drawBuffer.beginDraw();
    drawBuffer.clear();
    drawBuffer.endDraw();
    
  }
  
  void addStroke(float[] pos)
  {
    println("pos: " + pos[0] + ", " + pos[1] );
    println("scr wxh: " + width + ", " + height );
    float transformedMouse[] = {scrImage.width*pos[0]/width,  
                                scrImage.height*pos[1]/height};
    println("transformedMouse: " + transformedMouse[0] + ", " + transformedMouse[1] ) ; 
    println("img wxh: " + scrImage.width + ", " + scrImage.height );    
    ColorStroke cs = new ColorStroke();
    cs.constructLine(drawBuffer, scrImage, transformedMouse);
    strokes.add(cs);
    cs.draw(drawBuffer);
  }
  
  void drawStrokes()
  {
//    drawBuffer.beginDraw();
//    drawBuffer.clear();
//    drawBuffer.endDraw();
    
    for(ColorStroke cs : strokes)
    {
//      cs.draw(drawBuffer);
    }
  }
  
}
