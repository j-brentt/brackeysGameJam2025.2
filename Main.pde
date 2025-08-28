//I'm thinking we add walls to the Walls arraylist and then display them in draw()
ArrayList<Wall> Walls = new ArrayList<Wall>();
ArrayList<Cookie> cookies;
ArrayList<Stocking> stockings;

boolean keyUpPressed, keyDownPressed, keyLeftPressed, keyRightPressed;
Santa santa;
Wall wall;

// ---- interaction hold variables ----
boolean interacting = false;        
int interactStartTime = 0;        
int interactHoldRequired = 3000;   // milliseconds required to hold (3000 ms = 3 s)
Items currentTarget = null;        
boolean eDown = false; // track 'E' key state seperately



int detectNoCollision(PVector obj1, PVector obj2, PVector size1, PVector size2){
  if (obj1.x+size1.x < obj2.x || obj1.x > obj2.x+size2.x || obj1.y+size1.y < obj2.y || obj1.y > obj2.y+size2.y){
    return 1;
  }
  else{
    return 2;}

}

void setup() {
  size(1280, 720);
  background(255);
  santa = new Santa(50, 50);
  wall = new Wall(200,200,10,100, 1);
  Walls.add(wall);
  cookies = new ArrayList<Cookie>();
  stockings = new ArrayList<Stocking>();
  textSize(48);
  
  
  // TEST OBJECTS
  //cookies.add(new Cookie(400, 150));
  //cookies.add(new Cookie(600, 300));
  //cookies.add(new Cookie(750, 500));
  //stockings.add(new Stocking(550, 150));
  //stockings.add(new Stocking(800, 400));
  
}

void draw(){
  background(255);
  for (Wall w : Walls){
    w.display();
  }
    
  for (Cookie c : cookies) {
    c.display();
  }
  for (Stocking s : stockings) {
    s.display();
  }

  
  
  santa.update();
  santa.display();
  
  
  fill(0);
  textSize(16);
  text("Cookies eaten: " + santa.cookieCount, 550, 20);        // Can be changed later, sample texts
  text("Stockings filled: " + santa.stockingsFilled, 550, 40);
  
  Items nearby = getNearbyItem();
  boolean nearItem = (nearby != null);
   if (nearItem && !interacting) 
   {
    text("Hold E for 3s to interact", 10, height - 20);
   } 

  // Interaction handling (for holding)
  if (interacting) 
  {
    if (currentTarget == null || currentTarget.collected) {
      interacting = false;
      currentTarget = null;
    } else {
      // If Santa is no longer overlapping the target, cancel the hold
      if (!currentTarget.overlapsWithSanta(santa)) {
        interacting = false;
        currentTarget = null;
        //text("Moved away — interaction cancelled", 10, height - 40);
      } else {
        // still holding and still in range: compute progress and show bar
        int elapsed = millis() - interactStartTime;
        float pct = constrain((float)elapsed / (float)interactHoldRequired, 0, 1);

        // Small progress bar
        float barW = 200;
        float barH = 16;
        float bx = 10;
        float by = height - 60;
        noFill();
        stroke(0);
        rect(bx, by, barW, barH);
        noStroke();
        fill(215, 30, 30); // dark red fill
        rect(bx, by, barW * pct, barH);

        fill(0);
        textSize(12);
        text(int(pct * 100) + "%", bx + barW + 8, by + barH - 2);

        if (elapsed >= interactHoldRequired) {
          if (!currentTarget.collected && currentTarget.overlapsWithSanta(santa)) {
            currentTarget.onInteract(santa); // this will mark collected and update santa counters
          }
          // reset hold state
          interacting = false;
          currentTarget = null;
        }
      }
    }
  }


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
  
  if ((key == 'e' || key == 'E') && !interacting) {
    Items target = getNearbyItem();
    if (target != null && !target.collected) {
      interacting = true;
      interactStartTime = millis(); // set once at start
      currentTarget = target;
      eDown = true;
    }
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
  
  // Interaction key: CANCEL HOLD
  if (key == 'e' || key == 'E') {
    interacting = false;
    currentTarget = null;
    eDown = false;
  }
}


// Return first overlapping Cookie (not collected), else first overlapping Stocking (not collected), else null
Items getNearbyItem() {
  for (Cookie c : cookies) {
    if (!c.collected && c.overlapsWithSanta(santa)) {
      return (Items)c;
    }
  }
  for (Stocking s : stockings) {
    if (!s.collected && s.overlapsWithSanta(santa)) {
      return (Items)s;
    }
  }
  return null;
}
