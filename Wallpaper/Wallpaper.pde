Sun sun;
Planet[] planets;

float r = 20;
float a = 150;
float b = 90;
int i = 0;

void settings() {
  fullScreen(P3D);
}

void setup() {
  sun = new Sun(50);
  planets = new Planet[5];

  i = 0;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), 30, 0.020);
  i = 1;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), -25, 0.018);
  i = 2;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), 15, 0.013);
  i = 3;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), -20, 0.017);
  i = 4;
  planets[i] = new Planet(r * (1.1 + i * 0.2), a * (1 + i), b * (1 + i), 20, 0.015);
}

void draw() {
  background(0);
  pushMatrix();
  translate(width / 2, height / 2, 0);
  rotateX(radians(60));
  sun.display();
  for (int i = 0; i < planets.length; i++) {
    planets[i].display();
    planets[i].orbit();
  }
  popMatrix();
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
    rotateX(radians(-60));
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
