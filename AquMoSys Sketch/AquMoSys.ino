#include <WiFi.h>
#include <IOXhop_FirebaseESP32.h>

#include <OneWire.h>
#include <DallasTemperature.h>

#include <DHT.h>

#include "DFRobot_ESP_PH.h"
#include <EEPROM.h>

//#define factor 1000000
//#define sleep_time  120

#define SSID "UUMWiFi_Guest"
#define PASSWORD ""
#define FIREBASE_HOST "aqumosys.firebaseio.com"
#define FIREBASE_AUTH "z0YDhWOZK4C8x2Up83SDVLDRwASDoctkTvTCQ8A4"

#define ESPADC 4096.0   //the esp Analog Digital Convertion value
#define ESPVOLTAGE 3300 //the esp voltage supply value

#define pin_ph          35
#define pin_turbidity   34
#define pin_dht         17
#define pin_ds          16
#define pin_led         13

#define DHTTYPE         DHT11


//FirebaseData firebaseData;

DFRobot_ESP_PH ph;
DHT dht(pin_dht, DHTTYPE);

OneWire oneWire(pin_ds);
// Pass our oneWire reference to Dallas Temperature sensor
DallasTemperature sensors(&oneWire);

double voltage, phValue, temperature, humidity, turbidity, ntu, ntu1;

void setup() {
  Serial.begin(115200);

  Serial.println(WiFi.localIP());
  WiFi.begin(SSID, PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print("..");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());

  dht.begin();
  sensors.begin();
  EEPROM.begin(32);
  ph.begin();
  //  esp_sleep_enable_timer_wakeup(sleep_time * factor);

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void read_all()
{
  static unsigned long timepoint = millis();
  if (millis() - timepoint > 1000U) //time interval: 1s
  {
    timepoint = millis();
    //voltage = rawPinValue / esp32ADC * esp32Vin
    voltage = analogRead(pin_ph) / ESPADC * ESPVOLTAGE; // read the voltage
    phValue = ph.readPH(voltage, temperature); // convert voltage to pH with temperature compensation

  }
  ph.calibration(voltage, temperature); // calibration process by Serail CMD
}

// https://wiki.dfrobot.com/Turbidity_sensor_SKU__SEN0189
void read_turbidity() {
  ntu1 = (analogRead(pin_turbidity) * (-0.067)) + 146.65;
  ntu = constrain(ntu1, 1, 100);
  turbidity = ntu;
}

void loop() {

  sensors.requestTemperatures();
  temperature  = sensors.getTempCByIndex(0);
  humidity = dht.readHumidity();
  read_turbidity();
  read_all();

  DynamicJsonBuffer jsonBuffer;
  JsonObject& senObject = jsonBuffer.createObject();
  JsonObject& sensorTime = senObject.createNestedObject("timestamp");

  senObject["Temperature"] = temperature;
  senObject["Humidity"] = humidity;
  senObject["pH"] = phValue;
  senObject["Turbidity"] = turbidity;
  sensorTime[".sv"] = "timestamp";

  Firebase.push("AquMoSys", senObject);

  Serial.print(temperature);
  Serial.print(" C ");
  Serial.print(humidity);
  Serial.print(" % ");
  Serial.print(turbidity);
  Serial.print(" NTU ");
  Serial.print(phValue);
  Serial.print(" P ");
  Serial.println();

  delay(58000);

}
