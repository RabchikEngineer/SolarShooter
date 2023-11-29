//import java.util.Iterator;
import peasy.*;
//import java.lang.Math;

Bullet bullet1;
HashMap<String,ArrayList> data = new HashMap<String,ArrayList>();
JSONObject config;

ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Ship> ships = new ArrayList<Ship>();
ArrayList<EnemyShip> spawn_list = new ArrayList<EnemyShip>(); 

float dt=1/60,t=0;
float fric_force = 3000;
float moving_force = 10000;
float moving_force_mult = 1;
float push_force_mult=100;
float rotate_damper=10000;
float rotate_moment=2;
float rotation_speed_mult=5;
float ai_speed = 50;
float ai_shoot_distance = 500;
float marker_radius = 300;
float marker_ind=100;
PVector bounds=new PVector(1000,1000);
PVector shift = new PVector(0,0);

PShape modelPlayer;
PImage texturePlayer;
PImage background;

boolean w_pressed = false, s_pressed = false, a_pressed = false, d_pressed = false, q_pressed=false, e_pressed=false;
boolean control_pressed=false, shift_pressed=false, space_pressed=false;
boolean one_pressed=false, two_pressed=false;
boolean control_active = false;



boolean JOYSTICK_MODE = false;
boolean ARCADE_MODE = false;
boolean SOLAR_MODE = true;
boolean win=false;




Sun sun;
Planet[] planets;
Cam cam;

// Planets parameters

float r = 20;
float a = 150;
float b = 90;
int i;

// Camera parameters

boolean kw = false, ks = false, ka = false, kd = false, kbackspace = false, kshift = false;
boolean kup = false, kdown = false, kright = false, kleft = false;
float x=0, y=0;
float cx = 0, cy = 0, cz = 1700;
float step;
float angle;

// In future versions

// Background

PShape modelb;
PImage textureb;



void settings(){
  fullScreen(P3D);
  //size(736, 552, P3D); 
}
 
void setup() {
  //noStroke();
  rectMode(RADIUS);
  ellipseMode(RADIUS);
  
  textFont(createFont("arial.ttf",20));
  textSize(17);
  
  background = loadImage("sprites/background.jpeg");
  
  
  Table projs = loadTable("configs/projectiles.csv","header");
  data.put("bullets", new ArrayList<BulletConf>());
  for (int i = 0; i<projs.getRowCount();i++) {
    data.get("bullets").add(new BulletConf(
        loadImage("sprites/"+projs.getString(i,"filename")),
        projs.getFloat(i,"mass"),
        projs.getFloat(i,"damage"),
        projs.getFloat(i,"speed"),
        projs.getFloat(i,"alive"),
        projs.getFloat(i,"resize"),
        projs.getFloat(i,"rotate")));
  }
  Table shipt = loadTable("configs/ships.csv","header");
  data.put("ships", new ArrayList<ShipConf>());
  for (int i = 0; i<shipt.getRowCount();i++) {
    data.get("ships").add(new ShipConf(
        shipt.getString(i,"filename"),
        shipt.getFloat(i,"kd"),
        shipt.getInt(i,"proj_type"),
        shipt.getFloat(i,"rotate"),
        shipt.getFloat(i,"shift")));
  }
  
  
  
  config = loadJSONObject("configs/global.json");
  fric_force=config.getFloat("fric_force");
  moving_force=config.getFloat("moving_force");
  rotate_damper=config.getFloat("rotate_damper");
  rotate_moment=config.getFloat("rotate_moment");
  ai_speed=config.getFloat("ai_speed");
  ai_shoot_distance=config.getFloat("ai_shoot_distance");
  marker_radius=config.getFloat("marker_radius");
  marker_ind=config.getFloat("marker_ind");
  
  
  //print(config.get("bullets").toString());
  bullets.add(new Bullet(0,100,new PVector(100,0), PI, 0, 0));
  //for (int i=0; i<bullets.length;i++) {
  //  bullets[i]=new Bullet(100,100,1,false);
  //}
  
  //ships.add(new Ship(width/2,height/2,20,0,10,200,100));
  ships.add(new PlayerShip(width/2,height/2,40,10));
  //generate_enemy();
  generate_enemy();
  spawn();
  //ships.add(new EnemyShip(-200,200,30,10));
  //ships.add(new EnemyShip(300,-200,30,10));
  //ships.add(new EnemyShip(600,-400,30,10));
  
  //ships.get(1).speed.y=100;
  
  //cam = new PeasyCam(this, 200, 200, 100, 50);
  
  
  //modelPlayer = loadShape("models/ship1/ship1.obj");
  //texturePlayer = loadImage("models/ship1/ship1.png");
  
  //modelPlayer.setTexture(texturePlayer);
  
  
  
  sun = new Sun(50);
  planets = new Planet[5];
  cam = new Cam();

  modelb = loadShape("sphere.obj");
  textureb = loadImage("background.png");
  
  if (textureb == null) {
    println("Ошибка загрузки текстуры background.png");
  }
  
  modelb.scale(5000);
  modelb.setTexture(textureb);

  i = 0;
  planets[i] = new Planet(r * (1.1 + 1.3 * i * 0.2), a * (1 + i), b * (1 + i), 0.015, i);
  i = 1;
  planets[i] = new Planet(r * (1.1 + 1.3 * i * 0.2), a * (3 + i), b * (3 + i), 0.013, i); //0.018
  i = 2;
  planets[i] = new Planet(r * (1.1 + 1.3 * i * 0.2), a * (5 + i), b * (5 + i), 0.008, i); //0.013
  i = 3;
  planets[i] = new Planet(r * (1.1 + 1.3 * i * 0.2), a * (7 + i), b * (7 + i), 0.008, i); //0.017
  i = 4;
  planets[i] = new Planet(r * (1.1 + 1.3 * i * 0.2), a * (9 + i), b * (9 + i), 0.005, i); //0.015

  cam.pos.set(cx, cy, cz);
  
  
  
  
  frameRate(60);
}

int side = 5;


void draw() {
  
  dt=1/frameRate;
  background(0);
  
  println("start");
  
  if (ARCADE_MODE) {
  //dt=(millis()/1000.0)-t; //чёт не работает, хз
  
  //println(dt);
  
  camera(width/2,height/2,500,width/2,height/2,0,0,1,0);
  
  
  Ship ps=ships.get(0);
  
  //if (ps.side==1) {ARCADE_MODE=false; win=false;}
  
  
  
  
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
  
  pushMatrix();
  translate(-shift.x, -shift.y);
  text(str(spawn_list.size()),100,100);
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
  
  //if (space_pressed) {ps.proj_type=1;} else {ps.proj_type=0;}
  if (one_pressed) ps.proj_type=0;
  if (two_pressed) ps.proj_type=1;
  
  if (!JOYSTICK_MODE) {
  
    if (!(w_pressed ^ s_pressed)) {
      ps.constant_force.x=0;
    } else if (w_pressed) {ps.constant_force.x=moving_force*moving_force_mult;}
      else                {ps.constant_force.x=-moving_force;}
      
    if (!(a_pressed ^ d_pressed)) {
      ps.set_moment(0);
    } else if (a_pressed) {ps.set_moment(-rotate_moment);}
      else                {ps.set_moment(rotate_moment);}  
    
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
    generate_enemy();
    //spawn();
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
  
  
  spawn();
  

  
  t=millis()/1000.0;
  //println(frameRate);
  } else if (SOLAR_MODE) {
    //background(#00ff00);
    println("solar_mode");
    shape(modelb, 0, 0);

    dt = 1 / frameRate;
    step = 10.0;
  
    if (space_pressed) {
      cam.pos.x -= step * cam.ver.x;
      cam.pos.y -= step * cam.ver.y;
      cam.pos.z -= step * cam.ver.z;
    }
    if (shift_pressed) {
      cam.pos.x += step * cam.ver.x;
      cam.pos.y += step * cam.ver.y;
      cam.pos.z += step * cam.ver.z;
    }
    if (a_pressed) {
      cam.pos.x -= step * cam.hor.x;
      cam.pos.y -= step * cam.hor.y;
      cam.pos.z -= step * cam.hor.z;
    }
    if (d_pressed) {
      cam.pos.x += step * cam.hor.x;
      cam.pos.y += step * cam.hor.y;
      cam.pos.z += step * cam.hor.z;
    }
    if (w_pressed) {
      cam.pos.x += step * cam.dir.x;
      cam.pos.y += step * cam.dir.y;
      cam.pos.z += step * cam.dir.z;
    }
    if (s_pressed) {
      cam.pos.x -= step * cam.dir.x;
      cam.pos.y -= step * cam.dir.y;
      cam.pos.z -= step * cam.dir.z;
    }
  
    x = 0;
    y = 0;
    angle = 0.02;
    if (kup) y -= angle;
    if (kdown) y += angle;
    if (kright) x -= angle;
    if (kleft) x += angle;
    cam.rotate(x, y);
  
    //px = cx + cr * sin(x) * cos(y);
    //py = cy + cr * cos(x);
    //pz = cz + cr * sin(x) * sin(y);
  
    camera(cam.pos.x, cam.pos.y, cam.pos.z, cam.trg.x, cam.trg.y, cam.trg.z, cam.ver.x, cam.ver.y, cam.ver.z);
  
    //println(x, y);
  
    // Сoordinate axes
  
    //strokeWeight(7);
    //stroke(255, 0, 0);
    //line(0, 0, 0, 700, 0, 0); //red
    //stroke(0, 255, 0);
    //line(0, 0, 0, 0, 700, 0); //green
    //stroke(0, 0, 255);
    //line(0, 0, 0, 0, 0, 700); //blue
    //noStroke();
    //strokeWeight(1);
  
    pushMatrix();
    rotateX(radians(45));
    sun.display();
    for (int i = 0; i < planets.length; i++) {
      planets[i].display();
      planets[i].orbit();
      
      PVector planetPos = planets[i].orbit.get(planets[i].orbit.size() - 1);
      float distanceToPlanet = dist(cam.pos.x, cam.pos.y, cam.pos.z, planetPos.x, planetPos.y, planetPos.z);
      
      if (distanceToPlanet <= 200) {
        println("Камера находится на расстоянии " + distanceToPlanet + " от планеты " + i);
 
        ARCADE_MODE=true;
        SOLAR_MODE=false;
        generate_many(int(random(1,5)));
        
        //pushMatrix();
        //translate(width - textWidth("Нажми меняяяяя") - 20, height - 20);
        //textSize(128);
        //fill(0, 408, 612);
        //text("Нажми меняяяяя", 0, 0);
        //popMatrix();
      }
    }
    popMatrix();
    
    
    println("solar_mode_end");
    
  } else {
    //println(win);
    if (win) {victory();} else {defeat();}
    if (mousePressed) {
      SOLAR_MODE=true;
      ships.remove(0);
      ships.add(new PlayerShip(width/2,height/2,40,10));
      cam.pos.set(cx, cy, cz);
    }
  }
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
  if (char(keyCode) == '1') {
    one_pressed=true;
  }
  if (char(keyCode) == '2') {
    two_pressed=true;
  }
  
  
  if (key == 'w' || key == 'W' || key == 'ц' || key == 'Ц') kw = true;
  if (key == 's' || key == 'S' || key == 'ы' || key == 'Ы') ks = true;
  if (key == 'a' || key == 'A' || key == 'ф' || key == 'Ф') ka = true;
  if (key == 'd' || key == 'D' || key == 'в' || key == 'В') kd = true;
  if (key == ' ') kbackspace = true;
  if (keyCode == SHIFT) kshift = true;

  if (keyCode == UP) kup = true;
  if (keyCode == DOWN) kdown = true;
  if (keyCode == LEFT) kright = true;
  if (keyCode == RIGHT) kleft = true;
  
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
  if (char(keyCode) == '1') {
    one_pressed=false;
  }
  if (char(keyCode) == '2') {
    two_pressed=false;
  }
  
  if (key == 'w') kw = false;
  if (key == 's') ks = false;
  if (key == 'a') ka = false;
  if (key == 'd') kd = false;
  if (key == ' ') kbackspace = false;
  if (keyCode == SHIFT) kshift = false;

  if (keyCode == UP) kup = false;
  if (keyCode == DOWN) kdown = false;
  if (keyCode == LEFT) kright = false;
  if (keyCode == RIGHT) kleft = false;
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
  
