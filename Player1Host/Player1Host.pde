import oscP5.*;
import netP5.*;

OscP5 oscs, oscr;
NetAddress address;

int r, barw, barh;
float x, y;
float myx, myy, youx, youy;
PVector v;
boolean start;
int score1, score2;
int p1, p2;        //勝ち負け
boolean outflag;       //ボールが外に行ったときにtrue
int count;
boolean end;

void setup(){
  size(900, 600);
  oscs = new OscP5(this, 1234);                    //季節を送信するインスタンス、自分のポート
  oscr = new OscP5(this, 5678);                    //受信用
  address = new NetAddress("25.19.14.76", 1234);   //相手のIPアドレス、ポート
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
        int counter = count - 120;
        
        if(counter <= 40){
          if(counter % 10 <= 0)  rebirth();
          else{
            x = width + r/2;
            y = height + r/2;
          }
          count++;
        }else{
          outflag = false;
          count = 0;
        }
      }
    }
    
    dicision();
    judge();
    send();
    
    drawing();
  }else if(end){
    textSize(80);
    if(p1 == 1){
      fill(255, 134, 0);
      text("WIN!!", width/10*4, height/8*3);
    }
    if(p2 == 1){
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
  p1 = p2 = 0;
  end = false;
}

void rebirth(){
  x = width/2;
  y = height/2;
  
  float vx = random(2) < 1 ? random(2)+1 : (random(2)+1)*-1;
  float vy = random(2) < 1 ? random(2)+1 : (random(2)+1)*-1;
  v = new PVector(vx, vy);
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
  OscMessage mes = new OscMessage("/player2");
  mes.add(x);
  mes.add(y);
  mes.add(myy);
  
  OscMessage mes2 = new OscMessage("/judge");
  mes2.add(score1);
  mes2.add(score2);
  mes2.add(p1);
  mes2.add(p2);
  oscs.send(mes, address);
  oscs.send(mes2, address);
}

public void receive(float y){
  youy = y;
}

void dicision(){
  //バーが画面外に行かないように
  if(myy < barh/2)           myy = barh/2;
  if(myy > height - barh/2)  myy = height - barh/2;
  
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
  if(score1 >= 7)  p1 = 1;
  if(score2 >= 7)  p2 = 1;
  
  if(p1 == 1 || p2 == 1)  end = true;
}

void keyPressed(){
  if(key == ' '){
    initial();
    start = true;
  }
}

