class Santa {
  PVector position;
  float size = 50;
  float weight;
  float friction = 0.95;

  PVector velocity = new PVector(0, 0);
  float maxVelocity = 5;
  PVector acceleration = new PVector(0, 0);
  float maxacceltime; //time it takes to achieve max acceleration
  int coalcount; //write some event that checks santa's position against position of stockings and decrease counter
  int cookiecount; //should affect weight and hence maybe some of the vel/accel caps.
  float cooldown1;
  float cooldown2;
  float cooldown3; //if we have abilities w cooldowns, maybe set cooldowns to infinity at start and only display them when finite
  //some of these variables are determined/affected by others, we just write those relations in the draw step. This is just to make writing functions easier hopefully if we want to use momentum.
  //I think it would be cool if Santa could crash through walls with enough momentum. It would give you more reason to get funky with the controls and let him speed out of control, and a way to avoid getting cornered and waiting to die.
  Santa(float x, float y) {
    this.position = new PVector(x, y);
  }

  void update() {
    
    movement();
  }

  void display() {
    // draw santa centered at x,y with size size
    rect(position.x, position.y, size, size);
  }
  
  void movement() {
    acceleration.set(0,0); //<>//
    if (keyUpPressed) acceleration.y = -0.2;
    if (keyDownPressed) acceleration.y = 0.2;
    if (keyLeftPressed) acceleration.x = -0.2;
    if (keyRightPressed) acceleration.x = 0.2;
    
    if (!keyUpPressed && !keyDownPressed) velocity.y *= friction;
    if (abs(velocity.y) < 0.01) velocity.y = 0;
    
    if (!keyLeftPressed && !keyRightPressed) velocity.x *= friction;
    if (abs(velocity.x) < 0.01) velocity.x = 0;

    velocity.add(acceleration); //<>//
    velocity.limit(maxVelocity);
    position.add(velocity);
  }
  
  void xMovement(int sign) {
    velocity.x = maxVelocity * sign;
  }

  void yMovement(int sign) {
    velocity.y = maxVelocity * sign;
  }

}
