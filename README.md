# ferm_chamber
ESP8266 (NodeMCU) controlled beer fermentation chamber.

## Hardware

The whole project is created by modifying a wine cooler, similar to [this one](http://www.amazon.com/NewAir-AW-121E-Bottle-Thermoelectric-Cooler/dp/B0046XD52W) without the digital temperature controls or LCD.

The microcontroller is an [ESP8266 board v0.9](
http://www.dx.com/p/nodemcu-esp8266-esp-12-deleopment-board-lua-wi-fi-module-w-built-in-antennas-385190).

The ESP8266 controls a [two channel relay module](http://www.dx.com/p/2-channel-relay-module-extension-board-for-arduino-51-avr-avr-arm-143916).

One of the relays control the [peltier cooler](http://www.dx.com/p/tec1-12706-semiconductor-thermoelectric-cooler-peltier-white-157283).

The other relay controls the fans for the heatsinks that are connected to the peltier cooler. The temperature readings are provided by a  [DS18B20 temperature probe](http://www.dx.com/p/ds18b20-waterproof-digital-temperature-probe-black-silver-204290). You'll also need a 4k pullup resistor between the data and the power lines.

The power supply, heatsinks and fans are reused from the wine cooler itself.

### Pinout

- D0 - controls the relay of the cooling fans (high - fan on)
- D1 - controls the relay for the peltier (high - power on)
- D4 -  the data pin for the DS18B20

## Software

### Flashing the NodeMCU firmware

Use ESP8266Flasher to upload the firmware in the repository. If you want to build your own, use http://nodemcu-build.com/, use the dev branch and enable the following modules: file,gpio,http,mdns,net,node,ow,sntp,tmr,uart,wifi

### Uploading the lua files to the ESP8266

Use ESPLorer for uploading the files.

You will need an additional "credentials.lua" file with contents like this:

```lua
wifi_ssid = "MyWifi"
wifi_password = "MyPassword"
thingspeak_api_key = 'MYTHINGSPEAKAPIKEY'
thingspeak_channel_id = 123456
```
### How it works

Every 30 seconds, it takes a temp reading. It enables/disables the cooling based on the temperature, then submits the temperature data to thingspeak ([check out my channel here](https://thingspeak.com/channels/100779)).

It also runs a HTTP server for setting the target temperature.

# TODO

- don't lose thingspeak data if there is no wifi
- enable heating by reversing the peltier polarity
- make it possible to update the wifi ssid/password from the http control site
