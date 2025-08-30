void resetState() {
  Walls.clear();
  Childs.clear();
  nodeGraph.nodes.clear();
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
  

  mapAssets = new PImage[filenames.length];
  for (int i = 0; i < mapAssets.length; i++) {

    mapAssets[i] = loadImage(dataPath + File.separator + filenames[i]);
  }
}
