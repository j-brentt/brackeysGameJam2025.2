

class Wall{
  float x;
  float y;
  float xlength;
  float ylength;
  int id;
  Wall(float x, float y, float xlength, float ylength, int id){
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
  boolean detect(float xpos, float ypos){
    if (x>xpos && x<xpos+xlength && y>ypos && y<ypos+ylength){
      return true;
    }
    else{
    return false;
    }
  }
}
