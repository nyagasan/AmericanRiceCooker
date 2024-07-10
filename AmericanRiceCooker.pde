import ddf.minim.*;
import processing.serial.*;

Minim minim = new Minim(this);
AudioPlayer player;
Serial myPort;
int mage; // まげセンサーの値

void setup() {
   println(Serial.list());
size(480, 240);
player = minim.loadFile("openSuihan.wav");
// player = minim.loadFile("close.mp3");

// arduino settings
// macOSの場合
myPort = new Serial(this, "/dev/tty.usbmodem101", 9600);
// Windowsの場合
// myPort = new Serial(this,"COM8" , 9600);
}

boolean isPlaying = false;
int isOpened = 20;

void draw() {
  if (mage > isOpened && !isPlaying) {
    player.play();
    isPlaying = true;
    println("再生");
  } else if (mage <= isOpened && isPlaying) {
    player.pause();
    player.rewind();
    isPlaying = false;
    println("停止");
  }
}

void stop(){
player.close(); //サウンドデータを終了
minim.stop();
super.stop();
}

void serialEvent(Serial p) {
  if (p.available() > 0) {
    String inString = p.readStringUntil('\n');
    if (inString != null) {
      inString = trim(inString);
      mage = int(inString);
    }
  }
}
