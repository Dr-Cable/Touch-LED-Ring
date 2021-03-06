/*
#   HOOKUP GUIDE (For Arduino)
  
    =============================
   | 1 2 3 4 5 6 7               |      #  PIN 1 - HOST_V+    ----    5V Pin or 3v3 Pin depending on what Arduino is running on.                                
   |                      HOVER  |      #  PIN 2 - RESET      ----    Any Digital Pin.  This example uses Pin 6. 
   |                             |      #  PIN 3 - SCL        ----    SCL pin
   | +++++++++++++++++++++++++++ |      #  PIN 4 - SDA        ----    SDA pin
   | +                         + |      #  PIN 5 - GND        ----    Ground Pin
   | +                         + |      #  PIN 6 - 3V3        ----    3V3 pin
   | +                         + |      #  PIN 7 - TS         ----    Any Digital Pin.  This example uses Pin 5.
   | +                         + |
   | +                         + |
   |_+++++++++++++++++++++++++++_|
   
  =============================================================================

#   OUTPUT DEFINITION
    The following table defines the event map.   
                  
    =============================================
    | Gesture Type | Gesture ID | Gesture Value |
    =============================================
    | Invalid      | 0x00       | 0x00          |
    | Right Swipe  | 0x01       | 0x01          |
    | Left Swipe   | 0x01       | 0x02          |
    | Up Swipe     | 0x01       | 0x03          |
    | Down Swipe   | 0x01       | 0x04          |
    ---------------------------------------------
    
    =============================================
    | Touch Type   | Touch ID   | Touch Value   | 
    =============================================
    | Invalid      | 0x00       | 0x00          | 
    | Touch East   | 0x01       | 0x01          | 
    | Touch West   | 0x01       | 0x02          | 
    | Touch North  | 0x01       | 0x03          | 
    | Touch South  | 0x01       | 0x04          | 
    | Touch Center | 0x01       | 0x05          | 
    | Tap East     | 0x02       | 0x01          | 
    | Tap West     | 0x02       | 0x02          | 
    | Tap North    | 0x02       | 0x03          | 
    | Tap South    | 0x02       | 0x04          | 
    | Tap Center   | 0x02       | 0x05          | 
    | 2x Tap East  | 0x03       | 0x01          | 
    | 2x Tap West  | 0x03       | 0x02          | 
    | 2x Tap North | 0x03       | 0x03          | 
    | 2x Tap South | 0x03       | 0x04          | 
    | 2x Tap Center| 0x03       | 0x05          | 
    ---------------------------------------------
    
    =============================================================
    | Position Type|   x        |   y           |   z           |
    =============================================================
    | 3D Position  | 0 to 100   | 0 to 100      |   0 to 100    |
    -------------------------------------------------------------

#  HISTORY
    v1.0  -  Initial Release
    v2.0  -  Standardized Output Definition, On Github
    v2.1  -  Fixed Count Issue, Update Output String with examples
    v3.0  -  Major library update -- added 3D Position, Touch, Double Tap
  
#  INSTALLATION
    The 3 library files (Hover.cpp, Hover.h and keywords.txt) in the Hover folder should be placed in your Arduino Library folder.
    Run the HoverDemo.ino file from your Arduino IDE.

#  SUPPORT
    For questions and comments, email us at support@hoverlabs.co

*********************************************************************************************************/

#include <Wire.h>
#include <Hover.h>
#include <Adafruit_NeoPixel.h>

// pin declarations for Hover
int ts = 5;
int reset = 6;

// Enable or disable different modes. Only gestures and taps are enabled by default. 
// Set the following four options to 0x01 if you want to capture every event. Note that the Serial console will be 'spammy'. 
#define GESTUREMODE 0x01    //0x00 = disable gestures, 0x01 = enable gestures
#define TOUCHMODE 0x01      //0x00 = disable touch, 0x01 = enable touch 
#define TAPMODE 0x01        //0x00 = disable taps, 0x01 = enable taps, 0x02 = single taps only, 0x03 = double taps only
#define POSITIONMODE 0x01   //0x00 = disable position tracking, 0x01 = enable position tracking

// initialize Hover
Hover hover = Hover(ts, reset, GESTUREMODE, TOUCHMODE, TAPMODE, POSITIONMODE );    

// used when printing 3D position coordinates. Using a smaller interval will result in a 'spammy' console. Set to update every 150ms by default.  
long interval = 200;        
long previousMillis = 0;
long waitTime = 80;
long currentTime = 0;
long loopTime = 0;


//#define BUTTON_PIN   2    // Digital IO pin connected to the button.  This will be
                          // driven with a pull-up resistor so the switch should
                          // pull the pin to ground momentarily.  On a high -> low
                          // transition the button press logic will execute.

#define PIXEL_PIN    3    // Digital IO pin connected to the NeoPixels.
#define PIXEL_COUNT 24

// Parameter 1 = number of pixels in strip,  neopixel stick has 8
// Parameter 2 = pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_RGB     Pixels are wired for RGB bitstream
//   NEO_GRB     Pixels are wired for GRB bitstream, correct for neopixel stick
//   NEO_KHZ400  400 KHz bitstream (e.g. FLORA pixels)
//   NEO_KHZ800  800 KHz bitstream (e.g. High Density LED strip), correct for neopixel stick
Adafruit_NeoPixel strip = Adafruit_NeoPixel(PIXEL_COUNT, PIXEL_PIN, NEO_GRB + NEO_KHZ800);

boolean countUP = false;

int StartLEDVK = 1;
int StartLEDHK = 18;
int Ladestartzeit = 1;
int Ladedauer = 8;
int istSOC = 3;
int sollSOC = 16;
int showSOC = istSOC;
int newgestureID = 0;
int oldgestureID = 0;
int newgestureValue = 0;
int oldgestureValue = 0;
int newtouchID = 0;
int oldtouchID = 0;
int newtouchValue = 0;
int oldtouchValue = 0;
int showType = 0;
int activeFunction = 0;
int k = 0;
uint8_t Atmen = 0;
uint32_t red = (255,0,0);
uint32_t green = (0,255,0);
uint32_t blue = (0,0,255);
uint32_t white = (255,255,255);
uint32_t Bred = (127,0,0);
uint32_t Bgreen = (0,127,0);
uint32_t Bblue = (0,0,127);
uint32_t Bwhite = (127,127,127);
uint32_t Lblue = (0,54,54);
uint32_t orange = (127,54,0);





void setup() {
  Serial.begin(9600);
  delay(2000);
  Serial.println("Initializing Hover...please wait.");
  hover.begin(); 
//  pinMode(BUTTON_PIN, INPUT_PULLUP);
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
}


    
void loop(void) {
  
  long currentMillis = millis();    // used for updating 3D position coordinates. Set to update every 150ms by default. 
  long currentTime = millis();
  // read incoming data stream from Hover
  hover.readI2CData();
  
  // retreive a gesture, touch, or position                
  Gesture g = hover.getGesture();
  Touch t = hover.getTouch();
  Position p = hover.getPosition();        
  
  // print Gesture data
  if ( g.gestureID != 0){
    Serial.print("Event: "); Serial.print(g.gestureType); Serial.print("\t");          
    Serial.print("Gesture ID: "); Serial.print(g.gestureID,HEX); Serial.print("\t");
    Serial.print("Value: "); Serial.print(g.gestureValue,HEX); Serial.println("");
  }     
  
  // print Touch data 
  if ( t.touchID != 0 && !(p.x==0 && p.y==0 && p.z==0)){  
    Serial.print("Event: "); Serial.print(t.touchType); Serial.print("\t");      
    Serial.print("Touch ID: "); Serial.print(t.touchID,HEX); Serial.print("\t");
    Serial.print("Value: "); Serial.print(t.touchValue,HEX); Serial.println("");
    
    // scale raw position coordinates from (0,65535) to (0, 100). Set to 100 by default. Can be changed to any positive value for the desired granularity.   
      p.x = map(p.x, 0, 65535, 0, 100);
      p.y = map(p.y, 0, 65535, 0, 100);
      p.z = map(p.z, 0, 65535, 0, 100);
      
    Serial.print("(x,y,z): "); Serial.print("\t"); Serial.print("("); 
    Serial.print(p.x); Serial.print(", "); 
    Serial.print(p.y); Serial.print(", "); 
    Serial.print(p.z); Serial.print(")"); Serial.println("");
  }

  // print 3D Position data (x,y,z coordinates)       
  /*if( (currentMillis - previousMillis) > interval) {
    
    previousMillis = currentMillis;
    if ( !(p.x==0 && p.y==0 && p.z==0) ) {          
      
      // scale raw position coordinates from (0,65535) to (0, 100). Set to 100 by default. Can be changed to any positive value for the desired granularity.   
      p.x = map(p.x, 0, 65535, 0, 100);
      p.y = map(p.y, 0, 65535, 0, 100);
      p.z = map(p.z, 0, 65535, 0, 100);
      
      Serial.print("(x,y,z): "); Serial.print("\t"); Serial.print("("); 
      Serial.print(p.x); Serial.print(", "); 
      Serial.print(p.y); Serial.print(", "); 
      Serial.print(p.z); Serial.print(")"); Serial.println("");
    }
    
  }*/

  // Get current button state.
  newgestureID = g.gestureID;
  newgestureValue = g.gestureValue;

  // Check hover from to
  if (newgestureID != 0 && oldgestureID == 0) {
    switch(newgestureValue){
        case 0: showType = 0;
                   break;
        case 1: Wartezeit(strip.Color(127, 54, 0), strip.Color(255, 54, 0), 0, waitTime, 0); // Red
                   break;    
        case 2: Ladezeitanzeige(strip.Color(54, 54, 54), strip.Color(0, 54, 0), strip.Color(0, 0, 54), 255, 0, 0);
                   break;
        case 3: Ladezustandsanzeige(strip.Color(54, 54, 54), strip.Color(0, 54, 0), strip.Color(0, 54, 54), 255, 0, 0);
                   break;  
        case 4: Laden(strip.Color(0, 54, 0), 255, 0, 0);
                   break;                
    }
    newgestureID = 0;
  }
  // Get current touch state.
  newtouchID = t.touchID;
  newtouchValue = t.touchValue;


  // Check double Tap from to
  if (newtouchID == 3 && oldtouchID == 0) {
    switch(newtouchValue){
        /*case 0: showType = 0;
                   break;
        case 1: showType = 3;
                   break;    
        case 2: showType = 1;
                   break;
        case 3: showType = 2;
                   break;  
        case 4: showType = 4;
                   break;*/                
        case 5: Auffindleuchte(strip.Color(54, 54, 54), 0, 0, 0);
                   break;  
      }
    //startShow(showType);
    newtouchID = 0;    
  }

   
  
  /* if (newState == LOW ) {
      showType = 1;
      if (showType > 9)
        showType=0;
      startShow(showType);
    }
  }
  if (newState == 0x01 && oldState != 0x01) {
    // Short delay to debounce button.
    delay(20);
    // Check if button is still low after debounce.
    newState = 0x00;
  }*/

  // Set the last button state to the old state.
  oldgestureID = newgestureID;
  oldgestureValue = newgestureValue;
  
  //Animation Ladezeitanzeige
  if(activeFunction == 2){
    if (newtouchID == 1 && oldtouchID == 0) {
      switch(newtouchValue){
        case 3: if(Ladestartzeit < 26-Ladedauer) { 
                  Ladestartzeit++;
                  Ladezeitanzeige(strip.Color(54, 54, 54), strip.Color(0, 54, 0), strip.Color(0, 0, 54), 255, 0, 0);
                }
                if(Ladestartzeit+Ladedauer >=26){
                  Ladestartzeit = 0;
                  Ladedauer = 4;
                }
                   break;  
        case 4: if(Ladedauer+Ladestartzeit <= 24) { 
                    Ladedauer++;
                    Ladezeitanzeige(strip.Color(54, 54, 54), strip.Color(0, 54, 0), strip.Color(0, 0, 54), 255, 0, 0);
                  }
                   break;                  
      }
    }
  }
  
  //Animation soll SOC
  if(activeFunction == 3) {
    if (newtouchID == 1 && oldtouchID == 0) {
      switch(newtouchValue){
        case 3: if(sollSOC <= 17){
                  sollSOC++;
                  Ladezustandsanzeige(strip.Color(54, 54, 54), strip.Color(0, 54, 0), strip.Color(0, 54, 54), 255, 0, 0);
                }
                   break;  
        case 4: if(sollSOC >= istSOC) {
                  sollSOC--;
                  Ladezustandsanzeige(strip.Color(54, 54, 54), strip.Color(0, 54, 0), strip.Color(0, 54, 54), 255, 0, 0);
                }
                   break;                  
      }
    //startShow(showType);
    newtouchID = 0;    
    }
    if(showSOC <= istSOC) {
    countUP = true;
    delay(waitTime*2);
    }
    if(showSOC >= sollSOC) {
    countUP = false;
    delay(waitTime*2);
    }
    
    if(currentTime - waitTime > loopTime && showSOC < sollSOC && countUP == true){
      if(showSOC > 12){
        strip.setPixelColor(showSOC, strip.Color(0, 0, 54));
      }
      else {
        strip.setPixelColor(showSOC, strip.Color(0, 54, 0));
      }
      strip.show();
      showSOC++;
      loopTime = currentTime;
    }
    if(currentTime - waitTime > loopTime && showSOC > istSOC && countUP == false){
      if(showSOC > 12){
        strip.setPixelColor(showSOC, strip.Color(54, 54, 54));
      }
      else {
        strip.setPixelColor(showSOC, strip.Color(0, 0, 0));
      }
      strip.show();
      showSOC--;
      loopTime = currentTime;
    }
  }
  // Animation Wartezeit
  if(activeFunction == 4) {
    if(currentTime - waitTime > loopTime){
      strip.setPixelColor(k+3, strip.Color(127, 54, 0));
      strip.show();
      strip.setPixelColor(k+2, strip.Color(255, 54, 0));
      strip.show();
      strip.setPixelColor(k+1, strip.Color(255, 54, 0));
      strip.show();
      strip.setPixelColor(k, strip.Color(127, 54, 0));
      strip.show();
      strip.setPixelColor(k-1, strip.Color(0, 0, 0));
      strip.show();
      k++;
      if(k >= 24) {
        k=0;
        strip.setPixelColor(23, strip.Color(0, 0, 0));
        strip.show();
        //delay(waitTime);
      }
      loopTime = currentTime;
    }
  }
  
  
    // Animation Laden
  if(activeFunction == 5) {
     if(Atmen <= 10) {
    countUP = true;
    delay(waitTime);
    }
    if(Atmen >= 120) {
    countUP = false;
    delay(waitTime);
    }
    if(currentTime - (10) > loopTime) {
      for(uint16_t i = 0; i < strip.numPixels(); i++){
        strip.setPixelColor(i, strip.Color(0, Atmen , 0));
        strip.show();
      }
    if(countUP == true) {
      Atmen = Atmen+5;
    }
    if(countUP == false) {
      Atmen = Atmen-5;
    }
    loopTime = currentTime;  
    }
  }


   
}


/*void startShow(int i) {
  switch(i){
    case 0: colorWipe(strip.Color(0, 0, 0), 50);    // Black/off
            break;
    case 1: colorWipe(strip.Color(255, 0, 0), 0);  // Red
            break;
    case 2: colorWipe(strip.Color(0, 255, 0), 0);  // Green
            break;
    case 3: colorWipe(strip.Color(0, 0, 255), 0);  // Blue
            break;
    case 4: colorWipe(strip.Color(127, 127, 127), 0);  // White
            break;
    case 5: theaterChase(strip.Color(127, 127, 127), 50); // White
            break;
    case 6: theaterChase(strip.Color(127,   0,   0), 50); // Red
            break;
    case 7: theaterChase(strip.Color(  0,   0, 127), 50); // Blue
            break;
    case 8: rainbow(20);
            break;
    case 9: rainbowCycle(20);
            break;
    case 10: theaterChaseRainbow(50);
            break;
  }
}*/


//Auffindleuchte Übergabe Farbe, Helligkeit, Delay, Lage 1. Pixel
void Auffindleuchte(uint32_t color, uint8_t brightness, uint8_t wait, uint8_t StartLED) {
  activeFunction = 1;
  for(uint16_t i = 0; i < strip.numPixels(); i++){
    strip.setPixelColor(i, 0);
    strip.show();
    delay(wait);
  }
  for(uint16_t i = 0; i < strip.numPixels(); i++){
    strip.setPixelColor(i, color);
    strip.show();
    delay(wait);
    /*Serial.print("Auffindleuchte: "); Serial.print(i); Serial.print("\t");
    Serial.print("Farbe: "); Serial.print(color); Serial.print("\t");
    Serial.print("Helligkeit: "); Serial.print(brightness); Serial.print("\t");
    Serial.print("Wait: "); Serial.print(wait); Serial.print("\t");
    Serial.print("StartLED: "); Serial.print(StartLED); Serial.println("");
    */
  }
}

//Ladezeitanzeige Übergabe Farbe, Helligkeit, Delay, Lage 1. StartPixel
void Ladezeitanzeige(uint32_t color1, uint32_t color2, uint32_t color3, uint8_t brightness, uint8_t wait, uint8_t StartLED) {
  activeFunction = 2;
  for(uint16_t i = 0; i < strip.numPixels(); i++){
    strip.setPixelColor(i, 0);
    strip.show();
    //delay(wait);
  }
  for(uint16_t i = 0; i < strip.numPixels(); i++){
    strip.setPixelColor(i, strip.Color(54,54,54));
    strip.show();
    //delay(wait);
  }
  for(uint16_t j = Ladestartzeit; j < Ladestartzeit+Ladedauer; j++){
    strip.setPixelColor(j, strip.Color(0,127,0));
    strip.show();
    //delay(wait);
  }
  for(uint16_t k = 0; k < strip.numPixels(); k=k+6){
    strip.setPixelColor(k, strip.Color(0,0,127));
    strip.setPixelColor(k+1, strip.Color(0,0,127));
    strip.show();
    //delay(wait);
    /*Serial.print("Ladezeitanzeige: "); Serial.print(k); Serial.print("\t");
    Serial.print("Farbe: "); Serial.print(color3); Serial.print("\t");
    Serial.print("Helligkeit: "); Serial.print(brightness); Serial.print("\t");
    Serial.print("Wait: "); Serial.print(wait); Serial.print("\t");
    Serial.print("StartLED: "); Serial.print(StartLED); Serial.println("");
    */
  }
}


//Ladezustandsanzeige Übergabe Farbe, Helligkeit, Delay, Lage 1. StartPixel
void Ladezustandsanzeige(uint32_t color1, uint32_t color2, uint32_t color3, uint8_t brightness, uint8_t wait, uint8_t StartLED) {
  activeFunction = 3;
  showSOC = istSOC;
  for(uint16_t i = 0; i < strip.numPixels(); i++){
    strip.setPixelColor(i, 0);
    strip.show();
    delay(wait);
  }
  for(uint16_t i = 13; i < strip.numPixels(); i++){
    strip.setPixelColor(i, color1);
    strip.show();
    delay(wait);
  }
  for(uint16_t i = 0; i < 1; i++){
    strip.setPixelColor(i, color1);
    strip.show();
    delay(wait);
  }
  for(uint16_t j = 1; j < istSOC; j++){
    strip.setPixelColor(j, color2);
    strip.show();
    delay(wait);
  }
  //if(currentTime - waitTime > loopTime && k < sollSOC && sollSoc
  
  /*
  for(uint16_t k = istSOC; k < sollSOC; k++){
    strip.setPixelColor(k, color3);
    strip.show();
    delay(100);
  }
  for(uint16_t k = sollSOC; k > istSOC; k--){
    strip.setPixelColor(k, 0);
    strip.show();
    delay(100);
    
    Serial.print("Ladezeitanzeige: "); Serial.print(k); Serial.print("\t");
    Serial.print("Farbe: "); Serial.print(color3); Serial.print("\t");
    Serial.print("Helligkeit: "); Serial.print(brightness); Serial.print("\t");
    Serial.print("Wait: "); Serial.print(wait); Serial.print("\t");
    Serial.print("StartLED: "); Serial.print(StartLED); Serial.println("");
    
  }*/
}


void Wartezeit(uint32_t color1, uint32_t color2, uint8_t brightness, uint8_t wait, uint8_t StartLED) {
  activeFunction = 4;
  for(uint16_t i = 0; i < strip.numPixels(); i++){
    strip.setPixelColor(i, 0);
    strip.show();
    //delay(wait);
  }
  /*for (int j=0; j<10; j++) {
    for(uint16_t i = 0; i < strip.numPixels()+4; i++){
      strip.setPixelColor(i, color1);
      strip.show();
      strip.setPixelColor(i-1, color2);
      strip.show();
      strip.setPixelColor(i-2, color2);
      strip.show();
      strip.setPixelColor(i-3, color1);
      strip.show();
      strip.setPixelColor(i-4, 0);
      strip.show();
      delay(wait);
    Serial.print("Auffindleuchte: "); Serial.print(i); Serial.print("\t");
    Serial.print("Farbe: "); Serial.print(color); Serial.print("\t");
    Serial.print("Helligkeit: "); Serial.print(brightness); Serial.print("\t");
    Serial.print("Wait: "); Serial.print(wait); Serial.print("\t");
    Serial.print("StartLED: "); Serial.print(StartLED); Serial.println("");
    
    }
  }*/
}


void Laden(uint32_t color, uint8_t brightness, uint8_t wait, uint8_t StartLED) {
  activeFunction = 5;
  for(uint16_t i = 0; i < strip.numPixels(); i++){
    strip.setPixelColor(i, 0);
    strip.show();
    //delay(wait);
  }
  
  
  /*for(uint16_t i = 0; i < strip.numPixels(); i++){
    strip.setPixelColor(i, color);
    strip.show();
    delay(wait);
    Serial.print("Auffindleuchte: "); Serial.print(i); Serial.print("\t");
    Serial.print("Farbe: "); Serial.print(color); Serial.print("\t");
    Serial.print("Helligkeit: "); Serial.print(brightness); Serial.print("\t");
    Serial.print("Wait: "); Serial.print(wait); Serial.print("\t");
    Serial.print("StartLED: "); Serial.print(StartLED); Serial.println("");
    
  }*/
}



// Fill the dots one after the other with a color
void colorWipe(uint32_t c, uint8_t wait) {
  for(uint16_t i=0; i<strip.numPixels(); i++) {
    strip.setPixelColor(i, c);
    strip.show();
    delay(wait);
  }
}

void rainbow(uint8_t wait) {
  uint16_t i, j;

  for(j=0; j<256; j++) {
    for(i=0; i<strip.numPixels(); i++) {
      strip.setPixelColor(i, Wheel((i+j) & 255));
    }
    strip.show();
    delay(wait);
  }
}

// Slightly different, this makes the rainbow equally distributed throughout
void rainbowCycle(uint8_t wait) {
  uint16_t i, j;

  for(j=0; j<256*5; j++) { // 5 cycles of all colors on wheel
    for(i=0; i< strip.numPixels(); i++) {
      strip.setPixelColor(i, Wheel(((i * 256 / strip.numPixels()) + j) & 255));
    }
    strip.show();
    delay(wait);
  }
}

//Theatre-style crawling lights.
void theaterChase(uint32_t c, uint8_t wait) {
  for (int j=0; j<10; j++) {  //do 10 cycles of chasing
    for (int q=0; q < 3; q++) {
      for (int i=0; i < strip.numPixels(); i=i+3) {
        strip.setPixelColor(i+q, c);    //turn every third pixel on
      }
      strip.show();

      delay(wait);

      for (int i=0; i < strip.numPixels(); i=i+3) {
        strip.setPixelColor(i+q, 0);        //turn every third pixel off
      }
    }
  }
}

//Theatre-style crawling lights with rainbow effect
void theaterChaseRainbow(uint8_t wait) {
  for (int j=0; j < 256; j++) {     // cycle all 256 colors in the wheel
    for (int q=0; q < 3; q++) {
      for (int i=0; i < strip.numPixels(); i=i+3) {
        strip.setPixelColor(i+q, Wheel( (i+j) % 255));    //turn every third pixel on
      }
      strip.show();

      delay(wait);

      for (int i=0; i < strip.numPixels(); i=i+3) {
        strip.setPixelColor(i+q, 0);        //turn every third pixel off
      }
    }
  }
}

// Input a value 0 to 255 to get a color value.
// The colours are a transition r - g - b - back to r.
uint32_t Wheel(byte WheelPos) {
  WheelPos = 255 - WheelPos;
  if(WheelPos < 85) {
    return strip.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  }
  if(WheelPos < 170) {
    WheelPos -= 85;
    return strip.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  }
  WheelPos -= 170;
  return strip.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
}
