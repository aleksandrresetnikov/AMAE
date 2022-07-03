public final ColorsList DefaultColorsList = new ColorsList(#FAFAFA, #D1D1D1, #A7A7A7);
public final ColorsList DefaultTextColorsList = new ColorsList(#FAFAFA, #D1D1D1, #A7A7A7);

class Control {
  // location:
  public int PosX;
  public int PosY;
  public int SizeX;
  public int SizeY;
  
  // appearance:
  public ColorsList Colors;
  public boolean Visible = true;
  
  public boolean Hover;
  public boolean Press;
  
  public Control(int PosX, int PosY, int SizeX, int SizeY) {
    this.PosX = PosX;
    this.PosY = PosY;
    this.SizeX = SizeX;
    this.SizeY = SizeY;
    this.Colors = new ColorsList();
  }
  
  public Control(int PosX, int PosY, int SizeX, int SizeY, ColorsList Colors) {
    this.PosX = PosX;
    this.PosY = PosY;
    this.SizeX = SizeX;
    this.SizeY = SizeY;
    this.Colors = Colors;
  }
  
  public Control(int PosX, int PosY, int SizeX, int SizeY) {
    this.PosX = PosX;
    this.PosY = PosY;
    this.SizeX = SizeX;
    this.SizeY = SizeY;
    this.Colors = new ColorsList();
  }
  
  public Control(int PosX, int PosY, int SizeX, int SizeY, ColorsList Colors) {
    this.PosX = PosX;
    this.PosY = PosY;
    this.SizeX = SizeX;
    this.SizeY = SizeY;
    this.Colors = Colors;
  }
  
  public void Draw() {
    this.updateHoverStatys();
    this.updatePressStatys();
  }
  
  private void updateHoverStatys(){
    this.Hover = mouseX >= this.PosX && mouseX <= this.PosX + this.SizeX &&
                 mouseY >= this.PosY && mouseY <= this.PosY + this.SizeY;
  }
  
  private void updatePressStatys(){
    this.Hover = mouseX >= this.PosX && mouseX <= this.PosX + this.SizeX &&
                 mouseY >= this.PosY && mouseY <= this.PosY + this.SizeY;
  }
}

class Button extends Control {
  public Button(int PosX, int PosY, int SizeX, int SizeY) {
    super(PosX, PosY, SizeX, SizeY);
  }
  
  @Override
  public void Draw() {
    super.Draw();
  }
}

class ColorsList{
  public color NormalColor;
  public color HoverColor;
  public color PressColor;
  
  public ColorsList(){
    this.NormalColor = DefaultColorsList.NormalColor;
    this.HoverColor  = DefaultColorsList.HoverColor;
    this.PressColor  = DefaultColorsList.PressColor;
  }
  
  public ColorsList(color NormalColor, color HoverColor, color PressColor){
    this.NormalColor = NormalColor;
    this.HoverColor  = HoverColor;
    this.PressColor  = PressColor;
  }
}

class TextProperties {
  public String Text = "";
  public int TextSize = 10;
  public boolean TextVisible = false;
  public ColorsList TextColorList = DefaultTextColorsList;
  
  public TextProperties(String Text) { 
  }
}
