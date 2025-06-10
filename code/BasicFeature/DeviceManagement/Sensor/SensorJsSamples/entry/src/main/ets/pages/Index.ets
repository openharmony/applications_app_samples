/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import AbilityAccessCtrl from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import { sensor } from '@kit.SensorServiceKit';
import { ComponentContent, promptAction, PromptAction, SelectDialog } from '@kit.ArkUI';
import BusinessError from '@ohos.base';
import hilog from '@ohos.hilog'


let TAG = 'sensor: '

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

class Logger {
  private domain: number = 0xC02701;
  private prefix: string = '[Sample_Vibrator]'
  private format: string = '%{public}, %{public}'
  debug(...args: string[]) {
    hilog.debug(this.domain, this.prefix, this.format, args)
  }
  info(...args: string[]) {
    hilog.info(this.domain, this.prefix, this.format, args)
  }
  error(...args: string[]) {
    hilog.error(this.domain, this.prefix, this.format, args)
  }
}
const logger = new Logger();

@Entry
@Component
struct SensorList {
  @State
  private sensorItems: string[] = [];
  private sampleRate: number = 200000000;
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  dialogControllerList: CustomDialogController | null = null;
  selectedSensorId: number = 0;
  @State
  private realSensorName: string = '';
  @State
  private deviceId: number = 0;
  private strDeviceId: string = '';
  private sensors = new Map<string, number>();
  @State
  private callbackContent:string = '';
  @State
  private SensorListByDevice:string = '';
  SensorListByDeviceList: sensor.Sensor[] = [];
  private supportSensorIdList: (number|undefined)[] = [1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 256,
    257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 277, 278, 279, 280, 281, 282];
  private checkDeviceId(): CheckRet {
    if (!this.strDeviceId.length) {
      return { ok: false, ret: -1 };
    }
    return { ok: true, ret: Number(this.deviceId) };
  }

  sensorStatusChangeCallback = (data: sensor.SensorStatusEvent) => {
    logger.debug('Succeeded in getting data: ' + JSON.stringify(data));
  };

  private getUserOption(): sensor.Options {
    let result: sensor.Options = {};
    if (options.interval.length) {
      result.interval = Number(options.interval);
    }
    if (options.sensorInfoParam.deviceId.length) {
      if (!result.sensorInfoParam) {
        result.sensorInfoParam = {};
      }
      result.sensorInfoParam.deviceId = Number(options.sensorInfoParam.deviceId);
    }
    if (options.sensorInfoParam.sensorIndex.length) {
      if (!result.sensorInfoParam) {
        result.sensorInfoParam = {};
      }
      result.sensorInfoParam.sensorIndex = Number(options.sensorInfoParam.sensorIndex);
    }
    return result;
  }

  onPageShow(): void {
    let traceCount = 0;
    logger.info(TAG + 'getSensorList in');
    try {
      sensor.getSensorList((error, data) => {
        if (error) {
          logger.info(TAG + 'getSensorList failed');
        } else {
          logger.info(TAG + 'getSensorList call back in');
          for (let i = 0; i < data.length; i++) {
            logger.info(TAG + 'getSensorList ' + JSON.stringify(data[i]));
            this.sensorItems[i] = data[i].sensorName;
            this.sensors.set(data[i].sensorName, data[i].sensorId);
          }
        };
      });
    } catch (e) {
      logger.error(TAG + 'get list exception in2, code:' + e.code + 'msg:' + e.message);
      logger.error(TAG + 'get list exception in1, msg:' + JSON.stringify(e));
    }
    logger.info(TAG + 'getSensorList left');
  }
  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      TextInput({ placeholder: 'Please select sensor type', text: this.realSensorName })
        .placeholderColor('rgb(0,0,225)')
        .placeholderFont({ size: 20, weight: 100, family: 'cursive', style: FontStyle.Italic })
        .caretColor(Color.Blue)
        .height(50)
        .type(InputType.Normal)
        .fontSize(20)
        .fontWeight(FontWeight.Normal)
        .fontFamily('sans-serif')
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .enableKeyboardOnFocus(false)
        .textAlign(TextAlign.Center)
        .borderStyle(BorderStyle.Solid).borderWidth(1).borderColor('rgb(0,0,225)').borderRadius(10)
        .focusable(false)
        .onClick(() => {
          TextPickerDialog.show({
            range: this.sensorItems,
            selected: 0,
            onAccept: (result: TextPickerResult) => {
              this.realSensorName = result.value.toString();
            },
            onCancel: () => {
              logger.info(TAG, 'TextPickerDialog onCancel');
            }
          });
        })
        .width('80%')
        .margin({top: 10})

      TextInput({ placeholder: 'deviceId' })
        .placeholderColor('rgb(0,0,225)')
        .placeholderFont({ size: 20, weight: 100, family: 'cursive', style: FontStyle.Italic })
        .caretColor(Color.Blue)
        .height(50)
        .type(InputType.Number)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily('sans-serif')
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Red)
        .textAlign(TextAlign.Center)
        .onChange((value: string) => {
          this.deviceId = parseInt(value)
        }).width('100%')
        .margin({top: 10})

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center}) {
        Button($r('app.string.subscribe')).onClick(() => {
          try {
            logger.info(TAG + this.realSensorName + 'subscribe in')
            if (!this.supportSensorIdList.includes(this.sensors.get(this.realSensorName))) {
              logger.info('This is not support, please change other sensorId!');
              return
            }
            if(this.sensors.get(this.realSensorName) == 278) {
              logger.info(TAG + this.sensors.get(this.realSensorName) +  'on in');
              let atManager = AbilityAccessCtrl.createAtManager();
              let context = getContext(this) as common.UIAbilityContext;
              atManager.requestPermissionsFromUser(context, ['ohos.permission.READ_HEALTH_DATA'], (err, data)=>{
                if (err) {
                  logger.info(TAG + 'grant READ_HEALTH_DATA failed:' + JSON.stringify(data));
                  return;
                }
                logger.info(TAG + 'data:' + JSON.stringify(data));
                logger.info(TAG + 'data permissions:' + data.permissions);
                logger.info(TAG + 'data authResults:' + data.authResults);
                sensor.getSingleSensor(this.sensors.get(this.realSensorName), (err, data) => {
                  if(err) {
                    logger.error(TAG + JSON.stringify(err));
                    return;
                  }
                  if(data) {
                    const userOption = this.getUserOption();
                    sensor.on(this.sensors.get(this.realSensorName), (data:sensor.Response)=>{
                      logger.info(TAG + 'PEDOMETER: ' + JSON.stringify(data));
                      this.callbackContent = JSON.stringify(data);
                    }, userOption)
                  } else {
                    logger.info(TAG + 'Program run failed');
                  }
                });
              });
            } else { //普通sensor
              logger.info('before')
              let countSame:number = 0;
              let timestamp:number = 0;
              let countSame2:number = 0;
              let timestamp2:number = 0;
              sensor.on(this.sensors.get(this.realSensorName), ((data:sensor.Response) => {
                logger.info(TAG + 'callback: ' + JSON.stringify(data));
                this.callbackContent = JSON.stringify(data)
                if (data.timestamp - timestamp == 0) {
                  countSame = countSame + 1;
                  logger.info(TAG + 'callbackcountSame: ' + JSON.stringify(data));
                }
                timestamp = data.timestamp;
              }), {'interval': this.sampleRate});
              logger.info('left')

            }
          }catch(e) {
            logger.info(TAG + 'subscribe exception in,msg:' + JSON.stringify(e))
            logger.info(TAG + 'unSubscribe exception in,code:' + e.code + 'msg:' + e.message)
          }
        })

        Button($r('app.string.unSubscribe')).onClick(() => {
          logger.info(TAG + 'unSubscribe in');
          try {
            sensor.off(this.sensors.get(this.realSensorName));
          }catch(e) {
            logger.info(TAG + 'unSubscribe exception in,msg:' + JSON.stringify(e));
          }
          this.callbackContent = '';
        })

        Button($r('app.string.getSensorListByDeviceSync'))
          .onClick(() => {
            logger.info(TAG + 'getSensorListByDeviceSync in');
            try {
              let sensorInfoList = sensor.getSensorListByDeviceSync();
              this.SensorListByDevice = 'sensorInfoList:' + JSON.stringify(sensorInfoList);
              this.SensorListByDeviceList = sensorInfoList;
              logger.info(TAG + 'unSubscribe exception in,msg:' + JSON.stringify(sensorInfoList))
            } catch (err) {
              logger.error('Error occurred: ' + JSON.stringify(err));
            }
          })

        Button($r('app.string.getSingleSensorByDeviceSync'))
          .onClick(() => {
            if (!this.SensorListByDevice.length) {
              this.promptAction.showToast({
                message: 'Please click getSensorListByDeviceSync.',
                duration: 2000
              });
              return;
            }
            this.dialogControllerList = new CustomDialogController({
              autoCancel: false,
              builder: SelectDialog({
                title: 'select SensorId',
                selectedIndex: this.selectedSensorId,
                radioContent: this.SensorListByDeviceList.map((sensorInfo: sensor.Sensor) => {
                  return {
                    title: `${sensorInfo.sensorName}_${sensorInfo.sensorId}`,
                    action: async () => {
                      this.selectedSensorId = sensorInfo.sensorId;
                      try {
                        const checkRet = this.checkDeviceId();
                        const data = sensor.getSingleSensorByDeviceSync(this.selectedSensorId,
                          checkRet.ok ? checkRet.ret : undefined);
                        this.SensorListByDevice = 'sensorInfoList:' + JSON.stringify(data);
                      } catch (error) {
                        logger.error('Error occurred: ' + JSON.stringify(error));
                      }
                    }
                  } as SheetInfo
                }),
              }),
            })
            this.dialogControllerList.open();
          })

        Button($r('app.string.on')).fontSize(16).fontWeight(FontWeight.Bold).width('100%')
          .onClick(() => {
            logger.info("sensor.on('SensorStatusChange')");
            try {
              sensor.on('sensorStatusChange', this.sensorStatusChangeCallback);
              this.callbackContent = 'on:sensorStatusChange'
            } catch (error) {
              let e: BusinessError.BusinessError = error as BusinessError.BusinessError;
              logger.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
            }
          })

        Button($r('app.string.off')).fontSize(16).fontWeight(FontWeight.Bold).width('100%')
          .onClick(() => {
            try {
              sensor.off('sensorStatusChange', this.sensorStatusChangeCallback);
              this.callbackContent = 'off:sensorStatusChange'
            } catch (error) {
              let e: BusinessError.BusinessError = error as BusinessError.BusinessError;
              logger.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
            }
          })

        Button($r('app.string.clean'))
          .onClick(() => {
            this.SensorListByDevice = '';
          })

      }.margin({top: 20})

      Text(`${this.callbackContent}`)
        .fontSize(20)
        .margin({ top: 20 })

      Text(`${this.SensorListByDevice}`)
        .fontSize(20)
        .margin({ top: 20 })
    }
    .height('100%')
    .width('100%')
  }
}