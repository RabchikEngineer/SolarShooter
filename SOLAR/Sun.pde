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
