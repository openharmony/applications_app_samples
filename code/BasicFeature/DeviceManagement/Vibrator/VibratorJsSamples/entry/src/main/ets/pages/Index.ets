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
// [Start vibrator_js_development_dependency_import_example]
import { vibrator } from '@kit.SensorServiceKit';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';
// [End vibrator_js_development_dependency_import_example]

// [Start vibrator_js_define_variables_example]
const fileName: string = 'vibrator.json';
let TAG = 'vibrator:';
// [End vibrator_js_define_variables_example]

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
  // [Start vibrator_js_vibrator_off_state_change_example]
  // [Start vibrator_js_vibrator_on_state_change_example]
  // 回调函数
  vibratorStateChangeCallback = (data: vibrator.VibratorStatusEvent) => {
    console.info('vibrator state callback info:', JSON.stringify(data));
    // [StartExclude vibrator_js_vibrator_on_state_change_example]
    // [StartExclude vibrator_js_vibrator_off_state_change_example]
    this.vibratorStatusEvent = data;
    // [EndExclude vibrator_js_vibrator_on_state_change_example]
    // [EndExclude vibrator_js_vibrator_off_state_change_example]
  }
  // [StartExclude vibrator_js_vibrator_on_state_change_example]
  // [StartExclude vibrator_js_vibrator_off_state_change_example]
  scroller: Scroller = new Scroller;
  @State private callbackContent: string = '';

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      Scroll(this.scroller) {
        Column() {
          Text(`${this.callbackContent}`)
            .fontSize(14)
            .margin({ top: 15 })
            .id('callbackText')
        }
      }
      .width('96%')
      .height('20%')
      .backgroundColor('#F1F1F1')
      .borderRadius(10)
      .borderColor($r('sys.color.popup_border_color'))

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
        .id('Please select effectId')
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
               // [Start vibrator_js_vibrator_by_type_file_example]
               // 获取文件资源描述符
               let rawFd: resourceManager.RawFileDescriptor | undefined = this.uiContext.getHostContext()?.resourceManager.getRawFdSync(fileName);
               if (rawFd != undefined) {
                 // 触发马达振动
                 try {
                   vibrator.startVibration({
                     type: "file",
                     hapticFd: { fd: rawFd.fd, offset: rawFd.offset, length: rawFd.length }
                   }, {
                     id: 0,
                     usage: 'alarm' // 根据实际选择类型归属不同的开关管控
                   }, (error: BusinessError) => {
                     if (error) {
                       console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
                       return;
                     }
                     console.info('Succeed in starting vibration');
                   });
                 } catch (err) {
                   let e: BusinessError = err as BusinessError;
                   console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
                 } finally {
                   vibrator.stopVibration();
                   this.uiContext.getHostContext()?.resourceManager.closeRawFdSync(fileName);
                 }
               }
               // [End vibrator_js_vibrator_by_type_file_example]
               this.callbackContent = 'Click the file button successfully';
               hilog.info(0xF811, 'Sample_Vibrator', 'Click the file button successfully');
            })

          Button('preset:' + this.realEffectId)
            .onClick(() => {
              // [Start vibrator_js_vibrator_by_type_preset_example]
              try {
                vibrator.isSupportEffect(this.realEffectId, (err: BusinessError, state: boolean) => {
                  if (err) {
                    console.error(`Failed to query effect. Code: ${err.code}, message: ${err.message}`);
                    return;
                  }
                  console.info('Succeed in querying effect');
                  if (state) {
                    try {
                      // 触发马达振动
                      vibrator.startVibration({
                        type: 'preset',
                        effectId: this.realEffectId,
                        count: 1,
                        intensity: 50,
                      }, {
                        usage: 'unknown'
                      }, (error: BusinessError) => {
                        if (error) {
                          console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
                        } else {
                          console.info('Succeed in starting vibration');
                        }
                      });
                    } catch (error) {
                      let e: BusinessError = error as BusinessError;
                      console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
                    }
                  }
                })
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_vibrator_by_type_preset_example]
              this.callbackContent = 'Click the preset button successfully'
              hilog.info(0xF811, 'Sample_Vibrator', 'Click the preset button successfully');
            })
            .id('preset')

          Button($r('app.string.time'))
            .onClick(() => {
              // [Start vibrator_js_vibrator_by_type_time_example]
              try {
                // 触发马达振动
                vibrator.startVibration({
                  type: 'time',
                  duration: 1000,
                }, {
                  id: 0,
                  usage: 'alarm'
                }, (error: BusinessError) => {
                  if (error) {
                    console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
                    return;
                  }
                  console.info('Succeed in starting vibration');
                });
              } catch (err) {
                let e: BusinessError = err as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_vibrator_by_type_time_example]
              this.callbackContent = 'Click the time button successfully';
              hilog.info(0xF811, 'Sample_Vibrator', 'Click the time button successfully');
            })

          Button($r('app.string.addTransientEvent'))
            .onClick(() => {
              // [Start vibrator_js_vibrator_by_type_pattern_use_transient_example]
              let builder: vibrator.VibratorPatternBuilder = new vibrator.VibratorPatternBuilder();
              try {
                let param: vibrator.TransientParam = {
                  intensity: 80,
                  frequency: 70,
                  index: 0
                }
                builder.addTransientEvent(0, param);
                console.info(`addTransientEvent builder is ${builder.build()}`);
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              try {
                vibrator.startVibration({
                  type: "pattern",
                  pattern: builder.build()
                }, {
                  id: 1,
                  deviceId: -1,
                  // 根据实际选择类型归属不同的开关管控
                  usage: "alarm"
                }, (error: BusinessError) => {
                  if (error) {
                    let e: BusinessError = error as BusinessError;
                    console.error(`Vibrate fail. Code: ${e.code}, message: ${e.message}`);
                  } else {
                    console.info(`vibrate success`);
                  }
                });
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_vibrator_by_type_pattern_use_transient_example]
              this.callbackContent = 'Click the addTransientEvent button successfully';
              hilog.info(0xF811, 'Sample_Vibrator', 'Click the addTransientEvent button successfully');
            })

          Button($r('app.string.addContinuousEvent'))
            .onClick(() => {
              // [Start vibrator_js_vibrator_by_type_pattern_use_continuous_example]
              let builder: vibrator.VibratorPatternBuilder = new vibrator.VibratorPatternBuilder();
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
                console.info(`addContinuousEvent builder is ${builder.build()}`);
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`Exception. Code ${e.code}`);
              }
              try {
                vibrator.startVibration({
                  type: 'pattern',
                  pattern: builder.build()
                }, {
                  id: 1,
                  deviceId: -1,
                  usage:"alarm",
                }, (error: BusinessError) => {
                  if (error) {
                    let e: BusinessError = error as BusinessError;
                    console.error(`Vibrate fail. Code: ${e.code}, message: ${e.message}`);
                  } else {
                    console.info(`vibrate success`);
                  }
                });
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_vibrator_by_type_pattern_use_continuous_example]
              this.callbackContent = 'Click the addContinuousEvent button successfully';
              hilog.info(0xF811, 'Sample_Vibrator', 'Click the addContinuousEvent button successfully');
            })

          Button($r('app.string.stopVibration'))
            .onClick(() => {
              // [Start vibrator_js_stop_vibrator_by_type_time_example]
              try {
                // 按照VIBRATOR_STOP_MODE_TIME模式停止振动
                vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME, (error: BusinessError) => {
                  if (error) {
                    console.error(`Failed to stop vibration. Code: ${error.code}, message: ${error.message}`);
                    return;
                  }
                  console.info('Succeed in stopping vibration');
                })
              } catch (err) {
                let e: BusinessError = err as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_stop_vibrator_by_type_time_example]
              // [Start vibrator_js_stop_vibrator_by_type_preset_example]
              try {
                // 按照VIBRATOR_STOP_MODE_PRESET模式停止振动
                vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_PRESET, (error: BusinessError) => {
                  if (error) {
                    console.error(`Failed to stop vibration. Code: ${error.code}, message: ${error.message}`);
                    return;
                  }
                  console.info('Succeed in stopping vibration');
                })
              } catch (err) {
                let e: BusinessError = err as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_stop_vibrator_by_type_preset_example]
              // [Start vibrator_js_stop_vibrator_by_type_all_example]
              try {
                // 停止所有模式的马达振动
                vibrator.stopVibration((error: BusinessError) => {
                  if (error) {
                    console.error(`Failed to stop vibration. Code: ${error.code}, message: ${error.message}`);
                    return;
                  }
                  console.info('Succeed in stopping vibration');
                })
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_stop_vibrator_by_type_all_example]
              // [Start vibrator_js_stop_vibrator_by_device_id_example]
              const vibratorInfoParam: vibrator.VibratorInfoParam = {
                deviceId: -1   // deviceid 需要是查询出来真实存在的设备
              }
              try {
                vibrator.stopVibration(vibratorInfoParam).then(() => {
                  console.info('Succeed in stopping vibration');
                }, (error: BusinessError) => {
                  console.error(`Failed to stop vibration. Code: ${error.code}, message: ${error.message}`);
                });
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_stop_vibrator_by_device_id_example]
              this.callbackContent = 'Click the stopVibration button successfully'
              hilog.info(0xF811, 'Sample_Vibrator', 'Click the stopVibration button successfully');
            })

          Button($r('app.string.on'))
            .onClick(() => {
              // [EndExclude vibrator_js_vibrator_on_state_change_example]
              try {
                // 订阅 vibratorStateChange事件
                vibrator.on('vibratorStateChange', this.vibratorStateChangeCallback);
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_vibrator_on_state_change_example]
              this.callbackContent = 'Click the on button successfully'
              hilog.info(0xF811, 'Sample_Vibrator', 'Click the on button successfully');
            })

          Button($r('app.string.off'))
            .onClick(() => {
              // [EndExclude vibrator_js_vibrator_off_state_change_example]
              try {
                // 取消订阅 vibratorStateChange事件
                vibrator.off('vibratorStateChange', this.vibratorStateChangeCallback);
                // 取消订阅所有 vibratorStateChange事件
                // vibrator.off('vibratorStateChange');
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_vibrator_off_state_change_example]
              this.callbackContent = 'Click the off button successfully';
              hilog.info(0xF811, 'Sample_Vibrator', 'Click the off button successfully');
            })

          Button($r('app.string.getVibratorInfoSync'))
            .onClick(async () => {
              // [Start vibrator_js_get_vibrator_info_sync_example]
              try {
                const vibratorInfoList: vibrator.VibratorInfo[] = vibrator.getVibratorInfoSync();
                console.info(`vibratorInfoList: ${JSON.stringify(vibratorInfoList)}`);
                // [StartExclude vibrator_js_get_vibrator_info_sync_example]
                this.vibratorInfoContent = JSON.stringify(vibratorInfoList)
                // [EndExclude vibrator_js_get_vibrator_info_sync_example]
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_get_vibrator_info_sync_example]
              logger.info('getVibratorInfoSync end');
              this.callbackContent = 'Click the getVibratorInfoSync button successfully';
              hilog.info(0xF811, 'Sample_Vibrator', 'Click the getVibratorInfoSync button successfully');
            })

          Button($r('app.string.getVibratorInfoSyncByDeviceId'))
            .onClick(async () => {
              // [Start vibrator_js_get_vibrator_info_sync_by_device_id_example]
              try {
                const vibratorParam: vibrator.VibratorInfoParam = {
                  deviceId: -1    // deviceid 需要是查询出来真实存在的设备
                }
                const vibratorInfoList: vibrator.VibratorInfo[] = vibrator.getVibratorInfoSync(vibratorParam);
                console.info(`vibratorInfoList: ${JSON.stringify(vibratorInfoList)}`);
                // [StartExclude vibrator_js_get_vibrator_info_sync_by_device_id_example]
                this.vibratorInfoContent = JSON.stringify(vibratorInfoList);
                // [EndExclude vibrator_js_get_vibrator_info_sync_by_device_id_example]
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_get_vibrator_info_sync_by_device_id_example]
              logger.info('getVibratorInfoSyncByDeviceId end');
              this.callbackContent = 'Click the getVibratorInfoSync button successfully';
              hilog.info(0xF811, 'Sample_Vibrator', 'Click the getVibratorInfoSync button successfully');
            })

          Button($r('app.string.getEffectInfoSync'))
            .onClick(() => {
              // [Start vibrator_js_vibrator_get_effect_info_sync_example]
              try {
                const effectInfo: vibrator.EffectInfo = vibrator.getEffectInfoSync('haptic.clock.timer', { deviceId: -1, vibratorId: 1});
                console.info(`isEffectSupported: ${effectInfo.isEffectSupported}`);
                // [StartExclude vibrator_js_vibrator_get_effect_info_sync_example]
                this.vibratorInfoContent = JSON.stringify(effectInfo);
                // [EndExclude vibrator_js_vibrator_get_effect_info_sync_example]
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_vibrator_get_effect_info_sync_example]
              this.callbackContent = 'Click the getEffectInfoSync button successfully'
              hilog.info(0xF811, 'Sample_Vibrator', 'Click the getEffectInfoSync button successfully');
            })

          Button($r('app.string.isHdHapticSupported'))
            .onClick(async () => {
              // [Start vibrator_js_vibrator_is_hd_haptic_supported_example]
              try {
                // 查询是否支持高清振动
                let ret = vibrator.isHdHapticSupported();
                console.info(`The query result is ${ret}`);
                // [StartExclude vibrator_js_vibrator_is_hd_haptic_supported_example]
                this.vibratorInfoContent = `${ret}`;
                // [EndExclude vibrator_js_vibrator_is_hd_haptic_supported_example]
              } catch (error) {
                let e: BusinessError = error as BusinessError;
                console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
              }
              // [End vibrator_js_vibrator_is_hd_haptic_supported_example]
              this.callbackContent = 'Click the isHdHapticSupported button successfully';
              hilog.info(0xF811, 'Sample_Vibrator', 'Click the isHdHapticSupported button successfully');
            })

          Text(`${this.vibratorStateChangeCallback}`)
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