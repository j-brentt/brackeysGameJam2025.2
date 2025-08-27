class Child{
  float x;
  float y;
  float alertness; //(maybe this should be an int)
  boolean enraged; //not sure if we're doing both systems or just 1
  float xvelocity;
  float yvelocity;
  int sprite_type;
  float vision_angle; 
  float vision_radius;
  
  
  
  void display(int sprite_type){
    //draw child of correct sprite type (if we want children from different countries to look different, idk if we r gonna have moving/running animation. If we do, then add another int to the arguments and increment every number of frames)
    //then check frame number modulo no. of animation frames then display accordingly. I guess the same goes for santa.
  }
  void pathfinding(){
    //yeah... i have no clue how we're gonna pathfind these kids towards santa in a maze. Is it okay if they're semi-random? It doesn't seem hard to stop them from running into walls at least, since u can just do a check by looping through the walls.
    //but actual pathfinding seems hard... Ofc if they can see santa they should beeline to him, maybe thats more realistic anyways?
    
    //hard code in the pathfinding by letting the children go in loops (maybe more than 1 loop for randomness)
  }
  
  
  
}
