import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.NotDirectoryException;
import java.nio.file.Files;
import java.nio.file.DirectoryStream;
import java.util.*;

final int flagWidthHeight = 16;
final int flagsUndoBufferMaxCountValue = 1500;

ArrayList<color[][]> flagsUndoBuffer = new ArrayList<color[][]>();
PrintWriter output;
color[][] flags = new color[flagWidthHeight][flagWidthHeight];
color selectColor;
int selectFlagX = 0;
int selectFlagY = 0;

void setup(){
  size(1150, 850);
  frameRate(60);
  smooth(8);
  colorMode(HSB,250);
  
  selectColor = color(#FFFFFF);
  drawInterface();
  drawPalette();
  saveToFlagsUndoBuffer();
  initGUI();
}

void draw(){
  checkSelectColor();
  checkSelectFlag();
  updateSelectPixel();
  drawFlags();
  drawGUI();
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
  if (keyPressed && keyCode == 16 && mouseButton == RIGHT)
    selectColor = get(mouseX,mouseY);
  else if (mouseX >= 0 && mouseX <= 800 && mouseY >= 50 && mouseY <= 850){
    if (mousePressed && (mouseButton == LEFT))
      if (selectFlagX < flagWidthHeight && selectFlagY < flagWidthHeight)
        setFlag(selectFlagX, selectFlagY, selectColor);
        
    if (mousePressed && (mouseButton == RIGHT))
      if (selectFlagX < flagWidthHeight && selectFlagY < flagWidthHeight)
        flags[selectFlagX][selectFlagY] = color(#000000);
  }
}
 
void setFlag(int x, int y, color c){
  if (flags[x][y] != c){
    flags[x][y] = c;
    
    saveToFlagsUndoBuffer();
    
    if (flagsUndoBuffer.size() > flagsUndoBufferMaxCountValue) 
      flagsUndoBuffer.remove(0);
    smashUndoBuffer();
  }
}

void saveToFlagsUndoBuffer(){
  color[][] newUndoArrayItem = new color[flagWidthHeight][flagWidthHeight];
  for(int _x = 0; _x < flagWidthHeight; _x++)
    for(int _y = 0; _y < flagWidthHeight; _y++)
      newUndoArrayItem[_x][_y] = flags[_x][_y];
      
  flagsUndoBuffer.add(newUndoArrayItem);
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

void keyPressed(){
  if (key == ENTER) saveMatrixData();
  if (keyCode == 37) undo();
  if (keyCode == 39) redo();
}

int lastUndo = -1;
void undo(){
  if (lastUndo == -1 || lastUndo > flagsUndoBuffer.size()) 
    lastUndo = flagsUndoBuffer.size() - 1;
  else if (lastUndo > 0)
    lastUndo--;
  else
    return;
    
  //println("lastUndo = " + lastUndo);
  
  if (lastUndo <= -1) return;
  color[][] lastUndoArray = flagsUndoBuffer.get(lastUndo);
  for(int x = 0; x < flagWidthHeight; x++)
    for(int y = 0; y < flagWidthHeight; y++)
      flags[x][y] = lastUndoArray[x][y];
}

void redo(){
  if (lastUndo <= -1 || lastUndo >= flagsUndoBuffer.size()-1) return;
  lastUndo++;
  //println("lastUndo = " + lastUndo);
  
  color[][] lastUndoArray = flagsUndoBuffer.get(lastUndo);
  for(int x = 0; x < flagWidthHeight; x++)
    for(int y = 0; y < flagWidthHeight; y++)
      flags[x][y] = lastUndoArray[x][y];
}

void smashUndoBuffer(){
  if (lastUndo <= -1) return;
  for (int i = flagsUndoBuffer.size(); i > lastUndo; i--)
    if (i < flagsUndoBuffer.size())
      flagsUndoBuffer.remove(i);
  lastUndo = -1;
}

void saveMatrixData(){
  output = createWriter("Frames\\frame-"+(getFilesCount("A:\\Александр\\Arduino прочее\\AMAE\\PixelPointer\\Frames", false)+1)+".txt");
  
  for (int x = 0; x < flagWidthHeight; x++) {
    for (int y = 0; y < flagWidthHeight; y++) {
      output.print(flags[x][y]+",");
    }
    output.println();
  }
  
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
}

int getFilesCount(String dirPath, boolean subdirectories) {
  int count = 0;
  File f = new File(dirPath);
  File[] files = f.listFiles();
  
  if (files != null){
    for (int i = 0; i < files.length; i++) {
      count++;
      File file = files[i];
      
      if (subdirectories && file.isDirectory()) {
        count += getFilesCount(file.getAbsolutePath(), subdirectories); 
      }
    }
  }
  return count;
}
