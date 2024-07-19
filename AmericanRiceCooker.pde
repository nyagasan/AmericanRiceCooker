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
  boolean anyPlaying = false;

  if (mageValue < OPEN_THRESHOLD && !isAnyOpenPlayerPlaying()) {
    playRandomOpenSound();
  }
  
  if (mageValue >= OPEN_THRESHOLD && !closedPlayer.isPlaying()) {
    closedPlayer.rewind();
    closedPlayer.play();
  }

  // 再生状態の確認
  for (AudioPlayer player : openedPlayers) {
    if (player.isPlaying()) {
      anyPlaying = true;
      break;
    }
  }
  if (closedPlayer.isPlaying()) {
    anyPlaying = true;
  }

  // LEDの制御
  sendLEDCommand(anyPlaying);
}

// ランダムなオープンサウンドを再生
void playRandomOpenSound() {
  int playerIndex = int(random(openedPlayers.length));
  openedPlayers[playerIndex].rewind();
  openedPlayers[playerIndex].play();
}

// いずれかのオープンプレイヤーが再生中かチェック
boolean isAnyOpenPlayerPlaying() {
  for (AudioPlayer player : openedPlayers) {
    if (player.isPlaying()) {
      return true;
    }
  }
  return false;
}

// LEDコマンドをArduinoに送信
void sendLEDCommand(boolean turnOn) {
  if (turnOn) {
    myPort.write('1');
  } else {
    myPort.write('0');
  }
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