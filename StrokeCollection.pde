class StrokeCollection
{
  
  RollingSampleListener rSlisten; 

  PImage scrImage;
  PGraphics drawBuffer;
  private ArrayList<ColorStroke> strokes;
  
  public StrokeCollection(PApplet p)
  {
    rSlisten = new RollingSampleListener(p);
    
    PImage img;
    img = loadImage("moth-1.jpg");
    img.loadPixels();
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

    float transformedMouse[] = {scrImage.width*pos[0]/width,  
                                scrImage.height*pos[1]/height};
   
    ColorStroke cs = new ColorStroke();
      cs.constructLine(drawBuffer, scrImage, transformedMouse);
 
    strokes.add(cs);
//    cs.draw(drawBuffer,scrImage);
  }
  
  void updateStrokes()
  {
    long start = millis();
    for(ColorStroke cs : strokes)
    {
      cs.update(drawBuffer, scrImage);
    }
  }
  
  void drawStrokes()
  {
    long start = millis();

    scrImage.loadPixels();
    updateStrokes();
    
    drawBuffer.beginDraw();
    //clear old buffer
    drawBuffer.clear();
    
    //draw strokes
    for(ColorStroke cs : strokes)
    {
      cs.draw(drawBuffer, scrImage);
    }
    drawBuffer.endDraw();
//    println("draw time: " + (millis()-start));
  }
  
}
