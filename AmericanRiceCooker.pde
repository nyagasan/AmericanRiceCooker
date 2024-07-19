import ddf.minim.*;
import processing.serial.*;

Minim minim;
AudioPlayer[] openedPlayers;
AudioPlayer closedPlayer;
Serial myPort;

final int OPEN_THRESHOLD = 100;
boolean wasOpen = false;
boolean ledOn = false;
int mageValue = 0;

long lastSendTime = 0;
final int SEND_INTERVAL = 50; // ミリ秒単位で送信間隔を設定

void setup() {
  size(480, 240);
  minim = new Minim(this);

  openedPlayers = new AudioPlayer[3];
  openedPlayers[0] = minim.loadFile("openSuihan.wav");
  openedPlayers[1] = minim.loadFile("open.mp3");
  openedPlayers[2] = minim.loadFile("OpenVoice.mp3");
  closedPlayer = minim.loadFile("close.mp3");

  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.bufferUntil('\n');
}

void draw() {
  boolean isOpen = mageValue < OPEN_THRESHOLD;

  if (isOpen != wasOpen) {
    stopAllSounds();
    if (isOpen) {
      playRandomOpenSound();
      println("開いた: " + mageValue);
    } else {
      closedPlayer.rewind();
      closedPlayer.play();
      println("閉じた: " + mageValue);
    }
    ledOn = true;
  }

  ledOn = isAnyPlayerPlaying();

  long currentTime = millis();
  if (currentTime - lastSendTime > SEND_INTERVAL) {
    sendLEDCommand(ledOn);
    lastSendTime = currentTime;
    println("LED状態: " + (ledOn ? "ON" : "OFF"));
  }

  wasOpen = isOpen;
}

void playRandomOpenSound() {
  int playerIndex = int(random(openedPlayers.length));
  openedPlayers[playerIndex].rewind();
  openedPlayers[playerIndex].play();
  println("再生中のプレイヤー: " + (playerIndex + 1));
}

void stopAllSounds() {
  for (AudioPlayer player : openedPlayers) {
    player.pause();
    player.rewind();
  }
  closedPlayer.pause();
  closedPlayer.rewind();
  println("すべての音を停止");
}

boolean isAnyPlayerPlaying() {
  for (AudioPlayer player : openedPlayers) {
    if (player.isPlaying()) return true;
  }
  return closedPlayer.isPlaying();
}

void sendLEDCommand(boolean turnOn) {
  myPort.write(turnOn ? '1' : '0');
}

void serialEvent(Serial p) {
  String inString = p.readStringUntil('\n');
  if (inString != null) {
    mageValue = int(trim(inString));
    println("センサー値: " + mageValue);
  }
}

void stop() {
  for (AudioPlayer player : openedPlayers) player.close();
  closedPlayer.close();
  minim.stop();
  super.stop();
}