class Planet {
  PImage texture1 = loadImage("texture1.png");
  PImage texture2 = loadImage("texture2.png");
  PImage texture3 = loadImage("texture3.png");
  PImage texture4 = loadImage("texture4.png");
  PImage texture5 = loadImage("texture5.png");
  
  PShape model1 = loadShape("sphere.obj");
  PShape model2 = loadShape("sphere.obj");
  PShape model3 = loadShape("sphere.obj");
  PShape model4 = loadShape("sphere.obj");
  PShape model5 = loadShape("sphere.obj");
  
  float r;
  float a;
  float b;
  float angle = 0;
  float ao;
  float speed;
  float i;
  ArrayList<PVector> orbit = new ArrayList<PVector>();

  Planet(float radius, float a, float b, float ao, float speed, float i) {
    this.r = radius;
    this.a = a;
    this.b = b;
    this.ao = ao;
    this.speed = speed;
    this.i = i;
    if (i == 0) {
      model1.scale(radius);
      model1.setTexture(texture1);
    }
    if (i == 1) {
      model2.scale(radius);
      model2.setTexture(texture2);
    }
    if (i == 2) {
      model3.scale(radius);
      model3.setTexture(texture3);
    }
    if (i == 3) {
      model4.scale(radius);
      model4.setTexture(texture4);
    }
    if (i == 4) {
      model5.scale(radius);
      model5.setTexture(texture5);
    }
  }

  void display() {
    angle += speed + 1;
    float px = cos(angle) * a;
    float py = sin(angle) * b;

    orbit.add(new PVector(px, py));

    stroke(255);
    pushMatrix();
    rotateY(radians(ao));
    translate(px, py, 0);
    //rotateY(PI / 2);
    rotateX(PI / 2);
    rotateY(angle);
    if (i == 0) shape(model1, 0, 0);
    if (i == 1) shape(model2, 0, 0);
    if (i == 2) shape(model3, 0, 0);
    if (i == 3) shape(model4, 0, 0);
    if (i == 4) shape(model5, 0, 0);
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
