/* autogenerated by Processing revision 1290 on 2023-02-21 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import processing.data.*;
import processing.core.*;
import java.sql.Timestamp;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.lang.Long;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class candlecharts2 extends PApplet {








JSONArray data = new JSONArray(); // initialize data to an empty array
float[] opens, highs, lows, closes;
float minPrice, maxPrice;
String[] dates;
int margin = 50;
float barWidth;
String prevDate = "";

//dragging
float startX, startY; // starting position of the mouse when dragging
float offsetX = 0; // amount to offset the canvas in x direction
float offsetY = 0; // amount to offset the canvas in y direction
boolean dragging = false; // flag to indicate if the user is currently dragging the canvas
//end dragging



public void setup() {
  //size(2500, 600);
  /* size commented out by preprocessor */;
  background(255);
}

public void mousePressed() {
  // check if the user clicked on the canvas
  if (mouseX >= 0 && mouseX <= width && mouseY >= 0 && mouseY <= height) {
    // store the starting position of the mouse
    startX = mouseX;
    startY = mouseY;
    dragging = true;
  }
}

public void mouseReleased() {
  // reset the dragging flag when the mouse is released
  dragging = false;
}

public void mouseDragged() {
  if (dragging) {
    // calculate the amount to offset the canvas based on the change in mouse position
    float deltaX = mouseX - startX;
    float deltaY = mouseY - startY;
    offsetX += deltaX;
    offsetY += deltaY;
    // update the starting position of the mouse
    startX = mouseX;
    startY = mouseY;
  }
}


public void draw() {
  // Load data
  String url = "https://min-api.cryptocompare.com/data/v2/histohour?fsym=BTC&tsym=USDT&limit=720&aggregate=4";
  JSONObject json = loadJSONObject(url);
  JSONArray data = json.getJSONObject("Data").getJSONArray("Data");
  opens = new float[data.size()];
  highs = new float[data.size()];
  lows = new float[data.size()];
  closes = new float[data.size()];
  dates = new String[data.size()];

  for (int i = 0; i < data.size(); i++) {
    JSONObject candle = data.getJSONObject(i);
    highs[i] = candle.getFloat("high");
    lows[i] = candle.getFloat("low");
    opens[i] = candle.getFloat("open");
    closes[i] = candle.getFloat("close");
    dates[i] = Integer.toString(candle.getInt("time"));
  }
  minPrice = min(lows);
  maxPrice = max(highs);

  //dragging canvas
  translate(offsetX, offsetY);
  //end dragging canvas

  // Draw data
  //float barWidth = (width - 2*margin)/data.size();
  float barWidth = 10;
  for (int i=0; i<data.size(); i++) {
    stroke(0, 100, 200);
    line(margin + i*barWidth + barWidth/2, map(highs[i], minPrice, maxPrice, height-margin, margin), margin + i*barWidth + barWidth/2, map(lows[i], minPrice, maxPrice, height-margin, margin));
    noStroke();
    if (opens[i] < closes[i]) {
      fill(0, 100, 100, 20);
    } else {
      fill(0, 200, 100, 20);
    }
    rect(margin + i*barWidth, map(max(opens[i], closes[i]), minPrice, maxPrice, height-margin, margin), width, map(abs(closes[i] - opens[i]), 0, maxPrice - minPrice, 0, height-2*margin));
  }

  // Draw axes
  stroke(0, 60, 120);
  line(margin, margin, margin, height-margin);
  line(margin, height-margin, width-margin, height-margin);

  for (int i = 0; i < data.size(); i += 10) {
  // convert unix time to Date object
  long unixTime = Long.valueOf(dates[i]);
  Date date = new Date(unixTime * 1000L);

  // format date and time
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
  SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
  String formattedDate = dateFormat.format(date);
  String formattedTime = timeFormat.format(date);

  fill(0);
  textSize(8);
  // display date and time only when the date changes
  if (!formattedDate.equals(prevDate)) {
    text(formattedDate + " " + formattedTime, margin + i*barWidth + barWidth/2, height-margin + 20);
    prevDate = formattedDate;
  }
}
  noLoop();
}


  public void settings() { fullScreen(2); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "candlecharts2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
