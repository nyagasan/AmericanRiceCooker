const int SENSOR_PIN = A0;
const int LED_PIN = 11;
const int DELAY_TIME = 10;

bool ledOn = false;
int lastSensorValue = 0;
const int SENSOR_THRESHOLD = 5;

unsigned long lastBlinkTime = 0;
const int BLINK_INTERVAL = 100; // LED点滅間隔（ミリ秒）

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  int sensorValue = analogRead(SENSOR_PIN);
  
  if (abs(sensorValue - lastSensorValue) > SENSOR_THRESHOLD) {
    Serial.println(sensorValue);
    lastSensorValue = sensorValue;
  }
  
  if (Serial.available() > 0) {
    char command = Serial.read();
    ledOn = (command == '1');
  }
  
  if (ledOn) {
    blinkLED();
  } else {
    digitalWrite(LED_PIN, LOW);
  }
  
  delay(DELAY_TIME);
}

void blinkLED() {
  unsigned long currentTime = millis();
  if (currentTime - lastBlinkTime >= BLINK_INTERVAL) {
    lastBlinkTime = currentTime;
    digitalWrite(LED_PIN, !digitalRead(LED_PIN));
  }
}