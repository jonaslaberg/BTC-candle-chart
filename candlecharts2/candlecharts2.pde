import processing.data.*;
import processing.core.*;
import java.sql.Timestamp;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.lang.Long;
import controlP5.*;

JSONArray data = new JSONArray(); // initialize data to an empty array
float[] opens, highs, lows, closes;
float minPrice, maxPrice;
String[] dates;
int margin = 50;
//float barWidth;
String prevDate = "";

//dragging
float startX, startY; // starting position of the mouse when dragging
float offsetX = 0; // amount to offset the canvas in x direction
float offsetY = 0; // amount to offset the canvas in y direction
boolean dragging = false; // flag to indicate if the user is currently dragging the canvas
float deltaX = mouseX - startX;
float deltaY = mouseY - startY;
//end dragging

//controlP5




ControlP5 cp5;

//int myColorBackground = color(0,0,0);

Knob myKnobA;
//Knob myKnobB;



float theValue = 10;
float barWidth;

void knob(float theValue) {
  barWidth = theValue;
  println("a knob event. setting barwidth to "+theValue);
}




void setup() {

  size(1000, 600);
  //fullScreen(2);
  
  stuffs();



  cp5 = new ControlP5(this);

  myKnobA = cp5.addKnob("knob")
  .setRange(0,10)
  .setValue(5)
  .setPosition(100,70)
  .setRadius(50)
  .setDragDirection(Knob.VERTICAL)
  ;

}



String url = "https://min-api.cryptocompare.com/data/v2/histohour?fsym=BTC&tsym=USDT&limit=720&aggregate=4";

void stuffs(){

  background(255);

  // Load data
  
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

  // Draw data
  //float barWidth = (width - 2*margin)/data.size();
  barWidth = theValue;
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
  SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM");
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



}

void draw() {

  //dragging canvas
  //stuffs();

  
  //end dragging canvas

  //noLoop();
}

// int lastX, lastY;

// public void mouseDragged(MouseEvent e) {
//     int dx = e.getX() - lastX;
//     int dy = e.getY() - lastY;

//     // Check if the mouse is near the edge of the monitor
//     if (e.getX() < panThreshold) {
//         // Panning left
//         canvas.translate(-panAmount, 0);
//     } else if (e.getX() > canvas.getWidth() - panThreshold) {
//         // Panning right
//         canvas.translate(panAmount, 0);
//     }

//     if (e.getY() < panThreshold) {
//         // Panning up
//         canvas.translate(0, -panAmount);
//     } else if (e.getY() > canvas.getHeight() - panThreshold) {
//         // Panning down
//         canvas.translate(0, panAmount);
//     }

//     // Update the lastX and lastY variables
//     lastX = e.getX();
//     lastY = e.getY();

//     canvas.repaint();
//}

