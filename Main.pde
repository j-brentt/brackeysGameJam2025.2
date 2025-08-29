//I'm thinking we add walls to the Walls arraylist and then display them in draw()
ArrayList<Wall> Walls = new ArrayList<Wall>();
ArrayList<Child> Childs = new ArrayList<Child>();
ArrayList<SightBullet> SightBullets = new ArrayList<SightBullet>();
PVector pointsize = new PVector(0, 0);
boolean keyUpPressed, keyDownPressed, keyLeftPressed, keyRightPressed, keyDashPressed, keyEPressed;
int dashedFrames = 0, dashInactive = 0;
Santa santa;
Wall wall;
Child child;
int detectNoCollision(PVector obj1, PVector obj2, PVector size1, PVector size2) {
  if (obj1.x+size1.x < obj2.x || obj1.x > obj2.x+size2.x || obj1.y+size1.y < obj2.y || obj1.y > obj2.y+size2.y) {
    return 1;
  } else {
    return 2;
  }
}

void setup() {
  //  PImage[] SantaWalkFront = new PImage[10];
  //  for (int i = 1; i < 11; i++) {
  //String imageName = "Frame" + nf(i, 5) + ".png";
  //SantaWalkFront[i] = loadImage(imageName);
  //}
  size(1280, 720);
  background(255);
  santa = new Santa(50, 50);
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
  for (Child c : Childs) {
    if (c.blind == false) {
      c.createSightBullets();
    }
    if (c.blind == true) {
      c.blindTime += 1;
      if (c.blindTime > 150) {
        c.blind = false;
        c.blindTime = 0;
      }
    }
    c.display();
  }
  for (SightBullet sb : SightBullets) {
    sb.hitscan();
    sb.display();
  }
  SightBullets.clear();
  if (santa.alive == false) {
    fill(255, 0, 0);
    rect(width-100, 0, 100, 100); //for testing
  }
  if (santa.alive == true) {
    fill(0, 255, 0);
    rect(width-100, 0, 100, 100); //for testing
  }
  santa.alive = true; // this is for testing
  santa.update();
  santa.display();
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
  if (santa.invisible == true){
    santa.invisibleTime += 1;
    if (santa.invisibleTime > santa.invisibleTimeMax){
      santa.invisible = false;
      santa.invisibleTime = 0;
      santa.cooldown3 = santa.ability3Cooldown;
    }
  }
  



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

void mouseClicked() {
  Childs.add(new Child(mouseX, mouseY, 25, 25, 100, 300));
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
  if (key == ' ' && santa.cooldown1 < 1) {
    keyDashPressed = true;
  }
  if (key == '1' && santa.cooldown2 < 1) {
    for (Child c : Childs) {
      if (((c.position.copy()).sub(santa.position.copy())).mag() < santa.EMP_radius) {
        c.blind = true;
        santa.cooldown2 = santa.ability2Cooldown;
      }
    }
  }
  if (key =='2' && santa.cooldown3 < 1){
    santa.invisible = true;
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
  if (key == ' ') {
    keyDashPressed = false;
  }
}
