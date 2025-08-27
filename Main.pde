//I'm thinking we add walls to the Walls arraylist and then display them in draw()
ArrayList<Wall> Walls = new ArrayList<Wall>();
Santa santa = new Santa();



void setup() {
  size(1280, 720);
  background(255);
}

void draw() {
  for (Wall w : Walls) {
    w.display();
  }



  //moving santa
  for (Wall w : Walls) {
    if (w.detect(santa.x+santa.xvelocity, santa.y+santa.yvelocity) == false) {
      santa.x += santa.xvelocity;
      santa.y += santa.yvelocity;
    }
  }
