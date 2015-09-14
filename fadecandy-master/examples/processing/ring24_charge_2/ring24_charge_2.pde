OPC opc;
PImage dot;
PImage dot_sharp;
float loopTime = 0;
boolean chargePortOpen = false;
boolean connecting = true;
boolean charge = false;
int wait = 8000;
float currentTime;
float atmenLED = -0.0025; //0.0025 => langsam/Ladeende 0.05 => schnell/Ladebegin
int istSOC = 1;
int sollSOC = 15;
int Stunde = 3;
int Minute = 0;
int wait_1 = 500;
float pi = 3.1415926535897932384626433832795028841971693993751058;
float a = -2*pi/24;


void setup()
{
  currentTime = millis();
  size(500, 500);
  

  // Load a sample image
  dot = loadImage("dot.png");
  //dot_sharp = loadImage("sharp-dot.png");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map one 24-LED ring to the center of the window

  opc.ledRing(0, 24, width/2, height/2, width*0.3, 0);
}


void drawDot(float angle, float distance, float size)
{
  image(dot, width/2 - distance * sin(angle) - size/2,
    height/2 - distance * cos(angle) - size/2, size, size);
}

void drawDot_sharp(float angle, float distance, float size)
{
  image(dot, width/2 - distance * sin(angle) - size/2,
    height/2 - distance * cos(angle) - size/2, size, size);
}



void draw()
{
  background(0); 
 currentTime = millis();
    
  blendMode(ADD);

//black
  if (chargePortOpen == false && connecting == false && charge == false){
    tint(0,0,0); //weiß
    drawDot(a*0, width*0, width*0); 
    //drawDot(0, width*0, width*(1.9+sin(-0.005*currentTime)));
  }

//Aufindbeleuchtung
  if (chargePortOpen == true && connecting == false && charge == false){
    tint(204,204,204); //weiß
    for (int i = 0; i < 24; i++){
     drawDot(a*i, width*0.3, 20); 
    }
  }

// Connecting time
  if(chargePortOpen == true && connecting == true && charge == false){
      tint(255, 200, 51); //orange
      //tint(0, 0, 255); //blau
      drawDot(a*currentTime*0.01, width*0.3, 300);
  }

//Atmen 
  if (chargePortOpen == true && connecting == true && charge == true){
    tint(51,255,51); //grün
    //tint(255, 51, 51); //rot
    //tint(255, 200, 51); //orange
   //drawDot(0, width*0, 750*(1.0+0.15*asin(sin(atmenLED*currentTime))));
   drawDot(0, width*0, 750*(1.0+0.15*sin(atmenLED*currentTime)));
    
  }
  
//SOC Statusanzeige
  if(chargePortOpen == false && connecting == true && charge == false) { 
    //Stefan_soc_1();
    //Stefan_soc_2();
    Riemer_soc();
  }
  
//Uhr anzeige
  if(chargePortOpen == false && connecting == false && charge == true) { 
    Riemer_clk();
    /*tint(100, 100, 100);
    for (int i = 1; i <= 5; i++){
      drawDot(a*i, width*0.35, width*0.05);
    }
    for (int i = 7 ; i <= 11; i++){
      drawDot(a*i, width*0.35, width*0.05);
    }
    for (int i = 13 ; i <= 17; i++){
      drawDot(a*i, width*0.35, width*0.05);
    }
    for (int i = 19 ; i <= 23; i++){
      drawDot(a*i, width*0.35, width*0.05);
    }
    //Stunde
    tint(255, 0, 0); //rot
    drawDot(a*16, width*0.18, width*0.1);
    //Minute
    tint(0, 255, 0); //blau
    for (int i = 5; i <= 5; i++){
       drawDot(a*i*0.003*currentTime, width*0.18, width*0.1); 
    }/*
    // 2te Uhr
    if(chargePortOpen == false && connecting == false && charge == true) { 
    tint(100, 100, 100);
    for (int i = 0; i <= 0; i++){
      drawDot(b*i, width*0.18, width*0.05);
    }
    for (int i = 6 ; i <= 6; i++){
      drawDot(b*i, width*0.18, width*0.05);
    }
    for (int i = 12 ; i <= 12; i++){
      drawDot(b*i, width*0.18, width*0.05);
    }
    for (int i = 18 ; i <= 18; i++){
      drawDot(b*i, width*0.18, width*0.05);
    }
    //Stunde
    tint(255, 0, 0); //rot
    drawDot(b*16, width*0.18, width*0.1);
    //Minute
    tint(0, 0, 255); //blau
    for (int i = 2; i <= 2; i++){
       drawDot(b*i*0.003*currentTime, width*0.18, width*0.2*1.0+(asin(sin(-0.0025*currentTime)))); 
    }*/
  }
  
/*  //Animation
  if (currentTime >= (loopTime + wait) && chargePortOpen == false && connecting == false && charge == false) {
    chargePortOpen = true;
    connecting = false;
    charge = false;
    loopTime = currentTime;
  }
    if (currentTime >= (loopTime + wait) && chargePortOpen == true && connecting == false && charge == false) {
    chargePortOpen = false;
    connecting = false;
    charge = true;
    loopTime = currentTime;
  }
    if (currentTime >= (loopTime + wait) && chargePortOpen == false && connecting == false && charge == true) {
    chargePortOpen = false;
    connecting = true;
    charge = false;
    loopTime = currentTime;
  }
    if (currentTime >= (loopTime + wait) && chargePortOpen == false && connecting == true && charge == false) {
    chargePortOpen = true;
    connecting = true;
    charge = false;
    loopTime = currentTime;
  }  
  if (currentTime >= (loopTime + wait) && chargePortOpen == true && connecting == true && charge == false) {
    chargePortOpen = true;
    connecting = true;
    charge = true;
    loopTime = currentTime;
  }
  if (currentTime >= (loopTime + wait) && chargePortOpen == true && connecting == true && charge == true) {
    chargePortOpen = true;
    connecting = false;
    charge = false;
    loopTime = currentTime;
  }
*/
}
void Stefan_soc_1(){
  
  currentTime = millis();  
  for (int i = 0; i <= istSOC; i++){
    switch (i) {
    case 0: tint(255, 51, 51); //rot
            break;
    case 1: tint(255, 51, 51); //rot
            break;
    case 2: tint(255, 200, 51); //orange
            break;
    case 3: tint(255, 200, 51); //orange
            break;
    default:tint(51, 255, 51); //grün
            break; 
    }
    drawDot(a*i, width*0.3, width*0.05);
  }
  for (int i = istSOC+1; i < sollSOC; i++){
    switch (i) {
    case 0: tint(255, 51, 51); //rot
            break;
    case 1: tint(255, 51, 51); //rot
            break;
    case 2: tint(255, 200, 51); //orange
            break;
    case 3: tint(255, 200, 51); //orange
            break;
    default:tint(51, 255, 51); //grün
            break; 
    }
    drawDot(a*i, width*0.3, 0.05*width*(asin(sin(-0.0025*currentTime))));
  }
}

// SOC Statusanzeige Vollkreis
void Stefan_soc_2(){
  currentTime = millis();  
  for (int i = 1; i <= istSOC; i++){
      switch (i) {
      case 1: tint(255, 51, 51); //rot
              break;
      case 2: tint(255, 51, 51); //rot
              break;
      case 3: tint(255, 200, 51); //orange
              break;
      case 4: tint(255, 200, 51); //orange
              break;
      default:tint(51, 255, 51); //grün
              break; 
      }
      drawDot(a*i, width*0.3, width*0.03);
  }
    //SollSOC Anzeige
  for (int i = istSOC+1; i <= sollSOC; i++){
    switch (i) {
    case 1: tint(255, 51, 51); //rot
            break;
    case 2: tint(255, 51, 51); //rot
            break;
    case 3: tint(255, 200, 51); //orange
            break;
    case 4: tint(255, 200, 51); //orange
            break;
    default:tint(51, 255, 51); //grün
            break; 
    }
    
      //drawDot(a*i, width*0.35, width*0.06*(sin(0.001*currentTime)));
      //drawDot(a*i, width*0.3, width*0.01); // schwach beleuchtet der SollSOC
      //drawDot(a*i, width*0.3, width*0.03*min(0,(sin(0.003*currentTime)))); 
      drawDot_sharp(a*i, width*0.31, width*0.1*min(1,(sin(0.002*currentTime)))); 
  }
}
void Riemer_soc(){
  currentTime = millis();  
  for (int i = 19; i <= 19+istSOC; i++){
      switch (i) {
      /*case 19: tint(255, 51, 51); //rot
              break;
      case 20: tint(255, 51, 51); //rot
              break;
      case 21: tint(255, 200, 51); //orange
              break;
      case 22: tint(255, 200, 51); //orange
              break;*/
      default:tint(51, 255, 51); //grün
              break; 
      }
      drawDot_sharp(a*i, width*0.3, width*0.03);
  }
    //SollSOC Anzeige mit Range Mode Halbkreis
  for (int i = 19+istSOC+1; i < 19+sollSOC; i++){
    switch (i) {
    case 7+24: tint(0, 204, 204); //türkis
            break;
    case 8+24: tint(0, 204, 204); //tükis
            break;
    case 9+24: tint(0, 204, 204); //türkis
            break;
      /* case 19: tint(255, 51, 51); //rot
            break;
    case 20: tint(255, 51, 51); //rot
            break;
    case 21: tint(255, 200, 51); //orange
            break;
    case 22: tint(255, 200, 51); //orange
            break;*/
    default:tint(51, 255, 51); //grün
            break; 
    }
    
      //drawDot(a*i, width*0.35, width*0.06*(sin(0.001*currentTime)));
      //drawDot(a*i, width*0.3, width*0.01); // schwach beleuchtet der SollSOC
      //drawDot(a*i, width*0.3, width*0.03*min(0,(sin(0.003*currentTime)))); 
      drawDot_sharp(a*i, width*0.29, width*0.1*min(1,(sin(0.002*currentTime)))); 
  }
   for (int i = 19+12; i < 19+24; i++){
      tint(51, 51, 51);
      drawDot_sharp(a*i, width*0.3, width*0.03); 
  }
}


void Riemer_soc_2(){
  currentTime = millis();  
  for (int i = 19; i <= 19+istSOC; i++){
      switch (i) {
      /*case 19: tint(255, 51, 51); //rot
              break;
      case 20: tint(255, 51, 51); //rot
              break;
      case 21: tint(255, 200, 51); //orange
              break;
      case 22: tint(255, 200, 51); //orange
              break;*/
      default:tint(51, 255, 51); //grün
              break; 
      }
      drawDot_sharp(a*i, width*0.3, width*0.03);
  }
    //SollSOC Anzeige mit Range Mode Halbkreis
  for (int i = 19+istSOC+1; i < 19+sollSOC; i++){
    switch (i) {
    case 7+24: tint(0, 204, 204); //türkis
            break;
    case 8+24: tint(0, 204, 204); //tükis
            break;
    case 9+24: tint(0, 204, 204); //türkis
            break;
      /* case 19: tint(255, 51, 51); //rot
            break;
    case 20: tint(255, 51, 51); //rot
            break;
    case 21: tint(255, 200, 51); //orange
            break;
    case 22: tint(255, 200, 51); //orange
            break;*/
    default:tint(51, 255, 51); //grün
            break; 
    }
    
      //drawDot(a*i, width*0.35, width*0.06*(sin(0.001*currentTime)));
      //drawDot(a*i, width*0.3, width*0.01); // schwach beleuchtet der SollSOC
      //drawDot(a*i, width*0.3, width*0.03*min(0,(sin(0.003*currentTime)))); 
      drawDot_sharp(a*i, width*0.29, width*0.1*min(1,(sin(0.002*currentTime)))); 
  }
   for (int i = 19+12; i < 19+24; i++){
      tint(51, 51, 51);
      drawDot_sharp(a*i, width*0.3, width*0.03); 
  }
}

//Uhr anzeige
void Riemer_clk(){
    for (int i = 1; i <= 24; i++){
    switch (i) {
    /*case 1: tint(0, 20, 0); //grün
            break;
    case 2: tint(0, 40, 0); //grün
            break;
    case 3: tint(0, 60, 0); //grün
            break;
    case 4: tint(0, 80, 0); //grün
            break;
            */
    case 5: tint(0, 100, 0); //grün
            break;
    case 7: tint(0, 140, 0); //grün
            break;
    case 8: tint(0, 160, 0); //grün
            break;
    case 9: tint(0, 180, 0); //grün
            break;
    case 10: tint(0, 200, 0); //grün
            break;
    case 11: tint(0, 220, 0); //grün
            break;
    case 13: tint(24, 255, 24); //grün
            break;
    case 14: tint(51, 255, 51); //grün
            break;
    case 6: tint(51, 0, 102); //violett
            break;
    case 12: tint(51, 0, 102); //violett
            break;
    case 18: tint(51, 0, 102); //violett
            break;
    case 24: tint(51, 0, 102); //violett
            break;
    default:tint(51, 51, 51); //weiß
            break; 
    }
    drawDot(a*i, width*0.3, width*0.05);
    }
    
    /*tint(51, 255, 51); //grün
    drawDot(a*16, width*0.18, width*0.1);
    //Ende
    tint(0, 255, 0); //blau
    for (int i = 5; i <= 5; i++){
       drawDot(a*i*0.003*currentTime, width*0.18, width*0.1); 
    }*/
}
