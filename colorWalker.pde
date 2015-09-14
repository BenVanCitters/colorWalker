PImage img;

StrokeCollection collection;

void setup()
{
  img = loadImage("027_27.JPG");
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
  float transformedMouse[] = {(mouseX*collection.drawBuffer.width/width),  
                              (mouseY*collection.drawBuffer.height/height)};
  long start = millis();
  
  //add a stroke and re-render the scene
  collection.addStroke(transformedMouse);
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
