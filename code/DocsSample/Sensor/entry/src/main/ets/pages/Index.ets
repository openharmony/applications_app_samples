import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import CommonUtils from '../common/utils/CommonUtils';
import sensor from '@ohos.sensor';
import Utils from '../common/utils/Utils';
import Logger from '../common/utils/Logger';

const TAG = '[Sample_Sensor]';
const DOMAIN = 0xF811;
const BUNDLE = 'Sensor_';

@Entry
@Component
struct SensorList {
  @State
  private sensorItems: string[] = [];
  private sampleRate: number = 200000000;
  @State
  private realSensorName: string = '';
  private sensors = new Map<string, number>();
  @State
  private callbackContent: string = "";
  private supportSensorIdList: (number | undefined)[] = [1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
    256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 277, 278, 279, 280, 281, 282];
  private sensorType = new Map<string, number>([
    ['sensor_test', 0],
    ['ACCELEROMETER', 1],
    ['GYROSCOPE', 2],
    ['AMBIENT_LIGHT', 5],
    ['MAGNETIC_FIELD', 6],
    ['CAPACITIVE', 7],
    ['BAROMETER', 8],
    ['TEMPERATURE', 9],
    ['HALL', 10],
    ['GESTURE', 11],
    ['PROXIMITY', 12],
    ['HUMIDITY', 13],
    ['COLOR', 14],
    ['SAR', 15],
    ['AMBIENT_LIGHT1', 16],
    ['SENSOR_TYPE_ID_HALL_EXT', 17],
    ['PROXIMITY1', 18],
    ['SENSOR_TYPE_ID_PHYSICAL_MAX', 0xFF],
    ['ORIENTATION', 256],
    ['GRAVITY', 257],
    ['LINEAR_ACCELEROMETER', 258],
    ['ROTATION_VECTOR', 259],
    ['AMBIENT_TEMPERATURE', 260],
    ['MAGNETIC_FIELD_UNCALIBRATED', 261],
    ['GAME_ROTATION_VECTOR', 262],
    ['GYROSCOPE_UNCALIBRATED', 263],
    ['SIGNIFICANT_MOTION', 264],
    ['PEDOMETER_DETECTION', 265],
    ['PEDOMETER', 266],
    ['POSTURE', 267],
    ['HEAD_POSTURE', 268],
    ['DROP_DETECTION', 269],
    ['GEOMAGNETIC_ROTATION_VECTOR', 277],
    ['HEART_RATE', 278],
    ['DEVICE_ORIENTATION', 279],
    ['WEAR_DETECTION', 280],
    ['ACCELEROMETER_UNCALIBRATED', 281],
    ['SENSOR_TYPE_ID_RPC', 282],
    ['SENSOR_TYPE_ID_MAX', 30],
  ]);

  aboutToAppear() {
    let data = sensor.getSensorListSync();
    for (let i = 0; i < data.length; i++) {
      Logger.info('getSensorListSync successful: ' + JSON.stringify(data[i]));
      this.sensorType.forEach((val, key) => {
        if (val === data[i].sensorId) {
          this.sensorItems[i] = key;
          this.sensors.set(key, data[i].sensorId);
          return;
        }
      })
      this.sensorItems[i] = data[i].sensorName;
      this.sensors.set(data[i].sensorName, data[i].sensorId);
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      TextInput({ placeholder: 'Please select sensor type', text: this.realSensorName })
        .placeholderColor("red")
        .id('sensorType')
        .placeholderFont({
          size: 30,
          weight: 105,
          family: 'cursive',
          style: FontStyle.Italic
        })
        .caretColor(Color.Blue)
        .height(50)
        .type(InputType.Normal)
        .fontSize(30)
        .focusable(false)
        .fontWeight(FontWeight.Normal)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Red)
        .textAlign(TextAlign.Center)
        .borderStyle(BorderStyle.Solid)
        .borderWidth(1)
        .borderColor("black")
        .borderRadius(10)
        .onClick(() => {
          CommonUtils.textPickerDialog(this.sensorItems, (sensorName: string) => {
            this.realSensorName = sensorName;
          });
        })
        .width('100%')
        .margin({ top: 10 })

      TextInput({ placeholder: 'Input data sampleRate' })
        .placeholderColor("blue")
        .id('sampleRate')
        .placeholderFont({
          size: 30,
          weight: 105,
          family: 'cursive',
          style: FontStyle.Italic
        })
        .caretColor(Color.Blue)
        .height(50)
        .type(InputType.Number)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Blue)
        .textAlign(TextAlign.Center)
        .onChange((value: string) => {
          this.sampleRate = parseInt(value)
        })
        .width('100%')
        .margin({ top: 10 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        Button($r('app.string.on')).onClick(() => {
          try {
            Logger.info('subscribe begin: ' + this.realSensorName);
            if (!this.supportSensorIdList.includes(this.sensors.get(this.realSensorName))) {
              Utils.toast("This is not support, please change other sensorId!");
              return;
            }
            if (this.sensors.get(this.realSensorName) == 265 || this.sensors.get(this.realSensorName) == 266) {
              Logger.info('subscribe begin' + this.sensors.get(this.realSensorName));
              let atManager = abilityAccessCtrl.createAtManager();
              let context = getContext(this) as common.UIAbilityContext;
              atManager.requestPermissionsFromUser(context, ["ohos.permission.ACTIVITY_MOTION"], (err, data) => {
                if (err) {
                  Logger.error('Grant ACTIVITY_MOTION failed: ' + JSON.stringify(data));
                  return;
                }
                Logger.info('data: ' + JSON.stringify(data));
                Logger.info('data permissions: ' + data.permissions);
                Logger.info('data authResults: ' + data.authResults);
                sensor.getSingleSensor(this.sensors.get(this.realSensorName), (err, data) => {
                  if (err) {
                    Logger.error(JSON.stringify(err));
                    return;
                  }
                  if (data) {
                    sensor.on(this.sensors.get(this.realSensorName), (data: sensor.Response) => {
                      Logger.info('PEDOMETER: ' + JSON.stringify(data));
                      this.callbackContent = JSON.stringify(data);
                    })
                  } else {
                    Logger.error('Program run failed: ');
                  }
                });
              });
              Logger.info('subscribe left: ' + this.sensors.get(this.realSensorName));
            } else { // normal sensor
              sensor.on(this.sensors.get(this.realSensorName), ((data: sensor.Response) => {
                Logger.info('callback: ' + JSON.stringify(data));
                this.callbackContent = JSON.stringify(data);
              }), { 'interval': this.sampleRate });
            }
          } catch (e) {
            Logger.error('Subscribe exception in,msg: ' + JSON.stringify(e));
            Logger.error('Unsubscribe exception in,Code: ' + e.code + ' ,msg: ' + e.message);
          }
        })

        Button($r('app.string.off')).onClick(() => {
          Logger.info('Unsubscribe begin: ');
          try {
            sensor.off(this.sensors.get(this.realSensorName));
            sensor.on(1, (data) => {
              Logger.info('callback: ' + JSON.stringify(data));
            })
          } catch (e) {
            Logger.info('Unsubscribe exception in,msg: ' + JSON.stringify(e));
          }
          this.callbackContent = "";
        })

        Button($r('app.string.once')).onClick(() => {
          Logger.info('Subscribe once begin: ');
          try {
            sensor.once(this.sensors.get(this.realSensorName), (data: sensor.Response) => {
              Logger.info('PEDOMETER: ' + JSON.stringify(data));
              this.callbackContent = JSON.stringify(data);
            })
          } catch {
            Logger.error('Program run failed: ');
          }
          this.callbackContent = "";
        })

      }.margin({ top: 20 })

      Text(`${this.callbackContent}`)
        .fontSize(20)
        .margin({ top: 20 })
    }
    .height('100%')
    .width('100%')
  }
}
