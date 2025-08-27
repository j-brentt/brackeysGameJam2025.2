class Santa{
  float x;
  float y;
  float size; 
  float weight;
  float xvelocity;
  float yvelocity;
  float xvelocitycap;
  float yvelocitycap;
  float xmomentum;
  float ymomentum;
  float xaccelcap;
  float yaccelcap;
  float maxacceltime; //time it takes to achieve max acceleration
  int coalcount; //write some event that checks santa's position against position of stockings and decrease counter
  int cookiecount; //should affect weight and hence maybe some of the vel/accel caps.
  float cooldown1;
  float cooldown2;
  float cooldown3; //if we have abilities w cooldowns, maybe set cooldowns to infinity at start and only display them when finite
  //some of these variables are determined/affected by others, we just write those relations in the draw step. This is just to make writing functions easier hopefully if we want to use momentum.
  //I think it would be cool if Santa could crash through walls with enough momentum. It would give you more reason to get funky with the controls and let him speed out of control, and a way to avoid getting cornered and waiting to die.
  void display(){
    //draw santa centered at x,y with size size
  }
  void posaccelx(float t){ //accelerate positive x direction, idk if we want time to ramp up to the max acceleration, this is just here as a lever cuz idk what will make good movement. My thinking was that it might be cool to have 
  //jerkier movements for santa so he is harder to control. Maybe only allowing player to control acceleration and not velocity is enough to get a jerky effect and this is overkill. "t" is meant to be the length of time the button is held down for
  //we can check for continuous holds by checking if the button was pressed on the previous frame. This is gonna be done in draw.
    if (xvelocity < xvelocitycap - xaccelcap*t/maxacceltime){
    xvelocity +=  xaccelcap*t/maxacceltime;
    }
    else{
      xvelocity = xvelocitycap;
    }
  } //repeat the accel function for the other 3 directions.
}
