class Child{
  int alertness = 0; //(maybe this should be an int)
  boolean enraged; //not sure if we're doing both systems or just 1
  PVector size;
  boolean blind;
  PVector position; // this is center of child
  PVector velocity = new PVector(0,0);
  float moveSpeed = 10;
  int sprite_type;
  float vision_angle; 
  float vision_radius;
  int facing_direction; //0 for right, 1 for down, 2 for left, 3 for up
  int blindTime;
  
  Node currentNode = null;
  Node goalNode = null;
  boolean isTraversing = false;
  ArrayList<Node> traversalPath = new ArrayList<Node>();
  
  
  Child(float x, float y, float sizeX, float sizeY, float vision_angle, float vision_radius) {
    this.position = new PVector(x, y);
    this.size = new PVector(sizeX, sizeY);
    this.facing_direction = 2;
    this.vision_angle = vision_angle;
    this.vision_radius = vision_radius;
    this.blind = false;
    this.blindTime = 0;
  }
  
    Child(float x, float y, float sizeX, float sizeY, float vision_angle, float vision_radius, Node spawnNode) {
    this.position = new PVector(x, y);
    this.size = new PVector(sizeX, sizeY);
    this.facing_direction = 2;
    this.vision_angle = vision_angle;
    this.vision_radius = vision_radius;
    
    this.currentNode = spawnNode;
    isTraversing = false;
  }
  void display() {
    PVector corner_position = new PVector(position.x-size.x/2, position.y-size.y/2);
    graphTraversal();
    fill(100);
    rect(corner_position.x, corner_position.y, size.x, size.y);
    //draw child of correct sprite type (if we want children from different countries to look different, idk if we r gonna have moving/running animation. If we do, then add another int to the arguments and increment every number of frames)
    //then check frame number modulo no. of animation frames then display accordingly. I guess the same goes for santa.
  }
  void pathfinding(){
    //change to traversalPath[1] or [2] maybe?
    if (currentNode.position.dist(position) < 20) {
      for (Node n : nodeGraph.nodes) {
        n.reset();
      }
      traversalPath = aStar(currentNode, nodeGraph.santaNode);
      //if (traversalPath == null) print("hi");
      if (traversalPath != null) {
        goalNode = traversalPath.get(traversalPath.size() - 1);
        print(traversalPath.size());
        for (Node n : traversalPath) {
          println(n.position);
        }
      }

    }
  }
  
  void graphTraversal() {
    if (traversalPath != null && traversalPath.size() > 1) {
      Node nextNode = traversalPath.get(1);
      PVector direction = nextNode.position.copy().sub(position);
      direction.normalize();
      velocity = direction.mult(moveSpeed);
      position.add(velocity);
      
      
      if (nextNode.position.dist(position) < moveSpeed) {
        currentNode = nextNode;
        traversalPath.remove(0);
      }
      
    }
  }
  
  void createSightBullets(){
    float angle;
    angle = facing_direction*90*PI/180 - (vision_angle/2)*PI/180;
    while (angle < facing_direction*90*PI/180 + (vision_angle/2) * PI/180){
      angle+= 2*PI/180;
      SightBullet sb = new SightBullet(position.x, position.y, angle, vision_radius, this);
      SightBullets.add(sb);
      //print("created sb");
    }
  }
  
  
}


class SightBullet{
  float x;
  float y;
  PVector position;
  PVector positionInit;
  float xInit;
  float yInit;
  float angle;
  float radius;
  boolean deleted;
  Child c;
  SightBullet(float x, float y, float angle, float radius, Child c){
    this.x=x;
    this.y=y;
    this.xInit=x;
    this.yInit=y;
    this.angle = angle;
    this.position = new PVector(x,y);
    this.positionInit = new PVector(xInit, yInit);
    this.radius = radius;
    this.deleted = false;
    this.c = c;
  }
  void display(){
    //fill(0,0,255);
    //line(xInit, yInit, x, y);
  }
  void hitscan(){
   while(position.copy().sub(positionInit.copy()).mag() < radius && deleted == false){
     PVector step;
     step = new PVector(10*cos(angle), 10*sin(angle));

     position.add(step);
     if (detectNoCollision(position, santa.position, pointsize, santa.size) == 2){
       deleted = true;
       santa.alive = false;
       //print("SANTA IS DEAD!!");
     }
     for (Wall w : Walls){
     if (detectNoCollision(position, w.position, pointsize, w.size) == 2){
       deleted = true;
       //print("DELETED");
     }
     }
   }
    fill(0,0,255);
    line(xInit, yInit, position.x, position.y);
  }
}
