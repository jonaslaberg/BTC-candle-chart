import processing.data.*;
import processing.core.*;
import java.sql.Timestamp;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.lang.Long;



JSONArray data = new JSONArray(); // initialize data to an empty array
//JSONArray data;
float[] opens, highs, lows, closes;
float minPrice, maxPrice;
String[] dates;

int margin = 50;
float barWidth;

void setup() {
  size(2500, 600);
  background(255);
}


void draw() {

  //loadDATA
  //15 min resolution
  //String url = "https://min-api.cryptocompare.com/data/histominute?fsym=BTC&tsym=USDT&limit=720&aggregate=15&e=CCCAGG";

  //1 hr resolution
  String url = "https://min-api.cryptocompare.com/data/v2/histohour?fsym=BTC&tsym=USDT&limit=350&aggregate=4";

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
    //println(highs);
    lows[i] = candle.getFloat("low");
    opens[i] = candle.getFloat("open");
    closes[i] = candle.getFloat("close");
    dates[i] = Integer.toString(candle.getInt("time"));
  }

  minPrice = min(lows);
  maxPrice = max(highs);


  //drawdata

  float barWidth = (width - 2*margin)/data.size();



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

  //drawaxes

  stroke(0, 60, 120);
  line(margin, margin, margin, height-margin);
  line(margin, height-margin, width-margin, height-margin);


  


  for (int i=0; i<data.size(); i+=10) {
//attempt to convert unix time to normal time

    long unixTime = Long.valueOf(dates[i]); // replace with your Unix time
    Date date = new Date(unixTime * 1000L); // Unix time is in seconds, so multiply by 1000 to convert to milliseconds
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // specify the date format you want
    String formattedDate = dateFormat.format(date); // format the date
    System.out.println(formattedDate); // print the formatted date

    fill(0);
    textSize(8);

    text(formattedDate, margin + i*barWidth + barWidth/2, height-margin + 20);
  }

  noLoop();
}