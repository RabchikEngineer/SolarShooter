class Bullet extends PhysicalObject {
  
  ArrayList<BulletConf> conf = config.get("bullets");
  float damage;
  PImage pic;
  
  Bullet(float x, float y, PVector speed, float ang, int side, int proj_type) {
    super(x,y,5,ang,side,0.5);
    this.speed=speed.add(PVector.fromAngle(ang).setMag(conf.get(proj_type).speed));
    this.damage=conf.get(proj_type).damage;
    this.pic=conf.get(proj_type).pic;
  }
  
  
  void display() {
    //rect(pos.x,pos.y,5,5);
    pushMatrix();
    rotate(this.ang);
    image(pic,pos.x-pic.width/2,pos.y-pic.height/2);
    popMatrix();
    ellipse(pos.x,pos.y,5,5);
    //text2(str(side),x,y);
  }
  
  void collide_bounds() {
    if (abs(this.pos.x)>bounds.x || abs(this.pos.y)>bounds.y) {this.destroy();}
    
  }
  
  void destroy() {
    super.destroy(bullets);
  }
  

  
}

class BulletConf {
  
  float speed,damage;
  PImage pic;
  
  BulletConf(float speed, float damage, PImage pic) {
    this.speed=speed;
    this.damage=damage;
    this.pic=pic;
  }
  
}
