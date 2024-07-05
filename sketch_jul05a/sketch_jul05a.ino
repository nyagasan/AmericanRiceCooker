int val = 0;
int teikou;

void setup() {
  Serial.begin(9600);
  pinMode(11,OUTPUT);
}

void loop() {
  val = analogRead(0);
  digitalWrite(11,LOW);
  teikou = map(val,0,1023,0,255);
  Serial.println(teikou);
  if(teikou>20){
    digitalWrite(11,HIGH);
  }
}