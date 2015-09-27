PImage img;

StrokeCollection collection;

void setup()
{
  img = loadImage("20150815_130152.jpg");
  img.loadPixels();
  int wth = 1500;
  size(1000,1000,P3D);
  
  collection = new StrokeCollection(img);
  resetCanvas();
}

void draw()
{
  image(collection.drawBuffer,0,0,width,height);
}

void resetCanvas()
{
  background(255);
  collection.clearStrokesAndBuffer();
}

void mouseReleased()
{
  
  long start = millis();
  
  //add a stroke and re-render the scene
  for(int i = 0; i < 5; i++)
    collection.addStroke(new float[]{mouseX,mouseY});
  collection.drawStrokes();
  println("draw time: " + (millis()-start));
}


void keyPressed() {
  //save the output by pressing 's'
  if (key == 's' ) {
    String className = this.getClass().getSimpleName();
    String path = "renders/" + className+"-"+year()+"-"+month()+"-"+day()+":"+hour()+":"+minute()+":"+second()+":"+millis() +".png";
    collection.drawBuffer.save(path);
    println("Saved buffer to: " +path);
  }
  
  //clear by pressing 'c'
  if(key == 'c'){
      resetCanvas();
  }
}
