class Ship extends PhysicalObject {
  float kd_val=0.1;
  boolean kd;
  int proj_type;
  float last_shot;
  float xp;
  float req_ang=0;
  boolean ai_active=true;
  ArrayList<ShipConf> conf_list = data.get("ships");
  ShipConf conf;
  PImage pic;
  int type = 0;
  
  Ship(float x, float y,float r,float ang, int side, float mass, float xp, int type) {
    super(x,y,r,ang,side,mass);
    this.conf = conf_list.get(type);
    this.pic=loadImage("sprites/"+conf.filename);
    this.pic.resize(int(r*2),int(r*2));
    this.proj_type=conf.proj_type;
    this.xp=xp;
  }
  
  void move() {
    
    if (JOYSTICK_MODE && control_active && this.side==0) {
      //this.moment+=(this.req_ang-this.ang);
      //float ang = abs(this.req_ang%TWO_PI-this.ang%TWO_PI);
      this.ang_speed=(this.req_ang-this.ang)*dt*rotation_speed_mult;
      //println((this.req_ang-this.ang)*dt*rotation_speed_mult);
    }
    
    if (this.side==1 && ai_active) {
      this.ang=this.req_ang;
      //this.apply_force(PVector.fromAngle(this.ang).setMag((ai_speed-this.speed.mag())*100));
      this.speed=PVector.fromAngle(this.ang).setMag(ai_speed);
    }
    
    

    super.move();
  }
  
  void display() {
    
    
    
    if (this.side==1) {
      Ship ps = ships.get(0);
      PVector marker = new PVector(this.pos.x-ps.pos.x,this.pos.y-ps.pos.y);
      //println(marker.mag());
      if (marker.mag()>marker_radius+marker_ind) {
        pushMatrix();
        translate(ps.pos.x,ps.pos.y);
        //line(0,0,marker.x,marker.y);
        marker.setMag(marker_radius);
        fill(#ff0000);
        ellipse(marker.x,marker.y,10,10);
        fill(#ffffff);
        popMatrix();
      }  
    }
    
    pushMatrix();
    stroke(255);
    translate(pos.x,pos.y);
    
    
    
    pushMatrix();
    rotate(this.ang);
    //this.pics[0].resize(int(this.pics[0].width/(this.pics[0].height/r)),int(r));
    translate(-pic.width/2+conf.shift,-pic.height/2);
    //println(conf.shift);
    rotate(radians(conf.rotate));
    image(pic,0,0);
    //ellipse(0,0,r,r);
    //rect(5,0,30,10);
    popMatrix();
    
    //pushMatrix();
    //rotate(this.req_ang);
    //line(0,0,100,0);
    //popMatrix();
    
    if (t<this.last_shot+this.kd_val) {text2(str(ceil((this.last_shot+this.kd_val-t)*100.0)/100.0), 0,0);}
    text2(str(this.xp),0,-20);
    //text2(this.speed.toString(),0,10);
    popMatrix();
  }
  
  void shoot() {
    kd=t<this.last_shot+this.kd_val;
    PVector direction = this.speed.copy().add(PVector.fromAngle(this.ang));
    PVector point = PVector.fromAngle(this.ang).setMag(this.r);
    if (!kd) {
      Bullet b = new Bullet(pos.x+point.x, pos.y+point.y, direction, this.ang, this.side, this.proj_type);
      bullets.add(b);
      this.add_momentum(new PVector(-b.ref_speed*b.mass,0)); //*b.speeds[proj_type]
      //this.kd=true;
      this.last_shot=t;
    }
    
  }
  
  void target(Ship s) {
    PVector guide = new PVector(s.pos.x-this.pos.x,s.pos.y-this.pos.y);
    this.req_ang=guide.heading();
    //this.shoot();
    //println(guide.mag());
    if (guide.mag()<=ai_shoot_distance) {
      this.shoot();
    }
  }
  
  void take_hit(Bullet b) {
    this.xp-=b.damage;
    if (this.xp<=0) {this.destroy();}
  }
  
  void destroy() {
    super.destroy(ships);
     // кодик с эффектами
  }
  
  
  //void collide_bounds() {
    
  //  //this.update_bounds();
  //  if ((this.x<=0 || this.x>=width) || (this.y<=0 || this.y>=height)) {this.destroy();}
  
  //}
  
  
}

class PlayerShip extends Ship {
  
  PlayerShip(float x, float y,float r, float mass) {
    super(x,y,r,0,0,mass,10,0);
  }
  
  void shoot() {
    super.shoot();
  }
 
  
  
}

class EnemyShip extends Ship {
  
  EnemyShip(float x, float y,float r, float mass, int type) {
    super(x,y,r,0,1,mass,100,type);
    this.kd_val=conf.kd;
  }
  
  
  void shoot() {
    super.shoot();
  }
  
  
}


class ShipConf {
  String filename;
  float kd,rotate,shift;
  int proj_type;
  
  ShipConf(String filename, float kd, int proj_type, float rotate, float shift) {
    this.filename=filename;
    this.kd=kd;
    this.proj_type=proj_type;
    this.rotate=rotate;
    this.shift=shift;
  }
  
}




    //if (this.side==0) {
    //float ang = PI-abs(abs((this.req_ang-this.ang)%TWO_PI)-PI);
    ////float ang1 = (this.req_ang-this.ang+HALF_PI)%PI+this.ang;
    ////float ang2 = (this.ang)%PI;
    //float ang1 = this.req_ang%TWO_PI;
    //float ang2 = this.ang%TWO_PI;
    //float dif = ang2-ang1;
    //if (dif<-PI) {ang2+=4*PI; dif = ang2-ang1;}
    
    //pushMatrix();
    //translate(mouseX,mouseY);
    //pushMatrix();
    //rotate(ang1);
    //line(0,0,30,0);
    //popMatrix();
    //pushMatrix();
    //rotate(ang2);
    //line(0,0,40,0);
    //popMatrix();
    //popMatrix();
    
    //int sign = -sgn(dif);
    //println(ang1,ang2,sign);
