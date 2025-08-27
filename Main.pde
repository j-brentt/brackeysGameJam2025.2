//I'm thinking we add walls to the Walls arraylist and then display them in draw()
ArrayList<Wall> Walls = new ArrayList<Wall>();
Santa santa = new Santa();
boolean santainwall = false;
void setup(){
  size(1280, 720);
  background(255);
  
}

void draw(){
  for (Wall w : Walls){
    w.display();
    if (w.detect(santa.x, santa.y) == true){
    santainwall  = true;
  }
  }
  if (santainwall == true){
    santa.xvelocity = 0;
    santa.yvelocity = 0;
    santainwall = false;
  }
}
