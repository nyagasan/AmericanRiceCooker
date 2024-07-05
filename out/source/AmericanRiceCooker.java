/* autogenerated by Processing revision 1293 on 2024-07-05 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import ddf.minim.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class AmericanRiceCooker extends PApplet {


Minim minim = new Minim(this);
AudioPlayer player;
public void setup() {
/* size commented out by preprocessor */;
int mage = 0; // まげセンサーの値
player = minim.loadFile("open.mp3");
// player = minim.loadFile("close.mp3");
}
public void draw() {
player.play();
}
public void stop(){
player.close(); //サウンドデータを終了
minim.stop();
super.stop();
}


  public void settings() { size(480, 240); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AmericanRiceCooker" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
