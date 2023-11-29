class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      String filename = imagePrefix + nf(i, 4) + ".gif"; 
      images[i] = loadImage(filename);
    }
  }


  void  display() {
    frame = (frame + 1) % imageCount;
    image(images[frame], 0, 0);
  }

  int getWidth() {
    return images[0].width;
  }
}
