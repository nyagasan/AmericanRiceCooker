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
boolean wasOpen = false; // 前回のフレームで開いていたかどうか
boolean ledOn = false; // LEDの状態

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
  boolean isOpen = mageValue < OPEN_THRESHOLD;

  // 開閉状態の変化を検出
  if (isOpen && !wasOpen) {
    stopAllSounds();
    playRandomOpenSound();
    ledOn = true;
  } else if (!isOpen && wasOpen) {
    stopAllSounds();
    closedPlayer.rewind();
    closedPlayer.play();
    ledOn = true;
  }

  // 音声再生状態の確認とLED制御
  boolean anyPlaying = isAnyPlayerPlaying();
  if (anyPlaying) {
    ledOn = true;
  } else {
    ledOn = false;
  }

  // LEDの制御
  sendLEDCommand(ledOn);

  wasOpen = isOpen;
}

// ランダムなオープンサウンドを再生
void playRandomOpenSound() {
  int playerIndex = int(random(openedPlayers.length));
  openedPlayers[playerIndex].rewind();
  openedPlayers[playerIndex].play();
}

// すべての音を停止
void stopAllSounds() {
  for (AudioPlayer player : openedPlayers) {
    player.pause();
    player.rewind();
  }
  closedPlayer.pause();
  closedPlayer.rewind();
}

// いずれかのプレイヤーが再生中かチェック
boolean isAnyPlayerPlaying() {
  for (AudioPlayer player : openedPlayers) {
    if (player.isPlaying()) {
      return true;
    }
  }
  return closedPlayer.isPlaying();
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