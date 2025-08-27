//I'm thinking we add walls to the Walls arraylist and then display them in draw()
ArrayList<Wall> Walls = new ArrayList<Wall>();

boolean keyUpPressed, keyDownPressed, keyLeftPressed, keyRightPressed;
Santa santa;



void setup() {
  size(1280, 720);
  background(255);
  santa = new Santa(50, 50);
  
  textSize(48);
  
}

void draw(){
  background(255);
  for (Wall w : Walls){
    w.display();
  }
  
  santa.update();
  santa.display();
  
  
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

