// http://www.openprocessing.org/visuals/?visualID=6268
// wrestled into VJ compatible MIDI form by Jay Silence

import themidibus.*;
 
// MIDI bus for parameter input via Akai LPD8
MidiBus myBus;

//processing 2.1.2 doesn't seem to support java enums...
//public enum LPD8_ {
public static final int LPD8_PAD1=36;
public static final int LPD8_PAD2=37;
public static final int LPD8_PAD3=38;
public static final int LPD8_PAD4=39;
public static final int LPD8_PAD5=40;
public static final int LPD8_PAD6=41;
public static final int LPD8_PAD7=42;
public static final int LPD8_PAD8=43;
public static final int LPD8_K1=1;
public static final int LPD8_K2=2;
public static final int LPD8_K3=3;
public static final int LPD8_K4=4;
public static final int LPD8_K5=5;
public static final int LPD8_K6=6;
public static final int LPD8_K7=7;
public static final int LPD8_K8=8;
public static final int LPD8_PAD1_CC=1;
public static final int LPD8_PAD2_CC=2;
public static final int LPD8_PAD3_CC=3;
public static final int LPD8_PAD4_CC=4;
public static final int LPD8_PAD5_CC=5;
public static final int LPD8_PAD6_CC=6;
public static final int LPD8_PAD7_CC=8;
public static final int LPD8_PAD8_CC=9;

public static boolean input_debug = false;
//==============================================================
//==============================================================
void initLPD8()
{
   if (input_debug) MidiBus.list(); // List all available Midi devices on STDOUT. 
  // Create a new MidiBus with Akai input device and no output device.
  myBus = new MidiBus(this, "LPD8", -1);
}

//==============================================================
// Handle keyboard input
//==============================================================
void keyPressed()
{
  ////////////////////
  switch(key){
    case 'd':
      input_debug = !input_debug;
      println("Debug Output" + (input_debug?"enabled":"disabled"));
      break;
    case 's':
      //save the output by pressing 's'
      {
        String className = this.getClass().getSimpleName();
        String path = "renders/" + className+"-"+year()+"-"+month()+"-"+day()+":"+hour()+":"+minute()+":"+second()+":"+millis() +".png";
        collection.drawBuffer.save(path);
        println("Saved buffer to: " +path);
      }
      break;
   case 'c':
      //clear by pressing 'c'
      resetCanvas();
      break;
  }
}

//============================================================== 
// MIDI Event handling
//==============================================================
void noteOn(int channel, int pad, int velocity) {
  // Receive a noteOn
  if(input_debug) {
    print("Note On - ");
    print("Channel "+channel);
    print(" - Pad "+pad);
    println(" - Value: "+velocity);
  }

  switch(pad){
    case LPD8_PAD1:
      randomStokes();
      break;   
    case LPD8_PAD2:
      pointStokes();
      break;
    case LPD8_PAD3:
      lineStokes();
      break;
    case LPD8_PAD5:
      incrementIndex();
    break;


    default:
      break;   
  }
}

//==============================================================
// Right now we are doing nothing on pad release events
//==============================================================
void noteOff(int channel, int pad, int velocity) {
    // Receive a noteOff
  if(input_debug) {
    print("Note Off - ");
    print(" Channel "+channel);
    print(" - Pad "+pad);
    println(" - Value "+velocity);
  }
}

TweenedFloat scale1 = new TweenedFloat(1,1,.1); //segment pct to draw
TweenedFloat scale2 = new TweenedFloat(1,1,1.0); //pct total strokes to draw
TweenedFloat scale3 = new TweenedFloat(1,1,.1); // alpha
TweenedFloat scale4 = new TweenedFloat(10,10,.1);
TweenedFloat scale5 = new TweenedFloat(10,10,.1);
TweenedFloat scale6 = new TweenedFloat(10,10,.1);
TweenedFloat scale7 = new TweenedFloat(10,10,.1);
TweenedFloat scale8 = new TweenedFloat(10,10,.1);

//==============================================================
//==============================================================
void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  if(input_debug) {
    print("Controller Change - ");
    print("Channel "+channel);
    print(" - Number "+number);
    println(" - Value "+value);
  }
   
  switch(number){
    case LPD8_K1:  
      scale1.targetValue =(value)/128.f;
      break;
    case LPD8_K2: 
      scale2.targetValue = (value)/128.f;
      break;  
    case LPD8_K3: 
      scale3.targetValue = (value)/128.f;
      break;  
    case LPD8_K4: // = K4
      scale4.targetValue = (value)/128.f;
      break;  
    case LPD8_K5: // = K5
      scale5.targetValue = (value)/128.f;
      break;  
    case LPD8_K6: // = K6
      scale6.targetValue = (value)/128.f;
      break;  
    case LPD8_K7: // = K6
      scale7.targetValue = (int)((value*1.1f)/128.f);
      break;  
    case LPD8_K8: // = K6
      scale8.targetValue = (int)((value*10.f)/128.f);
      break;  
    default:
      break;   
  } 
}

class TweenedFloat
{
  float targetValue = 0;
  float currentValue = 0;
  float easing = .04;
//==============================================================
//==============================================================
  public TweenedFloat(float targ, float cur, float ease)
  {
    targetValue = targ;
    currentValue = cur;
    easing = ease;
  }
  
  //==============================================================
  //==============================================================
  public void update()
  {
    currentValue += (targetValue-currentValue)*easing;
  }
  //==============================================================
  //==============================================================
  float get()
  {
    return currentValue;
  }
  //==============================================================
  //==============================================================
  String toString()
  {
    return "currentValue: " + currentValue + ", targetValue: " + targetValue + ", easing: " + easing;
  }
}

//==============================================================
//==============================================================
void updateInputFloats()
{
  if(input_debug)
  {
    println("scale1: " + scale1.toString());
    println("scale2: " + scale2.toString());
    println("scale3: " + scale3.toString());
    println("scale4: " + scale4.toString());
    println("scale5: " + scale5.toString());
    println("scale6: " + scale6.toString());
    println("scale7: " + scale7.toString());
    println("scale8: " + scale8.toString());
  }
  scale1.update();
  scale2.update();
  scale3.update();
  scale4.update();
  scale5.update();
  scale6.update();
  scale7.update();
  scale8.update();
}
