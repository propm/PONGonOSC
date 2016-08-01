//player2(クライアント側）
import oscP5.*;
import netP5.*;

OscP5 oscH;
OscP5 oscC;
NetAddress address;
OscMessage message;

float p1x, p1y, p2x, p2y;
float ballx, bally;
int p1point, p2point;
boolean p1, p2;
int r, barw, barh;

void setup(){
  size(900, 600);
  
  oscC = new OscP5(this, 1234);
  oscC.plug(this,"getData","/player2");  
  oscH = new OscP5(this, 5678);
  address = new NetAddress("192.168.65.1", 5678);
  
  r = 20;
  barw = (int)((double)width/50);
  barh = (int)((double)width/5); 
  p1x = width/6;
  p2x = width - width/6;
}

public void getData(float a,float b,float c){
  p2y = c;
  ballx = a;
  bally = b;
  println(a);
  
}

void draw(){
  background(0);
  fill(120,120,200);
  noStroke();
  p1y = mouseY;
  sendFloat(p1y);
  rect(p1x - barw/2,p1y - barh/2,barw,barh);
  rect(p2x - barw/2,p2y - barh/2,barw,barh);
  
  ellipse(ballx,bally,r,r);
  
  lookPoint(p1point,0,30,30);
  lookPoint(p2point,1,width-30,30);
  
  judge(p1point,p2point);
}

void sendFloat(float a){
  message = new OscMessage("/player1");
  message.add(a);
  oscH.send(message, address);
}

void lookPoint(int point,int player, int x, int y){
  if(player == 0){
    fill(255,100,100);
  }else if(player == 1){
    fill(100,100,255);
  }
  textSize(30);
  text(point, x, y);
}

void judge(int p1,int p2){
  if(p1 == 5){
    fill(255,0,0);
    textSize(100);
    text("Player 1 Win!!",30, height/2);
  }else if(p2 == 5){
    fill(0,0,255);
    textSize(100);
    text("Player 2 Win!!",30, height/2);
  }
}
