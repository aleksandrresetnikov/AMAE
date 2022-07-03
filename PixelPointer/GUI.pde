Button button1;

void initGUI(){
  button1 = new Button(10, 10, 150, 35, new ColorsList(), new TextProperties("Button 1", 16));
}

void drawGUI(){
  button1.Draw();
}

void updateGUI(){
  
}
