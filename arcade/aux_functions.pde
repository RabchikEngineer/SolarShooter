int sgn(float f) {
  if (f > 0) return 1;
  if (f < 0) return -1;
  return 0;
} 


float pow_with_sign(float x,float n) {
  int sign;
  if (x > 0) {sign=1;} else {sign=-1;}
  
  return pow(abs(x),n)*sign;
}

//float norm_ang(float ang) {
//  ang=abs(abs(ang%TWO_PI)-PI);
//  println(ang);
//  //if (ang>) {
    
//  //}
//  return ang;
//}

class Force {
  float mag,ang;
  
  Force(float mag, float ang) {
    this.mag=mag;
    this.ang=ang;
  }
}

//class PlaneCoord extends PVector {
  
//  PlaneCoord(float x, float y) {
//    super(x,y);
//  }
  
//  //boolean equals(float a) {
//  //  return (this.x==a && this.y==a);
//  //}
  
//  //void multiply(float a) {
//  //  this.x*=a;
//  //  this.y*=a;
//  //}
  
//  //PVector multiply_ret(float a) {
//  //  return new PVector(this.x*a,this.y*a);
//  //}
  
//  //PVector multiply_ret(float a, float b) {
//  //  return new PVector(this.x*a,this.y*b);
//  //}
  
//  //void add(PVector a) {
//  //  this.x+=a.x;
//  //  this.y+=a.y;
//  //}
  
//  //PVector add_ret(PVector a) {
//  //  return new PVector(this.x+a.x,this.y+a.y);
//  //}
  
//  //PVector reverce_ret(PVector a) {
//  //  return new PVector(this.x+a.x,this.y+a.y);
//  //}
  
//}

void text2(String text,float x, float y) {
  fill(255,0,0);
  text(text,x-5,y+5);
  fill(255);
}


void victory() {
  //println("VICTORY");
  text("VICTORY",width/2,height/2);
}

void defeat() {
  //println("DEFEAT");
  text("DEFEAT",width/2,height/2);
}
