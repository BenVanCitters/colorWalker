class ColorStroke
{
  
  float angle = random(TWO_PI);
  float angleDelta = 0.1;
  
  ArrayList<float[]> pathPoints;
  ArrayList<float[]> triangleStripPoints;
  ArrayList<SegmentDrawAttributes> pathAttributes;
  int segmentCount = 500;


  public ColorStroke()
  {
    pathPoints = new ArrayList<float[]>();
    triangleStripPoints = new ArrayList<float[]>();
    pathAttributes = new ArrayList<SegmentDrawAttributes>();
  } 

  //constructs a line in img Space - expects a starting point in image space
  void constructLine(PGraphics g, PImage img, float[] startingPoint)
  {
    g.beginDraw();
    int currentIndex = getIndexFromPos(startingPoint, img);

    float maxDelta = .1;
    float deltaDelta = .05;
    img.loadPixels();

    float currentXY[] = new float[]{startingPoint[0],startingPoint[1]};
    
//    float x = startingPoint[0]* g.width*1.0/img.width;
//      float y = startingPoint[1]* g.height*1.0/img.height;
//     println("starttrans: " + x + "," + y);
//      println("g wxh: " + g.width + "," + g.height);
    for (int i = 0; i < segmentCount; i++)
    {
      //set some per-segment attributes
      SegmentDrawAttributes attributes = new SegmentDrawAttributes();
      currentIndex = getIndexFromPos(currentXY, img);
      attributes.strokeColor = img.pixels[currentIndex];
      attributes.segStrokeWeight = .1+random(2);

      float brtness = .99*brightness(attributes.strokeColor)/255.f;
       
      angleDelta += (random(deltaDelta*2)-deltaDelta)*(1-brtness);
      //constrain new angle
      angleDelta = max(-maxDelta, min(maxDelta, angleDelta));
      
      angle += angleDelta;
      attributes.segAngle = angle;
      
      //get a semi-random distance
      float distance = random(20);
      attributes.segLen = distance;

      currentXY[0] +=distance*cos(angle);
      currentXY[1] +=distance*sin(angle);

      //constrain index to positions on the image               
      currentXY[0] = max(0, min(currentXY[0], img.width));
      currentXY[1] = max(0, min(currentXY[1], img.height));  
      pathPoints.add(currentXY);

      //do cross product to add width to the line
      PVector p = new PVector(cos(angle), sin(angle), 0);
      p = p.cross(new PVector(0, 0, 1));
      p.mult(attributes.segStrokeWeight);

      float uVerts[] = {currentXY[0]+p.x, currentXY[1]+p.y, 0};
      float bVerts[] = {currentXY[0]-p.x, currentXY[1]-p.y, 0};
      
      triangleStripPoints.add(uVerts);
      triangleStripPoints.add(bVerts);
      
      pathAttributes.add(attributes);
    }
    g.endDraw();
    convertPointsToBufferSpace(g);
  }
  
  void update()
  {
    
  }
  
  
//convert points from image into buffer space
  void convertPointsToBufferSpace(PGraphics g)
  {
        for (float vert[] : triangleStripPoints)
    {
      vert[0] *= g.width*1.0/img.width;
      vert[1] *= g.height*1.0/img.height;
    }
    
    for (float vert[] : pathPoints)
    {
      vert[0] *= g.width*1.0/img.width;
      vert[1] *= g.height*1.0/img.height;
    }
  }

  // draw a smooth line
  void draw(PGraphics g)
  {
    g.beginDraw();
    g.beginShape(TRIANGLE_STRIP);

    g.noStroke();
    for (int i = 0; i < triangleStripPoints.size()/2; i++)
    {
      int currentColor = pathAttributes.get(i).strokeColor;
      g.fill(currentColor);

      float currentPoint[] = triangleStripPoints.get(i*2);
      g.vertex(currentPoint[0], currentPoint[1], currentPoint[2]);
      currentPoint = triangleStripPoints.get(i*2+1);
      g.vertex(currentPoint[0], currentPoint[1], currentPoint[2]);
    }

    g.endShape();
    g.endDraw();
  }

  //draw with boxes
  void draw2(PGraphics g)
  {
    g.beginDraw();
    g.noFill();
  
    for(int i = 0; i < pathPoints.size()-1; i++)
    {
      SegmentDrawAttributes attributes = pathAttributes.get(i);
      g.strokeWeight(attributes.segStrokeWeight);
      int currentColor = attributes.strokeColor;
      g.stroke(currentColor);
      
      float currentPoint[] = pathPoints.get(i);
      float nextPoint[] = pathPoints.get(i+1);
  
      g.line(currentPoint[0], currentPoint[1],nextPoint[0],nextPoint[1]);
    }
    g.endDraw();
  }

  int getIndexFromPos(float[] pos, PImage img)
  {
    if (img.pixels == null)
      return -1;
    int result = 0;
    //out of bounds positions break our calculation so we have to enforce that they are in the box!
    pos[0] = max(0, min(img.width-1, pos[0]));
    pos[1] = max(0, min(img.height-1, pos[1]));
    result = (int)pos[0] + (int)(pos[1])*img.width;
//    result = max(0, min(result, img.pixels.length-1));
    return result;
  }

//  int[] getPosFromIndex(int index, PImage g)
//  {
//    int result[] = new int[] { index%g.width, index/g.width };
//    result[0] = max(0, min(result[0], g.width));
//    result[1] = max(0, min(result[1], g.height));  
//    return result;
//  }
}

