//player2(クライアント側）
import oscP5.*;
import netP5.*;

OscP5 oscH;
OscP5 oscC;
NetAddress address;
OscMessage message;

float p1x, p1y, p2x, p2y; //バーの座標
float ballx, bally;  //ボールの座標
int p1point, p2point;  //プレイヤーのポイント 
int p1 = 0;  //勝敗判定
int p2 = 0;
int r, barw, barh;   //ボールの半径，バーの長さ

void setup(){
  size(900, 600);
  
  oscC = new OscP5(this, 1234); //自分のポート
  oscC.plug(this,"getData","/player2");  //データの取得
  oscC.plug(this,"getJudge","/judge");
  oscH = new OscP5(this, 5678);  //相手のポート
  address = new NetAddress("25.15.192.83", 5678); //相手のIPアドレスを指定
  
  r = 20;
  barw = (int)((double)width/50);
  barh = (int)((double)height/5); 
  p1x = width/6;
  p2x = width - width/6;
}

public void getData(float a,float b,float c){
  ballx = a;
  bally = b;
  p2y = c;
 
  
}

public void getJudge(int a, int b, int c, int d){
  p1point = a;
  p2point = b;
  p1 = c;
  p2 = d;
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
  
  lookPoint(p2point,0,30,30);
  lookPoint(p1point,1,width-30,30);
  
  judge(p1,p2);
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
  if(p1 == 1){
    fill(255,0,0);
    textSize(100);
    text("Player 1 Win!!",30, height/2);
  }else if(p2 == 1){
    fill(0,0,255);
    textSize(100);
    text("Player 2 Win!!",30, height/2);
  }
}

