Button saveFrameButton;
Button clearButton;

void initGUI(){
  saveFrameButton = new Button(7, 7, 150, 35, new ColorsList(#5fa6e1, #5594c9, #4f8abc), 
    new TextProperties("Save frame", 18, new ColorsList(#ffffff, #ffffff, #ffffff), 
      createFont("Fonts\\WorkSans-Medium.ttf", 18)));
  clearButton = new Button(150 + 16, 7, 150, 35, new ColorsList(#5fa6e1, #5594c9, #4f8abc), 
    new TextProperties("Clear", 18, new ColorsList(#ffffff, #ffffff, #ffffff), 
      createFont("Fonts\\WorkSans-Medium.ttf", 18)));
      
  clearButton.HoverAction = new clearButtonHoverAction();
  clearButton.PressAction = new clearButtonPressAction();
}

void drawGUI(){
  saveFrameButton.Draw();
  clearButton.Draw();
}

void updateGUI(){
  if (saveFrameButton.Press){
    
  }
  if (clearButton.Press){
    println("kek");
    //clearMatrix();
  }
}

public class clearButtonHoverAction implements Action {
  @Override
  public void Invoke() {
    
  }
}

public class clearButtonPressAction implements Action {
  @Override
  public void Invoke() {
    clearMatrix();
  }
}
