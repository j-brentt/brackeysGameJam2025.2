class Items {
  PVector position;
  PVector size;
  boolean collected = false;
  
  int holdRequiredMillis = 3000;

  Items(float x, float y, float w, float h) {
    position = new PVector(x, y);
    size = new PVector(w, h);
  }

  boolean overlapsWithSanta(Santa s) {
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
    holdRequiredMillis = 1500; // 1.5 seconds
  }

  void display() {
    if (!collected) {
      pushMatrix();
      ellipseMode(CORNER);
      ellipse(position.x, position.y, size.x, size.y);
      ellipseMode(CENTER);
      popMatrix();
    }
  }

  void onInteract(Santa s) {
    if (!collected && overlapsWithSanta(s)) {
      collected = true;
      s.cookieCount++;            
      // s.weight += 0.5;           // eating increases weight
      // sounds and/or animations can be added here after
    }
  }
}

class Stocking extends Items {
  Stocking(float x, float y) {
    super(x, y, 15, 20);
    holdRequiredMillis = 2000; // 2 seconds
  }

  void display() {
    if (!collected) {
      rect(position.x, position.y, size.x, size.y);
    }
  }
  
  // Added onInteract for Stocking
  void onInteract(Santa s) {
    if (!collected && overlapsWithSanta(s)) {
      collected = true;
      s.stockingsFilled++;
      // optionally add reward/effect
    }
  }
}
  
class Chimney extends Items {
  int stockingsRequired; // how many stockings must be filled to allow level completion

  Chimney(float x, float y, int stockingsRequired) {
    super(x, y, 40, 60);
    this.stockingsRequired = stockingsRequired;
    holdRequiredMillis = 5000; // 5 seconds
  }

  void display() {
    if (!collected) {
      pushMatrix();
      rectMode(CORNER);
      rect(position.x, position.y, size.x, size.y);
      popMatrix();
    }
  }

  void onInteract(Santa s) {
    // Only call this if stockings requirement has been checked before starting the hold.
    // But for safety, check again here:
    if (!collected && s.stockingsFilled >= stockingsRequired) {
      collected = true;
      // Indicate level complete — handled in main by levelComplete()
    }
  }
}

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
