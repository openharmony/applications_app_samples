/**
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

import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import Logger from '../common/Logger';
import { KeyCode } from '@kit.InputKit';
import { dfsManager } from '../manager/DfsManager';
import { PhotoModel } from '../models/PhotoModel';
import { router } from '@kit.ArkUI';

const TAG = 'DistributedDevicePage';
const FOCUS_CHANGE_DELAY = 100;
const LOADING_IMG_HEIGHT = '200lpx'
const DEVICE_LOADING_TEXT = '38lpx'

@Entry
@Component
export struct DistributedDevicePage {
  @State rotateAngle: number = 0
  @State isLength: boolean = false
  @State focusStr: string = 'default_focus_id';
  @State dialogFocusStr: string = '';
  @State photoList: PhotoModel[] = [];
  @State @Watch('judgeDeDeviceListLength') availableDeviceList: distributedDeviceManager.DeviceBasicInfo[] = [];
  @State @Watch('judgeDeDeviceListLength') otherDeviceList: distributedDeviceManager.DeviceBasicInfo[] = [];
  @State showDialog: boolean = false;
  private selectedDevice: distributedDeviceManager.DeviceBasicInfo | undefined = undefined;
  private listScroller: Scroller = new Scroller();

  changeFocusToId(str: string) {
    this.focusStr = str;
    AppStorage.setOrCreate<string>('focusStr', str);
    focusControl.requestFocus(str);
  }

  changeFocusNoRecord(str: string) {
    this.dialogFocusStr = str;
    focusControl.requestFocus(str);
  }

  async aboutToAppear(): Promise<void> {
    this.availableDeviceList = dfsManager.getAvailableDevices();
    this.startFindDistributedDevice();
    this.changeFocusToId(this.focusStr);
  }

  aboutToDisappear(): void {
    dfsManager.stopDiscovering();
  }

  startFindDistributedDevice() {
    dfsManager.getDmInstance()?.on('discoverSuccess', data => {
      if (data && data.device) {
        // 发现设备
        let index = this.otherDeviceList.findIndex((item) => {
          return item.deviceId === data.device.deviceId;
        })
        if (index < 0) {
          this.otherDeviceList.push(data.device);
        }
      }
      Logger.info(TAG, 'discoverSuccess on:' + JSON.stringify(data))
    });
    dfsManager.startDiscovering();
  }

  onBackPress(): boolean | void {
    if (this.showDialog) {
      this.dismissDialog();
      return true;
    }
  }

  dismissDialog() {
    this.showDialog = false;
    setTimeout(() => {
      this.changeFocusToId(this.focusStr);
    }, FOCUS_CHANGE_DELAY)
  }

  onDeviceEnterClick(device: distributedDeviceManager.DeviceBasicInfo) {
    dfsManager.bindDevice(device, (isSuccess: boolean) => {
      if (isSuccess) {
        this.availableDeviceList = dfsManager.getAvailableDevices();
        Logger.error(TAG, `bind success , availableDeviceList = ${JSON.stringify(this.availableDeviceList)}`);

        setTimeout(async () => {
          let result = await dfsManager.connectDfs(device);
          if (result) {
            router.back();
          }
        }, 1000)
      }
    });
  }

  async onAvailableDeviceEnterClick(device: distributedDeviceManager.DeviceBasicInfo) {
    this.selectedDevice = device;
    this.showDialog = true;
    setTimeout(() => {
      this.changeFocusNoRecord('dialog_connect');
    }, 50);
  }

  async connect(device: distributedDeviceManager.DeviceBasicInfo) {
    let isSuccess = await dfsManager.connectDfs(device);
    if (!isSuccess) {
      isSuccess = await dfsManager.connectDfs(device);
    }
    if (isSuccess) {
      router.back();
    }
  }

  judgeDeDeviceListLength() {
      if (this.availableDeviceList.length > 0 || this.otherDeviceList.length > 0) {
        this.isLength = true
      } else {
        this.isLength = false
      }
  }

  build() {
    Stack() {
      Column() {
        Text($r('app.string.distributed_device_title'))
          .focusable(true)
          .defaultFocus(true)
          .id('default_focus_id')
          .fontWeight(FontWeight.Medium)
          .fontFamily('HarmonyOS Sans')
          .fontColor('#FFFFFFFF')
          .fontSize('63lpx')
          .margin({
            top: '42lpx',
            left: '96lpx',
            bottom: '33lpx'
          })
          .alignSelf(ItemAlign.Start)
          .onKeyEvent(event => {
            if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN && event.type === KeyType.Down) {
              if (this.availableDeviceList.length > 0) {
                this.changeFocusToId('available_device_0');
              } else if (this.otherDeviceList.length > 0) {
                this.changeFocusToId('other_device_0');
              }
            }
          })

          Column(){
            Image($r('app.media.lading'))
              .height(LOADING_IMG_HEIGHT)
              .rotate({ angle: this.rotateAngle })
              .animation({
                duration: 1200,
                curve: Curve.Linear,
                iterations: -1, // 设置-1表示动画无限循环
                delay: 100,
                playMode: PlayMode.Normal,
              })
              .onAppear(()=>{
                this.rotateAngle = this.rotateAngle + 360
              })

            Text($r('app.string.Device_search_in_progress'))
              .fontWeight(FontWeight.Medium)
              .fontFamily('HarmonyOS Sans')
              .fontColor($r('app.color.decice_search_in_text'))
              .fontSize(DEVICE_LOADING_TEXT)
              .margin({ top: '2.6%',bottom: LOADING_IMG_HEIGHT })
          }

          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .height('100%')
          .width('100%')
          .visibility(this.isLength ? Visibility.None : Visibility.Visible)


        List({ space: '6lpx', scroller: this.listScroller }) {
          ForEach(this.availableDeviceList,
            (item: distributedDeviceManager.DeviceBasicInfo, index: number) => {
              ListItem() {
                Column() {
                  if (index === 0) {
                    // 分布式可信设备列表
                    Column() {
                      Text($r('app.string.distributed_device_available'))
                        .fontSize('48lpx')
                        .fontColor(Color.White)
                        .textAlign(TextAlign.Center)
                        .margin({ bottom: '36lpx' })
                    }
                  }

                  Column() {
                    Row() {
                      Row() {
                        Text(item.deviceName)
                          .fontFamily('HarmonyOS Sans')
                          .fontSize('36lpx')
                          .fontColor('#FFFFFFFF')
                          .focusable(true)
                          .onKeyEvent(event => {
                            event?.stopPropagation()
                            if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN && event.type === KeyType.Down) {
                              if (index < this.availableDeviceList.length - 1) {
                                this.changeFocusToId('available_device_' + (index + 1));
                                this.listScroller.scrollToIndex(index + 1, true)
                              } else {
                                if (this.otherDeviceList.length > 0) {
                                  this.changeFocusToId('other_device_0');
                                }
                              }
                            }
                            if (event.keyCode === KeyCode.KEYCODE_DPAD_UP && event.type === KeyType.Down) {
                              if (index > 0) {
                                this.changeFocusToId('available_device_' + (index - 1));
                                this.listScroller.scrollToIndex(index - 1, true);
                              }
                            }
                            // 电脑回车键KEYCODE_ENTER
                            if ((event.keyCode === KeyCode.KEYCODE_DPAD_CENTER ||
                              event.keyCode === KeyCode.KEYCODE_ENTER) &&
                              event.type === KeyType.Down) {
                            }
                          })
                      }.margin({
                        right: '24lpx'
                      })

                      Image($r('app.media.ic_arrow_right'))
                        .width('16lpx')
                    }
                    .padding({
                      left: '20lpx',
                      right: '20lpx'
                    })
                    .width('820lpx')
                    .height('100lpx')
                    .borderRadius('18lpx')
                    .alignItems(VerticalAlign.Center)
                    .justifyContent(FlexAlign.SpaceBetween)
                    .backgroundColor('#FF464648')
                  }
                  .id('available_device_' + index)
                  .width('840lpx')
                  .borderRadius('24lpx')
                  .padding('10lpx')
                  .border({
                    width: '2lpx',
                    color: this.focusStr == ('available_device_' + index) ? '#fff' : Color.Transparent,
                    style: BorderStyle.Solid
                  })
                }

              }.onClick(() => {
                this.onAvailableDeviceEnterClick(item);
              })
            }, (item: distributedDeviceManager.DeviceBasicInfo) => JSON.stringify(item))

          ForEach(this.otherDeviceList,
            (item: distributedDeviceManager.DeviceBasicInfo, index: number) => {
              ListItem() {
                Column() {
                  if (index === 0) {
                    // 分布式在线设备列表
                    Column() {
                      Text($r('app.string.distributed_device_other'))
                        .fontSize('48lpx')
                        .fontColor(Color.White)
                        .textAlign(TextAlign.Center)
                        .margin({ top: '30lpx', bottom: '36lpx' })
                    }
                  }
                  Column() {
                    Row() {
                      Row() {
                        Text(item.deviceName)
                          .fontFamily('HarmonyOS Sans')
                          .fontSize('36lpx')
                          .fontColor('#FFFFFFFF')
                          .focusable(true)
                          .onKeyEvent(event => {
                            if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN && event.type === KeyType.Down) {
                              if (index < this.otherDeviceList.length - 1) {
                                this.changeFocusToId('other_device_' + (index + 1));
                                this.listScroller.scrollToIndex(this.getOtherDeviceIndex(index + 1), true)
                              }
                            }
                            if (event.keyCode === KeyCode.KEYCODE_DPAD_UP && event.type === KeyType.Down) {
                              if (index > 0) {
                                this.changeFocusToId('other_device_' + (index - 1));
                                this.listScroller.scrollToIndex(this.getOtherDeviceIndex(index - 1), true)
                              } else {
                                if (this.availableDeviceList.length > 0) {
                                  this.changeFocusToId('available_device_' + (this.availableDeviceList.length - 1));
                                }
                              }
                            }
                            // 电脑回车键KEYCODE_ENTER
                            if ((event.keyCode === KeyCode.KEYCODE_DPAD_CENTER ||
                              event.keyCode === KeyCode.KEYCODE_ENTER) &&
                              event.type === KeyType.Down) {
                              this.onDeviceEnterClick(item);
                            }
                          })
                      }.margin({
                        right: '24lpx'
                      })

                      Image($r('app.media.ic_arrow_right'))
                        .width('16lpx')
                    }
                    .padding({
                      left: '20lpx',
                      right: '20lpx'
                    })
                    .width('820lpx')
                    .height('100lpx')
                    .borderRadius('18lpx')
                    .alignItems(VerticalAlign.Center)
                    .justifyContent(FlexAlign.SpaceBetween)
                    .backgroundColor('#FF464648')
                  }
                  .id('other_device_' + index)
                  .width('840lpx')
                  .borderRadius('24lpx')
                  .padding('10lpx')
                  .border({
                    width: '2lpx',
                    color: this.focusStr == ('other_device_' + index) ? '#fff' : Color.Transparent,
                    style: BorderStyle.Solid
                  })
                }

              }.onClick(() => {
                this.onDeviceEnterClick(item);
              })
            }, (item: distributedDeviceManager.DeviceBasicInfo) => JSON.stringify(item))
        }
        .height('80%')
        .width('850lpx')
        .scrollBar(BarState.Off)

      }
      .width('100%')
      .height('100%')

      if (this.showDialog) {
        Flex({ justifyContent: FlexAlign.Center }) {
          Column() {
            Row() {
              Column() {
                Text($r('app.string.connect'))
                  .width('230lpx')
                  .height('72lpx')
                  .id('dialog_connect')
                  .focusable(true)
                  .backgroundColor('#33FFFFFF')
                  .borderRadius('200lpx')
                  .fontFamily('HarmonyOS Sans')
                  .fontSize('36lpx')
                  .textAlign(TextAlign.Center)
                  .fontColor('#DBFFFFFF')
                  .fontWeight(FontWeight.Bold)
                  .onKeyEvent(e => {
                    e?.stopPropagation()
                    if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
                      this.changeFocusNoRecord('dialog_unbind');
                    }
                    // 电脑回车键KEYCODE_ENTER
                    if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                      e.type == KeyType.Down) {
                    }
                  })
                  .onClick(()=>{
                    this.dismissDialog();
                    if (this.selectedDevice) {
                      this.connect(this.selectedDevice);
                    }
                  })
              }
              .borderRadius('200lpx')
              .padding('6lpx')
              .border({
                width: 2,
                color: this.dialogFocusStr === 'dialog_connect' ? '#fff' : Color.Transparent,
                style: BorderStyle.Solid
              })

              Column() {
                Text($r('app.string.unbind'))
                  .width('230lpx')
                  .height('72lpx')
                  .id('dialog_unbind')
                  .focusable(true)
                  .backgroundColor('#33FFFFFF')
                  .borderRadius('200lpx')
                  .fontFamily('HarmonyOS Sans')
                  .fontSize('36lpx')
                  .textAlign(TextAlign.Center)
                  .fontColor('#DBFFFFFF')
                  .fontWeight(FontWeight.Bold)
                  .onKeyEvent(e => {
                    e?.stopPropagation()
                    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
                      this.changeFocusNoRecord('dialog_connect');
                    }
                    // 电脑回车键KEYCODE_ENTER
                    if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                      e.type == KeyType.Down) {
                    }
                  })
                  .onClick(()=>{
                    if (this.selectedDevice) {
                      dfsManager.unBindDevice(this.selectedDevice);
                      this.dismissDialog();
                    }
                  })
              }
              .borderRadius('200lpx')
              .padding('6lpx')
              .border({
                width: 2,
                color: this.dialogFocusStr === 'dialog_unbind' ? '#fff' : Color.Transparent,
                style: BorderStyle.Solid
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('640lpx')
          .height('200lpx')
          .backgroundColor('rgba(64, 64, 64 , 1)')
          .shadow({ radius: 4, color: 'rgba(255, 255, 255, 0.25)' })
          .borderRadius('24lpx')
          .padding('48lpx')
        }
        .position({ x: '0%', y: '39%' })
      }
    }.backgroundColor($r('app.color.main_color'))
    .width('100%')
    .height('100%')
  }

  getOtherDeviceIndex(index: number) {
    return index + this.availableDeviceList.length
  }
}
