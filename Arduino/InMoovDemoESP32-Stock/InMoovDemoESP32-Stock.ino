#include <ESP32Servo.h>

// Servo commands
#define CMDS_HEADYAW 1
#define CMDS_HEADPITCH 2
#define CMDS_JAW 3
#define CMDS_EYEX 4
#define CMDS_EYEY 5
#define CMDS_EYE_LEFT 6
#define CMDS_EYE_RIGHT 7
// Animations
#define CMDA_EYE_BLINK 100
#define CMDA_JAW_OPEN_CLOSE 110
#define CMDA_JAW_TALK 111
#define CMDA_HEAD_YES 120
#define CMDA_HEAD_NO 121
// System
#define CMDS_DEMO_MODE 200
#define CMDS_DEMO_MODE_TIMING 201

// Config
#define SERVO_COUNT 5
#define SERVO_MIN_MS 1000
#define SERVO_MAX_MS 2000
#define HEADYAW_IDX 0
#define HEADPITCH_IDX 1
#define JAW_IDX 2
#define EYEX_IDX 3
#define EYEY_IDX 4

// Pins
#define US_LEFT_TRIGGER_PIN 5
#define US_LEFT_ECHO_PIN 18
#define US_RIGHT_TRIGGER_PIN 17
#define US_RIGHT_ECHO_PIN 16
#define PIR_PIN 4
#define SERVO_HEADYAW_PIN 13
#define SERVO_HEADPITCH_PIN 12
#define SERVO_EYEX_PIN 14
#define SERVO_EYEY_PIN 27
#define SERVO_JAW_PIN 26
#define LED_LEFT_EYE_PIN 32
#define LED_RIGHT_EYE_PIN 33

// Neutral
#define NEUTRAL_HEADYAW 90
#define NEUTRAL_HEADPITCH 90
#define NEUTRAL_EYEX 130
#define NEUTRAL_EYEY 105
#define NEUTRAL_JAW 45

// Servo
Servo* servos[SERVO_COUNT];
// States
int previousPIR;
bool demoModeOn = true;
int demoModeTiming = 3500;

long ReadUltrasonicDistance(int trigPin, int echoPin) {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  return pulseIn(echoPin, HIGH) / 58.2;
}

int ReadPIR() {
  return digitalRead(PIR_PIN);
}

void MoveServo(Servo* servo, int pin, int position) {
  if (position < 0) {
    position = 0;
  } else if (position > 180) {
    position = 180;
  }

  if (!servo->attached()) {
    servo->attach(pin, SERVO_MIN_MS, SERVO_MAX_MS);
  }

  servo->write(position);
}

void AnimBlinkEyes() {
  digitalWrite(LED_LEFT_EYE_PIN, LOW);
  digitalWrite(LED_RIGHT_EYE_PIN, LOW);
  delay(1000);
  digitalWrite(LED_LEFT_EYE_PIN, HIGH);
  digitalWrite(LED_RIGHT_EYE_PIN, HIGH);
}

void AnimJawOpenClose() {
  MoveServo(servos[JAW_IDX], SERVO_JAW_PIN, 180);
  delay(500);
  MoveServo(servos[JAW_IDX], SERVO_JAW_PIN, NEUTRAL_JAW);
}

void AnimJawTalk() {
  for (int i = 0; i < 5; i++) {
    MoveServo(servos[JAW_IDX], SERVO_JAW_PIN, 180);
    delay(500);
    MoveServo(servos[JAW_IDX], SERVO_JAW_PIN, NEUTRAL_JAW);
    delay(500);
  }
}

void AnimHeadYes() {
  MoveServo(servos[HEADPITCH_IDX], SERVO_HEADPITCH_PIN, NEUTRAL_HEADPITCH + 10);
  delay(500);
  MoveServo(servos[HEADPITCH_IDX], SERVO_HEADPITCH_PIN, 0);
  delay(500);
  MoveServo(servos[HEADPITCH_IDX], SERVO_HEADPITCH_PIN, NEUTRAL_HEADPITCH);
}

void AnimHeadNo() {
  MoveServo(servos[HEADYAW_IDX], SERVO_HEADYAW_PIN, NEUTRAL_HEADYAW + 40);
  delay(500);
  MoveServo(servos[HEADYAW_IDX], SERVO_HEADYAW_PIN, NEUTRAL_HEADYAW - 40);
  delay(500);
  MoveServo(servos[HEADYAW_IDX], SERVO_HEADYAW_PIN, NEUTRAL_HEADYAW);
}

void MoveServoThenNeutral(Servo* servo, int pin, int position, int neutral, int wait) {
  MoveServo(servo, pin, position);
  delay(wait);
  MoveServo(servo, pin, neutral);
}

void DemoMode() {
  /*int pir = ReadPIR();
  Serial.printf("PIR: %d\n", pir);

  if (pir != previousPIR) {
    if (pir) {
      AnimBlinkEyes();
    }

    previousPIR = pir;
  }

  long leftUS = ReadUltrasonicDistance(leftUSTriggerPin, leftUSEchoPin);
  Serial.printf("Left Ultrasonic Sensor: %ld\n", leftUS);
  long rightUS = ReadUltrasonicDistance(rightUSTriggerPin, rightUSEchoPin);
  Serial.printf("Right Ultrasonic Sensor: %ld\n", rightUS);*/

  int action = random(0, 10);
  switch (action) {
    case 0:
      MoveServoThenNeutral(servos[HEADYAW_IDX], SERVO_HEADYAW_PIN, random(NEUTRAL_HEADYAW - 30, NEUTRAL_HEADYAW + 30), NEUTRAL_HEADYAW, 1000);
      break;
    case 1:
      MoveServoThenNeutral(servos[HEADPITCH_IDX], SERVO_HEADPITCH_PIN, random(30, NEUTRAL_HEADPITCH), NEUTRAL_HEADPITCH, 1000);
      break;
    case 2:
      AnimJawOpenClose();
      break;
    case 3:
      MoveServoThenNeutral(servos[EYEX_IDX], SERVO_EYEX_PIN, random(NEUTRAL_EYEX - 60, NEUTRAL_EYEX + 60), NEUTRAL_EYEX, 1000);
      break;
    case 4:
      MoveServoThenNeutral(servos[EYEY_IDX], SERVO_EYEY_PIN, random(NEUTRAL_EYEX - 60, NEUTRAL_EYEX + 60), NEUTRAL_EYEY, 1000);
      break;
    case 5:
      AnimBlinkEyes();
      break;
    case 6:
      AnimHeadYes();
      break;
    case 7:
      AnimHeadNo();
    case 8:
      AnimJawTalk();
      break;
  }

  delay(demoModeTiming);

  for (int i = 0; i < SERVO_COUNT; i++) {
    servos[i]->detach();
  }
}

void ParseExternalCommands(String inputString) {
  Serial.println(inputString);

  int separatorIndex = inputString.indexOf('=');
  String command = inputString.substring(0, separatorIndex);
  String commandValue = inputString.substring(separatorIndex + 1);
  int commandInt = command.toInt();
  int commandValueInt = commandValue.toInt();

  if (commandInt == CMDS_DEMO_MODE) {
    demoModeOn = commandValueInt == 1;
  } else if (commandInt == CMDS_DEMO_MODE_TIMING) {
    demoModeTiming = commandValueInt;
  }

  if (demoModeOn) {
    return;
  }

  switch (commandInt) {
    case CMDS_HEADYAW:
      MoveServo(servos[HEADYAW_IDX], SERVO_HEADYAW_PIN, commandValueInt);
      break;
    case CMDS_HEADPITCH:
      MoveServo(servos[HEADPITCH_IDX], SERVO_HEADPITCH_PIN, commandValueInt);
      break;
    case CMDS_JAW:
      MoveServo(servos[JAW_IDX], SERVO_JAW_PIN, commandValueInt);
      break;
    case CMDS_EYEX:
      MoveServo(servos[EYEX_IDX], SERVO_EYEX_PIN, commandValueInt);
      break;
    case CMDS_EYEY:
      MoveServo(servos[EYEY_IDX], SERVO_EYEY_PIN, commandValueInt);
      break;
    case CMDS_EYE_LEFT:
      digitalWrite(LED_LEFT_EYE_PIN, commandValueInt == 1 ? HIGH : LOW);
      break;
    case CMDS_EYE_RIGHT:
      digitalWrite(LED_RIGHT_EYE_PIN, commandValueInt == 1 ? HIGH : LOW);
      break;
    // Animations
    case CMDA_EYE_BLINK:
      AnimBlinkEyes();
      break;
    case CMDA_JAW_OPEN_CLOSE:
      AnimJawOpenClose();
      break;
    case CMDA_HEAD_YES:
      AnimHeadYes();
      break;
    case CMDA_HEAD_NO:
      AnimHeadNo();
      break;
  }
}

void setup() {
  Serial.begin(115200);

  for (int i = 0; i < SERVO_COUNT; i++) {
    servos[i] = new Servo();
    servos[i]->setPeriodHertz(50);
  }

  pinMode(LED_LEFT_EYE_PIN, OUTPUT);
  pinMode(LED_RIGHT_EYE_PIN, OUTPUT);
  pinMode(US_LEFT_TRIGGER_PIN, OUTPUT);
  pinMode(US_LEFT_ECHO_PIN, INPUT);
  pinMode(US_RIGHT_TRIGGER_PIN, OUTPUT);
  pinMode(US_RIGHT_ECHO_PIN, INPUT);
  pinMode(PIR_PIN, INPUT);

  AnimBlinkEyes();
  MoveServo(servos[HEADYAW_IDX], SERVO_HEADYAW_PIN, NEUTRAL_HEADYAW);
  delay(500);
  servos[HEADYAW_IDX]->detach();

  MoveServo(servos[HEADPITCH_IDX], SERVO_HEADPITCH_PIN, NEUTRAL_HEADPITCH);
  delay(500);
  servos[HEADPITCH_IDX]->detach();

  MoveServo(servos[JAW_IDX], SERVO_JAW_PIN, NEUTRAL_JAW);
  delay(500);
  servos[JAW_IDX]->detach();

  MoveServo(servos[EYEX_IDX], SERVO_EYEX_PIN, NEUTRAL_EYEX);
  delay(500);
  servos[EYEX_IDX]->detach();

  MoveServo(servos[EYEY_IDX], SERVO_EYEY_PIN, NEUTRAL_EYEY);
  delay(500);
  servos[EYEY_IDX]->detach();

  previousPIR = ReadPIR();
}

void loop() {
  if (Serial.available()) {
    String inputString = Serial.readStringUntil('\n');
    ParseExternalCommands(inputString);
  }

  if (demoModeOn) {
    DemoMode();
  }
}
