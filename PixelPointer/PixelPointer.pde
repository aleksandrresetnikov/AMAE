final int flagWidthHeight = 16;

color[][] flags = new color[flagWidthHeight][flagWidthHeight];
color selectColor;
int selectFlagX = 0;
int selectFlagY = 0;

void setup(){
  size(1150, 850);
  frameRate(120);
  smooth(8);
  colorMode(HSB,250);
  
  selectColor = color(#FFFFFF);
  drawInterface();
  drawPalette();
}

void draw(){
  checkSelectColor();
  checkSelectFlag();
  updateSelectPixel();
  drawFlags();
}

void updateSelectPixel(){
  if (mouseX >= 0 && mouseX <= 800 && mouseY >= 50 && mouseY <= 850){
    selectFlagX = (mouseX / ((800) / flagWidthHeight));
    selectFlagY = ((mouseY - 50) / ((800) / flagWidthHeight));
  }
}

void drawFlags(){
  for (int x = 0;x < flagWidthHeight;x++){
    for (int y = 0;y < flagWidthHeight;y++){
      if (selectFlagX == x && selectFlagY == y)stroke(#FF003C);
      else stroke(#FFFFFF);
      fill(flags[x][y]);
      rect(x * (800 / flagWidthHeight), 50 + y * (800 / flagWidthHeight), (800 / flagWidthHeight), (800 / flagWidthHeight));
    }
  }
}

void drawInterface(){
  noStroke();
  
  fill(#C06C84);
  rect(800, 50 + 0, 350, 800);
  
  fill(#355C7D);
  rect(0, 0, 1150, 50);
  
  fill(#355C7D);
  rect(840, 50 + 40, 270, 270);
  rect(840, 50 + 340, 270, 270);
}

void drawPalette(){
  noStroke();
  for (int x = 850; x < 1100; x++) {
    for (int y = 50; y < 300; y++) {
      stroke(x - 850, y - 50, 255);
      point(x, 50 + y);
    }
  }
}

void clearFlags(){
  for (int x = 0;x < flagWidthHeight;x++){
    for (int y = 0;y < flagWidthHeight;y++){
      flags[x][y] = color(#000000);
    }
  }
}

void checkSelectFlag(){
  if (mouseX >= 0 && mouseX <= 800 && mouseY >= 50 && mouseY <= 850){
    if (mousePressed && (mouseButton == LEFT))
      if (selectFlagX < flagWidthHeight && selectFlagY < flagWidthHeight)
        flags[selectFlagX][selectFlagY] = selectColor;
    if (mousePressed && (mouseButton == RIGHT))
      if (selectFlagX < flagWidthHeight && selectFlagY < flagWidthHeight)
        flags[selectFlagX][selectFlagY] = color(#000000);
  }
}

void checkSelectColor(){
  if (mouseX >= 850 && mouseX <= 1100 && mouseY >= 100 && mouseY <= 350)
    if (mousePressed)
      selectColor = get(mouseX,mouseY);
    
  noStroke();
  
  fill(selectColor);
  rect(850, 50 + 350, 250, 250);
  
  if (selectFlagX < flagWidthHeight && selectFlagY < flagWidthHeight && selectFlagX >= 0 && selectFlagY >= 0){
    fill(#355C7D);
    rect(990, 540, 120, 120);
    
    fill(flags[selectFlagX][selectFlagY]);
    rect(1000, 550, 100, 100);
  }
}
