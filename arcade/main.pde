//import java.util.Iterator;
import peasy.*;
//import java.lang.Math;

Bullet bullet1;
HashMap<String,ArrayList> config = new HashMap<String,ArrayList>();
//Ship ship2 = new Ship(200,100,30,30,1);
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Ship> ships = new ArrayList<Ship>();
//Bullet[] bullets = new Bullet[100];
//int bullnum = 0;
//float demph = 1.5;
float dt=1/60,t=0;
float fric_force = 3000;
float moving_force = 10000;
float moving_force_mult = 1;
float push_force_mult=100;
float rotate_damper=10000;
float rotation_speed_mult=5;
float ai_speed = 50;
float ai_shoot_distance = 500;
float marker_radius=250;
PVector bounds=new PVector(3000,3000);
PVector shift = new PVector(0,0);

PShape modelPlayer;
PImage texturePlayer;
PImage background;

PeasyCam cam;

boolean w_pressed = false, s_pressed = false, a_pressed = false, d_pressed = false, q_pressed=false, e_pressed=false;
boolean control_pressed=false, shift_pressed=false, space_pressed=false;
boolean control_active = false;



boolean JOYSTICK_MODE = false;

void settings(){
  //fullScreen(P3D);
  size(736, 552, P3D); 
}
 
void setup() {
  //noStroke();
  rectMode(RADIUS);
  ellipseMode(RADIUS);
  
  textFont(createFont("arial.ttf",20));
  textSize(17);
  
  background = loadImage("sprites/background.jpeg");
  
  
  Table projs = loadTable("configs/projectiles.csv","header");
  config.put("bullets", new ArrayList<BulletConf>());
  for (int i = 0; i<projs.getRowCount();i++) {
    config.get("bullets").add(new BulletConf(projs.getFloat(i,"speed"),projs.getFloat(i,"damage"),loadImage("sprites/"+projs.getString(i,"filename"))));
  }
  
  print(config.get("bullets").toString());
  bullets.add(new Bullet(0,100,new PVector(100,0), PI, 0, 0));
  //for (int i=0; i<bullets.length;i++) {
  //  bullets[i]=new Bullet(100,100,1,false);
  //}
  
  //ships.add(new Ship(width/2,height/2,20,0,10,200,100));
  ships.add(new PlayerShip(width/2,height/2,40,10));
  spawn();
  spawn();
  //ships.add(new EnemyShip(-200,200,30,10));
  //ships.add(new EnemyShip(300,-200,30,10));
  //ships.add(new EnemyShip(600,-400,30,10));
  
  ships.get(1).speed.y=100;
  
  //cam = new PeasyCam(this, 200, 200, 100, 50);
  
  
  modelPlayer = loadShape("models/ship1/ship1.obj");
  texturePlayer = loadImage("models/ship1/ship1.png");
  
  modelPlayer.setTexture(texturePlayer);
  
  
  frameRate(600);
}

int side = 5;


void draw() {
  //dt=(millis()/1000.0)-t; //чёт не работает, хз
  dt=1/frameRate;
  //println(dt);
  background(0);
  
  
  Ship ps=ships.get(0);
  
  shift = new PVector(lerp(shift.x,width/2-ps.pos.x,dt*3),lerp(shift.y,height/2-ps.pos.y,dt*3));
  translate(shift.x, shift.y);
  
  for (float ix=-bounds.x; ix<=bounds.x; ix+=background.width) {
    for (float iy=-bounds.y; iy<=bounds.y; iy+=background.height) {
      
      image(background,ix,iy);
      
    }
  }
  
  pushMatrix();
  //fill(#ff0000);
  stroke(#ff0000);
  strokeWeight(10);
  line(-bounds.x,bounds.y,bounds.x,bounds.y);
  line(-bounds.x,bounds.y,-bounds.x,-bounds.y);
  line(bounds.x,bounds.y,bounds.x,-bounds.y);
  line(-bounds.x,-bounds.y,bounds.x,-bounds.y);
  strokeWeight(1);
  popMatrix();
  
  
  
  
  //for (int i = 0; i<=side; i++) {
  //  for (int k = 0; k<=side; k++) {
  //    pushMatrix();
  //    scale(10);
  //    shape(modelPlayer,i*10,k*10);
  //    popMatrix();
  //  }
  //}

  //println(pow_with_sign(mouseX-ship1.x,demph));
  //ships.get(0).set_velocity(pow_with_sign(mouseX-ships.get(0).x,demph),pow_with_sign(mouseY-ships.get(0).y,demph));
  //ships.get(0).move(mouseX,mouseY);
  
  if (shift_pressed) {moving_force_mult=2;} else {moving_force_mult=1;}
  
  if (space_pressed) {ps.proj_type=1;} else {ps.proj_type=0;}
  
  if (!JOYSTICK_MODE) {
  
    if (!(w_pressed ^ s_pressed)) {
      ps.constant_force.x=0;
    } else if (w_pressed) {ps.constant_force.x=moving_force*moving_force_mult;}
      else                {ps.constant_force.x=-moving_force;}
      
    if (!(a_pressed ^ d_pressed)) {
      ps.set_moment(0);
    } else if (a_pressed) {ps.add_moment(-2);}
      else                {ps.add_moment(2);}  
    
    if (!(q_pressed ^ e_pressed)) {
      ps.constant_force.y=0;
    } else if (q_pressed) {ps.constant_force.y=-moving_force;}
      else                {ps.constant_force.y=moving_force;}
  
  } else {
    
    if (!(w_pressed ^ s_pressed)) {
      ps.constant_force.x=0;
    } else if (w_pressed) {ps.constant_force.x=moving_force;}
      else                {ps.constant_force.x=-moving_force;}
      
    if (!(a_pressed ^ d_pressed)) {
      //ps.set_moment(0);
    } else if (a_pressed) {ps.req_ang-=0.01;}
      else                {ps.req_ang+=0.01;}  
    
    control_active=space_pressed;
    if (!control_active) {ps.set_moment(0);}
    //println(ps.ang);
    //ps.req_ang=mouseX/10.0;
    
  } 
  
  if (mousePressed && mouseButton==LEFT) {
    ships.get(0).shoot();
  }
  
  if (mousePressed && mouseButton==RIGHT) {
    //ships.add(new EnemyShip(mouseX,mouseY-100,30,10));
    //ps.add_moment(1000);
    //ships.get(0).add_momentum(new PVector(500,0));
    //ships.get(0).set_velocity(new PVector(10,0));
    spawn();
  }
  
  
  for (int k = 0; k<ships.size();k++) {
    Ship s = ships.get(k);
    
    if (abs(s.speed.x)>=1 || abs(s.speed.y)>=1) {
      s.apply_force(s.speed.copy().setMag(-fric_force).rotate(-s.ang));
      //s.apply_force(new PVector(2000,0));
    } else {s.speed.x=0; s.speed.y=0;}
    
    if (!JOYSTICK_MODE || !control_active) {
      if (abs(s.ang_speed)>=0 && s.moment==0) {
        s.add_moment(-s.ang_speed*rotate_damper);
        //println(-s.ang_speed*dt*rotate_damper);      
      } 
    }
    
    if (s.side==1) {
      s.target(ps);
    }
    
    s.collide_bounds();
    
    
    for (Ship s1: ships) {
      if (s!=s1) {
        if (s.will_intersect(s1)) {
          if (s.intersects(s1)) {
            s.push_out(s1);
          } else {
            s.collide(s1);
          }
        }
      }
    }
    
    s.move();
    s.display();
    
  }
  
  ////Ship s11 = ships.get(0);
  ////Ship s12 = ships.get(1);
  ////if (s11.will_intersect(s12)) {
  ////  if (s11.intersects(s12)) {
  ////    s11.push_out(s12);
  ////  } else {
  ////    s11.collide(s12);
  ////  }
  ////}
  
  ////for (int i = 0; i<ships.size();i++) {
  ////  ships.get(i).shoot();
  ////}
  
  for (int i = 0; i<bullets.size();i++) {
    Bullet b = bullets.get(i);
    b.collide_bounds();

    
    for (int k = 0; k<ships.size();k++) {
      Ship s = ships.get(k);
      
      //if (s.x>width-50) {ships.remove(s);}
      
      if (b.will_intersect(s) && (b.side!=s.side)) {
        
        //b.collide(s);
        s.collide(b);
        s.take_hit(b);
        b.destroy();
        
        
        
        //ships.remove(k); 
        //s.shoot(); 
        //println(s.kd);
      }
      
      //s.shoot();
      //ships.get(0).shoot();
    }
    
    //if (b.pos.y<40) {bullets.remove(i);}
    
    b.move();
    b.display();
  }
  
  
  
  

  
  t=millis()/1000.0;
  //println(frameRate);
}



void keyPressed() {
  
  if (char(keyCode) == 'W') {
    w_pressed=true;
  }
  if (char(keyCode) == 'S') {
    s_pressed=true;
  }
  if (char(keyCode) == 'A') {
    a_pressed=true;
  }
  if (char(keyCode) == 'D') {
    d_pressed=true;
  }
  if (char(keyCode) == 'Q') {
    q_pressed=true;
  }
  if (char(keyCode) == 'E') {
    e_pressed=true;
  } 
  if (char(keyCode) == ' ') {
    space_pressed=true;
  }
  if (keyCode == SHIFT) {
    shift_pressed=true;
  }
  if (keyCode == CONTROL) {
    control_pressed=true;
  }
}

void keyReleased() {
  //println(char(keyCode));
  if (char(keyCode) == 'W') {
    w_pressed=false;
  }
  if (char(keyCode) == 'S') {
    s_pressed=false;
  }
  if (char(keyCode) == 'A') {
    a_pressed=false;
  }
  if (char(keyCode) == 'D') {
    d_pressed=false;
  }
  if (char(keyCode) == 'Q') {
    q_pressed=false;
  }
  if (char(keyCode) == 'E') {
    e_pressed=false;
  }
  if (char(keyCode) == ' ') {
    space_pressed=false;
  }
  if (keyCode == SHIFT) {
    shift_pressed=false;
  }
  if (keyCode == CONTROL) {
    control_pressed=false;
  }
}



//отображение направления трения
      //if (s.side==0) {
      //  //println(s.force.x);
      //  float angle=atan2(s.speed.y,s.speed.x);
      //  //println(angle);
      //  pushMatrix();
      //  translate(mouseX,mouseY);
      //  rotate(angle);
      //  //println(angle);
      //  stroke(255);
      //  line(0,0,150,0);
      //  popMatrix();
      //} 
      
      
  //for (Iterator<Bullet> it_b = bullets.iterator(); it_b.hasNext();) {
  //  Bullet b = it_b.next();
  //  b.update();
  //  b.display();
    
  //  for (Iterator<Ship> it_s = ships.iterator(); it_s.hasNext();) {
  //    Ship s = it_s.next();
      
  //    if (b.intersects(s) && (b.side!=s.side)) {it_b.remove();}
      
  //    //s.shoot();
  //    //ships.get(0).shoot();
  //  }
    
  //  if (b.y<40) {it_b.remove();}
  //}
  
  
  //pushMatrix();
  //    translate(s.pos.x,s.pos.y);
  //    pushMatrix();
  //    rotate(atan2(s.speed.y,s.speed.x));
  //    line(0,0,100,0);
  //    popMatrix();
  //    pushMatrix();
  //    rotate(s.ang);
  //    line(0,0,50,0);
  //    popMatrix();
  //    popMatrix();
  
