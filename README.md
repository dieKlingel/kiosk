# dieKlingel Kiosk

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/dieklingel-kiosk)

This repository contains a kiosk application for the dieKlinge project. The kiosk is a simple user interface, for the front of your doorbell. It has some basic possibilities to customize the user interface. As soon as someone rings the bell or enters a passcode to unlock the door, the kiosk will emit an event/action-trigger using the dieKlingel mqtt api.

## Getting Started

Install the latest build from snapcraft

```bash
sudo snap install dieklingel-kiosk
```

Configure the kiosk:

```bash
sudo snap set dieklingel-kiosk <key>=<value>
```

| Key            | Value                         | Example                                            |
| -------------- | ----------------------------- | -------------------------------------------------- |
| clip           | {LEFT},{TOP},{RIGHT},{BOTTOM} | 10,6,35,16                                         |
| timeout        | Seconds                       | 30                                                 |
| mqtt.uri       | Url                           | mqtt://server.dieklingel.com/dieklingel/name/main/ |
| mqtt.username  | String                        | user1                                              |
| mqtt.password  | String                        | password1                                          |

Run the kiosk

```bash
sudo snap set dieklingel-kiosk daemon=true
```

## Signs

Add your signs in format of `.rfwtxt`. Signs are parsed from the directrory `/var/snap/dieklingel-kiosk/current` in alphabetical order. All files with extension `.rfwtxt` are parsed. A file should be in rfw format, see [rfw package](https://pub.dev/packages/rfw) and the example in [conf/00_sign.rfwtxt](conf/00_sign.rfwtxt).

## Events

If someone rings the bell the kiosk will emit an action-trigger to `$DIEKLINGEL_MQTT_URI/actions/execute` within the following payload:

```json
{
  "pattern": "ring",
  "environment": {
    "SIGN": "<custom, set in <sign>.rfwtxt>"
  }
}
```

and when the passcode is enterd an action-trigger to `$DIEKLINGEL_MQTT_URI/actions/execute` is send, with the following payload:

```json
{
  "pattern": "unlock",
  "environment": {
    "PASSCODE": "<the passcode>"
  }
}
```
