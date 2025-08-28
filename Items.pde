class Items {
  PVector position;
  PVector size;
  boolean collected = false;

  Items(float x, float y, float w, float h) {
    position = new PVector(x, y);
    size = new PVector(w, h);
  }

  // Axis-aligned bounding-box overlap test
  boolean overlapsWithSanta(Santa s) {
    // Santa's rect: s.position.x .. s.position.x + s.size.x
    // Item's rect: position.x .. position.x + size.x
    if (s.position.x + s.size.x < position.x) return false;
    if (s.position.x > position.x + size.x) return false;
    if (s.position.y + s.size.y < position.y) return false;
    if (s.position.y > position.y + size.y) return false;
    return true;
  }

  void display() {}

  // called when player interacts with items (presses 'E')
  void onInteract(Santa s) {
    // overrides in subclasses
  }
}

class Cookie extends Items {
  Cookie(float x, float y) {
    super(x, y, 15, 15);
  }

  void display() {
    if (!collected) {
      pushMatrix();
      // draw cookie centered in its box
      ellipseMode(CORNER);
      ellipse(position.x, position.y, size.x, size.y);
      popMatrix();
    }
  }

  void onInteract(Santa s) {
    if (!collected && overlapsWithSanta(s)) {
      collected = true;
      s.cookieCount++;            
      // s.weight += 0.5;           // eating increases weight
      // sounds and/or animations can be added here
    }
  }
}

class Stocking extends Items {
  Stocking(float x, float y) {
    super(x, y, 15, 20);
  }

  void display() {
    if (!collected) {
      rect(position.x, position.y, size.x, size.y);s
    }
  }

  void onInteract(Santa s) {
    if (!collected && overlapsWithSanta(s)) {
      collected = true;
      s.stockingsFilled++;       // increment Santa's stocking stat
      // optionally change velocity limits or other effects
    }
  }
}
