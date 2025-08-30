//I'm thinking we add walls to the Walls arraylist and then display them in draw()
import java.util.PriorityQueue;
import java.util.HashSet;
import java.io.File;

float storeX1, storeY1, storeX2, storeY2 = 0;


ArrayList<Wall> Walls = new ArrayList<Wall>();
ArrayList<Child> Childs = new ArrayList<Child>();
ArrayList<SightBullet> SightBullets = new ArrayList<SightBullet>();
PVector pointsize = new PVector(0, 0);
boolean keyUpPressed, keyDownPressed, keyLeftPressed, keyRightPressed, keyDashPressed, keyEPressed;
int dashedFrames = 0, dashInactive = 0;
Santa santa;
Wall wall;
NodeGraph nodeGraph;
Child child;

PImage[] SantaWalkFront = new PImage[9];
PImage[] SantaWalkSide = new PImage[10];
PImage[] SantaWalkBackside = new PImage[9];
PImage[] mapAssets;
String[] filenames;

int currentAssetIndex = 0;
float imageHeight, imageWidth;

boolean detectCollision(PVector obj1, PVector obj2, PVector size1, PVector size2) {
  if (obj1.x+size1.x < obj2.x || obj1.x > obj2.x+size2.x || obj1.y+size1.y < obj2.y || obj1.y > obj2.y+size2.y) {
    return false;
  }
  return true;
}

void setup() {
  frameRate(60);
  
  loadImages();
  size(1280, 720);
  background(255);
  santa = new Santa(50, 50);

  nodeGraph = new NodeGraph(-1);
  wall = new Wall(200, 200, 10, 100, 1);
  Walls.add(wall);
  textSize(48);
}

void draw() {
  background(255);
  for (Wall w : Walls) {
    w.display();
  }
  for (Child c : Childs) {
    if (c.blind == false) {
      c.createSightBullets();
    }
    if (c.blind == true) {
      c.blindTime += 1;
      if (c.blindTime > c.blindTimeMax) {
        c.blind = false;
        c.blindTime = 0;
      }
    }
    c.display();

    if (c.moveMode == 2 && nodeGraph.santaNode != c.goalNode) {
      c.pathfinding();
    }
  }
  for (SightBullet sb : SightBullets) {
    sb.hitscan();
    sb.display();
  }
  SightBullets.clear();
  //if (santa.notObserved == false) {
  //  fill(255, 0, 0);
  //  rect(width-100, 0, 100, 100); //for testing
  //}
  //if (santa.notObserved == true) {
  //  fill(0, 255, 0);
  //  rect(width-100, 0, 100, 100); //for testing
  //}
  santa.notObserved = true; // this is for testing
  santa.update();
  santa.display();
  nodeGraph.display();
  if (keyDashPressed == true) {
    dashedFrames+= 1;
    if (dashedFrames == 15) {
      santa.cooldown1 = santa.ability1Cooldown;
      keyDashPressed = false;
      dashedFrames = 0;
    }
  }

  santa.cooldown1 -= 1;
  santa.cooldown2 -= 1;
  santa.cooldown3 -= 1;

  if (santa.cooldown1 < 1) {
    fill(0, 255, 0);
    text("Dash:", 700, 700);
    fill(255);
    rect(825, 672, 200, 30);
    fill(0, 255, 0);
    rect(825, 672, (15-dashedFrames)*200/15, 30);
    if (dashedFrames != 0) {
      dashInactive += 1;
    }
  }
  if (dashInactive > santa.ability1Cooldown) {
    dashInactive = 0;
    dashedFrames = 0;
  }
  if (santa.cooldown1 >= 1) {
    fill(255, 0, 0);
    text("Dash:", 700, 700);
    fill(255);
    rect(825, 672, 200, 30);
    fill(255, 0, 0);
    rect(825, 672, (15-dashedFrames)*200/15, 30);
  }
  if (santa.invisible == true) {
    santa.invisibleTime += 1;
    if (santa.invisibleTime > santa.invisibleTimeMax) {
      santa.invisible = false;
      santa.invisibleTime = 0;
      santa.cooldown3 = santa.ability3Cooldown;
    }
  }




  //fill(0);
  //if (keyUpPressed) {
  //  fill(#08FF09);
  //} else {
  //  fill(0);
  //}
  //text("w", 50, 50);

  //if (keyLeftPressed) {
  //  fill(#08FF09);
  //} else {
  //  fill(0);
  //}
  //text("a", 25, 75);
  //if (keyDownPressed) {
  //  fill(#08FF09);
  //} else {
  //  fill(0);
  //}
  //text("s", 50, 75);
  //if (keyRightPressed) {
  //  fill(#08FF09);
  //} else {
  //  fill(0);
  //}
  //text("d", 75, 75);
  
  //IJKL to scale, OP to cycle
  image(mapAssets[currentAssetIndex], mouseX, mouseY, imageWidth, imageHeight);
  fill(0);
  text(currentAssetIndex, 25, 25);
  text(filenames[currentAssetIndex], 50, 50);
  
  fill(0);
  circle(storeX1, storeY1, 4);
  circle(storeX2, storeY2, 4);
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
  if (key == ' ' && santa.cooldown1 < 1) {
    keyDashPressed = true;
  }
  if (key == 'k' && santa.cooldown2 < 1) {
    for (Child c : Childs) {
      if (((c.position.copy()).sub(santa.position.copy().add(santa.size.copy().mult(0.5)))).mag() < santa.EMP_radius) {
        c.blind = true;
        santa.cooldown2 = santa.ability2Cooldown;
      }
    }
  }
  if (key =='o' && santa.cooldown3 < 1) {
    santa.invisible = true;
  }
  
  
  if (key == 'i') {
    imageHeight -= 10;
  }
  if (key == 'j') {
    imageWidth -= 10;
  }
  
  if (key == 'k') {
    imageHeight += 10;
  }
  
  if (key == 'l') {
    imageWidth += 10;
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

  //testing
  if (key == 'b') {
    //println("currentNode: " + child.currentNode.position);
    //println("goalNode: " + child.goalNode.position);
    //println("santaNode: " + nodeGraph.santaNode.position);

    //child.setTraversalPath(new int[]{0,1,2,1,3,0});
    //print(child.traversalPath.size());

    println(santa.position);
    println(santa.velocity);
  }
  if (key == 'v') resetState();

  if (key == ' ') {
    keyDashPressed = false;
  }
  if (key == 'i') {
    imageHeight += 5;
  }
  if (key == 'j') {
    imageWidth += 5;
  }
  
  if (key == 'k') {
    imageHeight -= 5;
  }
  
  if (key == 'l') {
    imageWidth -= 5;
  }
  
  
  if (key == 'o') {
    if (currentAssetIndex == 0) currentAssetIndex = mapAssets.length - 1;
    else currentAssetIndex -= 1;
    
    imageHeight = mapAssets[currentAssetIndex].height;
    imageWidth = mapAssets[currentAssetIndex].width;
  }
  if (key == 'p') {
    if (currentAssetIndex == mapAssets.length - 1) currentAssetIndex = 0;
    else currentAssetIndex += 1;
    imageHeight = mapAssets[currentAssetIndex].height;
    imageWidth = mapAssets[currentAssetIndex].width;
  }
}


void mousePressed() {
  //nodeGraph.newNode(mouseX, mouseY);
  //if (nodeGraph.nodes.size() == 1) {
  //  child = new Child(mouseX, mouseY, 25, 25, 100, 300, nodeGraph.nodes.get(0), 1);
  //  Childs.add(child);
  //}

  if (mouseButton == LEFT) {
    storeX1 = mouseX;
    storeY1 = mouseY;
  }
  if (mouseButton == RIGHT) {
    storeX2 = mouseX;
    storeY2 = mouseY;
  }
}
