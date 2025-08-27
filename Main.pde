//I'm thinking we add walls to the Walls arraylist and then display them in draw()
ArrayList<Wall> Walls = new ArrayList<Wall>();


void setup(){
  size(1280, 720);
  background(255);
  
}

void draw(){
  for (Wall w : Walls){
    w.display();
  }
}
