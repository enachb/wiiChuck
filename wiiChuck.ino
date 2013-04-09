#include <EEPROM.h>
#include <math.h>

#include <Servo.h> 

#include "Wire.h"
#include "WiiChuck.h"
//#include "nunchuck_funcs.h"

#define MAXANGLE 90
#define MINANGLE -90
#define DIV_ADDR 0

Servo myservo;  // create servo object to control a servo 
Servo myservo2;  // create servo object to control a servo 

// nunchuck pos
int posY = 0;
int posX = 0;

// servo pos
int sYPos = 90;
int sXPos = 90;

// default is half speed
//int div = 2;

WiiChuck chuck = WiiChuck();
int angleStart, currentAngle;
int tillerStart = 0;
double angle;

void setup() {

//  // check if we have ever written into it. if not initialize it with default.
//  int init_div = EEPROM.read(DIV_ADDR);
//  if( init_div > 20 || init_div <= 0 ){
//    EEPROM.write(DIV_ADDR, div);
//  } else {
//    // we have written it before. restore it so it survives restarts.
//     div =  EEPROM.read(DIV_ADDR);
//  }

  myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
  myservo2.attach(10);  // attaches the servo on pin 9 to the servo object 

  Serial.begin(115200);
  chuck.begin();
  chuck.update();
}

float convY(int chuck){ 

  return 90.6185+0.9278*(float)chuck;

//  if(chuck>0){
//    return (float)(90+chuck*(90.0/110.0));
//  } 
//  else {
//    return (float)(90.0+chuck*(90.0/102.0));
//  } 
}


float convX(int chuck){ 
  return (float)91.7138-0.8569*(float)chuck;
}

//float convX(int chuck){ 
//  if(chuck>0){
//    return (float)(90+chuck*(90.0/96.0));
//  } 
//  else {
//    return (float)(90.0+chuck*(90.0/99.0));
//  } 
//}

void chuck2servo(){
  delay(50);
  chuck.update(); 

  while(chuck.zPressed() && chuck.cPressed()){
    delay(1000);
    // if still pressed increase sensitity
    chuck.update();
    if(chuck.zPressed() && chuck.cPressed()){
//      incDiv();    
    }    
  }

  posY = chuck.readJoyY();
  posX = chuck.readJoyX();
  sYPos = convY(posY);
  sXPos = convX(posX);

  Serial.print("y:");
  Serial.print(posY);
  Serial.print(" x:");
  Serial.print(posX);
  Serial.print(" convY:");
  Serial.print(sYPos);
  Serial.print(" convX:");
  Serial.print(sXPos);
  Serial.print(" z:");
  Serial.print(chuck.zPressed()?"z_on ":"z_off");
  Serial.print(" c:");
  Serial.print(chuck.cPressed()?"c_on ":"c_off");
  Serial.println();

  if(chuck.zPressed()){
    myservo.write(sYPos);
    myservo2.write(sXPos);
  } 
  else {
    myservo.write(90);
    myservo2.write(90);
  }  
}

void loop() {

  chuck2servo();  

}



