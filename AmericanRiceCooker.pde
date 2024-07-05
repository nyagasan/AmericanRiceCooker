import ddf.minim.*;
Minim minim = new Minim(this);
AudioPlayer player;
void setup() {
size(480, 240);
int mage = 0; // まげセンサーの値
player = minim.loadFile("open.mp3");
// player = minim.loadFile("close.mp3");
}
void draw() {
player.play();
}
void stop(){
player.close(); //サウンドデータを終了
minim.stop();
super.stop();
}
