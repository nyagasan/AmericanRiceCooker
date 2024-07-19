const int SENSOR_PIN = A0;
const int LED_PIN = 11;
const int THRESHOLD = 100;
const int DELAY_TIME = 100;

bool shouldBlink = false;

void setup() {
  Serial.begin(9600);
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  int sensorValue = analogRead(SENSOR_PIN);
  int resistanceValue = map(sensorValue, 0, 1023, 0, 255);
  
  Serial.println(resistanceValue); // シリアルモニタで抵抗の値を表示
  
  // Processingからのコマンドを確認
  if (Serial.available() > 0) {
    char command = Serial.read();
    if (command == '1') {
      shouldBlink = true;
    } else if (command == '0') {
      shouldBlink = false;
    }
  }
  
  // LEDの状態を更新
  if (shouldBlink) {
    blinkLED();
  } else {
    digitalWrite(LED_PIN, LOW);
  }
  
  delay(DELAY_TIME); // データ送信の間隔を設定
}

void blinkLED() {
  digitalWrite(LED_PIN, HIGH);
  delay(DELAY_TIME);
  digitalWrite(LED_PIN, LOW);
  delay(DELAY_TIME);
}