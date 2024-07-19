import ddf.minim.*;
import processing.serial.*;

// オーディオ関連の変数
Minim minim;
AudioPlayer[] openedPlayers;
AudioPlayer closedPlayer;

// シリアル通信関連の変数
Serial myPort;
int mageValue; // まげセンサーの値

// 状態管理用の変数
boolean isPlaying = false;
final int OPEN_THRESHOLD = 100; // センサー値のしきい値

void setup() {
  size(480, 240);
  println(Serial.list());

  // Minimライブラリの初期化
  minim = new Minim(this);

  // オーディオファイルの読み込み
  openedPlayers = new AudioPlayer[3];
  openedPlayers[0] = minim.loadFile("openSuihan.wav");
  openedPlayers[1] = minim.loadFile("open.mp3");
  openedPlayers[2] = minim.loadFile("OpenVoice.mp3");
  closedPlayer = minim.loadFile("close.mp3");

  // Arduino設定
  // macOSの場合: myPort = new Serial(this, "/dev/tty.usbmodem101", 9600);
  // Windowsの場合:
  myPort = new Serial(this, "COM8", 9600);
}

void draw() {
  if (mageValue < OPEN_THRESHOLD && !isPlaying) {
    playRandomOpenSound();
  } else if (mageValue >= OPEN_THRESHOLD && isPlaying) {
    stopAllOpenSounds();
  }
  
  if (mageValue >= OPEN_THRESHOLD && !isPlaying) {
    closedPlayer.play();
    println("再生2: " + mageValue);
  } else if (mageValue < OPEN_THRESHOLD && isPlaying) {
    closedPlayer.pause();
    closedPlayer.rewind();
    println("停止2: " + mageValue);
  }
}

// ランダムなオープンサウンドを再生
void playRandomOpenSound() {
  int playerIndex = int(random(openedPlayers.length));
  openedPlayers[playerIndex].play();
  isPlaying = true;
  println("再生: " + mageValue + ", プレイヤー: " + (playerIndex + 1));
}

// すべてのオープンサウンドを停止
void stopAllOpenSounds() {
  for (AudioPlayer player : openedPlayers) {
    player.pause();
    player.rewind();
  }
  isPlaying = false;
  println("停止: " + mageValue);
}

void stop() {
  // すべてのオーディオリソースを解放
  for (AudioPlayer player : openedPlayers) {
    player.close();
  }
  closedPlayer.close();
  minim.stop();
  super.stop();
}

void serialEvent(Serial p) {
  if (p.available() > 0) {
    String inString = p.readStringUntil('\n');
    if (inString != null) {
      inString = trim(inString);
      mageValue = int(inString);
    }
  }
}