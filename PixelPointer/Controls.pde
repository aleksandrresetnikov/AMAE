public final ColorsList DefaultColorsList     = new ColorsList(#FAFAFA, #D1D1D1, #A7A7A7, #FFFFFF, #FFFFFF, #FFFFFF);
public final ColorsList DefaultTextColorsList = new ColorsList(#1F1F1F, #434242, #FFFFFF, #FFFFFF, #FFFFFF, #1F1F1F);

class Control {
  // location:
  public int PosX;
  public int PosY;
  public int SizeX;
  public int SizeY;
  
  // appearance:
  public ColorsList Colors = new ColorsList();
  public TextProperties Text = null;
  public boolean Visible = true;
  
  // user input character:
  public boolean Hover;
  public boolean Press;
  
  public Control(int PosX, int PosY, int SizeX, int SizeY) {
    this.PosX = PosX;
    this.PosY = PosY;
    this.SizeX = SizeX;
    this.SizeY = SizeY;
    //this.Colors = new ColorsList();
    //this.Text = null;
  }
  
  public Control(int PosX, int PosY, int SizeX, int SizeY, ColorsList Colors) {
    this(PosX, PosY, SizeX, SizeY);
    this.Colors = Colors;
  }
  
  public Control(int PosX, int PosY, int SizeX, int SizeY, TextProperties Text) {
    this(PosX, PosY, SizeX, SizeY);
    this.Text = Text;
  }
  
  public Control(int PosX, int PosY, int SizeX, int SizeY, ColorsList Colors, TextProperties Text) {
    this(PosX, PosY, SizeX, SizeY, Colors);
    this.Text = Text;
  }
  
  public Control(int PosX, int PosY, int SizeX, int SizeY, boolean Visible) {
    this(PosX, PosY, SizeX, SizeY);
    this.Visible = Visible;
  }
  
  public Control(int PosX, int PosY, int SizeX, int SizeY, ColorsList Colors, boolean Visible) {
    this(PosX, PosY, SizeX, SizeY, Colors);
    this.Visible = Visible;
  }
  
  public Control(int PosX, int PosY, int SizeX, int SizeY, TextProperties Text, boolean Visible) {
    this(PosX, PosY, SizeX, SizeY, Text);
    this.Visible = Visible;
  }
  
  public Control(int PosX, int PosY, int SizeX, int SizeY, ColorsList Colors, TextProperties Text, boolean Visible) {
    this(PosX, PosY, SizeX, SizeY, Colors, Text);
    this.Visible = Visible;
  }
  
  public void Draw() {
    this.UpdateHoverStatys();
    this.UpdatePressStatys();
    this.SetColor();
  }
  
  protected void DrawText(){ 
    if (this.Text == null) return;
    
    this.SetTextColor();
    this.Text.SetFont();
    textSize(Text.TextSize);
    textAlign(RIGHT);
    text(this.Text.Text, this.PosX + this.SizeX / 2 + (textWidth(this.Text.Text) / 2),
                         this.PosY + this.SizeY / 2.2 + (this.Text.TextSize / 2));
  }
  
  protected void UpdateHoverStatys(){
    this.Hover = mouseX >= this.PosX && mouseX <= this.PosX + this.SizeX &&
                 mouseY >= this.PosY && mouseY <= this.PosY + this.SizeY;
  }
  
  protected void UpdatePressStatys(){
    this.Press = this.Hover && mousePressed;
  }
  
  protected void SetColor(){
    if (this.Hover && !this.Press) fill(this.Colors.HoverColor);
    else if (this.Hover && this.Press) fill(this.Colors.PressColor);
    else fill(this.Colors.NormalColor);
  }
  
  protected void SetTextColor(){
    if (this.Hover && !this.Press) fill(this.Text.TextColors.HoverColor);
    else if (this.Hover && this.Press) fill(this.Text.TextColors.PressColor);
    else fill(this.Text.TextColors.NormalColor);
  }
}

class Button extends Control {
  public Button(int PosX, int PosY, int SizeX, int SizeY) {
    super(PosX, PosY, SizeX, SizeY);
  }
  
  public Button(int PosX, int PosY, int SizeX, int SizeY, ColorsList Colors) {
    super(PosX, PosY, SizeX, SizeY, Colors);
  }
  
  public Button(int PosX, int PosY, int SizeX, int SizeY, TextProperties Text) {
    super(PosX, PosY, SizeX, SizeY, Text);
  }
  
  public Button(int PosX, int PosY, int SizeX, int SizeY, ColorsList Colors, TextProperties Text) {
    super(PosX, PosY, SizeX, SizeY, Colors, Text);
  }
  
  public Button(int PosX, int PosY, int SizeX, int SizeY, boolean Visible) {
    super(PosX, PosY, SizeX, SizeY, Visible);
  }
  
  public Button(int PosX, int PosY, int SizeX, int SizeY, ColorsList Colors, boolean Visible) {
    super(PosX, PosY, SizeX, SizeY, Colors, Visible);
  }
  
  public Button(int PosX, int PosY, int SizeX, int SizeY, TextProperties Text, boolean Visible) {
    super(PosX, PosY, SizeX, SizeY, Text, Visible);
  }
  
  public Button(int PosX, int PosY, int SizeX, int SizeY, ColorsList Colors, TextProperties Text, boolean Visible) {
    super(PosX, PosY, SizeX, SizeY, Colors, Text, Visible);
  }
  
  @Override
  public void Draw() {
    super.Draw();
    
    rect(super.PosX, super.PosY, super.SizeX, super.SizeY);
    super.DrawText();
  }
}

class ColorsList{
  public color NormalColor;
  public color HoverColor;
  public color PressColor;
  
  public color NormalBorderColor;
  public color HoverBorderColor;
  public color PressBorderColor;
  
  public boolean DrawBorders = true;
  
  public ColorsList(){
    this.NormalColor = DefaultColorsList.NormalColor;
    this.HoverColor  = DefaultColorsList.HoverColor;
    this.PressColor  = DefaultColorsList.PressColor;
    this.NormalColor = DefaultColorsList.NormalBorderColor;
    this.HoverColor  = DefaultColorsList.HoverBorderColor;
    this.PressColor  = DefaultColorsList.PressBorderColor;
  }
  
  public ColorsList(color NormalColor, color HoverColor, color PressColor){
    this.NormalColor = NormalColor;
    this.HoverColor  = HoverColor;
    this.PressColor  = PressColor;
    this.NormalColor = DefaultColorsList.NormalBorderColor;
    this.HoverColor  = DefaultColorsList.HoverBorderColor;
    this.PressColor  = DefaultColorsList.PressBorderColor;
  }
  
  public ColorsList(color NormalColor, color HoverColor, color PressColor, 
  color NormalBorderColor, color HoverBorderColor, color PressBorderColor){
    this.NormalColor = NormalColor;
    this.HoverColor  = HoverColor;
    this.PressColor  = PressColor;
    this.NormalBorderColor = NormalBorderColor;
    this.HoverBorderColor  = HoverBorderColor;
    this.PressBorderColor  = PressBorderColor;
  }
  
  public ColorsList(color NormalColor, color HoverColor, color PressColor, boolean DrawBorders){
    this.NormalColor = NormalColor;
    this.HoverColor  = HoverColor;
    this.PressColor  = PressColor;
    this.NormalColor = DefaultColorsList.NormalBorderColor;
    this.HoverColor  = DefaultColorsList.HoverBorderColor;
    this.PressColor  = DefaultColorsList.PressBorderColor;
    this.DrawBorders = DrawBorders;
  }
  
  public ColorsList(color NormalColor, color HoverColor, color PressColor, 
  color NormalBorderColor, color HoverBorderColor, color PressBorderColor, boolean DrawBorders){
    this.NormalColor = NormalColor;
    this.HoverColor  = HoverColor;
    this.PressColor  = PressColor;
    this.NormalBorderColor = NormalBorderColor;
    this.HoverBorderColor  = HoverBorderColor;
    this.PressBorderColor  = PressBorderColor;
    this.DrawBorders = DrawBorders;
  }
}

class TextProperties {
  public String Text = "";
  public int TextSize = 10;
  public boolean TextVisible = false;
  public ColorsList TextColors = DefaultTextColorsList;
  public PFont TextFont = null;
  
  public TextProperties(String Text) { 
    this.Text = Text;
  }
  
  public TextProperties(String Text, ColorsList TextColors) { 
    this(Text);
    this.TextColors = TextColors;
  }
  
  public TextProperties(String Text, int TextSize) { 
    this(Text);
    this.TextSize = TextSize;
  }
  
  public TextProperties(String Text, boolean TextVisible) { 
    this(Text);
    this.TextVisible = TextVisible;
  }
  
  public TextProperties(String Text, int TextSize, ColorsList TextColors) { 
    this(Text, TextSize);
    this.TextColors = TextColors;
  }
  
  public TextProperties(String Text, int TextSize, boolean TextVisible) { 
    this(Text, TextSize);
    this.TextVisible = TextVisible;
  }
  
  public TextProperties(String Text, int TextSize, ColorsList TextColors, boolean TextVisible) { 
    this(Text, TextSize, TextColors);
    this.TextVisible = TextVisible;
  }
  
  public TextProperties(String Text, PFont TextFont) { 
    this(Text);
    this.TextFont = TextFont;
  }
  
  public TextProperties(String Text, ColorsList TextColors, PFont TextFont) { 
    this(Text, TextColors);
    this.TextFont = TextFont;
  }
  
  public TextProperties(String Text, int TextSize, PFont TextFont) { 
    this(Text, TextSize);
    this.TextFont = TextFont;
  }
  
  public TextProperties(String Text, boolean TextVisible, PFont TextFont) { 
    this(Text, TextVisible);
    this.TextFont = TextFont;
  }
  
  public TextProperties(String Text, int TextSize, ColorsList TextColors, PFont TextFont) { 
    this(Text, TextSize, TextColors);
    this.TextFont = TextFont;
  }
  
  public TextProperties(String Text, int TextSize, boolean TextVisible, PFont TextFont) { 
    this(Text, TextSize, TextVisible);
    this.TextFont = TextFont;
  }
  
  public TextProperties(String Text, int TextSize, ColorsList TextColors, boolean TextVisible, PFont TextFont) { 
    this(Text, TextSize, TextColors, TextVisible);
    this.TextFont = TextFont;
  }
  
  public void SetFont(){
    if (this.TextFont == null) return;
    textFont(this.TextFont);
  }
}