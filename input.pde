// http://www.openprocessing.org/visuals/?visualID=6268
// wrestled into VJ compatible MIDI form by Jay Silence

import themidibus.*;
 
// MIDI bus for parameter input via Akai LPD8
MidiBus myBus;

//processing 2.1.2 doesn't seem to support java enums...
//public enum LPD8_ {
public final int LPD8_PAD1=(36);
public final int LPD8_PAD2=(37);
public final int LPD8_PAD3=(38);
public final int LPD8_PAD4=(39);
public final int LPD8_PAD5=(40);
public final int LPD8_PAD6=(41);
public final int LPD8_PAD7=(42);
public final int LPD8_K1=(1);
public final int LPD8_K2=(2);
public final int LPD8_K3=(3);
public final int LPD8_K4=(4);
public final int LPD8_K5=(5);
public final int LPD8_K6=(6);
public final int LPD8_K7=(7);
public final int LPD8_K8=(8);
public final int LPD8_PAD1_CC=(1);
public final int LPD8_PAD2_CC=(2);
public final int LPD8_PAD3_CC=(3);
public final int LPD8_PAD4_CC=(4);
public final int LPD8_PAD5_CC=(5);
public final int LPD8_PAD6_CC=(6);
public final int LPD8_PAD7_CC=(8);
public final int LPD8_PAD8_CC=(9);



boolean debug = false;
void initLPD8()
{
   if (debug) MidiBus.list(); // List all available Midi devices on STDOUT. 
  // Create a new MidiBus with Akai input device and no output device.
  myBus = new MidiBus(this, "LPD8", -1);
}

// Handle keyboard input
void keyPressed()
{
  ////////////////////
  switch(key){
    case 'd':
      debug = !debug;
      println("Debug Output" + (debug?"enabled":"disabled"));
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
 
// MIDI Event handling
void noteOn(int channel, int pad, int velocity) {
  // Receive a noteOn
  if(debug) {
    print("Note On - ");
    print("Channel "+channel);
    print(" - Pad "+pad);
    println(" - Value: "+velocity);
  }
  switch(pad){
    case LPD8_PAD1:
      randomStokes();
      break;   
    default:
      break;   
  }
}

 
// Right now we are doing nothing on pad release events
void noteOff(int channel, int pad, int velocity) {
    // Receive a noteOff
  if(debug) {
    print("Note Off - ");
    print(" Channel "+channel);
    print(" - Pad "+pad);
    println(" - Value "+velocity);
  }
}
TweenedFloat scale1 = new TweenedFloat(10,10,.1);
TweenedFloat scale2 = new TweenedFloat(10,10,.1);
TweenedFloat scale3 = new TweenedFloat(10,10,.1);
TweenedFloat scale4 = new TweenedFloat(10,10,.1);
TweenedFloat scale5 = new TweenedFloat(10,10,.1);
TweenedFloat scale6 = new TweenedFloat(10,10,.1);
TweenedFloat scale7 = new TweenedFloat(10,10,.1);
TweenedFloat scale8 = new TweenedFloat(10,10,.1);


void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  if(debug) {
    print("Controller Change - ");
    print("Channel "+channel);
    print(" - Number "+number);
    println(" - Value "+value);
  }
   
  switch(number){
    case LPD8_K1:  // = K1
      scale1.targetValue =(value*10.f)/128.f;
      break;
    case LPD8_K2: // = K2
      scale2.targetValue = (value*10.f)/128.f;
      break;  
    case LPD8_K3: // = K3
      scale3.targetValue = (value*130.f)/128.f;
      break;  
    case LPD8_K4: // = K4
      scale4.targetValue = (value*48.f)/128.f;
      break;  
    case LPD8_K5: // = K5
      scale5.targetValue = (value*4.f)/128.f;
      break;  
    case LPD8_K6: // = K6
      scale6.targetValue = (value*.02f)/128.f;
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
  public TweenedFloat(float targ, float cur, float easing)
  {
    targetValue = targ;
    currentValue = cur;
    easing = easing;
  }
  
  public void update()
  {
    currentValue += (targetValue-currentValue)*easing;
  }
  float get()
  {
    return currentValue;
  }
  
}
