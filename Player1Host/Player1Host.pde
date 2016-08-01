import oscP5.*;
import netP5.*;

OscP5 oscs, oscr;
NetAddress address;
OscMessage mes;
int r, barw, barh;
float x, y;
float myx, myy, youx, youy;
PVector v;
boolean start;

void setup(){
  size(900, 600);
  oscs = new OscP5(this, 1234);                    //季節を送信するインスタンス、自分のポート
  oscr = new OscP5(this, 5678);                    //受信用
  address = new NetAddress("10.0.1.111", 1234);   //相手のIPアドレス、ポート
  oscr.plug(this, "receive", "/player1");
  initial();
}

void draw(){
  drawing();
  send();
  
  if(start){
    
    x += v.x;
    y += v.y;
    
    myy = mouseY;
    
    dicision();
    send();
    
    drawing();
  }
}

void initial(){
  v = new PVector(3, 1);
  v.setMag(14);
  r = 20;
  barw = (int)((double)width/50);
  barh = (int)((double)height/5);
  x = width/2;
  y = height/2;
  myx = width/6*5;
  youx = width/6;
  myy = height/2;
  youy = height/2;
}

void drawing(){
  background(0);
  noStroke();
    
  fill(255, 134, 0);
  rect(myx - barw/2, myy - barh/2, barw, barh);
    
  fill(120, 120, 200);
  rect(youx - barw/2, youy - barh/2, barw, barh);
    
  fill(255, 0, 0);
  ellipse(x, y, r, r);
}

void send(){
  mes = new OscMessage("/player2");
  mes.add(x);
  mes.add(y);
  mes.add(myy);
  oscs.send(mes, address);
}

public void receive(float y){
  youy = y;
}

void dicision(){
  //バーが画面外に行かないように
  if(myy < barh/2)           myy = barh/2;
  if(myy > height - barh/2)  myy = width - barh/2;
  
  //ボールが画面外に行かないように
  if(y < r/2){
    y = r/2;
    v.y *= -1;
  }
  if(y > height - r/2){
    y = height - r/2;
    v.y *= -1;
  }
  
  //ボールとバーのあたり判定
  if(y > myy - barh/2 && y < myy + barh/2){
    if(x + r/2 > myx - barw/2 && x + r/2 < myx + barw/2){
      x = myx - barw/2 - r/2;
      v.x *= -1;
    }
  }
  if(y > youy - barh/2 && y < youy + barh/2){
    if(x - r/2 < youx + barw/2 && x - r/2 > youx - barw/2){
      x = youx + barw/2 + r/2;
      v.x *= -1;
    }
  }
}

void keyPressed(){
  if(key == ' '){
    initial();
    start = true;
  }
}

