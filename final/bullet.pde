class Bullet extends PhysicalObject {
  
  ArrayList<BulletConf> conf_list = data.get("bullets");
  BulletConf conf;
  float damage;
  float ref_speed;
  float spawn_time;
  PImage pic;
  
  Bullet(float x, float y, PVector speed, float ang, int side, int proj_type) {
    super(x,y,8,ang,side,1);
    this.conf=conf_list.get(proj_type);
    this.mass=conf.mass;
    this.ref_speed=conf.speed;
    this.speed=speed.add(PVector.fromAngle(ang).setMag(ref_speed));
    this.damage=conf.damage;
    this.pic=conf.pic;
    this.spawn_time=t;
  }
  
  void move(){
    super.move();
    if (spawn_time+conf.alive<t) this.destroy();
  }
  
  
  void display() {
    //rect(pos.x,pos.y,5,5);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(this.ang+radians(conf.rotate));
    pic.resize(int(pic.width/(pic.height/conf.resize)),int(conf.resize));
    image(pic,-pic.width/2,-pic.height/2);
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
  
  float speed,damage,mass,resize,rotate,alive;
  PImage pic;
  
  BulletConf(PImage pic,float mass, float damage, float speed, float alive, float resize, float rotate) {
    this.mass=mass;
    this.speed=speed;
    this.damage=damage;
    this.pic=pic;
    this.alive=alive;
    this.resize=resize;
    this.rotate=rotate;
  }
  
}
