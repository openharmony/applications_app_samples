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
import { vibrator } from '@kit.SensorServiceKit';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';


const fileName: string = 'vibrator.json';
let TAG = 'vibrator:'

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
struct Index {
  @State message: string = 'Hello World';
  @State timeout_10: number = 10;
  @State timeout_20: number = 20;
  @State
  private vibratorStatusEvent: vibrator.VibratorStatusEvent = {
    timestamp: 0,
    deviceId: 0,
    vibratorCount: 0,
    isVibratorOnline: false
  };
  @State
  private realEffectId: string = '';
  @State
  private realUsage: vibrator.Usage = 'unknown';
  @State
  private vibratorInfoContent: string = '';
  private effectId: (string)[] = [
    'haptic.notice.warning',
    'haptic.notice.fail',
    'haptic.notice.success',
    'haptic.effect.soft',
    'haptic.effect.hard',
    'haptic.effect.sharp',
  ];
  private usage: (string)[] =
    ['unknown', 'alarm', 'ring', 'notification', 'communication', 'touch', 'media', 'physicalFeedback',
      'simulateReality'];
  private usageMap = new Map<string, vibrator.Usage>([
    ['unknown', 'unknown'],
    ['alarm', 'alarm'],
    ['ring', 'ring'],
    ['notification', 'notification'],
    ['communication', 'communication'],
    ['touch', 'touch'],
    ['media', 'media'],
    ['physicalFeedback', 'physicalFeedback'],
    ['simulateReality', 'simulateReality'],
  ]);
  uiContext = this.getUIContext();
  VibratorStateChangeCallback = (data: vibrator.VibratorStatusEvent) => {
    this.vibratorStatusEvent = data;
    logger.info('Vibrator plunged info:', JSON.stringify(data));
    logger.info('on is end');
  };

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      TextInput({ placeholder: 'Please select effectId', text: this.realEffectId })
        .placeholderColor('rgb(0,0,225)')
        .placeholderFont({
          size: 20,
          weight: 100,
          family: 'cursive',
          style: FontStyle.Italic
        })
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
        .borderStyle(BorderStyle.Solid)
        .borderWidth(1)
        .borderColor('rgb(0,0,225)')
        .borderRadius(10)
        .focusable(false)
        .onClick(() => {
          TextPickerDialog.show({
            range: this.effectId,
            selected: 0,
            onAccept: (result: TextPickerResult) => {
              this.realEffectId = result.value.toString();
              logger.info('Succeed in starting vibration' + this.effectId);
            },
            onCancel: () => {
              logger.info('Succeed in starting vibration' + this.effectId);
            }
          });
        })
        .width('80%')
        .margin({ top: 10 })

      TextInput({ placeholder: 'Please select usage', text: this.realUsage })
        .placeholderColor('rgb(0,0,225)')
        .placeholderFont({
          size: 20,
          weight: 100,
          family: 'cursive',
          style: FontStyle.Italic
        })
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
        .borderStyle(BorderStyle.Solid)
        .borderWidth(1)
        .borderColor('rgb(0,0,225)')
        .borderRadius(10)
        .focusable(false)
        .onClick(() => {
          TextPickerDialog.show({
            range: this.usage,
            selected: 0,
            onAccept: (resultUsage: TextPickerResult) => {
              this.realUsage = this.usageMap.get(resultUsage.value.toString());
              logger.info('Succeed in starting vibration' + this.effectId);
            },
            onCancel: () => {
              logger.info('Succeed in starting vibration' + this.effectId);
            }
          });
        })
        .width('100%')
        .margin({ top: 10 })

      Row() {
        Column() {
          Button($r('app.string.file'))
            .onClick(() => {
              try {
                let rawFd: resourceManager.RawFileDescriptor | undefined =
                  this.uiContext.getHostContext()?.resourceManager.getRawFdSync(fileName);
                if (rawFd != undefined) {
                  vibrator.startVibration({
                    type: 'file',
                    hapticFd: { fd: rawFd.fd, offset: rawFd.offset, length: rawFd.length }
                  }, {
                    id: 1,
                    deviceId: -1,
                    usage: this.realUsage
                  }, (error: BusinessError) => {
                    if (error) {
                      logger.error(TAG + 'error in, msg:' + JSON.stringify(error));
                      return;
                    }
                    logger.info('Succeed in starting vibration');
                  });
                }
                this.uiContext.getHostContext()?.resourceManager.closeRawFdSync(fileName);
              } catch (e) {
                logger.error(TAG + 'Exception:', e);
              }

            })

          Button($r('app.string.preset') + this.realEffectId)
            .onClick(() => {
              try {
                // 查询是否支持'haptic.clock.timer'
                vibrator.isSupportEffect(this.realEffectId, (err: BusinessError, state: boolean) => {
                  if (err) {
                    logger.error(`Failed to query effect. Code: ${err.code}, message: ${err.message}`);
                    return;
                  }
                  logger.info('Succeed in querying effect');
                  if (state) {
                    try {
                      // 使用startVibration需要添加ohos.permission.VIBRATE权限
                      vibrator.startVibration({
                        type: 'preset',
                        effectId: this.realEffectId,
                        count: 1,
                        intensity: 100
                      }, {
                        id: 1,
                        deviceId: -1,
                        usage: this.realUsage // 根据实际选择类型归属不同的开关管控
                      }, (error: BusinessError) => {
                        if (error) {
                          logger.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
                        } else {
                          logger.info('Succeed in starting vibration');
                        }
                      });
                    } catch (error) {
                      let e: BusinessError = error as BusinessError;
                      logger.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
                    }
                  }
                })
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                logger.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
            })

          Button($r('app.string.time'))
            .onClick(() => {
              try {
                vibrator.startVibration(
                  {
                    type: 'time',
                    duration: 2000,
                  }, {
                  id: 1,
                  deviceId: -1,
                  usage: this.realUsage
                }, (error: BusinessError) => {
                  if (error) {
                    logger.error(TAG + "error in, msg:" + JSON.stringify(error));
                    return;
                  }
                  logger.info('Succeed in starting vibration');
                });
              } catch (e) {
                logger.error(TAG + 'Exception:', e);
              }
            })

          Button($r('app.string.addTransientEvent'))
            .onClick(() => {
              let builder:vibrator.VibratorPatternBuilder = new vibrator.VibratorPatternBuilder();
              try {
                let param: vibrator.TransientParam = {
                  intensity: 80,
                  frequency: 70,
                  index: 0
                }
                builder.addTransientEvent(0, param);
                logger.info(`addTransientEvent builder is ${builder.build()}`);
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                logger.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              try {
                vibrator.startVibration({
                  type: "pattern",
                  pattern: builder.build()
                }, {
                  id: 1,
                  deviceId: -1,
                  // 根据实际选择类型归属不同的开关管控
                  usage: this.realUsage
                }, (error: BusinessError) => {
                  if (error) {
                    let e: BusinessError = error as BusinessError;
                    logger.error(`Vibrate fail. Code: ${e.code}, message: ${e.message}`);
                  } else {
                    logger.info(`vibrate success`);
                  }
                });
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                logger.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
            })

          Button($r('app.string.addContinuousEvent'))
            .onClick(() => {
              let builder:vibrator.VibratorPatternBuilder = new vibrator.VibratorPatternBuilder();
              try {
                // VibratorCurvePoint参数最少设置4个，最大设置16个
                let pointsMe: vibrator.VibratorCurvePoint[] = [
                  { time: 0, intensity: 0, frequency: -7 },
                  { time: 42, intensity: 1, frequency: -6 },
                  { time: 128, intensity: 0.94, frequency: -4 },
                  { time: 217, intensity: 0.63, frequency: -14 },
                  { time: 763, intensity: 0.48, frequency: -14 },
                  { time: 1125, intensity: 0.53, frequency: -10 },
                  { time: 1503, intensity: 0.42, frequency: -14 },
                  { time: 1858, intensity: 0.39, frequency: -14 },
                  { time: 2295, intensity: 0.34, frequency: -17 },
                  { time: 2448, intensity: 0.21, frequency: -14 },
                  { time: 2468, intensity: 0, frequency: -21 }
                ]
                let param: vibrator.ContinuousParam = {
                  intensity: 97,
                  frequency: 34,
                  points: pointsMe,
                  index: 0
                }
                builder.addContinuousEvent(0, 2468, param);
                logger.info(`addContinuousEvent builder is ${builder.build()}`);
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                logger.error(`Exception. Code ${e.code}`);
              }
              try {
                vibrator.startVibration({
                  type: 'pattern',
                  pattern: builder.build()
                }, {
                  id: 1,
                  deviceId: -1,
                  // 根据实际选择类型归属不同的开关管控
                  usage: this.realUsage, // 根据实际选择类型归属不同的开关管控
                }, (error: BusinessError) => {
                  if (error) {
                    let e: BusinessError = error as BusinessError;
                    logger.error(`Vibrate fail. Code: ${e.code}, message: ${e.message}`);
                  } else {
                    logger.info(`vibrate success`);
                  }
                });
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                logger.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
            })

          Button($r('app.string.stopVibration'))
            .onClick(() => {
              try {
                vibrator.stopVibration({
                  deviceId: -1,
                  vibratorId: 1
                }).then(() => {
                  logger.info('stopVibration successfully');
                }).catch((error: Error) => {
                  logger.error('stopVibration failed:', error.name, error.message);
                });
              } catch (error) {
                logger.error('stopVibration Error:', error.code, error.message);
              }
            })

          Button($r('app.string.on'))
            .onClick(() => {
              try {
                vibrator.on('vibratorStateChange', this.VibratorStateChangeCallback);
              } catch (err) {
                logger.error('Error in GetVibratorList:', err);
              }
            })

          Button($r('app.string.off'))
            .onClick(() => {
              try {
                vibrator.off('vibratorStateChange', this.VibratorStateChangeCallback);
              } catch (err) {
                logger.error("Error in GetVibratorList:", err);
              }
            })

          Button($r('app.string.getVibratorInfoSync'))
            .onClick(async () => {
              try {
                let vibratorInfoList: vibrator.VibratorInfo[] = vibrator.getVibratorInfoSync({
                  deviceId: -1,
                  vibratorId: 1
                });
                this.vibratorInfoContent = JSON.stringify(vibratorInfoList)
              } catch (err) {
                logger.error('Error in GetVibratorList:', err);
              }
              logger.info('getVibratorInfoSync end');
            })

          Text(`${this.VibratorStateChangeCallback}`)
            .fontSize(20)
            .margin({ top: 20 })

          Text(`${this.vibratorInfoContent}`)
            .fontSize(20)
            .margin({ top: 20 })
        }
        .width('100%')
      }
      .height('100%')
    }
  }
}