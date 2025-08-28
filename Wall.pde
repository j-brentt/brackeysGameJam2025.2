

class Wall{
  PVector position;
  PVector size;
  float x;
  float y;
  float xlength;
  float ylength;
  int id;
  Wall(float x, float y, float xlength, float ylength, int id){
    this.position = new PVector(x,y);
    this.size = new PVector(xlength, ylength);
    this.x=x;
    this.y=y;
    this.xlength=xlength;
    this.ylength=ylength;
    this.id=id;
  }
  void display(){
    fill(100,100,100);
    rect(x,y,xlength,ylength); //replace with code for image
  }
  

}
