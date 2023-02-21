import processing.data.*;
import processing.core.*;
import java.sql.Timestamp;
import java.util.Date;
import java.text.SimpleDateFormat;


JSONArray data = new JSONArray(); // initialize data to an empty array
//JSONArray data;
float[] opens, highs, lows, closes;
float minPrice, maxPrice;
String[] dates;

int margin = 50;
float barWidth;

void setup() {
  fullScreen();
  //size(1500, 600);
  background(255);
}

void draw() {

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