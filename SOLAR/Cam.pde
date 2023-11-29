class Cam {

  PVector pos;
  PVector dir;
  PVector hor;
  PVector up;
  PVector trg;

  Cam() {
    this.pos = new PVector(0, 0, 0);

    this.dir = new PVector(0, 0, -1);
    this.hor = new PVector(1, 0, 0);
    this.up =  new PVector(0, 1, 0);

    this.trg = new PVector(0, 0, 0);

    this.trg.x = this.pos.x + this.dir.x;
    this.trg.y = this.pos.y + this.dir.y;
    this.trg.z = this.pos.z + this.dir.z;
  }

  //constructor

  void rotate(float dx, float dy) {

    //rotate horizont

    dir.x += hor.x * dx;
    dir.y += hor.y * dx;
    dir.z += hor.z * dx;
    dir.normalize();

    hor.x = dir.y * up.z - dir.z * up.y;
    hor.y = dir.z * up.x - dir.x * up.z;
    hor.z = dir.x * up.y - dir.y * up.x;
    hor.normalize();

    //rotate vertical

    dir.x += up.x * dy;
    dir.y += up.y * dy;
    dir.z += up.z * dy;
    dir.normalize();
    up.x = - dir.y * hor.z + dir.z * hor.y;
    up.y = - dir.z * hor.x + dir.x * hor.z;
    up.z = - dir.x * hor.y + dir.y * hor.x;
    up.normalize();

    //recalc target

    this.trg.x = this.pos.x + this.dir.x * 100.0;
    this.trg.y = this.pos.y + this.dir.y * 100.0;
    this.trg.z = this.pos.z + this.dir.z * 100.0;
  }
}
