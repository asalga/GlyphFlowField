abstract class CreateClass{
  color mask;
  PGraphics pg;
  
  CreateClass(){}
  
  void setImage(PGraphics p){
    this.pg = p;
  }
  
  void reset(){}
  
  void createGrid(int x, int y){}
  
  void setMask(color m){
    this.mask = m;
  }
}