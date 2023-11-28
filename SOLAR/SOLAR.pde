Sun sun;
Planet[] planets;

float r = 20;
float a = 150;
float b = 90;

int i = 0;

boolean skw = false, sks = false, ska = false, skd = false, kspace = false;
float px = 0, py = 0, pz = 0, deep = 1000;


void settings() {
  fullScreen(P3D);
}



void setup() {
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

  if (skw) py -= 10;
  if (sks) py += 5;
  if (ska) px -= 5;
  if (skd) px += 5;
  if (kspace) deep -= 3;
  
  camera(0, 0, deep, px, py, pz, 0, 1, 0);
  //rotateX(radians(45));
  
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
  if (keyCode == UP) skw = true;
  if (keyCode == DOWN) sks = true;
  if (keyCode == LEFT) ska = true;
  if (keyCode == RIGHT) skd = true;
  if (key == ' ') kspace = true;
}

void  keyReleased() {
  if (keyCode == UP) skw = false;
  if (keyCode == DOWN) sks = false;
  if (keyCode == LEFT) ska = false;
  if (keyCode == RIGHT) skd = false;
  if (key == ' ') kspace = false;
}











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
