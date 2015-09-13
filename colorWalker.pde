PImage img;
int currentIndex = 0;

float angle = random(TWO_PI);
float angleDelta = 0.1;

PGraphics render;
void setup()
{
  img = loadImage("027_27.JPG");
  img.loadPixels();
  int wth = 1500;
  size(1000,1000,P3D);
  
   
  render = createGraphics(img.width,img.height,P3D);
  resetCanvas();
}

void draw()
{
  image(render,0,0,width,height);
  
}


void resetCanvas()
{
  render.beginDraw();
  render.clear();
  render.endDraw();
  background(255);
}

void mouseReleased()
{
  doLineFill2();
  println("clicked" + millis());
}

void doLineFill2()
{
   render.beginDraw();
   currentIndex =(int)( (mouseX*render.width/width) + (mouseY*render.height/height)*render.width);
   render.noFill();
   render.stroke(0);
//   render.ellipse((mouseX*render.width*1.f/width), (mouseY*render.height*1.f/height),100,100);

  
  float maxDelta = .1;
  float deltaDelta = .02;
  img.loadPixels();
  render.beginShape(TRIANGLE_STRIP);

  int iterations = 800;
  int currentXY[] = {0,0};
      render.noStroke();
  for(int i = 0; i < iterations; i++)
  {
    float strokeW = .6+random(10); //(i*1.f/iterations)*random(100)
//    render.strokeWeight(strokeW);

    int currentColor = img.pixels[currentIndex];

    render.fill(currentColor);
    float brtness = .99*brightness(currentColor)/255.f;
    
    angleDelta += (random(deltaDelta*2)-deltaDelta)*(1-brtness);
    angleDelta = max(-maxDelta,min(maxDelta,angleDelta));
    angle += angleDelta;
    
    //get random distance
    
    float distance = random(40);// *(1-brtness);
     
    currentXY= getPosFromIndex(currentIndex);//new int[]{currentIndex%img.width,currentIndex/img.width};
    
    int newXY[] = {(int)(currentXY[0]+distance*cos(angle)),
                   (int)(currentXY[1]+distance*sin(angle))};
   
    //constrain index to positions on the image               
    newXY[0] = max(0,min(newXY[0],img.width));
    newXY[1] = max(0,min(newXY[1],img.height));  
    PVector p = new PVector(cos(angle),sin(angle),0);
    p = p.cross(new PVector(0,0,1));
    p.mult(strokeW);
    
    float rndZ = 0;
    render.vertex(newXY[0]+p.x,newXY[1]+p.y,rndZ);
    render.vertex(newXY[0]-p.x,newXY[1]-p.y,rndZ);
    
    currentIndex = getIndexFromPos(newXY);//newXY[0] + newXY[1]*img.width;
//    currentIndex = max(0,min(currentIndex,img.pixels.length-1));
  }
  render.vertex(currentXY[0],currentXY[1],0);
    render.vertex(currentXY[0],currentXY[1],0);
  render.endShape();
  render.endDraw();
}

int getIndexFromPos(int[] pos)
{
  if(render.pixels == null)
    return -1;
  int result = 0;
  //out of bounds positions break our calculation so we have to enforce that they are in the box!
  pos[0] = max(0,min(render.width-1, pos[0]));
  pos[1] = max(0,min(render.height-1, pos[1]));
  result = pos[0] + pos[1]*render.width;
  result = max(0,min(result,render.pixels.length-1));
  return result;
}

int[] getPosFromIndex(int index)
{
  int result[] = new int[]{index%render.width, index/render.width};
  result[0] = max(0,min(result[0],render.width));
  result[1] = max(0,min(result[1],render.height));  
  return result;
}

void keyPressed() {
  if (key == 's' ) {
    String className = this.getClass().getSimpleName();
    render.save("renders/" + className+"-"+year()+"-"+month()+"-"+day()+":"+hour()+":"+minute()+":"+second()+":"+millis() +".png");    
  }
  
  if(key == 'c'){
      resetCanvas();
  }
}
