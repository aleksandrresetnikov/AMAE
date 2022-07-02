//---УТИЛИТЫ v2.2---

#define _WIDTH WIDTH 
#define THIS_X x
#define THIS_Y y
#define MATRIX_TYPE 0 
#define SEGMENTS 1 

#define TRACK_STEP 50

// служебные функции

// очистить все
void clearAll() {
  fillAll(CRGB::Black);
}

// залить все
void fillAll(CRGB color) {
  for (int i = 0; i < NUM_LEDS; i++) {
    leds[i] = color;
  }
}

// функция отрисовки точки по координатам X Y
void drawPixelXY(int8_t x, int8_t y, CRGB color) {
  if (x < 0 || x > WIDTH - 1 || y < 0 || y > HEIGHT - 1) return;
  int thisPixel = getPixelNumber(x, y) * SEGMENTS;
  for (byte i = 0; i < SEGMENTS; i++) {
    leds[thisPixel + i] = color;
  }
}

// получить номер пикселя в ленте по координатам
uint16_t getPixelNumber(int8_t x, int8_t y) {
  if ((THIS_Y % 2 == 0) || MATRIX_TYPE) {               // если чётная строка
    return (THIS_Y * _WIDTH + THIS_X);
  } else {                                              // если нечётная строка
    return (THIS_Y * _WIDTH + _WIDTH - THIS_X - 1);
  }
}

// функция получения цвета пикселя в матрице по его координатам
uint32_t getPixColorXY(int8_t x, int8_t y) {
  return getPixColor(getPixelNumber(x, y));
}

// функция получения цвета пикселя по его номеру
uint32_t getPixColor(int thisSegm) {
  int thisPixel = thisSegm * SEGMENTS;
  if (thisPixel < 0 || thisPixel > NUM_LEDS - 1) return 0;
  return (((uint32_t)leds[thisPixel].r << 16) | ((long)leds[thisPixel].g << 8 ) | (long)leds[thisPixel].b);
}

// получить случайный цвет
CRGB randomColor(){
  return CRGB(random(0,255),random(0,255),random(0,255));
}

// получить случайный цвет 2й вариант
CRGB randomColor2(){
  return CHSV(random(0,255),255,255);
}

// обновить яркость
void refreshBrightness(boolean theShow){
  FastLED.setBrightness(brightness);
  if (theShow)
    FastLED.show();
}
void refreshBrightness(){
  FastLED.setBrightness(brightness);
  FastLED.show();
}

// потухание
void fade() {
  for (int i = 0; i < NUM_LEDS; i++) {
    if ((uint32_t)getPixColor(i) == 0) continue;
    leds[i].fadeToBlackBy(TRACK_STEP);
  }
}

void drawMap(CRGB bitmap[]){
  for (int i = 0; i < NUM_LEDS; i++) {
    leds[i] = bitmap[i];
  }
}

// координатная позиция 2D
/*struct Vector2I{
  Vector2I();
  Vector2I(int _X, int _Y){
    X = _X;
    Y = _Y;
  }
  int X;
  int Y;
};*/

// динамическая генерацая случайных чисел
void dynamicRandomMeneger(){
  if (DYNAMIC_RANDOM_TYPE == 1)
    randomSeed(micros());
  else if (DYNAMIC_RANDOM_TYPE == 2)
    randomSeed(millis());
  else if (DYNAMIC_RANDOM_TYPE == 3)
    randomSeed(micros() / millis());
  else if (DYNAMIC_RANDOM_TYPE == 4)
    randomSeed(analogRead(PIN_DYNAMIC_RANDOM_TYPE));
  else if (DYNAMIC_RANDOM_TYPE == 5)
    randomSeed(analogRead(MY_RANDOM_SIDE));
  else 
    randomSeed(micros());
}

extern int __bss_end;
extern void *__brkval;
// Функция, возвращающая количество свободного ОЗУ
int memoryFree() {
  int freeValue;
  if ((int)__brkval == 0)
    freeValue = ((int)&freeValue) - ((int)&__bss_end);
  else
    freeValue = ((int)&freeValue) - ((int)__brkval);
  return freeValue;
}

// rgb16 bit to rgb32 bit
unsigned long rgb16_to_rgb32(unsigned long a)
{
  unsigned long r = (a & 0xF800) >11;
  unsigned long g = (a & 0x07E0) >5;
  unsigned long b = (a & 0x001F);

  r = r * 255 / 31;
  g = g * 255 / 63;
  b = b * 255 / 31;
  
  return (r << 16) | (g << 8) | b;

  /* Or for BGR0:
  return (r << 8) | (g << 16) | (b << 24);
  */
}
