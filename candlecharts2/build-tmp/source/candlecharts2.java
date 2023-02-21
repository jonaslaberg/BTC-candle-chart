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
//JSONArray data;
float[] opens, highs, lows, closes;
float minPrice, maxPrice;
String[] dates;

int margin = 50;
float barWidth;

public void setup() {
  /* size commented out by preprocessor */;
  //size(1500, 600);
  background(255);
}

public void draw() {

  //loadDATA
  //15 min resolution
  //String url = "https://min-api.cryptocompare.com/data/histominute?fsym=BTC&tsym=USDT&limit=720&aggregate=15&e=CCCAGG";

  //1 hr resolution
  String url = "https://min-api.cryptocompare.com/data/v2/histohour?fsym=BTC&tsym=USDT&limit=350&aggregate=4";

  //time thing
  String currentDate = "";
  String currentTime = "";
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
  SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");



  JSONObject json = loadJSONObject(url);

  //15min resolution
  //JSONArray data = json.getJSONArray("Data");

  //1hr resolution
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

    long unixTime = candle.getInt("time") * 1000L; // Convert Unix time to milliseconds
    Date date = new Date(unixTime);
    String newDate = dateFormat.format(date); // Format date string
    String newTime = timeFormat.format(date); // Format time string

    if (!newDate.equals(currentDate)) { // If the date has changed, display the new date
      fill(0);
      textSize(12);
      float x = margin + i*barWidth + barWidth/2;
      float y = height-margin + 20;
      if (i == 0) {
        text(newDate, x, y);
      } else {
        float prevX = margin + (i-1)*barWidth + barWidth/2;
        float textWidth = textWidth(newDate);
        if (x - prevX >= textWidth) {
          text(newDate, x - textWidth/2, y);
        }
      }
      currentDate = newDate;
    }

    fill(0);
    textSize(8);
    float x = margin + i*barWidth + barWidth/2;
    float y = height-margin + 40;
    if (i == 0) {
      text(newTime, x, y);
    } else {
      float prevX = margin + (i-1)*barWidth + barWidth/2;
      float textWidth = textWidth(newTime);
      if (x - prevX >= textWidth) {
        text(newTime, x - textWidth/2, y);
      }
    }
    currentTime = newTime;
  }


  minPrice = min(lows);
  maxPrice = max(highs);


  //drawdata

  float barWidth = (width - 2*margin)/data.size();

  for (int i=0; i<data.size(); i++) {
    //Draw the lines
    stroke(0, 100, 200);
    line(margin + i*barWidth + barWidth/2, map(highs[i], minPrice, maxPrice, height-margin, margin), margin + i*barWidth + barWidth/2, map(lows[i], minPrice, maxPrice, height-margin, margin));

    //set the color for the rectangles
    noStroke();
    if (opens[i] < closes[i]) {

      //the color here could be changed to red to show the direction of the price change.
      fill(0, 100, 100, 20);
    } else {
      fill(0, 200, 100, 20);
    }

    //draw the rectangle
    rect(margin + i*barWidth, map(max(opens[i], closes[i]), minPrice, maxPrice, height-margin, margin), width, map(abs(closes[i] - opens[i]), 0, maxPrice - minPrice, 0, height-2*margin));


    //draw the red dot in the center of the lines
    fill(255, 0, 0);
    ellipse(margin + i*barWidth + barWidth/2, map((highs[i]+lows[i])/2, minPrice, maxPrice, height-margin, margin), 2, 2);
  }


  //drawaxes

  stroke(0, 60, 120);
  line(margin, margin, margin, height-margin);
  line(margin, height-margin, width-margin, height-margin);


  noLoop();
}


  public void settings() { fullScreen(); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "candlecharts2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}