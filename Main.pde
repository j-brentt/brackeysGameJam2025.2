//I'm thinking we add walls to the Walls arraylist and then display them in draw()
ArrayList<Wall> Walls = new ArrayList<Wall>();
ArrayList<Child> Childs = new ArrayList<Child>();
ArrayList<SightBullet> SightBullets = new ArrayList<SightBullet>();
PVector pointsize = new PVector(0,0);
boolean keyUpPressed, keyDownPressed, keyLeftPressed, keyRightPressed;
Santa santa;
Wall wall;
NodeGraph nodeGraph;
Child child;

int detectNoCollision(PVector obj1, PVector obj2, PVector size1, PVector size2){
  if (obj1.x+size1.x < obj2.x || obj1.x > obj2.x+size2.x || obj1.y+size1.y < obj2.y || obj1.y > obj2.y+size2.y){
    return 1;
  } else {
    return 2;
  }
}

void setup() {
  size(1280, 720);
  background(255);
  santa = new Santa(50, 50);
  nodeGraph = new NodeGraph(-1);
  wall = new Wall(200, 200, 10, 100, 1);
  child = new Child(300, 250, 25, 25, 100, 300);
  Childs.add(child);
  Walls.add(wall);
  textSize(48);
}

void draw() {
  background(255);
  for (Wall w : Walls) {
    w.display();
  }
  for (Child c : Childs){
    c.createSightBullets();
    c.display();
  }
  for (SightBullet sb : SightBullets){
    sb.hitscan();
    sb.display();
  }
  SightBullets.clear();
  if (santa.alive == false){
    fill(255,0,0);
    rect(width-100, 0, 100, 100); //for testing
  }
  if (santa.alive == true){
    fill(0,255,0);
    rect(width-100, 0, 100, 100); //for testing
  }
  santa.alive = true; // this is for testing
  santa.update();
  santa.display();
  nodeGraph.display();

  fill(0);
  if (keyUpPressed) {
    fill(#08FF09);
  } else {
    fill(0);
  }
  text("w", 50, 50);

  if (keyLeftPressed) {
    fill(#08FF09);
  } else {
    fill(0);
  }
  text("a", 25, 75);
  if (keyDownPressed) {
    fill(#08FF09);
  } else {
    fill(0);
  }
  text("s", 50, 75);
  if (keyRightPressed) {
    fill(#08FF09);
  } else {
    fill(0);
  }
  text("d", 75, 75);
  fill(255);
}

void keyPressed() {
  if (key == 'w' || keyCode == UP) {
    keyUpPressed = true;
    keyDownPressed = false;
  }
  if (key == 'a' || keyCode == LEFT) {
    keyLeftPressed = true;
    keyRightPressed = false;
  }

  if (key == 's' || keyCode == DOWN) {
    keyDownPressed = true;
    keyUpPressed = false;
  }

  if (key == 'd' || keyCode == RIGHT) {
    keyRightPressed = true;
    keyLeftPressed = false;
  }
  
  //Adding Edges testing
  if (keyCode >= 48 && keyCode < 57) {
    nodeGraph.newEdge(nodeGraph.nodes.get(nodeGraph.nodes.size()-1), nodeGraph.nodes.get(keyCode - 48));
  }
}

void keyReleased() {
  if (key == 'w' || keyCode == UP) {
    keyUpPressed = false;
  }
  if (key == 'a' || keyCode == LEFT) {
    keyLeftPressed = false;
  }

  if (key == 's' || keyCode == DOWN) {
    keyDownPressed = false;
  }

  if (key == 'd' || keyCode == RIGHT) {
    keyRightPressed = false;
  }
}


void mousePressed() {
  nodeGraph.newNode(mouseX, mouseY);
}
