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
int score1, score2;
boolean p1, p2;        //勝ち負け
boolean outflag;       //ボールが外に行ったときにtrue
int count;
boolean end;

void setup(){
  size(900, 600);
  oscs = new OscP5(this, 1234);                    //季節を送信するインスタンス、自分のポート
  oscr = new OscP5(this, 5678);                    //受信用
  address = new NetAddress("10.0.1.185", 1234);   //相手のIPアドレス、ポート
  oscr.plug(this, "receive", "/player1");
  initial();
}

void draw(){
  drawing();
  send();
  
  if(start && !end){
    
    x += v.x;
    y += v.y;
    
    myy = mouseY;
    
    if(outflag){
      drawing();
      count++;
      if(count/60 >= 2){
        outflag = false;
        count = 0;
        rebirth();
      }
    }
    
    dicision();
    judge();
    send();
    
    drawing();
  }else if(end){
    textSize(80);
    if(p1){
      fill(255, 134, 0);
      text("WIN!!", width/10*4, height/8*3);
    }
    if(p2){
      fill(120, 0, 255);
      text("LOSE...", width/10*4, height/8*3);
    }
  }
}

void initial(){
  
  r = 20;
  barw = (int)((double)width/50);
  barh = (int)((double)height/5);
  myx = width/6*5;
  youx = width/6;
  myy = height/2;
  youy = height/2;
  
  rebirth();
  
  score1 = score2 = 0;
  p1 = p2 = false;
  end = false;
}

void rebirth(){
  x = width/2;
  y = height/2;
  v = new PVector(random(-3, 3), random(-3, 3));
  v.setMag(14);
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
  
  textSize(50);
  fill(255, 134, 0);
  text(score1, width/30*28, height/50*4);
  
  fill(120, 120, 200);
  text(score2, width/30*2, height/50*4);
}

void send(){
  mes = new OscMessage("/player2");
  mes.add(x);
  mes.add(y);
  mes.add(myy);
  mes.add(score1);
  mes.add(score2);
  mes.add(p1);
  mes.add(p2);
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
  
  //ゴール判定
  if(x + r/2 < 0 && !outflag){
    score1++;
    outflag = true;
  }
  if(x - r/2 > width && !outflag){
    score2++;
    outflag = true;
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


void judge(){
  if(score1 >= 7)  p1 = true;
  if(score2 >= 7)  p2 = true;
  
  if(p1 || p2)  end = true;  
}

void keyPressed(){
  if(key == ' '){
    initial();
    start = true;
  }
}

