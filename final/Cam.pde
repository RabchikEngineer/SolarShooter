class Cam {

  PVector pos;
  PVector dir;
  PVector hor;
  PVector ver;
  PVector trg;

  Cam() {
    this.pos = new PVector(0, 0, 0);

    this.dir = new PVector(0, 0, -1);
    this.hor = new PVector(1, 0, 0);
    this.ver =  new PVector(0, 1, 0);

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

    hor.x = dir.y * ver.z - dir.z * ver.y;
    hor.y = dir.z * ver.x - dir.x * ver.z;
    hor.z = dir.x * ver.y - dir.y * ver.x;
    hor.normalize();

    //rotate vertical

    dir.x += ver.x * dy;
    dir.y += ver.y * dy;
    dir.z += ver.z * dy;
    dir.normalize();
    ver.x = - dir.y * hor.z + dir.z * hor.y;
    ver.y = - dir.z * hor.x + dir.x * hor.z;
    ver.z = - dir.x * hor.y + dir.y * hor.x;
    ver.normalize();

    //recalc target

    this.trg.x = this.pos.x + this.dir.x * 100.0;
    this.trg.y = this.pos.y + this.dir.y * 100.0;
    this.trg.z = this.pos.z + this.dir.z * 100.0;
  }
}
