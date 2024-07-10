int val = 0;
int teikou;

void setup() {
  Serial.begin(9600);
  pinMode(11, OUTPUT);
}

void loop() {
  val = analogRead(0);
  digitalWrite(11, LOW); //LED消灯
  teikou = map(val, 0, 1023, 0, 255);
  Serial.println(teikou); //シリアルモニタで抵抗の値を見られるように
  if (teikou > 20) { //抵抗の値が 20より大きければ
    digitalWrite(11, HIGH); //LED 点灯
  }
  delay(100); // データ送信の間隔を設定
}
