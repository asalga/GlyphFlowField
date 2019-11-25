class Particle{
  PVector pos = new PVector();
  PVector vel = new PVector();
  
  Particle(){
    //pos = new PVector(random(0, width), random(0,height));
  }
  
  void update(float dt){
    //this.pos.x += 1;
    this.pos.x = 1.0;
  }
  
  void draw(){
    ellipse(this.pos.x, this.pos.y, 3, 3);  
  }
}