void spawn() {
  
  if (ships.size()<3 && spawn_list.size()>0) {
    ships.add(spawn_list.get(0));
    spawn_list.remove(0);
  } else if (ships.get(0).side!=0) {
    ARCADE_MODE=false;
    win=false;
  } else if (ships.size()==1 && spawn_list.size()==0) {
    ARCADE_MODE=false;
    if (ships.get(0).side==0) {win=true;} else {win=false;}
  } 
  

}

void generate_enemy() {
  PVector pos = PVector.fromAngle(random(0,TWO_PI)).setMag(min(bounds.x,bounds.y));
  spawn_list.add(new EnemyShip(pos.x,pos.y,50,20,int(random(0,3))));
}

void generate_many(int num) {
  for (int i =0; i<=num; i++) {
    generate_enemy();
  }
}
