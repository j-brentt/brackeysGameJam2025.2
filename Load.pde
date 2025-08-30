void resetState() {
  Walls.clear();
  Childs.clear();
  nodeGraph.nodes.clear();
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

void loadImages() {
  String imageName;
  String dataPath = sketchPath("data");
  File folder = new File(dataPath);
  filenames = folder.list();
  for (int i = 1; i < 10; i++) {
    imageName = "Santa_Walking_Front\\frame_" + nf(i, 5) + ".png";
    SantaWalkFront[i-1] = loadImage(imageName);
  }

  for (int i = 1; i < 11; i++) {
    imageName = "Santa_Walking_Side\\frame_" + nf(i, 5) + ".png";
    SantaWalkSide[i-1] = loadImage(imageName);
  }

  for (int i = 1; i < 10; i++) {
    imageName = "Santa_Walking_Backside\\frame_" + nf(i, 5) + ".png";
    SantaWalkBackside[i-1] = loadImage(imageName);
  }
  Bed1 = loadImage("data\\Bed1.png");
  Bed2 = loadImage("data\\Bed2.png");
  Counter_Corner = loadImage("data\\Counter_Corner.png");
  Counter_F = loadImage("data\\Counter_F.png");
  Counter_S = loadImage("data\\Counter_S.png");
  Deco_Painting = loadImage("data\\Deco_Painting.png");
  Deco_Plant = loadImage("data\\Deco_Plant.png");
  Door = loadImage("data\\Door.png");
  Fireplace_F = loadImage("data\\Fireplace_F.png");
  Fireplace_S = loadImage("data\\Fireplace_S.png");
  Floorboard = loadImage("data\\Floorboard.png");
  Stocking_Filled = loadImage("data\\Stocking_Filled.png");
  Stocking_Unfilled = loadImage("data\\Stocking_Unfilled.png");
  Wall = loadImage("data\\Wall.png");

  mapAssets = new PImage[filenames.length];
  for (int i = 0; i < mapAssets.length; i++) {
    println("PImage " + filenames[i] + " = loadImage(\"" + "data\\" + File.separator+filenames[i] + "\");");
    mapAssets[i] = loadImage(dataPath + File.separator + filenames[i]);
  }
}
