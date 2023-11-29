class PhysicalObject extends CollisionSphere {
  
  PVector force = new PVector(0,0);
  PVector momentum = new PVector(0,0);
  PVector constant_force = new PVector(0,0);
  float mass=0;
  float I;
  float moment=0;
  
  PhysicalObject(float x, float y, float r, float ang, int side, float mass) {
    super(x,y,r,ang,side);
    this.mass=mass;
    this.I=mass/2*pow(r,2);
  }
  
  void move() {
    force.add(constant_force);
    speed.add(PVector.mult(force,dt/mass).rotate(this.ang));
    this.ang_speed+=this.moment/this.I*dt;
    //println(force.toString());

    //println(speed instanceof FloatDict);
    momentum=PVector.mult(speed,mass);
    super.move();
    force = new PVector(0,0);
  }
  
  void set_forces(float fx, float fy) {
    force.x=fx;
    force.y=fy;
  }
  
  void apply_force(PVector force) {
    this.force.add(force);
  }
  
  void apply_force(float x, float y) {
    PVector force = new PVector(x,y).rotate(this.ang);
    this.force.add(force);
  }
  
  void set_constant_force(Force force) {
    this.constant_force.x=force.mag*cos(force.ang);
    this.constant_force.y=force.mag*sin(force.ang);
  }
  
  void set_constant_force(float x, float y) {
    this.constant_force.x=x;
    this.constant_force.y=y;
  }
  
  void set_velocity(float x, float y) {
    force.x=mass*dt*(x-speed.x);
    force.y=mass*dt*(y-speed.y);
    super.set_velocity(x,y);
  }
  
  void set_velocity(PVector val) {
    val.rotate(this.ang);
    force.x=mass*dt*(val.x-speed.x);
    force.y=mass*dt*(val.y-speed.y);
    super.set_velocity(val.x,val.y);
  }
  
  void add_momentum(PVector val) {
    momentum.add(val);
    speed.add(val.div(mass).rotate(this.ang));
  }
  
  void set_ang_speed(float val) {
    this.ang_speed=val;
  }
  
  
  //void set_momentum(PVector val) {
  //  momentum=val;
  //  speed=val.div(mass);
  //}
  
  //@Override 
  
  
  void add_moment(float val) {
    this.moment+=val;
  }
  
  void set_moment(float val) {
    this.moment=val;
  }
  
  
  void push_out(PhysicalObject obj) {
    
    //dist(this.x,this.y,obj.x,obj.y-dist(this.xm+obj.xm,this.ym+obj.ym,0,0)
    
    float x_force = ((this.r+obj.r)-(this.pos.x-obj.pos.x))*push_force_mult;
    float y_force = ((this.r+obj.r)-(this.pos.y-obj.pos.y))*push_force_mult;
    
    //PVector force = new PVector(this.r,obj.r).sub(PVector.sub(this.pos,obj.pos).mult(push_force_mult*10));
    
    //println(force.toString());
    PVector force = new PVector(x_force,y_force);
    this.apply_force(force.copy().mult(-1).rotate(this.ang));
    obj.apply_force(force.rotate(obj.ang));
    println("push");
  }
  
  
  void collide(PhysicalObject obj) {
    
    println("collide");
    
    PVector sum = PVector.add(this.momentum, obj.momentum);
    
    
    
    
    
    // петровский стрелков
    
    
    //float m1 = this.mass;
    //float m2 = obj.mass;
    //PVector v1 = this.speed;
    //PVector v2 = obj.speed;
    //PVector v1p = new PVector(0,0);
    //PVector v2p = new PVector(0,0);
    
    //v1p.x=((m1-m2)*v1.x+2*obj.momentum.x)/(m1+m2);
    //v1p.y=((m1-m2)*v1.y+2*obj.momentum.y)/(m1+m2);
    
    //v2p.x=((m2-m1)*v2.x+2*this.momentum.x)/(m1+m2);
    //v1p.y=((m2-m1)*v2.y+2*this.momentum.y)/(m1+m2);
    
    
    //this.set_momentum(v1p);
    //obj.set_momentum(v2p);
    
    
    //this.momentum.multiply(this.mass);
    //obj.momentum.multiply(obj.mass);
    //float cx = obj.momentum.x - this.momentum.x;
    //float cy = obj.momentum.y - this.momentum.y;
    
    //float cqr = pow(cx,2) + pow(cy,2);
    
    //float ball1CScalar = this.momentum.x * cx + this.momentum.y * cy;
    //float ball2CScalar = obj.momentum.x * cx + obj.momentum.y * cy;
    
    //// Разложение скорости шара № 1 на нормальную и тагенсальную.
    
    //float ball1Nvx = (cx * ball1CScalar) / cqr; 
    //float ball1Nvy = (cy * ball1CScalar) / cqr; 
    //float ball1Tvx = this.momentum.x - ball1Nvx; 
    //float ball1Tvy = this.momentum.y - ball1Nvy;
    
    //// Разложение скорости шара № 2 на нормальную и тагенсальную.
    
    //float ball2Nvx = (cx * ball2CScalar) / cqr; 
    //float ball2Nvy = (cy * ball2CScalar) / cqr; 
    //float ball2Tvx = obj.momentum.x - ball2Nvx; 
    //float ball2Tvy = obj.momentum.y - ball2Nvy;
    
    //// Реализация обмена нормальными скоростями (тагенсальные остаются неизменными).
    
    //this.set_momentum(new PVector(ball2Nvx + ball1Tvx,ball2Nvy + ball1Tvy).multiply_ret(1/this.mass));
    //obj.set_momentum(new PVector(ball1Nvx + ball2Tvx,ball1Nvy + ball2Tvy).multiply_ret(1/obj.mass));
    //this.momentum.multiply(this.mass);
    //obj.momentum.multiply(obj.mass);
    //ball1->SetVx(ball2Nvx + ball1Tvx); 
    //ball1->SetVy(ball2Nvy + ball1Tvy); 
    //ball2->SetVx(ball1Nvx + ball2Tvx); 
    //ball2->SetVy(ball1Nvy + ball2Tvy);
    
    
  }
  

}
