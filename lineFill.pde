void doLineFill1()
{
   render.beginDraw();
   currentIndex =(int)( (mouseX*render.width/width) + (mouseY*render.height/height)*render.width);
  render.noFill();
   render.stroke(0);
   render.ellipse((mouseX*render.width*1.f/width), (mouseY*render.height*1.f/height),100,100);

  
  float maxDelta = .1;
      float deltaDelta = .05;
  img.loadPixels();
int iterations = 1500;
  for(int i = 0; i < iterations; i++)
  {
    render.strokeWeight(.6+random(50));
    //render.strokeWeight((i*1.f/iterations)*random(100));
    int currentColor = img.pixels[currentIndex];
    render.stroke(currentColor);
    float brtness = .99*brightness(currentColor)/255.f;
    
    angleDelta += (random(deltaDelta*2)-deltaDelta)*(brtness);
    angleDelta = max(-maxDelta,min(maxDelta,angleDelta));
    angle += angleDelta;
    //get random distance and angle
    
    float distance = random(150) *(1-brtness);
     
    int currentXY[] = {currentIndex%img.width,currentIndex/img.width};
//    ellipse(currentXY[0],currentXY[1],distance,distance);
    
    int newXY[] = {(int)(currentXY[0]+distance*cos(angle)),
                   (int)(currentXY[1]+distance*sin(angle))};
   
    //constrain index to positions on the image               
    newXY[0] = max(0,min(newXY[0],img.width));
    newXY[1] = max(0,min(newXY[1],img.height));  
    
    render.line(currentXY[0],currentXY[1],newXY[0],newXY[1]);
    currentIndex = newXY[0] + newXY[1]*img.width;
    currentIndex = max(0,min(currentIndex,img.pixels.length-1));
//    println("angleDelta: " +  angleDelta);
  }
  render.endDraw();
}
