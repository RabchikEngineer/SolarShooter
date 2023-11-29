void spawn() {
  
  PVector pos = PVector.fromAngle(random(0,TWO_PI)).setMag(min(bounds.x,bounds.y));
  ships.add(new EnemyShip(pos.x,pos.y,50,20));
  

}
