Button saveFrameButton;
Button clearButton;
Button undoButton;
Button redoButton;

void initGUI(){
  PImage undoImage = loadImage("Images\\undo.png");
  PImage redoImage = loadImage("Images\\redo.png");
  undoImage.resize(25, 25);
  redoImage.resize(25, 25);
  
  saveFrameButton = new Button(7, 7, 150, 35, new ColorsList(#5fa6e1, #5594c9, #4f8abc), 
    new TextProperties("Save frame", 18, new ColorsList(#ffffff, #ffffff, #ffffff), 
      createFont("Fonts\\WorkSans-Medium.ttf", 18)));
  clearButton = new Button(150 + 16, 7, 150, 35, new ColorsList(#5fa6e1, #5594c9, #4f8abc), 
    new TextProperties("Clear", 18, new ColorsList(#ffffff, #ffffff, #ffffff), 
      createFont("Fonts\\WorkSans-Medium.ttf", 18)));
  undoButton = new Button(width-35-35-16, 7, 35, 35, new ColorsList(#5fa6e1, #5594c9, #4f8abc), 
    new Icon(undoImage, 25, 25));
  redoButton = new Button(width-35-7, 7, 35, 35, new ColorsList(#5fa6e1, #5594c9, #4f8abc), 
    new Icon(redoImage, 25, 25));
      
  saveFrameButton.PressAction = new saveButtonPressAction();
  clearButton.PressAction = new clearButtonPressAction();
  undoButton.PressAction = new undoButtonPressAction();
  redoButton.PressAction = new redoButtonPressAction();
}

void drawGUI(){
  saveFrameButton.Draw();
  clearButton.Draw();
  undoButton.Draw();
  redoButton.Draw();
}

void updateGUI(){
  undoButton.ResetActionTimers();
  redoButton.ResetActionTimers();
}

public class saveButtonPressAction implements Action {
  @Override
  public void Invoke() {
    saveMatrixData();
  }
}

public class clearButtonPressAction implements Action {
  @Override
  public void Invoke() {
    clearMatrix();
  }
}

public class undoButtonPressAction implements Action {
  @Override
  public void Invoke() {
    undo();
  }
}

public class redoButtonPressAction implements Action {
  @Override
  public void Invoke() {
    redo();
  }
}
