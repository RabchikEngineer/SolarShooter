Sun sun;
Planet[] planets;

float r = 20;
float a = 150;
float b = 90;

int i;

boolean kw = false, ks = false, ka = false, kd = false, kbackspace = false, kshift = false;
boolean kup = false, kdown = false, kright = false, kleft = false;
float px = 0, py = 0, pz = 0, deep = 1000;
float angg = 0;
float angv = 0;
float x = - PI / 2, y = PI / 2;
float cx = 0, cy = 0, cz = 700;
float cr = 10;

float dt;

//void settings() {
//  fullScreen(P3D);
//}



void setup() {
  size(1100, 800, P3D);
  sun = new Sun(50);
  planets = new Planet[5];

  i = 0;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), 20, 0.020);
  i = 1;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), -25, 0.020); //0.018
  i = 2;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), 20, 0.020); //0.013
  i = 3;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), -25, 0.020); //0.017
  i = 4;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), 20, 0.020); //0.015
}



void draw() {
  
  background(0);
  dt = 1 / frameRate;
  
  if (kw) cy -= 5;
  if (ks) cy += 5;
  if (ka) cx -= 5;
  if (kd) cx += 5;
  if (kbackspace) cz -= 5;
  if (kshift) cz += 5;
  
  if (kup) x -= 0.05;
  if (kdown) x += 0.05;
  if (kright) y -= 0.05;
  if (kleft) y += 0.05;
  
  angv = map(x, -1000, 1000, TWO_PI, -TWO_PI);
  angg = map(y, -1000, 1000, TWO_PI, -TWO_PI);
   
  px = cx + cr * sin(x) * cos(y);
  py = cy + cr * cos(x);
  pz = cz + cr * sin(x) * sin(y);
  
  camera(cx, cy, cz, px, py, pz, 0, 1, 0);
  
  println(x, y);
  
  //rotateX(radians(45));
  //println(deep);
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

//void  keyPressed() {
//  if (keyCode == UP) kw = true;
//  if (keyCode == DOWN) ks = true;
//  if (keyCode == LEFT) ka = true;
//  if (keyCode == RIGHT) kd = true;
//  if (key == ' ') kbackspace = true;
//  if (keyCode == SHIFT) kshift = true;
//}

//void  keyReleased() {
//  if (keyCode == UP) kw = false;
//  if (keyCode == DOWN) ks = false;
//  if (keyCode == LEFT) ka = false;
//  if (keyCode == RIGHT) kd = false;
//  if (key == ' ') kbackspace = false;
//  if (keyCode == SHIFT) kshift = false;
//}











class Sun {
  float r;
  float angle = 0;

  Sun(float radius) {
    this.r = radius;
  }

  void display() {
    stroke(255, 255, 0);
    noFill();
    pushMatrix();
    rotateX(radians(-45));
    rotateY(angle);
    sphere(r);
    popMatrix();
    angle += 0.001;
    noStroke();
  }
}

















class Planet {
  float r;
  float a;
  float b;
  float angle = 0;
  float ao;
  float speed;
  ArrayList<PVector> orbit = new ArrayList<PVector>();

  Planet(float radius, float a, float b, float ao, float speed) {
    this.r = radius;
    this.a = a;
    this.b = b;
    this.ao = ao;
    this.speed = speed;
  }

  void display() {
    angle += speed;
    float px = cos(angle) * a;
    float py = sin(angle) * b;

    orbit.add(new PVector(px, py));

    stroke(255);
    pushMatrix();
    rotateY(radians(ao));
    translate(px, py, 0);
    rotateX(PI / 2);
    rotateY(angle);
    sphere(r);
    popMatrix();
    noStroke();
  }

  void orbit() {
    stroke(255, 50);
    pushMatrix();
    beginShape();
    rotateY(radians(ao));

    for (int i = 0; i < orbit.size(); i++) {
      PVector point = orbit.get(i);
      float alpha = map(i, 0, orbit.size(), 0, 255);
      stroke(255, alpha);
      vertex(point.x, point.y, 0);
    }
    endShape();
    popMatrix();
    noStroke();

    // Уменьшение размера орбиты
    if (orbit.size() > 180) {
      orbit.remove(0);
    }
  }
}
