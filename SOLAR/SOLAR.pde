Sun sun;
Planet[] planets;

float r = 20;
float a = 150;
float b = 90;

int i;
Cam cam = new Cam();
boolean kw = false, ks = false, ka = false, kd = false, kbackspace = false, kshift = false;
boolean kup = false, kdown = false, kright = false, kleft = false;
float px = 0, py = 0, pz = 0, deep = 1000;
float angg = 0;
float angv = 0;
float x = 0, y = 0;
float cx = 0, cy = 0, cz = 700;
float cr = 10;

float dt;

void setup() {
  
  size(1100, 800, P3D);
  sun = new Sun(50);
  planets = new Planet[5];

  i = 0;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), 20, 0.020);
  i = 1;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), -25, 0.020); //0.018
  i = 2;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), 20, 0.020);  //0.013
  i = 3;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), -25, 0.020); //0.017
  i = 4;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), 20, 0.020);  //0.015
  
  cam.pos.set(cx, cy, cz);
  
}



void draw() {

  background(0);
  //dt = 1 / frameRate;

  if (kw) {
    cam.pos.x -= 5.0 * cam.up.x;
    cam.pos.y -= 5.0 * cam.up.y;
    cam.pos.z -= 5.0 * cam.up.z;
  }
  if (ks) {
    cam.pos.x += 5.0 * cam.up.x;
    cam.pos.y += 5.0 * cam.up.y;
    cam.pos.z += 5.0 * cam.up.z;
  }
  if (ka) {
    cam.pos.x -= 5.0 * cam.hor.x;
    cam.pos.y -= 5.0 * cam.hor.y;
    cam.pos.z -= 5.0 * cam.hor.z;
  }
  if (kd) {
    cam.pos.x += 5.0 * cam.hor.x;
    cam.pos.y += 5.0 * cam.hor.y;
    cam.pos.z += 5.0 * cam.hor.z;
  }
  if (kbackspace) {
    cam.pos.x += 5.0 * cam.dir.x;
    cam.pos.y += 5.0 * cam.dir.y;
    cam.pos.z += 5.0 * cam.dir.z;
  }
  if (kshift) {
    cam.pos.x -= 5.0 * cam.dir.x;
    cam.pos.y -= 5.0 * cam.dir.y;
    cam.pos.z -= 5.0 * cam.dir.z;
  }
  
  x = 0;
  y = 0;
  if (kup) x -= 0.005;
  if (kdown) x += 0.005;
  if (kright) y -= 0.005;
  if (kleft) y += 0.005;
  
  cam.rotate(x, y);

  camera(cam.pos.x, cam.pos.y, cam.pos.z, cam.trg.x, cam.trg.y, cam.trg.z, cam.up.x, cam.up.y, cam.up.z);

  println(x, y);

  strokeWeight(7);
  stroke(255, 0, 0);
  line(0, 0, 0, 700, 0, 0); //red
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 700, 0); //green
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 700); //blue
  noStroke();
  strokeWeight(1);

  pushMatrix();
  rotateX(radians(45));
  sun.display();
  for (int i = 0; i < planets.length; i++) {
    planets[i].display();
    planets[i].orbit();
  }
  popMatrix();
}



void  keyPressed() {
  if (key == 'w') kw = true;
  if (key == 's') ks = true;
  if (key == 'a') ka = true;
  if (key == 'd') kd = true;
  if (key == ' ') kbackspace = true;
  if (keyCode == SHIFT) kshift = true;

  if (keyCode == UP) kup = true;
  if (keyCode == DOWN) kdown = true;
  if (keyCode == LEFT) kright = true;
  if (keyCode == RIGHT) kleft = true;
}



void  keyReleased() {
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
