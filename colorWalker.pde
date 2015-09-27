
StrokeCollection collection;

void setup()
{
  size(displayWidth,displayHeight,P3D);
  initLPD8();
  collection = new StrokeCollection(this);
  resetCanvas();
}

void draw()
{
  fill(0,10);
  rect(0,0,width,height);
  collection.drawStrokes();
  image(collection.drawBuffer,0,0,width,height);
}

void resetCanvas()
{
//  background(255);
  collection.clearStrokesAndBuffer();
}

void mouseReleased()
{
  
  long start = millis();
  
  //add a stroke and re-render the scene
  for(int i = 0; i < 1; i++)
    collection.addStroke(new float[]{mouseX,mouseY});
  
  println("draw time: " + (millis()-start));
}

void randomStokes()
{
  collection.clearStrokesAndBuffer();
  for(int i = 0; i < 13; i++)
    collection.addStroke(new float[]{random(width),random(height)});
}
