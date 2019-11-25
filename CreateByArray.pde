class CreateByArray extends CreateClass {
  
  int idx;
  
  CreateByArray(){
    super();
    this.reset();
  }
  
  void reset(){
    this.idx = 0;
  }
   
  void createGrid(int _x, int _y){
    //int idx = _x + (_y * this.pg.width); 
    x[this.idx] = _x;
    y[this.idx] = _y;
    this.idx++;
  }
}