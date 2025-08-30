//I'm thinking we add walls to the Walls arraylist and then display them in draw()
ArrayList<Wall> Walls = new ArrayList<Wall>();
ArrayList<Cookie> cookies;
ArrayList<Stocking> stockings;
ArrayList<Chimney> chimneys;  

boolean keyUpPressed, keyDownPressed, keyLeftPressed, keyRightPressed;
Santa santa;
Wall wall;

// ---- interaction hold variables ----
boolean interacting = false;        
int interactStartTime = 0;        
int interactHoldRequired = 3000;   // milliseconds required to hold (3000 ms = 3 s)
Items currentTarget = null;        
boolean eDown = false; // track 'E' key state seperately

// simple level state
boolean levelOver = false;
String message = "";
int messageUntil = 0; // millis until which to show the transient message


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
  chimneys = new ArrayList<Chimney>();
    
  
  // TEST OBJECTS
  cookies.add(new Cookie(400, 150));
  cookies.add(new Cookie(600, 300));
  cookies.add(new Cookie(750, 500));
  stockings.add(new Stocking(550, 150));
  stockings.add(new Stocking(800, 400));
  
  // example chimney that needs 2 stockings filled to finish
  chimneys.add(new Chimney(1000, 200, 2));
  
  textSize(48);
  
}

void draw(){
  background(255);
  for (Wall w : Walls){
    w.display();
  }
    
  for (Cookie c : cookies) c.display();
  for (Stocking s : stockings) s.display();
  for (Chimney ch : chimneys) ch.display();


  // If level is over, show message and stop normal updates
  if (levelOver) {
    fill(0);
    textSize(36);
    textAlign(CENTER, CENTER);
    text("Level Complete!", width/2, height/2 - 20);
    textSize(18);
    text("Press R to restart (or implement next level transition)", width/2, height/2 + 20);
    return;
  }
  
  
  santa.update();
  santa.display();
  
  
  fill(0);
  textSize(16);
  text("Cookies eaten: " + santa.cookieCount, 550, 20);        // Can be changed later, sample texts
  text("Stockings filled: " + santa.stockingsFilled, 550, 40);
  
  Items nearby = getNearbyItem();
  boolean nearItem = (nearby != null);
   if (nearItem && !interacting) {
    // If the nearby is a chimney and stockings are insufficient, show requirement message
    if (nearby instanceof Chimney) {
      Chimney ch = (Chimney)nearby;
      if (santa.stockingsFilled < ch.stockingsRequired) {
        text("Fill " + ch.stockingsRequired + " stockings to finish", 10, height - 20);
      } else {
        text("Hold E for " + (ch.holdRequiredMillis/1000) + "s to finish level", 10, height - 20);
      }
    } else {
      text("Hold E for 3s to interact", 10, height - 20);
    }
  }

  // transient message display
  if (millis() < messageUntil) {
    fill(0);
    textSize(14);
    text(message, 10, height - 45);
  }

  // Interaction hold handling
  if (interacting) {
    if (currentTarget == null || currentTarget.collected) {
      interacting = false;
      currentTarget = null;
    } else {
      if (!currentTarget.overlapsWithSanta(santa)) {
        interacting = false;
        currentTarget = null;
        message = "Moved away — interaction cancelled";
        messageUntil = millis() + 1200;
      } else {
        int elapsed = millis() - interactStartTime;
        float pct = constrain((float)elapsed / (float)interactHoldRequired, 0, 1);

        float barW = 200;
        float barH = 16;
        float bx = 10;
        float by = height - 60;
        noFill();
        stroke(0);
        rect(bx, by, barW, barH);
        noStroke();
        fill(0, 200);
        rect(bx, by, barW * pct, barH);

        fill(0);
        textSize(12);
        text(int(pct * 100) + "%", bx + barW + 8, by + barH - 2);

        // complete?
        if (elapsed >= interactHoldRequired) {
          // final safety checks
          if (!currentTarget.collected && currentTarget.overlapsWithSanta(santa)) {
            // special-case chimney: ensure stockings requirement is met
            if (currentTarget instanceof Chimney) {
              Chimney ch = (Chimney) currentTarget;
              if (santa.stockingsFilled >= ch.stockingsRequired) {
                // mark collected
                ch.onInteract(santa);
                // run level complete routine
                levelComplete();
              } else {
                // shouldn't happen because we prevented start, but handle gracefully
                message = "Not enough stockings filled!";
                messageUntil = millis() + 1500;
              }
            } else {
              currentTarget.onInteract(santa); // cookie or stocking
            }
          }
          interacting = false;
          currentTarget = null;
        }
      }
    }
  }

  if (keyUpPressed) fill(#08FF09); else fill(0);
  text("w", 50, 50);
  if (keyLeftPressed) fill(#08FF09); else fill(0);
  text("a", 25, 75);
  if (keyDownPressed) fill(#08FF09); else fill(0);
  text("s", 50, 75);
  if (keyRightPressed) fill(#08FF09); else fill(0);
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
  
 // Interaction key: START HOLD but only when not already interacting
  if ((key == 'e' || key == 'E') && !interacting) {
    Items target = getNearbyItem();
    if (target != null && !target.collected) {
      if (target instanceof Chimney) {
        Chimney ch = (Chimney) target;
        if (santa.stockingsFilled < ch.stockingsRequired) {
          // show a short message instead of starting the hold
          message = "You need " + ch.stockingsRequired + " stockings filled to finish!";
          messageUntil = millis() + 1500;
        } else {
          // start chimney hold
          interacting = true;
          currentTarget = target;
          interactStartTime = millis();
          interactHoldRequired = target.holdRequiredMillis;
          eDown = true;
        }
      } else {
        // cookie/stocking normal start
        interacting = true;
        currentTarget = target;
        interactStartTime = millis();
        interactHoldRequired = target.holdRequiredMillis;
        eDown = true;
      }
    } else {
      // no nearby item; optional: message
      message = "No item nearby to interact with";
      messageUntil = millis() + 900;
    }
  }

  // restart key example
  if ((key == 'r' || key == 'R') && levelOver) {
    restartLevel();
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


// items priority: cookie -> stocking -> chimney
Items getNearbyItem() {
  for (Cookie c : cookies) {
    if (!c.collected && c.overlapsWithSanta(santa)) return (Items)c;
  }
  for (Stocking s : stockings) {
    if (!s.collected && s.overlapsWithSanta(santa)) return (Items)s;
  }
  for (Chimney ch : chimneys) {
    if (!ch.collected && ch.overlapsWithSanta(santa)) return (Items)ch;
  }
  return null;
}

void levelComplete() {
  levelOver = true;
  message = "Level Complete!";
  messageUntil = millis() + 3000;
  // You can add more: play a sound, start next level, show score screen, etc.
}

void restartLevel() {
  levelOver = false;
  // un-collect items
  for (Cookie c : cookies) c.collected = false;
  for (Stocking s : stockings) s.collected = false;
  for (Chimney ch : chimneys) ch.collected = false;
  // reset santa stats
  santa.cookieCount = 0;
  santa.stockingsFilled = 0;
  // reset other states
  interacting = false;
  currentTarget = null;
  message = "";
}
