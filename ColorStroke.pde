class ColorStroke
{
  
  float angle = random(TWO_PI);
  float angleDelta = 0.1;
  
  ArrayList<float[]> pathPoints;
  ArrayList<float[]> triangleStripPoints;
  ArrayList<SegmentDrawAttributes> pathAttributes;
  int segmentCount = 1000;


  public ColorStroke()
  {
    pathPoints = new ArrayList<float[]>();
    triangleStripPoints = new ArrayList<float[]>();
    pathAttributes = new ArrayList<SegmentDrawAttributes>();
  } 

  void constructLine(PGraphics g, PImage img, float[] startingPoint)
  {
    g.beginDraw();
    int currentIndex = getIndexFromPos(startingPoint, g);

    float maxDelta = .1;
    float deltaDelta = .02;
    img.loadPixels();

    int currentXY[] = {0, 0};

    for (int i = 0; i < segmentCount; i++)
    {
      //set some per-segment attributes
      SegmentDrawAttributes attributes = new SegmentDrawAttributes();
      attributes.strokeColor = img.pixels[currentIndex];
      attributes.segStrokeWeight = .6+random(10);;
      pathAttributes.add(attributes);

      float brtness = .99*brightness(attributes.strokeColor)/255.f;

      angleDelta += (random(deltaDelta*2)-deltaDelta)*(1-brtness);
      angleDelta = max(-maxDelta, min(maxDelta, angleDelta));
      angle += angleDelta;

      //get a semi-random distance
      float distance = random(40);

      currentXY= getPosFromIndex(currentIndex, g);

      float newXY[] = {(currentXY[0]+distance*cos(angle)), 
                       (currentXY[1]+distance*sin(angle)),
                       0};

      //constrain index to positions on the image               
      newXY[0] = max(0, min(newXY[0], img.width));
      newXY[1] = max(0, min(newXY[1], img.height));  
      pathPoints.add(newXY);

      //do cross product to add width to the line
      PVector p = new PVector(cos(angle), sin(angle), 0);
      p = p.cross(new PVector(0, 0, 1));
      p.mult(attributes.segStrokeWeight);

      triangleStripPoints.add(new float[] {newXY[0]+p.x, newXY[1]+p.y, 0});
      triangleStripPoints.add(new float[] {newXY[0]-p.x, newXY[1]-p.y, 0});

      currentIndex = getIndexFromPos(newXY, g);
    }
    g.endDraw();
  }

  // draw a smooth line
  void draw(PGraphics g)
  {
    g.beginDraw();
    g.beginShape(TRIANGLE_STRIP);

    g.noStroke();
    for (int i = 0; i < segmentCount; i++)
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
  
    for(int i = 0; i < segmentCount-1; i++)
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

  int getIndexFromPos(float[] pos, PGraphics g)
  {
    if (g.pixels == null)
      return -1;
    int result = 0;
    //out of bounds positions break our calculation so we have to enforce that they are in the box!
    pos[0] = max(0, min(g.width-1, pos[0]));
    pos[1] = max(0, min(g.height-1, pos[1]));
    result = (int)pos[0] + (int)(pos[1])*g.width;
    result = max(0, min(result, g.pixels.length-1));
    return result;
  }

  int[] getPosFromIndex(int index, PGraphics g)
  {
    int result[] = new int[] { index%g.width, index/g.width };
    result[0] = max(0, min(result[0], g.width));
    result[1] = max(0, min(result[1], g.height));  
    return result;
  }
}

