import controlP5.*;
import oscP5.*;
import netP5.*;
import processing.serial.*; 

ControlP5 cp5;
Slider2D s;
CallbackListener cb;

OscP5 oscP5;
NetAddress myRemoteLocation;
int port = 250;


Serial myPort;    // The serial port

void setup() {
  size(1024,768);
  
  oscP5 = new OscP5(this,port);
  myRemoteLocation = new NetAddress("127.0.0.1",port);
  
  cp5 = new ControlP5(this);
  
    cb = new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
       float X =s.getArrayValue()[0];
       float Y =s.getArrayValue()[1];
            
       float x = map(X,-10000,10000,-1,1);
       float y = map(Y,-10000,10000,-1,1);
       println(x+"   "+y);
       
       OscMessage myMessage = new OscMessage("/coord");
       myMessage.add(x);
       myMessage.add(y);
       oscP5.send(myMessage, myRemoteLocation);
      
  }
  };
  
  
  s = cp5.addSlider2D("Coordinates")
         .setPosition(30,40)
         .setSize(500,500)
         .setMinMax(-10000,10000,10000,-10000)
         .setValue(0,0)
         .addCallback(cb)
         //.disableCrosshair()
         ;
         
  smooth();
   printArray(Serial.list());
   myPort = new Serial(this, Serial.list()[0], 230400);
   myPort.bufferUntil('\n');
}

float cnt;
void draw() {
  background(0);
  pushMatrix();
  translate(160,140);
  noStroke();
  fill(50);
 // rect(0, -100, 400,200);
  strokeWeight(1);
  line(0,0,200, 0);
  stroke(255);
  popMatrix();
}

void serialEvent(Serial p) { 
    String inBuffer = p.readStringUntil('\n');
    if (inBuffer != null) {
      try{
         JSONObject object = parseJSONObject(inBuffer);
          if(object!=null){
          parseJson(object);
         //   println(inBuffer);
       } 
      }catch(Exception e){
        e.printStackTrace();
      }
    }else{
      println("its null :(");    
    }
}

void parseJson(JSONObject json){
    sendAnalog(json);
    sendButtons(json);
} 

void sendAnalog(JSONObject json){
OscMessage myMessage = new OscMessage("/anal");
       myMessage.add(map(json.getInt("a0"),0,1024,-4,4));
       myMessage.add(map(json.getInt("a3"),0,1024,-4,4));  
       myMessage.add(map(json.getInt("a2"),0,1024,-4,4));
       myMessage.add(map(json.getInt("a1"),0,1024,0,100));
       myMessage.add(map(json.getInt("a7"),0,1024,-4,4));
       myMessage.add(map(json.getInt("a6"),0,1024,-4,4));
       myMessage.add(map(json.getInt("a4"),0,1024,-4,4));
       myMessage.add(map(json.getInt("a5"),0,1024,0,100));
       myMessage.add(map(json.getInt("a11"),0,1024,-4,4));
       myMessage.add(map(json.getInt("a10"),0,1024,-4,4));
       myMessage.add(map(json.getInt("a9"),0,1024,-4,4));
       myMessage.add(map(json.getInt("a8"),0,1024,0,1));
       
       //17600
       myMessage.add(map(json.getInt("a12"),0,17600,0,60));
       myMessage.add(map(json.getInt("a13"),0,17600,0,360));
       myMessage.add(map(json.getInt("a14"),0,17600,0,360));
       myMessage.add(map(json.getInt("a15"),0,17600,0,10));
        
        println("sending "+json.getInt("a12")+"  "+json.getInt("a13")+"  "+json.getInt("a14")+" "+json.getInt("a15"));
       oscP5.send(myMessage, myRemoteLocation);
}
  
void sendButtons(JSONObject json){
   OscMessage myMessage = new OscMessage("/buttons");
       myMessage.add(json.getBoolean("b1"));
       myMessage.add(json.getBoolean("b5"));
       myMessage.add(json.getBoolean("b4"));
       myMessage.add(json.getBoolean("b3"));
       myMessage.add(json.getBoolean("b0"));
       myMessage.add(json.getBoolean("b2"));
       myMessage.add(json.getBoolean("b11"));
       myMessage.add(json.getBoolean("b12"));
       myMessage.add(json.getBoolean("b10"));
       myMessage.add(json.getBoolean("b9"));
       myMessage.add(json.getBoolean("b8"));
       myMessage.add(json.getBoolean("b7"));
       myMessage.add(json.getBoolean("b6"));
       oscP5.send(myMessage, myRemoteLocation);
}
