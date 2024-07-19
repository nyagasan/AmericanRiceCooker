const int SENSOR_PIN = A0;
const int LED_PIN = 11;
const int THRESHOLD = 100;
const int DELAY_TIME = 100;

void setup() {
  Serial.begin(9600);
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  int sensorValue = analogRead(SENSOR_PIN);
  int resistanceValue = map(sensorValue, 0, 1023, 0, 255);
  
  Serial.println(resistanceValue); // シリアルモニタで抵抗の値を表示
  
  digitalWrite(LED_PIN, LOW); // LEDを消灯
  
  if (resistanceValue < THRESHOLD) {
    blinkLED();
  }
  
  delay(DELAY_TIME); // データ送信の間隔を設定
}

void blinkLED() {
  digitalWrite(LED_PIN, HIGH);
  delay(DELAY_TIME);
  digitalWrite(LED_PIN, LOW);
  delay(DELAY_TIME);
}