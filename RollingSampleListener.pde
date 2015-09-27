import ddf.minim.analysis.*;
import ddf.minim.*;



//copyright Benjamin Van Citters 2012
//class -listens to the audio-in and keeps a 
class RollingSampleListener implements AudioListener
{
  Minim minim;
AudioInput in;

  float backSamples[];
  
  //==============================================================
  //==============================================================
  public RollingSampleListener(PApplet p)
  {
    minim = new Minim(p);
    in = minim.getLineIn(Minim.MONO, 256);
    in.addListener(this);
    backSamples = new float[1028*1];
  }
  //==============================================================
  //==============================================================
  void samples(float[] sampL, float[] sampR) 
  {  }
  
  int topIndex = 0;
  //==============================================================
  //==============================================================
  void samples(float[] samp) 
  {    
    for(int i = 0; i < samp.length;  i++)
    {         
      backSamples[topIndex] = samp[i];
      topIndex = (topIndex+ 1) % backSamples.length;
    }
  }

//==============================================================
//==============================================================
  void getLastSamples(float[] emptySamples)
  {
    for(int i = 0; i < emptySamples.length && i < backSamples.length; i++)
    {
      int curIndex = (topIndex- i);
      if(curIndex < 0)
        curIndex += backSamples.length;  
      emptySamples[i] = backSamples[curIndex];
    }
  }
  
  //==============================================================
  //==============================================================
  float getSample(int index)
  {
    int wrappedIndex = (topIndex+index)%backSamples.length;
    return backSamples[wrappedIndex];
  }
  
  //==============================================================
  //==============================================================
  float[] getBackSamples()
  {
    float retVal[] = new float[backSamples.length];
    for(int i = 0; i < retVal.length; i++)
    {
      int curIndex = (topIndex+ i) % backSamples.length;
      retVal[i] = backSamples[curIndex];
    }
    return retVal;
  }
  
  //==============================================================
  //==============================================================
  public float getMaxAmp()
  {
    float curMax = 0;
    for(int i = 0; i < backSamples.length; i++)
    {
      curMax = max(curMax,backSamples[i]);
    }
    return curMax;
  }
}
