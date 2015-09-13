class ColorStroke
{
  ArrayList<float[]> points;
  
  void draw(PGraphics g, PImage img, int[] startingPoint)
  {
    g.beginDraw();
    int currentIndex = getIndexFromPos(startingPoint,g);//(int)( (mouseX*g.width/width) + (mouseY*g.height/height)*g.width);
    g.noFill();
    g.stroke(0);

    float maxDelta = .1;
    float deltaDelta = .02;
    img.loadPixels();
    g.beginShape(TRIANGLE_STRIP);

    int iterations = 800;
    int currentXY[] = {0,0};
    g.noStroke();
    for(int i = 0; i < iterations; i++)
    {
      float strokeW = .6+random(10);
  
      int currentColor = img.pixels[currentIndex];
  
      g.fill(currentColor);
      float brtness = .99*brightness(currentColor)/255.f;
      
      angleDelta += (random(deltaDelta*2)-deltaDelta)*(1-brtness);
      angleDelta = max(-maxDelta,min(maxDelta,angleDelta));
      angle += angleDelta;
      
      //get random distance
      
      float distance = random(40);// *(1-brtness);
       
      currentXY= getPosFromIndex(currentIndex,g);
      
      int newXY[] = {(int)(currentXY[0]+distance*cos(angle)),
                     (int)(currentXY[1]+distance*sin(angle))};
     
      //constrain index to positions on the image               
      newXY[0] = max(0,min(newXY[0],img.width));
      newXY[1] = max(0,min(newXY[1],img.height));  
      PVector p = new PVector(cos(angle),sin(angle),0);
      p = p.cross(new PVector(0,0,1));
      p.mult(strokeW);
      
      float rndZ = 0;
      g.vertex(newXY[0]+p.x,newXY[1]+p.y,rndZ);
      g.vertex(newXY[0]-p.x,newXY[1]-p.y,rndZ);
      
      currentIndex = getIndexFromPos(newXY,g);
    }
    g.vertex(currentXY[0],currentXY[1],0);
    g.vertex(currentXY[0],currentXY[1],0);
    g.endShape();
    g.endDraw();
  }
  
  int getIndexFromPos(int[] pos, PGraphics g)
{
  if(g.pixels == null)
    return -1;
  int result = 0;
  //out of bounds positions break our calculation so we have to enforce that they are in the box!
  pos[0] = max(0,min(g.width-1, pos[0]));
  pos[1] = max(0,min(g.height-1, pos[1]));
  result = pos[0] + pos[1]*g.width;
  result = max(0,min(result,g.pixels.length-1));
  return result;
}

int[] getPosFromIndex(int index, PGraphics g)
{
  int result[] = new int[]{index%g.width, index/g.width};
  result[0] = max(0,min(result[0],g.width));
  result[1] = max(0,min(result[1],g.height));  
  return result;
}
}
