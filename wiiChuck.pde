

#include <math.h>

#include <Servo.h> 

#include "Wire.h"
#include "WiiChuck.h"
//#include "nunchuck_funcs.h"

#define MAXANGLE 90
#define MINANGLE -90

Servo myservo;  // create servo object to control a servo 
Servo myservo2;  // create servo object to control a servo 
int pos = 0;
int posX = 0;

WiiChuck chuck = WiiChuck();
int angleStart, currentAngle;
int tillerStart = 0;
double angle;

void setup() {
  //nunchuck_init();

  myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
  myservo2.attach(10);  // attaches the servo on pin 9 to the servo object 

  Serial.begin(115200);
  chuck.begin();
  chuck.update();
  //chuck.calibrateJoy();
}

float conv(int chuck){ 
  if(chuck>0){
    return (float)(90+chuck*(90.0/110.0));
  } 
  else {
    return (float)(90.0+chuck*(90.0/102.0));
  } 
}


float convX(int chuck){ 
  if(chuck>0){
    return (float)(90+chuck*(90.0/96.0));
  } 
  else {
    return (float)(90.0+chuck*(90.0/99.0));
  } 
}

int sPos = 90;
int sXPos = 90;

void sweep(){
  for(pos = 90; pos < 120; pos += 1)  // goes from 0 degrees to 180 degrees 
  {                                  // in steps of 1 degree 
    myservo.write(pos);              // tell servo to go to position in variable 'pos' 
    delay(200);                       // waits 15ms for the servo to reach the position 
  } 
  for(pos = 120; pos>=90; pos-=1)     // goes from 180 degrees to 0 degrees 
  {                                
    myservo.write(pos);              // tell servo to go to position in variable 'pos' 
    delay(200);                       // waits 15ms for the servo to reach the position 
  } 
}

void chuck2servo(){
  delay(50);
  chuck.update(); 

  pos = chuck.readJoyY();
  posX = chuck.readJoyX();
  sPos = conv(pos);
  sXPos = 180-conv(posX);

  Serial.print("y:");
  Serial.print(pos);
  Serial.print(" x:");
  Serial.print(posX);
  Serial.print(" convY:");
  Serial.print(sPos);
  Serial.print(" convX:");
  Serial.print(sXPos);
  Serial.print(" z:");
  Serial.print(chuck.zPressed()?"z_on ":"z_off");
  Serial.print(" c:");
  Serial.print(chuck.cPressed()?"c_on ":"c_off");
  Serial.println();

  if(chuck.zPressed()){
    myservo.write(sPos);
    myservo2.write(sXPos);
  } 
  else {
    myservo.write(90);
    myservo2.write(90);
  }  
}

void loop() {

  chuck2servo();  

  /**
   * Serial.print(chuck.zPressed()?"z_on ":"z_off");
   * Serial.print(", ");
   * 
   * Serial.print(chuck.cPressed()?"c_on ":"c_off");
   * Serial.print(", ");
   * 
   * myservo.write(chuck.readJoyY()); 
   * 
   * Serial.print(chuck.readJoyX());
   * Serial.print(", ");
   * 
   * 
   * Serial.print(chuck.readJoyY());
   * Serial.print(", ");
   **/


  /** Serial.print(chuck.readRoll());
   * Serial.print(", ");  
   * Serial.print(chuck.readPitch());
   * Serial.print(", ");  
   * 
   * Serial.print((int)chuck.readAccelX()); 
   * Serial.print(", ");  
   * Serial.print((int)chuck.readAccelY()); 
   * Serial.print(", ");  
   * 
   * Serial.print((int)chuck.readAccelZ()); 
   * Serial.println();
   **/

}



