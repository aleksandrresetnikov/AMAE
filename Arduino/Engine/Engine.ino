#include <FastLED.h>

#define WIDTH 16                 // ширина матрицы
#define HEIGHT 16                // высота матрицы
#define BRIGHTNESS 55            // начальная яркость
#define DATA_PIN A5              // пмн на матрицу
#define CURRENT_LIMIT 0          // лимит по току в миллиамперах, автоматически управляет яркостью (пожалей свой блок питания!) 0 - выключить лимит

uint8_t CentreX =  (WIDTH / 2) - 1;
uint8_t CentreY = (HEIGHT / 2) - 1;
CRGB leds[NUM_LEDS];

void setup() {
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);
  FastLED.setBrightness(brightness);
  if (CURRENT_LIMIT > 0) 
    FastLED.setMaxPowerInVoltsAndMilliamps(5, CURRENT_LIMIT);
    
}

void loop() {
  
}
