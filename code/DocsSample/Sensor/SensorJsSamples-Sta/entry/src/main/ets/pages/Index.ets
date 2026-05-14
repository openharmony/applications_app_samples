'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import {
  Entry,
  Text,
  Column,
  Component,
  Button,
  Flex,
  FlexOptions,
  ClickEvent,
  Scroll,
  Scroller,
  FlexDirection,
  FlexAlign,
  ItemAlign,
  TextInput,
  TextPickerResult,
  TextAttribute,
  Row,
  FontStyle,
  BorderStyle,
  TextPickerDialogOptions,
  TextAlign,
  FlexAlign,
  $r,
  Builder,
  Color,
  Margin,
  FontWeight,
  InputType
} from '@ohos.arkui.component'
import { $r, UIContext } from '@kit.ArkUI'
import { State } from '@ohos.arkui.stateManagement'
import common from '@ohos.app.ability.common';
import { abilityAccessCtrl } from '@kit.AbilityKit';
// [Start sensor_js_development_dependency_import_example]
import { sensor } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog'

// [End sensor_js_development_dependency_import_example]

// [Start sensor_js_define_variables_example]
let TAG = 'sensor: ';
// [End sensor_js_define_variables_example]

interface CheckRet {
  ok: boolean
  ret: number
  msg?: string
};

interface SensorInfoParamValString {
  deviceId: string
  sensorIndex: string
};

interface SensorOptionsValString {
  interval: string
  sensorInfoParam: SensorInfoParamValString
};

let options: SensorOptionsValString = {
  interval: "800000000",
  sensorInfoParam: {
    deviceId: "7",
    sensorIndex: "1"
  }
};

@Entry
@Component
struct Index {
  @State stateVar: string = 'state var';
  private DOMAIN: int = 0x0000
  @State private sensorItems: string[] = [''];
  private sampleRate: number = 200000000;
  selectedSensorId: number = 0;
  scroller: Scroller = new Scroller;
  @State private realSensorName: string = '';
  @State private deviceId: number = 0;
  private strDeviceId: string = '';
  private sensors: Map<string, int> = new Map<string, int>();
  @State private callbackContent: string = '';
  @State private sensorListByDevice: string = '';
  @State private sensorApiContent: string = '';
  sensorListByDeviceList: (sensor.Sensor)[] = [];
  private supportSensorIdList: (number | undefined)[] = [1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 256,
    257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 277, 278, 279, 280, 281, 282];

  private checkDeviceId(): CheckRet {
    if (!this.strDeviceId.length) {
      return { ok: false, ret: -1 };
    }
    return { ok: true, ret: Number(this.deviceId) };
  }

  aboutToAppear(): void {
    let traceCount = 0;
    hilog.info(this.DOMAIN, TAG, 'getSensorList in');
    // [Start sensor_js_get_sensor_list_example]
    try {
      sensor.getSensorList((err: BusinessError<void> | null, data: Array<sensor.Sensor> | undefined) => {
        if (err) {
          console.error(TAG + 'getSensorList failed');
        } else {
          console.info('getSensorList success');
          if (data == undefined) {
            console.error(TAG + 'getSensorList failed');
            return
          }
          for (let i = 0; i < data.length; i++) {
            console.info(TAG + JSON.stringify(data[i]));
            // [StartExclude sensor_js_get_sensor_list_example]
            this.sensorItems[i] = data[i].sensorName;
            this.sensors.set(data[i].sensorName, data[i].sensorId);
            // [EndExclude sensor_js_get_sensor_list_example]
          }
        }
      });
    } catch (error) {
      hilog.info(this.DOMAIN, TAG, `beforeAll failed err.code ${error.code} ,err.message${error.message}`);
    }
    // [End sensor_js_get_sensor_list_example]
    hilog.info(this.DOMAIN, TAG, 'getSensorList left');
  }

  build() {
    Flex({
      direction: FlexDirection.Column, justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Center
    } as FlexOptions) {
      Scroll(this.scroller) {
        Column() {
          Text(`${this.callbackContent}`)
            .fontSize(14)
            .margin({ top: 15 })
            .id('callbackText')

          Text(`${this.sensorListByDevice}`)
            .fontSize(14)
            .id('deviceText')

          Text(`${this.sensorApiContent}`)
            .fontSize(14)
            .id('sensorApiText')
        }
      }
      .width('96%')
      .height('20%')
      .backgroundColor('#F1F1F1')
      .borderRadius(10)
      .borderColor($r('sys.color.popup_border_color'))

      TextInput({ placeholder: 'Please select sensor type', text: this.realSensorName })
        .placeholderColor('rgb(0,0,225)')
        .placeholderFont({
          size: 18,
          weight: FontWeight.Bold
        })
        .caretColor(Color.Blue)
        .id('sensor_type_selector')
        .height(50)
        .type(InputType.Normal)
        .fontSize(20)
        .fontWeight(FontWeight.Normal)
        .fontFamily('sans-serif')
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .enableKeyboardOnFocus(false)
        .textAlign(TextAlign.Center)
        .borderStyle(BorderStyle.Solid)
        .borderWidth(1)
        .borderColor('rgb(0,0,225)')
        .borderRadius(10)
        .focusable(false)
        .onClick(() => {
          for (let i = 0; i < this.sensorItems.length; i++) {
            console.info(TAG + ", i:" + this.sensorItems[i])
          }
          let uiContext = UIContext.getCallingScopeUIContext();
          if (uiContext != null) {
            uiContext.showTextPickerDialog({
              range: this.sensorItems,
              selected: 0,
              onAccept: (result: TextPickerResult) => {
                this.realSensorName = result.value.toString();
                console.info("TextPickerDialog:onAccept()" + JSON.stringify(result));
              },
              onCancel: () => {
                console.info("TextPickerDialog:onCancel()");
              },
              onChange: (value: TextPickerResult) => {
                console.info("TextPickerDialog:onChange()" + JSON.stringify(value));
              }
            } as TextPickerDialogOptions);
          }

        })
        .width('80%')
        .margin({ top: 10 })

      TextInput({ placeholder: 'deviceId' })
        .placeholderColor('rgb(0,0,225)')
        .placeholderFont({
          size: 18,
          weight: FontWeight.Bold
        })
        .caretColor(Color.Blue)
        .height(50)
        .type(InputType.NUMBER)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily('sans-serif')
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Red)
        .textAlign(TextAlign.Center)
        .onChange((value: string) => {
          this.deviceId = parseInt(value)
        })
        .width('100%')
        .margin({ top: 10 })

      Flex({
        direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceAround,
        alignItems: ItemAlign.Center
      } as FlexOptions) {
        Button($r('app.string.subscribe')).onClick(() => {
          try {
            hilog.info(this.DOMAIN, TAG, this.realSensorName + 'subscribe in')
            if (!this.supportSensorIdList.includes(this.sensors.get(this.realSensorName) as sensor.SensorId)) {
              hilog.info(this.DOMAIN, TAG, this.realSensorName, 'This is not support, please change other sensorId!');
              return
            }
            if (this.sensors.get(this.realSensorName) == 278) {
              hilog.info(this.DOMAIN, TAG, this.sensors.get(this.realSensorName) + 'on in');
              let atManager = abilityAccessCtrl.createAtManager();
              const context = this.getUIContext().getHostContext();
              if (context !== undefined && context !== null) {
                atManager.requestPermissionsFromUser(context, ['ohos.permission.READ_HEALTH_DATA']).then((data) => {
                  hilog.info(this.DOMAIN, TAG, 'Permissions requested');
                  hilog.info(this.DOMAIN, TAG, 'data:' + JSON.stringify(data));
                  hilog.info(this.DOMAIN, TAG, 'data permissions:' + data.permissions);
                  hilog.info(this.DOMAIN, TAG, 'data authResults:' + data.authResults);
                  const id = this.sensors.get(this.realSensorName) != undefined;
                  if (id != undefined) {
                    sensor.getSingleSensor(this.sensors.get(this.realSensorName) as sensor.SensorId, (error, data) => {
                      if (error) {
                        hilog.info(this.DOMAIN, TAG,
                          ' getSingleSensor failed, error: ' + error.code + ', ' + error.message);
                      } else {
                        try {
                          hilog.info(this.DOMAIN, TAG, ' getSingleSensor data: ' + JSON.stringify(data));
                        } catch (error) {
                          error = error as BusinessError;
                          console.info(TAG + ' catch error:' + error);
                          hilog.info(this.DOMAIN, TAG,
                            ' getSingleSensor catch errCode: ' + error.code + ' ,msg:' + error.message);
                        }
                      }
                    });
                  }
                });
              }
            } else { //普通sensor
              hilog.info(this.DOMAIN, TAG, 'before')
              if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ACCELEROMETER) {
                // [Start sensor_js_on_accelerometer_example]
                try {
                  sensor.onAccelerometerChange((data: sensor.AccelerometerResponse) => {
                    console.info(TAG + "Succeeded in obtaining data. x: " + data.x + " y: " + data.y + " z: " + data.z);
                    // [StartExclude sensor_js_on_accelerometer_example]
                    this.callbackContent = JSON.stringify(data);
                    // [EndExclude sensor_js_on_accelerometer_example]
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
                // [End sensor_js_on_accelerometer_example]
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.ACCELEROMETER_UNCALIBRATED) {
                try {
                  sensor.onAccelerometerUncalibratedChange((data: sensor.AccelerometerUncalibratedResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking on. X-coordinate bias: ' + data.biasX);
                    console.info('Succeeded in invoking on. Y-coordinate bias: ' + data.biasY);
                    console.info('Succeeded in invoking on. Z-coordinate bias: ' + data.biasZ);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.AMBIENT_LIGHT) {
                try {
                  sensor.onAmbientLightChange((data: sensor.LightResponse) => {
                    console.info('Succeeded in getting the ambient light intensity: ' + data.intensity);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.AMBIENT_TEMPERATURE) {
                try {
                  sensor.onAmbientTemperatureChange((data: sensor.AmbientTemperatureResponse) => {
                    console.info('Succeeded in invoking on. Temperature: ' + data.temperature);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.BAROMETER) {
                try {
                  sensor.onBarometerChange((data: sensor.BarometerResponse) => {
                    console.info('Succeeded in invoking on. Atmospheric pressure: ' + data.pressure);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.GRAVITY) {
                try {
                  sensor.onGravityChange((data: sensor.GravityResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.GYROSCOPE) {
                try {
                  sensor.onGyroscopeChange((data: sensor.GyroscopeResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.GYROSCOPE_UNCALIBRATED) {
                try {
                  sensor.onGyroscopeUncalibratedChange((data: sensor.GyroscopeUncalibratedResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking on. X-coordinate bias: ' + data.biasX);
                    console.info('Succeeded in invoking on. Y-coordinate bias: ' + data.biasY);
                    console.info('Succeeded in invoking on. Z-coordinate bias: ' + data.biasZ);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HALL) {
                try {
                  sensor.onHallChange((data: sensor.HallResponse) => {
                    console.info('Succeeded in invoking on. Hall status: ' + data.status);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HUMIDITY) {
                try {
                  sensor.onHumidityChange((data: sensor.HumidityResponse) => {
                    console.info('Succeeded in invoking on. Humidity: ' + data.humidity);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.LINEAR_ACCELEROMETER) {
                try {
                  sensor.onLinearAccelerometerChange((data: sensor.LinearAccelerometerResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.MAGNETIC_FIELD) {
                try {
                  sensor.onMagneticFieldChange((data: sensor.MagneticFieldResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.MAGNETIC_FIELD_UNCALIBRATED) {
                try {
                  sensor.onMagneticFieldUncalibratedChange((data: sensor.MagneticFieldUncalibratedResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking on. X-coordinate bias: ' + data.biasX);
                    console.info('Succeeded in invoking on. Y-coordinate bias: ' + data.biasY);
                    console.info('Succeeded in invoking on. Z-coordinate bias: ' + data.biasZ);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ORIENTATION) {
                try {
                  sensor.onOrientationChange((data: sensor.OrientationResponse) => {
                    console.info('Succeeded in the device rotating at an angle around the Z axis: ' + data.alpha);
                    console.info('Succeeded in the device rotating at an angle around the X axis: ' + data.beta);
                    console.info('Succeeded in the device rotating at an angle around the Y axis: ' + data.gamma);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.PEDOMETER) {
                try {
                  sensor.onPedometerChange((data: sensor.PedometerResponse) => {
                    console.info('Succeeded in invoking on. Step count: ' + data.steps);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.PEDOMETER_DETECTION) {
                try {
                  sensor.onPedometerDetectionChange((data: sensor.PedometerDetectionResponse) => {
                    console.info('Succeeded in invoking on. Pedometer scalar: ' + data.scalar);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.PROXIMITY) {
                try {
                  sensor.onProximityChange((data: sensor.ProximityResponse) => {
                    console.info('Succeeded in invoking on. Distance: ' + data.distance);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ROTATION_VECTOR) {
                try {
                  sensor.onRotationVectorChange((data: sensor.RotationVectorResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking on. Scalar quantity: ' + data.w);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.SIGNIFICANT_MOTION) {
                try {
                  sensor.onSignificantMotionChange((data: sensor.SignificantMotionResponse) => {
                    console.info('Succeeded in invoking on. Scalar data: ' + data.scalar);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.WEAR_DETECTION) {
                try {
                  sensor.onWearDetectionChange((data: sensor.WearDetectionResponse) => {
                    console.info('Succeeded in invoking on. Wear status: ' + data.value);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000 });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              }
              hilog.info(this.DOMAIN, TAG, 'left');
            }
          } catch (e) {
            hilog.error(this.DOMAIN, TAG, 'subscribe exception in,msg:' + JSON.stringify(e));
          }
        })
          .id('subscribeId')


        //------------------
        Button($r('app.string.subscribeUseSensorInfoParam')).onClick(() => {
          try {
            hilog.info(this.DOMAIN, TAG, this.realSensorName + 'subscribeUseSensorInfoParam in')
            if (!this.supportSensorIdList.includes(this.sensors.get(this.realSensorName) as sensor.SensorId)) {
              hilog.info(this.DOMAIN, TAG, 'This is not support, please change other sensorId!');
              return
            }
            if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HEART_RATE) {
              hilog.info(this.DOMAIN, TAG, this.sensors.get(this.realSensorName) as sensor.SensorId + 'on in');
              let atManager = abilityAccessCtrl.createAtManager();
              let context = this.getUIContext().getHostContext();
              if (context !== undefined && context !== null) {
                atManager.requestPermissionsFromUser(context, ['ohos.permission.READ_HEALTH_DATA']).then((data) => {
                  hilog.info(this.DOMAIN, TAG, 'data:' + JSON.stringify(data));
                  hilog.info(this.DOMAIN, TAG, 'data permissions:' + data.permissions);
                  hilog.info(this.DOMAIN, TAG, 'data authResults:' + data.authResults);
                  sensor.getSingleSensor(this.sensors.get(this.realSensorName) as sensor.SensorId, (err, data) => {
                    if (err) {
                      hilog.info(this.DOMAIN, TAG, JSON.stringify(err));
                      return;
                    }
                    if (data) {
                      try {
                        sensor.onHeartRateChange((data: sensor.HeartRateResponse) => {
                          console.info('Succeeded in invoking on. Heart rate: ' + data.heartRate);
                          this.callbackContent = JSON.stringify(data);
                        }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                      } catch (error) {
                        let e: BusinessError = error as BusinessError;
                        console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                      }
                    } else {
                      hilog.info(this.DOMAIN, TAG, 'Program run failed');
                    }
                  });
                });
              }
            } else { //普通sensor
              hilog.info(this.DOMAIN, TAG, 'before')
              if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ACCELEROMETER) {
                // [Start sensor_js_on_accelerometer_use_sensor_info_param_example]
                try {
                  sensor.onAccelerometerChange((data: sensor.AccelerometerResponse) => {
                    console.info("Succeeded in obtaining data. x: " + data.x + " y: " + data.y + " z: " + data.z);
                    // [StartExclude sensor_js_on_accelerometer_use_sensor_info_param_example]
                    this.callbackContent = JSON.stringify(data);
                    // [EndExclude sensor_js_on_accelerometer_use_sensor_info_param_example]
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
                // [End sensor_js_on_accelerometer_use_sensor_info_param_example]
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.ACCELEROMETER_UNCALIBRATED) {
                try {
                  sensor.onAccelerometerUncalibratedChange((data: sensor.AccelerometerUncalibratedResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking on. X-coordinate bias: ' + data.biasX);
                    console.info('Succeeded in invoking on. Y-coordinate bias: ' + data.biasY);
                    console.info('Succeeded in invoking on. Z-coordinate bias: ' + data.biasZ);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.AMBIENT_LIGHT) {
                try {
                  sensor.onAmbientLightChange((data: sensor.LightResponse) => {
                    console.info('Succeeded in getting the ambient light intensity: ' + data.intensity);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.AMBIENT_TEMPERATURE) {
                try {
                  sensor.onAmbientTemperatureChange((data: sensor.AmbientTemperatureResponse) => {
                    console.info('Succeeded in invoking on. Temperature: ' + data.temperature);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.BAROMETER) {
                try {
                  sensor.onBarometerChange((data: sensor.BarometerResponse) => {
                    console.info('Succeeded in invoking on. Atmospheric pressure: ' + data.pressure);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.GRAVITY) {
                try {
                  sensor.onGravityChange((data: sensor.GravityResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.GYROSCOPE) {
                try {
                  sensor.onGyroscopeChange((data: sensor.GyroscopeResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.GYROSCOPE_UNCALIBRATED) {
                try {
                  sensor.onGyroscopeUncalibratedChange((data: sensor.GyroscopeUncalibratedResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking on. X-coordinate bias: ' + data.biasX);
                    console.info('Succeeded in invoking on. Y-coordinate bias: ' + data.biasY);
                    console.info('Succeeded in invoking on. Z-coordinate bias: ' + data.biasZ);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HALL) {
                try {
                  sensor.onHallChange((data: sensor.HallResponse) => {
                    console.info('Succeeded in invoking on. Hall status: ' + data.status);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HUMIDITY) {
                try {
                  sensor.onHumidityChange((data: sensor.HumidityResponse) => {
                    console.info('Succeeded in invoking on. Humidity: ' + data.humidity);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.LINEAR_ACCELEROMETER) {
                try {
                  sensor.onLinearAccelerometerChange((data: sensor.LinearAccelerometerResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.MAGNETIC_FIELD) {
                try {
                  sensor.onMagneticFieldChange((data: sensor.MagneticFieldResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.MAGNETIC_FIELD_UNCALIBRATED) {
                try {
                  sensor.onMagneticFieldUncalibratedChange((data: sensor.MagneticFieldUncalibratedResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking on. X-coordinate bias: ' + data.biasX);
                    console.info('Succeeded in invoking on. Y-coordinate bias: ' + data.biasY);
                    console.info('Succeeded in invoking on. Z-coordinate bias: ' + data.biasZ);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ORIENTATION) {
                try {
                  sensor.onOrientationChange((data: sensor.OrientationResponse) => {
                    console.info('Succeeded in the device rotating at an angle around the Z axis: ' + data.alpha);
                    console.info('Succeeded in the device rotating at an angle around the X axis: ' + data.beta);
                    console.info('Succeeded in the device rotating at an angle around the Y axis: ' + data.gamma);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.PEDOMETER) {
                try {
                  sensor.onPedometerChange((data: sensor.PedometerResponse) => {
                    console.info('Succeeded in invoking on. Step count: ' + data.steps);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.PEDOMETER_DETECTION) {
                try {
                  sensor.onPedometerDetectionChange((data: sensor.PedometerDetectionResponse) => {
                    console.info('Succeeded in invoking on. Pedometer scalar: ' + data.scalar);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.PROXIMITY) {
                try {
                  sensor.onProximityChange((data: sensor.ProximityResponse) => {
                    console.info('Succeeded in invoking on. Distance: ' + data.distance);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ROTATION_VECTOR) {
                try {
                  sensor.onRotationVectorChange((data: sensor.RotationVectorResponse) => {
                    console.info('Succeeded in invoking on. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking on. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking on. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking on. Scalar quantity: ' + data.w);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.SIGNIFICANT_MOTION) {
                try {
                  sensor.onSignificantMotionChange((data: sensor.SignificantMotionResponse) => {
                    console.info('Succeeded in invoking on. Scalar data: ' + data.scalar);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.WEAR_DETECTION) {
                try {
                  sensor.onWearDetectionChange((data: sensor.WearDetectionResponse) => {
                    console.info('Succeeded in invoking on. Wear status: ' + data.value);
                    this.callbackContent = JSON.stringify(data);
                  }, { interval: 100000000, sensorInfoParam: { deviceId: -1 } });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
                }
              }
              hilog.info(this.DOMAIN, TAG, 'left');
            }
          } catch (e) {
            hilog.info(this.DOMAIN, TAG, 'subscribeUseSensorInfoParam exception in,msg:' + JSON.stringify(e));
          }
        })
          .id('subscribeUseSensorInfoParamId')

        Button($r('app.string.onceSubscribe')).onClick(() => {
          try {
            hilog.info(this.DOMAIN, TAG, this.realSensorName + 'onceSubscribe in')
            if (!this.supportSensorIdList.includes(this.sensors.get(this.realSensorName) as sensor.SensorId)) {
              hilog.info(this.DOMAIN, TAG, 'This is not support, please change other sensorId!');
              return
            }
            if (this.sensors.get(this.realSensorName) as sensor.SensorId == 278) {
              hilog.info(this.DOMAIN, TAG, this.sensors.get(this.realSensorName) as sensor.SensorId + 'once in');
              let atManager = abilityAccessCtrl.createAtManager();
              let context = this.getUIContext().getHostContext();
              if (context !== undefined && context !== null) {
                atManager.requestPermissionsFromUser(context, ['ohos.permission.READ_HEALTH_DATA']).then((data) => {
                  hilog.info(this.DOMAIN, TAG, 'data:' + JSON.stringify(data));
                  hilog.info(this.DOMAIN, TAG, 'data permissions:' + data.permissions);
                  hilog.info(this.DOMAIN, TAG, 'data authResults:' + data.authResults);
                  sensor.getSingleSensor(this.sensors.get(this.realSensorName) as sensor.SensorId, (err, data) => {
                    if (err) {
                      hilog.info(this.DOMAIN, TAG, JSON.stringify(err));
                      return;
                    }
                    if (data) {
                      try {
                        sensor.onceHeartRateChange((data: sensor.HeartRateResponse) => {
                          console.info('Succeeded in invoking once. Heart rate: ' + data.heartRate);
                          this.callbackContent = JSON.stringify(data);
                        });
                      } catch (error) {
                        let e: BusinessError = error as BusinessError;
                        console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                      }
                    } else {
                      hilog.info(this.DOMAIN, TAG, 'Program run failed');
                    }
                  });
                });
              }
            } else { //普通sensor
              hilog.info(this.DOMAIN, TAG, 'before')
              if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ACCELEROMETER) {
                // [Start sensor_js_once_accelerometer_example]
                try {
                  sensor.onceAccelerometerChange((data: sensor.AccelerometerResponse) => {
                    console.info("Succeeded in obtaining data. x: " + data.x + " y: " + data.y + " z: " + data.z);
                    // [StartExclude sensor_js_once_accelerometer_example]
                    this.callbackContent = JSON.stringify(data);
                    // [EndExclude sensor_js_once_accelerometer_example]
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
                // [End sensor_js_once_accelerometer_example]
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.ACCELEROMETER_UNCALIBRATED) {
                try {
                  sensor.onceAccelerometerUncalibratedChange((data: sensor.AccelerometerUncalibratedResponse) => {
                    console.info('Succeeded in invoking once. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking once. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking once. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking once. X-coordinate bias: ' + data.biasX);
                    console.info('Succeeded in invoking once. Y-coordinate bias: ' + data.biasY);
                    console.info('Succeeded in invoking once. Z-coordinate bias: ' + data.biasZ);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.AMBIENT_LIGHT) {
                try {
                  sensor.onceAmbientLightChange((data: sensor.LightResponse) => {
                    console.info('Succeeded in invoking once. the ambient light intensity: ' + data.intensity);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.AMBIENT_TEMPERATURE) {
                try {
                  sensor.onceAmbientTemperatureChange((data: sensor.AmbientTemperatureResponse) => {
                    console.info('Succeeded in invoking once. Temperature: ' + data.temperature);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.BAROMETER) {
                try {
                  sensor.onceBarometerChange((data: sensor.BarometerResponse) => {
                    console.info('Succeeded in invoking once. Atmospheric pressure: ' + data.pressure);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.GRAVITY) {
                try {
                  sensor.onceGravityChange((data: sensor.GravityResponse) => {
                    console.info('Succeeded in invoking once. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking once. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking once. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.GYROSCOPE) {
                try {
                  sensor.onceGyroscopeChange((data: sensor.GyroscopeResponse) => {
                    console.info('Succeeded in invoking once. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking once. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking once. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.GYROSCOPE_UNCALIBRATED) {
                try {
                  sensor.onceGyroscopeUncalibratedChange((data: sensor.GyroscopeUncalibratedResponse) => {
                    console.info('Succeeded in invoking once. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking once. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking once. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking once. X-coordinate bias: ' + data.biasX);
                    console.info('Succeeded in invoking once. Y-coordinate bias: ' + data.biasY);
                    console.info('Succeeded in invoking once. Z-coordinate bias: ' + data.biasZ);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HALL) {
                try {
                  sensor.onceHallChange((data: sensor.HallResponse) => {
                    console.info('Succeeded in invoking once. Status: ' + data.status);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HUMIDITY) {
                try {
                  sensor.onceHumidityChange((data: sensor.HumidityResponse) => {
                    console.info('Succeeded in invoking once. Humidity: ' + data.humidity);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.LINEAR_ACCELEROMETER) {
                try {
                  sensor.onceLinearAccelerometerChange((data: sensor.LinearAccelerometerResponse) => {
                    console.info('Succeeded in invoking once. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking once. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking once. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.MAGNETIC_FIELD) {
                try {
                  sensor.onceMagneticFieldChange((data: sensor.MagneticFieldResponse) => {
                    console.info('Succeeded in invoking once. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking once. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking once. Z-coordinate component: ' + data.z);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.MAGNETIC_FIELD_UNCALIBRATED) {
                try {
                  sensor.onceMagneticFieldUncalibratedChange((data: sensor.MagneticFieldUncalibratedResponse) => {
                    console.info('Succeeded in invoking once. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking once. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking once. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking once. X-coordinate bias: ' + data.biasX);
                    console.info('Succeeded in invoking once. Y-coordinate bias: ' + data.biasY);
                    console.info('Succeeded in invoking once. Z-coordinate bias: ' + data.biasZ);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ORIENTATION) {
                try {
                  sensor.onceOrientationChange((data: sensor.OrientationResponse) => {
                    console.info('Succeeded in the device rotating at an angle around the X axis: ' + data.beta);
                    console.info('Succeeded in the device rotating at an angle around the Y axis: ' + data.gamma);
                    console.info('Succeeded in the device rotating at an angle around the Z axis: ' + data.alpha);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.PEDOMETER) {
                try {
                  sensor.oncePedometerChange((data: sensor.PedometerResponse) => {
                    console.info('Succeeded in invoking once. Step count: ' + data.steps);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.PEDOMETER_DETECTION) {
                try {
                  sensor.oncePedometerDetectionChange((data: sensor.PedometerDetectionResponse) => {
                    console.info('Succeeded in invoking once. Scalar data: ' + data.scalar);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.PROXIMITY) {
                try {
                  sensor.onceProximityChange((data: sensor.ProximityResponse) => {
                    console.info('Succeeded in invoking once. Distance: ' + data.distance);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ROTATION_VECTOR) {
                try {
                  sensor.onceRotationVectorChange((data: sensor.RotationVectorResponse) => {
                    console.info('Succeeded in invoking once. X-coordinate component: ' + data.x);
                    console.info('Succeeded in invoking once. Y-coordinate component: ' + data.y);
                    console.info('Succeeded in invoking once. Z-coordinate component: ' + data.z);
                    console.info('Succeeded in invoking once. Scalar quantity: ' + data.w);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.SIGNIFICANT_MOTION) {
                try {
                  sensor.onceSignificantMotionChange((data: sensor.SignificantMotionResponse) => {
                    console.info('Succeeded in invoking once. Scalar data: ' + data.scalar);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.WEAR_DETECTION) {
                try {
                  sensor.onceWearDetectionChange((data: sensor.WearDetectionResponse) => {
                    console.info('Succeeded in invoking once. Wear status: ' + data.value);
                    this.callbackContent = JSON.stringify(data);
                  });
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                }
              }
              hilog.info(this.DOMAIN, TAG, 'left')
            }
          } catch (e) {
            hilog.info(this.DOMAIN, TAG, 'onceSubscribe exception in,msg:' + JSON.stringify(e))
          }
        })
          .id('onceSubscribeId')

        Button($r('app.string.unSubscribe')).onClick(() => {
          hilog.info(this.DOMAIN, TAG, 'unSubscribe in');
          try {
            if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ACCELEROMETER) {
              // [Start sensor_js_off_accelerometer_example]
              try {
                sensor.offAccelerometerChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
              // [End sensor_js_off_accelerometer_example]
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
              sensor.SensorId.ACCELEROMETER_UNCALIBRATED) {
              try {
                sensor.offAccelerometerUncalibratedChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.AMBIENT_LIGHT) {
              try {
                sensor.offAmbientLightChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
              sensor.SensorId.AMBIENT_TEMPERATURE) {
              try {
                sensor.offAmbientTemperatureChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.BAROMETER) {
              try {
                sensor.offBarometerChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.GRAVITY) {
              try {
                sensor.offGravityChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.GYROSCOPE) {
              try {
                sensor.offGyroscopeChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
              sensor.SensorId.GYROSCOPE_UNCALIBRATED) {
              try {
                sensor.offGyroscopeUncalibratedChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HALL) {
              try {
                sensor.offHallChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HUMIDITY) {
              try {
                sensor.offHumidityChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
              sensor.SensorId.LINEAR_ACCELEROMETER) {
              try {
                sensor.offLinearAccelerometerChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.MAGNETIC_FIELD) {
              try {
                sensor.offMagneticFieldChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
              sensor.SensorId.MAGNETIC_FIELD_UNCALIBRATED) {
              try {
                sensor.offMagneticFieldUncalibratedChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ORIENTATION) {
              try {
                sensor.offOrientationChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.PEDOMETER) {
              try {
                sensor.offPedometerChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
              sensor.SensorId.PEDOMETER_DETECTION) {
              try {
                sensor.offPedometerDetectionChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.PROXIMITY) {
              try {
                sensor.offProximityChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ROTATION_VECTOR) {
              try {
                sensor.offRotationVectorChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.SIGNIFICANT_MOTION) {
              try {
                sensor.offSignificantMotionChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.WEAR_DETECTION) {
              try {
                sensor.offWearDetectionChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HEART_RATE) {
              try {
                sensor.offHeartRateChange();
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
              }
            }
          } catch (error) {
            let e: BusinessError = error as BusinessError;
            console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
          }
          this.callbackContent = '';
        })
          .id('unSubscribeId')

        Button($r('app.string.unSubscribeUseSensorInfoParam')).onClick(() => {
          hilog.info(this.DOMAIN, TAG, 'unSubscribeUseSensorInfoParam in');
          if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ACCELEROMETER) {
            // [Start sensor_js_off_accelerometer_use_sensor_info_param_example]
            try {
              sensor.offAccelerometerChange({ deviceId: -1 });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_off_accelerometer_use_sensor_info_param_example]
          } else {
            try {
              if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ACCELEROMETER) {
                // [Start sensor_js_off_accelerometer_example]
                try {
                  sensor.offAccelerometerChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
                // [End sensor_js_off_accelerometer_example]
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.ACCELEROMETER_UNCALIBRATED) {
                try {
                  sensor.offAccelerometerUncalibratedChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.AMBIENT_LIGHT) {
                try {
                  sensor.offAmbientLightChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.AMBIENT_TEMPERATURE) {
                try {
                  sensor.offAmbientTemperatureChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.BAROMETER) {
                try {
                  sensor.offBarometerChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.GRAVITY) {
                try {
                  sensor.offGravityChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.GYROSCOPE) {
                try {
                  sensor.offGyroscopeChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.GYROSCOPE_UNCALIBRATED) {
                try {
                  sensor.offGyroscopeUncalibratedChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HALL) {
                try {
                  sensor.offHallChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HUMIDITY) {
                try {
                  sensor.offHumidityChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.LINEAR_ACCELEROMETER) {
                try {
                  sensor.offLinearAccelerometerChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.MAGNETIC_FIELD) {
                try {
                  sensor.offMagneticFieldChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.MAGNETIC_FIELD_UNCALIBRATED) {
                try {
                  sensor.offMagneticFieldUncalibratedChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ORIENTATION) {
                try {
                  sensor.offOrientationChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.PEDOMETER) {
                try {
                  sensor.offPedometerChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.PEDOMETER_DETECTION) {
                try {
                  sensor.offPedometerDetectionChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.PROXIMITY) {
                try {
                  sensor.offProximityChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.ROTATION_VECTOR) {
                try {
                  sensor.offRotationVectorChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId ==
                sensor.SensorId.SIGNIFICANT_MOTION) {
                try {
                  sensor.offSignificantMotionChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.WEAR_DETECTION) {
                try {
                  sensor.offWearDetectionChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              } else if (this.sensors.get(this.realSensorName) as sensor.SensorId == sensor.SensorId.HEART_RATE) {
                try {
                  sensor.offHeartRateChange();
                } catch (error) {
                  let e: BusinessError = error as BusinessError;
                  console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
                }
              }
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to invoke off. Code: ${e.code}, message: ${e.message}`);
            }
          }
          this.callbackContent = '';
        })
          .id('unSubscribeUseSensorInfoParamId')

        Button($r('app.string.getSensorListByDeviceSync'))
          .onClick(() => {
            hilog.info(this.DOMAIN, TAG, 'getSensorListByDeviceSync in');
            // [Start sensor_js_get_sensor_list_by_device_example]
            try {
              this.deviceId = -1 as int;
              // 第一个参数deviceId 非必填，缺省默认查询的为本地设备。
              const sensorList: sensor.Sensor[] = sensor.getSensorListByDeviceSync(Double.toInt(this.deviceId));
              console.info(`sensorList length: ${sensorList.length}`);
              console.info(`sensorList: ${JSON.stringify(sensorList)}`);
              // [StartExclude sensor_js_get_sensor_list_by_device_example]
              this.sensorListByDevice = 'sensorInfoList:' + JSON.stringify(sensorList);
              this.sensorListByDeviceList = sensorList;
              // [EndExclude sensor_js_get_sensor_list_by_device_example]
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get sensorList. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_sensor_list_by_device_example]
          })
          .id('getSensorListByDeviceId')

        Button($r('app.string.getSingleSensorByDeviceSync'))
          .onClick(() => {
            // [Start sensor_js_get_single_sensor_by_device_sync_example]
            try {
              this.deviceId = -1 as int;
              // 第二个参数deviceId 非必填
              const sensorList: sensor.Sensor[] =
                sensor.getSingleSensorByDeviceSync(sensor.SensorId.ACCELEROMETER as sensor.SensorId,
                  Double.toInt(this.deviceId));
              console.info(`sensorList length: ${sensorList.length}`);
              console.info(`sensorList Json: ${JSON.stringify(sensorList)}`);
              // [StartExclude sensor_js_get_single_sensor_by_device_sync_example]
              this.sensorListByDevice = 'sensor_test:' + JSON.stringify(sensorList);
              // [EndExclude sensor_js_get_single_sensor_by_device_sync_example]
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get sensorList. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_single_sensor_by_device_sync_example]
          })
          .id('getSingleDeviceId')

        Button($r('app.string.on'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            hilog.info(this.DOMAIN, TAG, "sensor.onSensorStatusChange");
            // [Start sensor_js_on_sensor_status_change_example]
            try {
              sensor.onSensorStatusChange((data: sensor.SensorStatusEvent) => {
                console.info(`timestamp: ${data.timestamp},
                  deviceId: ${data.deviceId} deviceName: ${data.deviceName}
                  sensorId: ${data.sensorId} sensorIndex:${data.sensorIndex} isSensorOnline: ${data.isSensorOnline}`);
              });
              // [StartExclude sensor_js_on_sensor_status_change_example]
              this.callbackContent = 'on:sensorStatusChange';
              // [EndExclude sensor_js_on_sensor_status_change_example]
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_on_sensor_status_change_example]
          })
          .id('onSensorStatusId')

        Button($r('app.string.off'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            // [Start sensor_js_off_sensor_status_change_example]
            try {
              sensor.offSensorStatusChange();
              // [StartExclude sensor_js_off_sensor_status_change_example]
              this.callbackContent = 'off:sensorStatusChange';
              // [EndExclude sensor_js_off_sensor_status_change_example]
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_off_sensor_status_change_example]
          })
          .id('offSensorStatusId')

        Button($r('app.string.getGeomagneticInfo'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            // [Start sensor_js_get_geomagnetic_info_callback_example]
            try {
              sensor.getGeomagneticInfo({ latitude: 80, longitude: 0, altitude: 0 }, 1580486400000, (error, data) => {
                if (error) {
                  hilog.info(this.DOMAIN, TAG, ` getGeomagneticInfo error, ${error.code} , ${error.message}`);
                } else {
                  hilog.info(this.DOMAIN, TAG, ' getGeomagneticInfo success');
                  if (data) {
                    hilog.info(this.DOMAIN, TAG, ' getGeomagneticInfo data: ' + data);
                    hilog.info(this.DOMAIN, TAG, ' x: ' + data.x);
                    hilog.info(this.DOMAIN, TAG, ' y: ' + data.y);
                    hilog.info(this.DOMAIN, TAG, ' z: ' + data.z);
                    hilog.info(this.DOMAIN, TAG, ' geomagneticDip: ' + data.geomagneticDip);
                    hilog.info(this.DOMAIN, TAG, ' deflectionAngle: ' + data.deflectionAngle);
                    hilog.info(this.DOMAIN, TAG, ' levelIntensity: ' + data.levelIntensity);
                    hilog.info(this.DOMAIN, TAG, ' totalIntensity: ' + data.totalIntensity);
                  } else {
                    hilog.info(this.DOMAIN, TAG, ' getGeomagneticInfo data is null');
                  }
                }
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get geomagneticInfo. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_geomagnetic_info_callback_example]
            // [Start sensor_js_get_geomagnetic_info_promise_example]
            try {
              sensor.getGeomagneticInfo({ latitude: 80, longitude: 0, altitude: 0 }, 1580486400000).then((data) => {
                console.info("Succeeded in getting geomagneticInfo x" + data.x);
                console.info("Succeeded in getting geomagneticInfo y" + data.y);
                console.info("Succeeded in getting geomagneticInfo z" + data.z);
                console.info("Succeeded in getting geomagneticInfo geomagneticDip" + data.geomagneticDip);
                console.info("Succeeded in getting geomagneticInfo deflectionAngle" + data.deflectionAngle);
                console.info("Succeeded in getting geomagneticInfo levelIntensity" + data.levelIntensity);
                console.info("Succeeded in getting geomagneticInfo totalIntensity" + data.totalIntensity);
              }, (err) => {
                console.error(`Failed to get geomagneticInfo. Code: ${err.code}, message: ${err.message}`);
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get geomagneticInfo. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_geomagnetic_info_promise_example]
            this.sensorApiContent = 'geomagneticInfo:success';
          })
          .id('getGeomagneticInfoId')

        Button($r('app.string.getDeviceAltitude'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            // [Start sensor_js_get_device_altitude_callback_example]
            try {
              let seaPressure = 1013.2;
              let currentPressure = 1500.0;
              sensor.getDeviceAltitude(seaPressure, currentPressure, (err, data) => {
                if (err) {
                  console.error(`Failed to get altitude. Code: ${err.code}, message: ${err.message}`);
                  return;
                }
                console.info('Succeeded in getting altitude: ' + data);
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get altitude. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_device_altitude_callback_example]
            // [Start sensor_js_get_device_altitude_promise_example]
            try {
              let seaPressure = 1013.2;
              let currentPressure = 1500.0;
              sensor.getDeviceAltitude(seaPressure, currentPressure).then((data: number) => {
                console.info('Succeeded in getting device altitude: ', data);
              }, (err) => {
                console.error(`Failed to get altitude. Code: ${err.code}, message: ${err.message}`);
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get altitude. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_device_altitude_promise_example]
            this.sensorApiContent = 'deviceAltitude:success';
          })
          .id('getDeviceAltitudeId')

        Button($r('app.string.getInclination'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            // [Start sensor_js_get_inclination_callback_example]
            try {
              // inclinationMatrix可以为3*3，或者4*4
              let inclinationMatrix: Array<double> = [
                1, 0, 0,
                0, 1, 0,
                0, 0, 1
              ]
              sensor.getInclination(inclinationMatrix, (err, data) => {
                if (err) {
                  console.error(`Failed to get inclination. Code: ${err.code}, message: ${err.message}`);
                  return;
                }
                console.info('Succeeded in getting inclination: ' + data);
              })
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get inclination. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_inclination_callback_example]
            // [Start sensor_js_get_inclination_promise_example]
            try {
              // inclinationMatrix可以为3*3，或者4*4
              let inclinationMatrix: Array<double> = [
                1, 0, 0,
                0, 1, 0,
                0, 0, 1
              ]
              sensor.getInclination(inclinationMatrix).then((data: number) => {
                console.info('Succeeded in getting inclination: ' + data);
              }, (err) => {
                console.error(`Failed to get inclination. Code: ${err.code}, message: ${err.message}`);
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get inclination. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_inclination_promise_example]
            this.sensorApiContent = 'inclination:success';
          })
          .id('getInclinationId')

        Button($r('app.string.getAngleVariation'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            // [Start sensor_js_get_angle_variation_callback_example]
            try {
              // 旋转矩阵可以为3*3，或者4*4
              let currentRotationMatrix: Array<double> = [
                1, 0, 0,
                0, 1, 0,
                0, 0, 1
              ];
              let preRotationMatrix: Array<double> = [
                1, 0, 0,
                0, 0.87, -0.50,
                0, 0.50, 0.87
              ];
              sensor.getAngleVariation(currentRotationMatrix, preRotationMatrix, (err, data) => {
                if (err) {
                  console.error(`Failed to get angle variation. Code: ${err.code}, message: ${err.message}`);
                  return;
                }
                if (data != null) {
                  if (data.length < 3) {
                    console.error("Failed to get angle variation, length" + data.length);
                    return;
                  }
                  console.info("Z: " + data[0]);
                  console.info("X: " + data[1]);
                  console.info("Y: " + data[2]);
                }
              })
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get angle variation. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_angle_variation_callback_example]
            // [Start sensor_js_get_angle_variation_promise_example]
            try {
              // 旋转矩阵可以为3*3，或者4*4
              let currentRotationMatrix: Array<double> = [
                1, 0, 0,
                0, 1, 0,
                0, 0, 1
              ];
              let preRotationMatrix: Array<double> = [
                1, 0, 0,
                0, 0.87, -0.50,
                0, 0.50, 0.87
              ];
              sensor.getAngleVariation(currentRotationMatrix, preRotationMatrix).then((data: Array<number>) => {
                if (data.length < 3) {
                  console.error("Failed to get angle variation, length" + data.length);
                  return;
                }
                console.info("Z: " + data[0]);
                console.info("X: " + data[1]);
                console.info("Y: " + data[2]);
              }, (err) => {
                console.error(`Failed to get angle variation. Code: ${err.code}, message: ${err.message}`);
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get angle variation. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_angle_variation_promise_example]
            this.sensorApiContent = 'angleVariation:success';
          })
          .id('getAngleVariationId')

        Button($r('app.string.getRotationMatrix'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            // [Start sensor_js_get_rotation_matrix_callback_example]
            try {
              let rotationVector: Array<double> = [0.20046076, 0.21907, 0.73978853, 0.60376877];
              sensor.getRotationMatrix(rotationVector, (err, data) => {
                if (err) {
                  console.error(`Failed to get rotationMatrix. Code: ${err.code}, message: ${err.message}`);
                  return;
                }
                if (data != null) {
                  for (let i = 0; i < data.length; i++) {
                    console.info('Succeeded in getting data[' + i + ']: ' + data[i]);
                  }
                }
              })
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get rotationMatrix. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_rotation_matrix_callback_example]
            // [Start sensor_js_get_rotation_matrix_promise_example]
            try {
              let rotationVector: Array<double> = [0.20046076, 0.21907, 0.73978853, 0.60376877];
              sensor.getRotationMatrix(rotationVector).then((data: Array<number>) => {
                for (let i = 0; i < data.length; i++) {
                  console.info('Succeeded in getting data[' + i + ']: ' + data[i]);
                }
              }, (err) => {
                console.error(`Failed to get rotationMatrix. Code: ${err.code}, message: ${err.message}`);
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get rotationMatrix. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_rotation_matrix_promise_example]
            this.sensorApiContent = 'rotationMatrix:success';
          })
          .id('getRotationMatrixId')

        Button($r('app.string.transformRotationMatrix'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            // [Start sensor_js_transform_rotation_matrix_callback_example]
            try {
              let rotationMatrix: Array<double> = [
                1, 0, 0,
                0, 0.87, -0.50,
                0, 0.50, 0.87
              ];
              sensor.transformRotationMatrix(rotationMatrix, { x: 1, y: 3 }, (err, data) => {
                if (err) {
                  console.error(`Failed to transform rotationMatrix. Code: ${err.code}, message: ${err.message}`);
                  return;
                }
                if (data != null) {
                  for (let i = 0; i < data.length; i++) {
                    console.info('Succeeded in getting data[' + i + '] = ' + data[i]);
                  }
                }
              })
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to transform rotationMatrix. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_transform_rotation_matrix_callback_example]
            // [Start sensor_js_transform_rotation_matrix_promise_example]
            try {
              let rotationMatrix: Array<double> = [
                1, 0, 0,
                0, 0.87, -0.50,
                0, 0.50, 0.87
              ];
              sensor.transformRotationMatrix(rotationMatrix, { x: 1, y: 3 }).then((data: Array<number>) => {
                for (let i = 0; i < data.length; i++) {
                  console.info('Succeeded in getting data[' + i + ']: ' + data[i]);
                }
              }, (err) => {
                console.error(`Failed to transform rotationMatrix. Code: ${err.code}, message: ${err.message}`);
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to transform rotationMatrix. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_transform_rotation_matrix_promise_example]
            this.sensorApiContent = 'transformRotationMatrix:success';
          })
          .id('transformRotationMatrixId')

        Button($r('app.string.getQuaternion'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            // [Start sensor_js_get_quaternion_callback_example]
            try {
              let rotationVector: Array<double> = [0.20046076, 0.21907, 0.73978853, 0.60376877];
              sensor.getQuaternion(rotationVector, (err, data) => {
                if (err) {
                  console.error(`Failed to get quaternion. Code: ${err.code}, message: ${err.message}`);
                  return;
                }
                if (data != null) {
                  for (let i = 0; i < data.length; i++) {
                    console.info('Succeeded in getting data[' + i + ']: ' + data[i]);
                  }
                }
              })
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get quaternion. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_quaternion_callback_example]
            // [Start sensor_js_get_quaternion_promise_example]
            try {
              let rotationVector: Array<double> = [0.20046076, 0.21907, 0.73978853, 0.60376877];
              sensor.getQuaternion(rotationVector).then((data) => {
                for (let i = 0; i < data.length; i++) {
                  console.info('Succeeded in getting data[' + i + ']: ' + data[i]);
                }
              }, (err) => {
                console.error(`Failed to get quaternion. Code: ${err.code}, message: ${err.message}`);
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get quaternion. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_quaternion_promise_example]
            this.sensorApiContent = 'quaternion:success';
          })
          .id('getQuaternionId')

        Button($r('app.string.getOrientation'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            // [Start sensor_js_get_orientation_callback_example]
            try {
              let preRotationMatrix: Array<double> = [
                1, 0, 0,
                0, 0.87, -0.50,
                0, 0.50, 0.87
              ];
              sensor.getOrientation(preRotationMatrix, (err, data) => {
                if (err) {
                  console.error(`Failed to get orientation. Code: ${err.code}, message: ${err.message}`);
                  return;
                }
                if (data != null) {
                  if (data.length < 3) {
                    console.error("Failed to get orientation, length" + data.length);
                  }
                  console.info("Succeeded in getting data. Z: " + data[0]);
                  console.info("Succeeded in getting data. X: " + data[1]);
                  console.info("Succeeded in getting data. Y: " + data[2]);
                }
              })
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get orientation. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_orientation_callback_example]
            // [Start sensor_js_get_orientation_promise_example]
            try {
              let preRotationMatrix: Array<double> = [
                1, 0, 0,
                0, 0.87, -0.50,
                0, 0.50, 0.87
              ];
              sensor.getOrientation(preRotationMatrix).then((data: Array<number>) => {
                for (let i = 0; i < data.length; i++) {
                  console.info('Succeeded in getting data[' + i + ']: ' + data[i]);
                }
              }, (err) => {
                console.error(`Failed to get orientation. Code: ${err.code}, message: ${err.message}`);
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get orientation. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_orientation_promise_example]
            this.sensorApiContent = 'orientation:success';
          })
          .id('getOrientationId')

        Button($r('app.string.getRotationMatrixTwoParam'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            // [Start sensor_js_get_rotation_matrix_two_param_callback_example]
            try {
              let gravity: Array<double> = [-0.27775216, 0.5351276, 9.788099];
              let geomagnetic: Array<double> = [210.87253, -78.6096, -111.44444];
              sensor.getRotationMatrix(gravity, geomagnetic, (err, data) => {
                if (err) {
                  console.error(`Failed to get rotationMatrix. Code: ${err.code}, message: ${err.message}`);
                  return;
                }
                console.info('Succeeded in getting rotationMatrix' + JSON.stringify(data));
              })
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get rotationMatrix. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_rotation_matrix_two_param_callback_example]
            // [Start sensor_js_get_rotation_matrix_two_param_promise_example]
            try {
              let gravity: Array<double> = [-0.27775216, 0.5351276, 9.788099];
              let geomagnetic: Array<double> = [210.87253, -78.6096, -111.44444];
              sensor.getRotationMatrix(gravity, geomagnetic).then((data: sensor.RotationMatrixResponse) => {
                console.info('Succeeded in getting rotationMatrix' + JSON.stringify(data));
              }, (err) => {
                console.error(`Failed to get rotationMatrix. Code: ${err.code}, message: ${err.message}`);
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get rotationMatrix. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_rotation_matrix_two_param_promise_example]
            this.sensorApiContent = 'rotationMatrixTwoParam:success';
          })
          .id('getRotationMatrixTwoParamId')

        Button($r('app.string.getSingleSensor'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .onClick(() => {
            // [Start sensor_js_get_single_sensor_callback_example]
            try {
              sensor.getSingleSensor(sensor.SensorId.ACCELEROMETER, (err, data) => {
                if (err) {
                  console.error(`Failed to get singleSensor. Code: ${err.code}, message: ${err.message}`);
                  return;
                }
                console.info('Succeeded in getting sensor: ' + JSON.stringify(data));
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get singleSensor. Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_single_sensor_callback_example]
            // [Start sensor_js_get_single_sensor_promise_example]
            try {
              sensor.getSingleSensor(sensor.SensorId.ACCELEROMETER).then((data) => {
                console.info('Succeeded in getting sensor: ' + JSON.stringify(data));
              }, (err) => {
                console.error(`Failed to get singleSensor. Code: ${err.code}, message: ${err.message}`);
              });
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get singleSensor . Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_single_sensor_promise_example]
            // [Start sensor_js_get_single_sensor_sync_example]
            try {
              let ret = sensor.getSingleSensorSync(sensor.SensorId.ACCELEROMETER);
              console.info('Succeeded in getting sensor: ' + JSON.stringify(ret));
            } catch (error) {
              let e: BusinessError = error as BusinessError;
              console.error(`Failed to get singleSensor . Code: ${e.code}, message: ${e.message}`);
            }
            // [End sensor_js_get_single_sensor_sync_example]
            this.sensorApiContent = 'singleSensor:success';
          })
          .id('getSingleSensorId')

        Button($r('app.string.clean'))
          .onClick(() => {
            this.sensorListByDevice = '';
            this.sensorApiContent = '';
          })
          .id('cleanId')
      }
      .margin({ top: 20 })
      .width('100%')
      .height('70%')
    }
    .height('100%')
    .width('100%')

  }
}