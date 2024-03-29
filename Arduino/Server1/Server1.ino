#include <ESP8266WiFi.h>
#include <FastLED.h>

#define WIDTH 16                      // ширина матрицы
#define HEIGHT 16                     // высота матрицы
#define BRIGHTNESS 25                 // начальная яркость
#define DATA_PIN 5                   // пмн на матрицу
#define NUM_LEDS WIDTH * HEIGHT       // количество светтодиодов
#define CURRENT_LIMIT 0               // лимит по току в миллиамперах, автоматически управляет яркостью (пожалей свой блок питания!) 0 - выключить лимит

#define CHIPSET NEOPIXEL
#define FRAMES_PER_SECOND 12 //fps

#define DYNAMIC_RANDOM_NUMBERS 1      // динамическая генерация сида рандома
#define DYNAMIC_RANDOM_TYPE 4         // тип динамической генерации сида рандома 1 - по времени, 2 - по времени2, 3 - по времени3, 4 - шум, 5 - свой сид
#define PIN_DYNAMIC_RANDOM_TYPE 5     // если тип динамической генерации сида рандома 4 (шум), то будет использоваться этот пин для сида (не в коем случае на подключать резистр на этот пин)
#define MY_RANDOM_SIDE 0              // если тип динамической генерации сида рандома 5 (свой сид), то будет использоваться этот сид

const char* ssid = "Keenetic-3363";
const char* password = "JeckDog093";

uint8_t CentreX =  (WIDTH / 2) - 1;
uint8_t CentreY = (HEIGHT / 2) - 1;
WiFiServer server(8888);
CRGB leds[NUM_LEDS];
byte brightness = BRIGHTNESS;
int gif_select_frame = 0;
int curentSaveFrame = -1;

struct {
  byte brightness = BRIGHTNESS;
  byte speed = 1;
  byte scale = 40;
} modes[1];

CRGB gifBitmap_mask[50][256];

CRGB bitmap[] = {
0,-3355444,-3355444,-3355444,-3355444,-3355444,-6720871,-10664867,-10664867,-10664867,-10664867,-10664867,-10664867,-6720871,-3355444,-3355444,
-3355444,-3355444,-3355444,-3355444,-3355444,-6710887,-13424837,-13424838,-13424839,-13424839,-13424839,-13424839,-13490630,-13228229,-6710887,-3355444,
-3355444,-3355444,-3355444,-3355444,-6710887,-13293767,-10932682,-9752780,-9687244,-9687244,-9687244,-9687244,-9687244,-11261130,-13228229,-6720871,
-3355444,-3355444,-3355444,-13092790,-13358790,-11130058,-7064271,-1817556,-1287108,-1421773,-1489876,-1489876,-1555412,-7916750,-11260873,-13162693,
-3355444,-3355444,-6710887,-13358790,-13425095,-6605006,-2998226,-1489363,-747162,-1087163,-1424084,-1424341,-1424341,-3260627,-7326158,-13162952,
-3355444,-6710887,-13293767,-13621703,-13490631,-6930619,-2594988,-946080,-609160,-745365,-1017520,-1424084,-1424341,-1424341,-6342607,-13228488,
-6720871,-13424837,-13545932,-12819403,-10796222,-7323050,-3972773,-1079718,-609416,-812442,-1019317,-1424084,-1424341,-4768721,-8441294,-13162950,
-12566445,-13358789,-13409997,-11618253,-7115954,-6864034,-5029044,-1554127,-610443,-1018804,-1423827,-1424341,-1489876,-9359308,-13031623,-12833220,
-13292485,-8019874,-4329098,-6372504,-11382201,-9423020,-5029557,-1620947,-1358291,-1424084,-1424341,-1424341,-1424341,-1555411,-6473934,-13162695,
-13489351,-11233214,-9648821,-10524595,-12699586,-8438447,-4176311,-1555411,-1424341,-1424341,-1424341,-1424341,-1424340,-2799553,-7587006,-13294023,
-13620936,-13602767,-13531857,-13555656,-13490631,-6930619,-2865089,-1489876,-1424341,-1424341,-1424341,-1686225,-2275528,-4175024,-8438195,-13359559,
-13556423,-13555911,-13555400,-13424578,-13425095,-6605006,-2998226,-1489877,-1424341,-1882831,-2144714,-2734018,-4305838,-6207659,-9094581,-13294023,
-13359555,-13359555,-13489345,-12307900,-13358790,-11130058,-7064271,-1817812,-1555411,-3126975,-4175024,-4371374,-4895656,-9488311,-11850176,-13161669,
-3355444,-3355444,-3355444,-3355444,-6710887,-13293767,-10932682,-9752780,-9752779,-10407619,-10866109,-10866109,-10800572,-11850432,-13228229,-6720871,
-3355444,-3355444,-3355444,-3355444,-3355444,-6710887,-13424837,-13424838,-13424839,-13424839,-13424839,-13424839,-13490630,-13228229,-6710887,-3355444,
-3355444,-3355444,-3355444,-3355444,-3355444,-3355444,-6720871,-10664867,-10664867,-10664867,-10664867,-10664867,-10664867,-6720871,-3355444,-3355444,
};

void setup() {
  FastLED.addLeds<CHIPSET, DATA_PIN>(leds, NUM_LEDS);
  FastLED.setBrightness(brightness);
  FastLED.clear();
  if (CURRENT_LIMIT > 0) 
    FastLED.setMaxPowerInVoltsAndMilliamps(5, CURRENT_LIMIT);

  Serial.begin(115200);
  WiFistart();
  initGif();
}

void WiFistart() {
  // Connect to WiFi network
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");

  // Start the server
  server.begin();
  Serial.println("Server started");

  // Print the IP address
  Serial.println(WiFi.localIP());
}

uint32_t loop_timer = millis();
void loop() {
  loop_timer = millis();

  //sparklesRoutine();
  //paintSaveGif();
  serverLoop();

  /*drawPixelXY(5, 8, CRGB::Red);
  drawPixelXY(10, 1, CRGB::White);
  drawPixelXY(10, 2, CRGB::Blue);*/
  
  //delayFPS();
  //printFPS(); // http://192.168.1.36:8888/
}

void delayFPS(){
  for (;;) if ((1000/(millis()-loop_timer)) <= FRAMES_PER_SECOND) break;
}

void printFPS(){
  if (millis()-loop_timer == 0) Serial.println(1000);
  Serial.println(1000/(millis()-loop_timer));
}

int _step;
void serverLoop(){
  WiFiClient client = server.available();
  if (!client) return;
  while (!client.available()) { }

  String req = client.readStringUntil('\r');
  client.flush();

  // parsing:
  req[0] = ' ';
  req.replace("HTTP/1.1", "");
  req.replace("GET /", "");
  req.replace("ET /", "");

  if (req.indexOf("FRAME") != -1){
    String save = "";
    int teg = 0;
    for (int i = 0; i < req.length(); i++) {
      yield();
      if (req[i] == '_') {
        if (teg == 1)gif_select_frame = save.toInt();
        save = "";
        teg++; continue;
      }
      if (teg >= 2)break;
      save += req[i];
    }
    paintSaveGif();
    FastLED.show();
    return;
  }

  int parts = 257;
  int selectFrame = 0;
  for (int s = 0; s < parts; s++){
    yield();
    String inText = getPart(req, ',', s);
    if (s == 0) { selectFrame = inText.toInt(); continue; }
    /*int x = 0,
        y = 0,
        c = 0,
        teg = 0;
    String save = "";
    for (int i = 0; i < inText.length(); i++) {
      if (inText[i] == '_') {
        if (teg == 0)x = save.toInt();
        if (teg == 1)y = save.toInt();
        if (teg == 2)c = save.toInt();
        save = "";
        teg++; continue;
      }
      if (teg >= 3)break;
      save += inText[i];
    }

    drawPixelXY(x, y, c);*/
    //leds[s-1] = inText.toInt();
    gifBitmap_mask[selectFrame][s-1] = inText.toInt();
  }
  curentSaveFrame = -1;
  FastLED.show();
}

void sparklesRoutine() {
  for (byte i = 0; i < modes[0].scale; i++) {
    byte x = random(0, WIDTH);
    byte y = random(0, HEIGHT);
    if (getPixColorXY(x, y) == 0)
      leds[getPixelNumber(x, y)] = CHSV(random(0, 255), 255, 255);
  }
  fader(70);
}

// функция плавного угасания цвета для всех пикселей
void fader(byte step) {
  for (byte x = 0; x < WIDTH; x++)
    for (byte y = 0; y < HEIGHT; y++)
      fadePixel(x, y, step);
}
void fadePixel(byte i, byte j, byte step) {
  int pixelNum = getPixelNumber(i, j);
  if (getPixColor(pixelNum) == 0) return;

  if (leds[pixelNum].r >= 30 || leds[pixelNum].g >= 30 || leds[pixelNum].b >= 30)
    leds[pixelNum].fadeToBlackBy(step);
  else
    leds[pixelNum] = 0;
}

String getPart(String text, char del, int index) {
  int found = 0;
  int sInd[] = {0, -1};
  int mInd = text.length()-1;

  for(int i=0; i<=mInd && found<=index; i++){
    if(text.charAt(i)==del || i==mInd){
      found++;
      sInd[0] = sInd[1]+1;
      sInd[1] = (i == mInd) ? i+1 : i;
    }
  }

  return found>index ? text.substring(sInd[0], sInd[1]) : "";
}
