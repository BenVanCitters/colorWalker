import java.util.Vector;

class ColorStroke
{
  
  float startAngle = random(TWO_PI);
  float angle = startAngle;
  float angleDelta = random(.2)-.1;
  float maxWeightDelta = 0.1;
  float maxDistDelta = 3;
  
  Vector<float[]> pathPoints;
  Vector<float[]> triangleStripPoints;
  Vector<SegmentDrawAttributes> pathAttributes;
  int segmentCount = 200;
  
  float maxDelta = .25;
  float deltaDelta = .01;
  float[] startPoint;
  
  //==============================================================
  //==============================================================
  public ColorStroke()
  {
    pathPoints = new Vector<float[]>();
    triangleStripPoints = new Vector<float[]>();
    pathAttributes = new Vector<SegmentDrawAttributes>();
  } 

  //==============================================================
  //constructs a line in img Space - expects a starting point in image space
  //==============================================================
  void constructLine(PGraphics target, PImage source, float[] startingPoint)
  {
    startPoint = new float[]{startingPoint[0],startingPoint[1]};

    source.loadPixels();

    //float currentXY[] = new float[]{startingPoint[0],startingPoint[1]};

    for (int i = 0; i < segmentCount; i++)
    {
      //set some per-segment attributes
      SegmentDrawAttributes attributes = new SegmentDrawAttributes();
      
      attributes.strokeColor = 0;//source.pixels[getSrcIndexFromPos(currentXY, source)];
      attributes.segStrokeWeight = 1.1+random(2);

      float brtness = .99*brightness(attributes.strokeColor)/255.f;
       
      angleDelta += (random(deltaDelta*2)-deltaDelta);
      //constrain new angle
      angleDelta = max(-maxDelta, min(maxDelta, angleDelta));
      attributes.segAngleDelta = angleDelta;
      attributes.segAngleDeltaFreq = random(1)-.5;
      attributes.segAngleDeltaMag = random(.5);
      angle += angleDelta;

      
      //get a semi-random distance
      float distance = random(40);
      attributes.segLen = distance;
      

      pathAttributes.add(attributes);
    }
  }
  
  //==============================================================
  //update moves all of the verts
  //==============================================================
  void update(PGraphics target, PImage source, float maxAmp,float samps[], float tm, float sz,float strokeW)
  {
    

    float currentXY[] = new float[]{startPoint[0],startPoint[1]};
    SegmentDrawAttributes attr = pathAttributes.get(0);
    angle = startAngle;
//    pathAttributes.clear();
    pathPoints.clear();
    triangleStripPoints.clear();
    for (int i = 0; i < segmentCount; i++)
    {
      
      int sampIndex = min(i,samps.length-1);
      //set some per-segment attributes
      SegmentDrawAttributes attributes = pathAttributes.get(i);//new SegmentDrawAttributes();
      attributes.strokeColor = source.pixels[getSrcIndexFromPos(currentXY, source)];
      float brtness = .99*brightness(attributes.strokeColor)/255.f;
      attributes.segStrokeWeight += (random(maxWeightDelta*2)-maxWeightDelta);

      
//       attributes.segAngleDeltaFreq = random(1)-.5;
//      attributes.segAngleDeltaMag
      attributes.segAngleDelta = attributes.segAngleDeltaMag*sin(tm*attributes.segAngleDeltaFreq);//(random(deltaDelta*2)-deltaDelta)*(1-brtness);
      //constrain new angle
      attributes.segAngleDelta = max(-maxDelta, min(maxDelta, attributes.segAngleDelta));
      
      //attributes.segAngle = attributes.segAngle + angleDelta;
      angle += attributes.segAngleDelta ;
      
      
      //get a semi-random distance
      float distance = attributes.segLen;//max(0,attributes.segLen + (random(maxDistDelta*2)-maxDistDelta));
      attributes.segLen = distance;
distance *= sz;
      currentXY[0] +=distance*cos(angle);
      currentXY[1] +=distance*sin(angle);

      //constrain index to positions on the image               
      currentXY[0] = max(0, min(currentXY[0], source.width));
      currentXY[1] = max(0, min(currentXY[1], source.height));  
      
      pathPoints.add(currentXY);
      //do cross product to add width to the line
      PVector p = new PVector(cos(angle), sin(angle), 0);
      p = p.cross(new PVector(0, 0, 1));
      p.mult(strokeW*(samps[sampIndex]*200+brtness*15+attributes.segStrokeWeight));

      float uVerts[] = {currentXY[0]+p.x, currentXY[1]+p.y, 0};
      float bVerts[] = {currentXY[0]-p.x, currentXY[1]-p.y, 0};
      
      triangleStripPoints.add(uVerts);
      triangleStripPoints.add(bVerts);
      
    }
  }
  
  //==============================================================
  //convert points from image into buffer space
  //==============================================================
  void convertPointsToBufferSpace(PGraphics g, PImage src)
  {
    float mult[] = {g.width*1.0/src.width,g.height*1.0/src.height};
    for (float vert[] : triangleStripPoints)
    {
      vert[0] *= mult[0];
      vert[1] *= mult[1];
    }
    
    for (float vert[] : pathPoints)
    {
      vert[0] *= mult[0];
      vert[1] *= mult[1];
    }
  }
  
  //==============================================================
  // draw a smooth line
  //==============================================================
  void draw(PGraphics g, PImage src, float drawPct)
  {
    long start = millis();
    g.pushMatrix();
    g.scale(g.width*1.0/src.width,g.height*1.0/src.height,1);
    g.beginShape(TRIANGLE_STRIP);

    g.noStroke();
    int drawCount = (int )(drawPct* triangleStripPoints.size()/2);
//    println("drawCount: " + drawCount);
    for (int i = 0; i < drawCount; i++)
    {
      int currentColor = pathAttributes.get(i).strokeColor;
      g.fill(currentColor);

      float currentPoint[] = triangleStripPoints.get(i*2);
      g.vertex(currentPoint[0], currentPoint[1], currentPoint[2]);
      currentPoint = triangleStripPoints.get(i*2+1);
      g.vertex(currentPoint[0], currentPoint[1], currentPoint[2]);
    }

    g.endShape();
    g.popMatrix();
    
  }
  
  //==============================================================
  //draw with boxes
  //==============================================================
  void draw2(PGraphics g, PImage src)
  {
    long start = millis();
    convertPointsToBufferSpace( g,  src);
    g.beginDraw();
    g.pushMatrix();
//    g.scale(g.width*1.0/src.width,g.height*1.0/src.height,1);
    g.noFill();
//  println(pathPoints.size());
    for(int i = 0; i < pathPoints.size()-1; i++)
    {
      SegmentDrawAttributes attributes = pathAttributes.get(i);
      g.strokeWeight(10+attributes.segStrokeWeight);
      int currentColor = attributes.strokeColor;
      g.stroke(currentColor);
      
      float currentPoint[] = pathPoints.get(i);
      float nextPoint[] = pathPoints.get(i+1);
//  g.ellipse(currentPoint[0], currentPoint[1], 100,100);
      g.line(currentPoint[0], currentPoint[1],nextPoint[0],nextPoint[1]);
    }
    g.popMatrix();
    g.endDraw();
  }

  //==============================================================
  //==============================================================
  int getSrcIndexFromPos(float[] pos, PImage source)
  {
    if (source.pixels == null)
      return -1;
    int result = 0;
    //out of bounds positions break our calculation so we have to enforce that they are in the box!
    pos[0] = max(0, min(source.width-1, pos[0]));
    pos[1] = max(0, min(source.height-1, pos[1]));
    result = (int)pos[0] + (int)(pos[1])*source.width;
    //do I need this last check?  all these mins and maxs aren't the fastest...
//    result = max(0, min(result, img.pixels.length-1));
    return result;
  }
  
//  //==============================================================
//  //==============================================================
//  int[] getPosFromIndex(int index, PImage g)
//  {
//    int result[] = new int[] { index%g.width, index/g.width };
//    result[0] = max(0, min(result[0], g.width));
//    result[1] = max(0, min(result[1], g.height));  
//    return result;
//  }
}

