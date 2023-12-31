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
float cx = 0, cy = 0, cz = 1600;
float step;
float angle;

// In future versions

float dt;

// Background

PShape modelb;
PImage textureb;

void settings() {
  fullScreen(P3D);
}

void setup() {
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
}



void draw() {

  background(0);
  
  shape(modelb, 0, 0);

  dt = 1 / frameRate;
  step = 10.0;

  if (kbackspace) {
    cam.pos.x -= step * cam.ver.x;
    cam.pos.y -= step * cam.ver.y;
    cam.pos.z -= step * cam.ver.z;
  }
  if (kshift) {
    cam.pos.x += step * cam.ver.x;
    cam.pos.y += step * cam.ver.y;
    cam.pos.z += step * cam.ver.z;
  }
  if (ka) {
    cam.pos.x -= step * cam.hor.x;
    cam.pos.y -= step * cam.hor.y;
    cam.pos.z -= step * cam.hor.z;
  }
  if (kd) {
    cam.pos.x += step * cam.hor.x;
    cam.pos.y += step * cam.hor.y;
    cam.pos.z += step * cam.hor.z;
  }
  if (kw) {
    cam.pos.x += step * cam.dir.x;
    cam.pos.y += step * cam.dir.y;
    cam.pos.z += step * cam.dir.z;
  }
  if (ks) {
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
      //pushMatrix();
      //translate(width - textWidth("Нажми меняяяяя") - 20, height - 20);
      //textSize(128);
      //fill(0, 408, 612);
      //text("Нажми меняяяяя", 0, 0);
      //popMatrix();
    }
  }
  popMatrix();
}



void  keyPressed() {
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
