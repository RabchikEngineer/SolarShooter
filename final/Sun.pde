class Sun {
  PShape model0 = loadShape("sphere.obj");
  PImage texture0 = loadImage("texture0.png");
  float r;
  float angle = 0;

  Sun(float radius) {
    this.r = radius;
    model0.scale(radius);
    model0.setTexture(texture0);
  }

  void display() {
    stroke(255, 255, 0);
    noFill();
    pushMatrix();
    rotateX(radians(-45));
    rotateY(angle);
    shape(model0, 0, 0);
    popMatrix();
    angle += 0.001;
    noStroke();
  }
}
