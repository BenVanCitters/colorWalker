
public StrokeCollection collection;

//==============================================================
//==============================================================
void setup()
{
  size(displayWidth,displayHeight,P3D);
  initLPD8();
  noCursor();
  collection = new StrokeCollection(this);
  resetCanvas();
  background(0);
}

//==============================================================
//==============================================================
void draw()
{
  updateInputFloats();
  
  fill(0,50*scale3.get());
  rect(0,0,width,height);
  collection.drawStrokes();
  image(collection.drawBuffer,0,0,width,height);
}

//==============================================================
//==============================================================
void resetCanvas()
{
//  background(255);
  collection.clearStrokesAndBuffer();
}

//==============================================================
//==============================================================
void mouseReleased()
{
  
  long start = millis();
  
  //add a stroke and re-render the scene
  for(int i = 0; i < 1; i++)
    collection.addStroke(new float[]{mouseX,mouseY});
  
  println("draw time: " + (millis()-start));
}

//==============================================================
//==============================================================
void randomStokes()
{
  collection.clearStrokesAndBuffer();
  for(int i = 0; i < 30; i++)
    collection.addStroke(new float[]{random(width),random(height)});
}

//==============================================================
//==============================================================
void lineStokes()
{
  collection.clearStrokesAndBuffer();
  float[] pt1 = {random(width),random(height)};
  float[] pt2 = {random(width),random(height)};
  float[] v = {pt2[0]-pt1[0],pt2[1]-pt1[1]};
  int count = 30;
  for(int i = 0; i < count; i++)
  {
    float pct = i*1.0/ count;
    collection.addStroke(new float[]{pt1[0]+v[0]*pct,
                                     pt1[1]+v[1]*pct});
  }
}

//==============================================================
//==============================================================
void pointStokes()
{
  collection.clearStrokesAndBuffer();
  float[] pt1 = {random(width),random(height)};
  int count = 30;
  for(int i = 0; i < count; i++)
  {
    collection.addStroke(pt1);
  }
}

void incrementIndex()
{
  collection.increaseImgIndex();
}
