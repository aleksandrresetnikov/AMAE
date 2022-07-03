PrintWriter output;
PImage img;

final int matrixSize = 16;

void setup(){
  size(640, 640);
  frameRate(120);
  
  img = loadImage("img7.bmp");
  img.resize(16, 16);
  //img.resize(640, 640);
  
  output = createWriter("output.txt");
}

void draw(){
  image(img, 0, 0);
}

void keyPressed(){
  for (int x = 0; x < matrixSize; x++){
    for (int y = 0; y < matrixSize; y++){
      output.print(get(x, y)+",");
    }
    output.println();
  }
  
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}
