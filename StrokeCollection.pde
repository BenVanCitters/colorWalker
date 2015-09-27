import java.util.Vector;

class StrokeCollection
{

  RollingSampleListener rListen; 

  PImage scrImage[];
  int scrImageIndex = 0;
  PGraphics drawBuffer;
  private Vector<ColorStroke> strokes;
  
  private Vector<ColorStroke> newStrokes;
  private boolean clearStrokes;
  
  //==============================================================
  //==============================================================
  public StrokeCollection(PApplet p)
  {
    rListen = new RollingSampleListener(p);

    scrImage = new PImage[10];
    
   scrImage[7] = loadImage("moth-0.jpg");
   scrImage[0] = loadImage("moth-1.jpg");
   scrImage[1] = loadImage("moth-2.jpg");
   scrImage[2] = loadImage("moth-3.jpg");
   scrImage[3] = loadImage("moth-4.jpg");
   scrImage[4] = loadImage("moth-5.jpg");
   scrImage[5] = loadImage("moth-6.jpg");
   scrImage[6] = loadImage("moth-7.jpg");
   scrImage[8] = loadImage("moth-3.jpg");
   scrImage[9] = loadImage("moth-3.jpg");
    scrImage[scrImageIndex].loadPixels();
    strokes = new Vector<ColorStroke>();
    newStrokes = new Vector<ColorStroke>();

    drawBuffer = createGraphics(min(width, scrImage[scrImageIndex].width), min(height, scrImage[scrImageIndex].height), P3D);
  }

//==============================================================
//==============================================================
  void clearStrokesAndBuffer()
  {
    clearStrokes = true;
  }

//==============================================================
  //accepts a position in screen space
  //==============================================================
  void addStroke(float[] pos)
  {

    float transformedMouse[] = {
      scrImage[scrImageIndex].width*pos[0]/width, 
      scrImage[scrImageIndex].height*pos[1]/height
    };

    ColorStroke cs = new ColorStroke();
    cs.constructLine(drawBuffer, scrImage[scrImageIndex], transformedMouse);

    newStrokes.add(cs);
    //    cs.draw(drawBuffer,scrImage);
  }

//==============================================================
//==============================================================
  void updateStrokes()
  {
    long start = millis();
    float maxAmp = rListen.getMaxAmp();
    float samps[] = rListen.getBackSamples();
    
    atomicallyClearAndInsertStrokes();
    for (ColorStroke cs : strokes)
    {
      cs.update(drawBuffer, scrImage[scrImageIndex], maxAmp,samps);
    }
  }
//==============================================================
//==============================================================
  void drawStrokes()
  {
    long start = millis();

    scrImage[scrImageIndex].loadPixels();
    updateStrokes();

    drawBuffer.beginDraw();
    //clear old buffer
    drawBuffer.clear();

    //draw strokes
    int strokesToDraw = (int)(scale2.get()*strokes.size());
//    println("strokesToDraw: " + strokesToDraw);
    for(int i = 0; i < strokesToDraw; i++)
//    for (ColorStroke cs : strokes)
    {
      ColorStroke cs = strokes.get(i);
      cs.draw(drawBuffer, scrImage[scrImageIndex],scale1.get());
    }
    drawBuffer.endDraw();
    //    println("draw time: " + (millis()-start));
  }
//==============================================================
  //a bit of a hack, but it looks like processing can't deal with 
  // adding elements to or clearing my vector from other threads -
  // ie input - so I create another vector   
//==============================================================
private synchronized void atomicallyClearAndInsertStrokes()
    {
       try{
   
      if(clearStrokes)
      {
        strokes.clear();
        drawBuffer.beginDraw();
        drawBuffer.clear();
        drawBuffer.endDraw();
        clearStrokes = false;
      }
      for(ColorStroke cs : newStrokes)
      {
        strokes.add(cs);
      }
      newStrokes.clear();
    }
    catch( Exception e){
      println("EXCEPTION Caught: " + e);
    }
  }
  
  void increaseImgIndex()
  {
    scrImageIndex = (scrImageIndex+1) % scrImage.length;
  }
  
}


