#include <FastLED.h>

#define WIDTH 16                      // ширина матрицы
#define HEIGHT 16                     // высота матрицы
#define BRIGHTNESS 55                 // начальная яркость
#define DATA_PIN 5                   // пмн на матрицу
#define NUM_LEDS WIDTH * HEIGHT       // количество светтодиодов
#define CURRENT_LIMIT 0               // лимит по току в миллиамперах, автоматически управляет яркостью (пожалей свой блок питания!) 0 - выключить лимит

#define CHIPSET     NEOPIXEL
#define FRAMES_PER_SECOND 60 //fps

#define DYNAMIC_RANDOM_NUMBERS 1      // динамическая генерация сида рандома
#define DYNAMIC_RANDOM_TYPE 4         // тип динамической генерации сида рандома 1 - по времени, 2 - по времени2, 3 - по времени3, 4 - шум, 5 - свой сид
#define PIN_DYNAMIC_RANDOM_TYPE A5    // если тип динамической генерации сида рандома 4 (шум), то будет использоваться этот пин для сида (не в коем случае на подключать резистр на этот пин)
#define MY_RANDOM_SIDE 0              // если тип динамической генерации сида рандома 5 (свой сид), то будет использоваться этот сид

uint8_t CentreX =  (WIDTH / 2) - 1;
uint8_t CentreY = (HEIGHT / 2) - 1;
CRGB leds[NUM_LEDS];
byte brightness = BRIGHTNESS;

struct {
  byte brightness = BRIGHTNESS;
  byte speed = 1;
  byte scale = 40;
} modes[1];

void setup() {
  FastLED.addLeds<CHIPSET, DATA_PIN>(leds, NUM_LEDS);
  FastLED.setBrightness(brightness);
  FastLED.clear();
  if (CURRENT_LIMIT > 0) 
    FastLED.setMaxPowerInVoltsAndMilliamps(5, CURRENT_LIMIT);

  Serial.begin(9600);
}

uint32_t loop_timer = millis();
void loop() {
  loop_timer = millis();
  
  for (int8_t x = 0; x < WIDTH; x++)
    for (int8_t y = 0; y < HEIGHT; y++)
      drawPixelXY(x, y, randomColor());
  
  FastLED.show();
  delayFPS();
  //printFPS();
}

void delayFPS(){
  for (;;) if ((1000/(millis()-loop_timer)) <= FRAMES_PER_SECOND) break;
}

void printFPS(){
  if (millis()-loop_timer == 0) Serial.println(1000);
  Serial.println(1000/(millis()-loop_timer));
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
