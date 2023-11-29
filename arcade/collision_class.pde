class CollisionSphere {
  float r;
  float ang,ang_speed;
  PVector pos;
  PVector speed = new PVector(0,0);
  int side;
  
  CollisionSphere(float x, float y, float r, float ang, int side) {
    this.pos = new PVector(x,y);
    this.r=r;
    this.ang=ang;
    this.side=side;
  }
  
  void move() {
    this.pos.add(PVector.mult(speed,dt));
    this.ang+=ang_speed;
    this.ang=this.ang;
    //x+=speed.x*dt;
    //y+=speed.y*dt;
    //println(speed.toString());
  }
  
  void move(float x, float y) {
    this.pos = new PVector(x,y);
  }
    
  
  void set_velocity(float vx, float vy) {
    this.speed.x=vx;
    this.speed.y=vy;
  }
  
  boolean will_intersect(CollisionSphere obj) {
    

    PVector v1=this.speed.copy().rotate(this.ang);
    PVector v2=obj.speed.copy().rotate(this.ang);
    
    if (dist(this.pos.x+(v1.x*dt),this.pos.y+(v1.y*dt),
             obj.pos.x+(v2.x*dt),obj.pos.y+(v2.y*dt))<(this.r+obj.r)) {return true;}
    
    return false;
  }
  
  
  boolean intersects(CollisionSphere obj) {

    if (dist(this.pos.x,this.pos.y,obj.pos.x,obj.pos.y)<(this.r+obj.r))
    {return true;}
    
    return false;
  
  }
  
  
  void collide(CollisionSphere obj) {
    //float x_sign=1,y_sign=-1;
    //boolean cond1=obj.x-this.x < obj.y-this.y;
    //boolean cond2=obj.y > this.y+(this.x-obj.x);
    ////print(cond1);
    ////println(cond2);
    //if (cond1) {x_sign*=-1;y_sign*=-1;} 
    //if (cond2) {x_sign*=-1;y_sign*=-1;}
    
    //this.speed.x*=x_sign;
    //obj.speed.x*=x_sign;
    //this.speed.y*=y_sign;
    //obj.speed.y*=y_sign;
    this.speed.mult(-1);
    obj.speed.mult(-1);
    
  }
  
  void destroy(ArrayList array) {
    //int index = array.indexOf(this);
    //if (index!=-1) {array.remove(index);}
    array.remove(this);
  }
  
  void collide_bounds() {
    
    PVector v=this.speed.copy();
    
    if (this.pos.x-this.r+(v.x*dt)<=-bounds.x || this.pos.x+this.r+(v.x*dt)>=bounds.x) {this.speed.x*=-1;}
    if (this.pos.y-this.r+(v.y*dt)<=-bounds.y || this.pos.y+this.r+(v.y*dt)>=bounds.y) {this.speed.y*=-1;}
    
     
  }
  
  
}
