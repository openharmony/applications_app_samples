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

import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import ComponentConfig from '../../../../../../../common/component/src/main/ets/default/ComponentConfig';
import { KeyCode } from '../../common/constants/KeyCode';
import { Ratio } from '../../common/Ratio';
import BluetoothDeviceController from '../../controller/bluetooth/BluetoothDeviceController';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import lpx from '../../common/Lpx';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { CustomDialogContentStyle, SourcetoolConstants } from '../../common/constants/StyleConstants';
import EntryComponent from '../../default/layout/EntryComponent';
import BluetoothDevice from '../../model/bluetoothImpl/BluetoothDevice';
import { BondState, DeviceType, ProfileConnectionState } from '../../model/bluetoothImpl/BluetoothModel';
import BasicDataSource from '../../../../../../../common/utils/src/main/ets/default/model/BasicDataSource';
import { CustomDialogTvComponent, DialogContent } from '../../default/layout/CustomDialogTvComponent';
import { sound } from '../../model/keyVolumeImpl/KeyControl';
import { promptAction } from '@kit.ArkUI';
import { Duration } from '../../common/constants/Duration';
import { inputEventClient } from '@kit.InputKit';
import { EventUtil } from '../../common/EventUtil';

export interface PinRequiredParam {
  deviceId: string;
  pinCode: string;
}

class InjectedKeyEventPayload {
}

@Entry
@Component
struct BluetoothDeviceEntry {
  @StorageLink('isVolumeOn') isVolumeOn: boolean = false
  @StorageLink('isShow')  storageLink:number = 1
  @State imageUrl: string = Ratio.resName('icon_bluetooth')
  @State des: string = '开启后可被附近的蓝牙设备发现'
  private errorMessage: string = '开启蓝牙失败，请检查硬件设施';
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  private deviceController: BluetoothDeviceController = new BluetoothDeviceController();
  @StorageLink('bluetoothIsOn') isOn: boolean = true;
  @StorageLink('bluetoothToggleEnabled') isEnabled: boolean = true;
  @StorageLink('cancelPairFlag') @Watch('cancelPairFlagChange') cancelPairFlag: boolean = false;
  // 外层控制器
  private scroller: Scroller = new Scroller()
  private pairedScroller: Scroller = new Scroller()
  private availableScroller: Scroller = new Scroller()
  // 及时清理定时器
  private scrollTimer: number = 0;
  // 判断列表第一次才移动
  @State listFlag: string = '';
  // 已配对设备列表
  @StorageLink('bluetoothPairedDevices') @Watch('focusTobluetoothKey') pairedDevices: BluetoothDevice[] = [];
  @State isConnected: boolean = false;

  @StorageLink('bluetoothAvailableDevices')  @Watch('updateDataSource') availableDevices: BluetoothDevice[] = [];
  @State availableDevicesList: AvailableDevicesDataSource = new AvailableDevicesDataSource(this.availableDevices);
  @StorageLink('controlPairing') controlPairing: boolean = true;
  @StorageLink('pairData') pairData: BluetoothDevice = new BluetoothDevice();
  @StorageLink('pinRequiredParam') pinRequiredParam: PinRequiredParam = {
    deviceId: '',
    pinCode: ''
  };

  @State pairPinCode: string = '';
  private pairingDevice: BluetoothDevice = new BluetoothDevice();

  @State
  isOne: boolean = true
  @State deviceId: string= ''
  private openBluetooth: boolean = false;
  blueToothKey:string='blueToothKey'
  pairDialog: CustomDialogController = new CustomDialogController({
    builder: PairDialog({
      deviceName: this.pairingDevice.deviceName,
      pinCode: this.pairPinCode,
      action: (accept: boolean) => {
        this.confirmPairing(accept);
      }
    }),
    alignment: DialogAlignment.Center,
    offset: ({ dx: 0, dy: 0 }),
    autoCancel: true,
  });


  updateDataSource(){
    this.availableDevicesList.reloadData(this.availableDevices)
  }

  focusTobluetoothKey(){
    focusControl.requestFocus(this.blueToothKey)
  }

  // 判断超长设备
  getDeviceNameString() {
    return this.pairingDevice.deviceName?.length > 15
      ? `${this.pairingDevice.deviceName.substring(0, 15)}...`
      : this.pairingDevice.deviceName
  }

  disConnectDialog: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: () => {
        this.disConnectDialog.close()
      },
      confirm: () => {
        this.disConnectDialog.close()
        this.deviceController.disconnect(this.pairingDevice.deviceId)
        this.focusTobluetoothKey()
      },
      content: new DialogContent('断开连接', `此操作将会断开您与以下设备的连接：${this.getDeviceNameString()}`, '取消', '确定', 692, 332),
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  errorDialog: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: () => {
        this.errorDialog.close()
        this.focusTobluetoothKey()
      },
      confirm: () => {
        this.errorDialog.close()
        this.focusTobluetoothKey()
      },
      content: new DialogContent('连接失败',
        `无法与${this.getDeviceNameString()}连接，可能原因如下：\n1.该设备蓝牙关闭，或不在通信范围内（10米）；\n2.该设备已经与其他设备连接，请断开后重试`,
        '取消', '确定', 692, 432),
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  pairErrorDialog: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: () => {
        this.pairErrorDialog.close()
        this.focusTobluetoothKey()
      },
      confirm: () => {
        this.pairErrorDialog.close()
        this.focusTobluetoothKey()
      },
      content: new DialogContent('配对失败', '配对码或要配对的设备配置错误。', '取消', '确定', 692, 332),
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: () => {
        this.cancelPaired(this.pairingDevice);
        this.focusTobluetoothKey()
      },
      confirm: () => {
        if (this.isConnected) {
          this.disConnectDevice(this.pairingDevice);
        } else {
          this.connectDevice(this.pairingDevice);
        }
      },
      content: new DialogContent('蓝牙操作', '取消配对，会将蓝牙设备从已配对列表中删除', '取消配对', this.isConnected ? '断开连接' : '连接设备', 692, 332),
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  cancelPaired(item: BluetoothDevice) {
    this.deviceController.unpair(item.deviceId);
    this.dialogController.close();
  }

  cancelPairFlagChange() {
    if (this.controlPairing && this.pairDialog) {
      this.pairDialog.close()
      promptAction.showToast({ message: $r('app.string.pair_promptAction'), duration: 2000 })
    }
  }

  connectDevice(item: BluetoothDevice) {
    this.dialogController.close()
    const arr=this.deviceController.connect(item.deviceId)
    if (!arr.some(dev=> dev.connectRet ===true)) {
      this.pairingDevice=item
      this.errorDialog.open()
    }
  }

  disConnectDevice(item: BluetoothDevice) {
    this.pairingDevice = item
    this.dialogController.close()
    this.disConnectDialog.open()
  }

  doBluetoothOperation(item: BluetoothDevice) {
    this.pairingDevice = item;
    this.isConnected = item.connectionState === ProfileConnectionState.STATE_CONNECTED;
    this.dialogController.open();
  }

  getPairStateText(device: BluetoothDevice): string | Resource {
    return device.connectionState == BondState.BOND_STATE_BONDING ? $r('app.string.bluetooth_state_pairing') : '';
  }

  pairDevice(device: BluetoothDevice) {
    console.log(JSON.stringify(device),'pairDeviceitem')
    this.deviceController.pair(device.deviceId);
  }

  confirmPairing(accept: boolean) {
    this.deviceController.confirmPairing(this.pairingDevice.deviceId, accept);
    if (accept) {
      this.availableDevicesList.delData(this.pairingDevice);
      this.focusTobluetoothKey()
    } else {
      this.availableDevicesList.reloadData(this.availableDevices)
    }
  }

  getConnectionStateText(device: BluetoothDevice): string | Resource {
    let stateText: string | Resource = '';
    switch (device.connectionState) {
      case ProfileConnectionState.STATE_DISCONNECTED:
        stateText = $r('app.string.bluetooth_state_disconnected');
        break;

      case ProfileConnectionState.STATE_CONNECTING:
        stateText = $r('app.string.bluetooth_state_connecting');
        break;

      case ProfileConnectionState.STATE_CONNECTED:
        if (device.deviceType === DeviceType.HEADPHONE) {
          stateText = $r('app.string.bluetooth_state_connected');
        } else {
          stateText = $r('app.string.bluetooth_state_connected');
        }
        break;

      case ProfileConnectionState.STATE_DISCONNECTING:
        stateText = $r('app.string.bluetooth_state_disconnecting');
        break;

    }
    return stateText;
  }


  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  tabClick() {
    let keyDownOpt: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUpOpt: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let eventDown: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventDown, 'KeyEvent', keyDownOpt)
    let eventUp: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventUp, 'KeyEvent', keyUpOpt)

    try {
      inputEventClient.injectEvent(eventDown as never);
      inputEventClient.injectEvent(eventUp as never);
    } catch (err) {
      console.error('settingList inputEventClient' + err)
    }
  }

  aboutToAppear(): void {
    this.deviceController.initData().subscribe();
  }

  onPageShow(): void {
    this.storageLink=0;
    this.tabClick();
  }
  onPageHide(): void {
    this.storageLink=1;
  }
  aboutToDisappear(): void {
    this.deviceController.unsubscribe();
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        Scroll(this.scroller) {
          Column() {
            Column() {
              Text('蓝牙')
                .height(lpx(75))
                .lineHeight(lpx(75))
                .fontColor(Color.White)
                .fontSize(lpx(64))
                .fontWeight(500)
                .textAlign(TextAlign.Start)
                .margin({
                  top: lpx(48),
                  bottom: lpx(48),
                  left: lpx(12)
                })

              Row() {
                Row() {
                  Text('蓝牙')
                    .fontColor(this.focusIndex === -2 ? '#000000' : '#ffffff')
                    .height(lpx(98))
                    .fontSize(lpx(36))
                    .align(Alignment.Center)
                    .textAlign(TextAlign.Start)
                    .fontWeight(500)
                    .margin({
                      left: lpx(24)
                    })
                    .focusable(true)
                    .stateStyles({
                      focused: {
                        .border({
                          color: Color.Transparent
                        })
                      }
                    })
                  Text().flexGrow(1)

                  Toggle({ type: ToggleType.Switch, isOn: this.isOn })
                    .width(lpx(83))
                    .height(lpx(46))
                    .margin({ right: lpx(24) })
                    .selectedColor('#2056f7')
                    .switchPointColor(0xe5ffffff)
                    .align(Alignment.Center)
                    .focusable(false)
                    .stateStyles({
                      focused: {
                        .border({
                          color: Color.Transparent
                        })
                      }
                    })
                    .onClick(()=> {
                      if (this.isVolumeOn) {
                        sound.playAudio()
                      }
                      if (!this.isEnabled) {
                        return;
                      }
                      let isOn = !this.isOn
                      //关闭蓝牙后重置蓝牙连接状态
                      if (!isOn) {
                        this.controlPairing = true
                      }
                      this.deviceController.toggleValue(isOn, ret => {
                        if (!ret) {
                          promptAction.showToast({
                            message: this.errorMessage,
                            duration: 1000,
                          });
                        }
                      });
                    })
                }
                .onClick(()=>{
                  if (this.isVolumeOn) {
                    sound.playAudio()
                  }
                  if (!this.isEnabled) {
                    return;
                  }
                  let isOn = !this.isOn
                  //关闭蓝牙后重置蓝牙连接状态
                  if (!isOn) {
                    this.controlPairing = true
                  }
                  this.deviceController.toggleValue(isOn, ret => {
                    if (!ret) {
                      promptAction.showToast({
                        message: this.errorMessage,
                        duration: 1000,
                      });
                    }
                  });
                })
                .width(lpx(840))
                .height(lpx(98))
                .backgroundColor(this.focusIndex === -2 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
                .borderRadius(lpx(18))
              }
              .key(this.blueToothKey)
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)
              .padding('6lpx')
              .border({
                width: this.focusIndex === -2 ? '2lpx' : '0lpx',
                color: Color.White,
                radius: lpx(24),
                style: BorderStyle.Solid
              })
              .defaultFocus(true)
              .focusable(true)
              .onFocus(() => {
                this.focusIndex = -2
                this.scroller.scrollEdge(Edge.Top)
                this.listFlag = '';
              })
              .onKeyEvent((event) => {
                if (this.isVolumeOn && event.type == KeyType.Down) {
                  sound.playAudio()
                }
                if (event.type == KeyType.Down && event.keyCode == KeyCode.KEY_ENTER) {
                  if (!this.isEnabled) {
                    return;
                  }
                  let isOn = !this.isOn
                  //关闭蓝牙后重置蓝牙连接状态
                  if (!isOn) {
                    this.controlPairing = true
                  }
                  this.deviceController.toggleValue(isOn, ret => {
                    if (!ret) {
                      this.isEnabled = true;
                      promptAction.showToast({
                        message: this.errorMessage,
                        duration: 1000,
                      });
                    }
                  });
                }
              })
              .onHover(() => {
                this.focusIndex = -2
              })
              .onTouch((event) => {
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
                if (event.sourceTool !== SourceTool.Pen &&
                  event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                  return;
                }
              })

            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Start)

            if (this.isOn) {
              Text($r('app.string.bluetooth_paired_devices'))
                .fontColor('rgba(255, 255, 255, 0.9)')
                .fontSize(lpx(30))
                .lineHeight(lpx(36))
                .textAlign(TextAlign.Start)
                .width(ConfigData.WH_100_100)
                .padding({
                  top: lpx(24),
                  left: lpx(12),
                  bottom: lpx(12)
                })
                .visibility(this.pairedDevices && this.pairedDevices.length > 0 ? Visibility.Visible : Visibility.None)

              if (this.pairedDevices && this.pairedDevices.length > 0) {
                // 配对设备列表
                List({ space: lpx(14), scroller: this.pairedScroller }) {
                  ForEach(this.pairedDevices, (item: BluetoothDevice, index: number) => {
                    ListItem() {
                      EntryComponent({
                        isFocus: this.focusIndex === index && item.deviceId === this.deviceId && this.isOne,
                        settingIcon: getDeviceIconPath(item.deviceType),
                        settingTitle: item.deviceName,
                        settingValue: this.getConnectionStateText(item),
                        settingArrow: $r('app.media.bg'),
                        settingArrowStyle: 'bluetooth',
                        imageWh: lpx(36),
                        heights: lpx(98),
                        fontSize: lpx(36)
                      })
                    }
                    .id(item.deviceId)
                    .focusable(true)
                    .onFocus(() => {
                      if (this.listFlag !== 'paired') {
                        this.listFlag = 'paired';
                      }
                      this.isOne = true
                      this.focusIndex = index
                      this.deviceId = item.deviceId
                      if (index === this.pairedDevices.length - 1) {
                        this.pairedScroller.scrollEdge(Edge.Bottom)
                      } else {
                        if (this.pairedDevices.length <= 6) {
                          this.pairedScroller.scrollToIndex(index, true, ScrollAlign.END)
                        } else {
                          this.scroller.scrollTo({
                            xOffset: 0,
                            yOffset: lpx((index + 1) * 122),
                            animation: true
                          })
                        }
                      }
                    })
                    .onKeyEvent((event) => {
                      if (event.keyCode === KeyCode.KEY_ENTER && event.type == KeyType.Up) {
                        this.doBluetoothOperation(item);
                      }
                    })
                    .onClick(()=>{
                      this.doBluetoothOperation(item);
                    })
                    .onHover(() => {
                      this.isOne = true
                      this.focusIndex = index
                      this.deviceId = item.deviceId
                    })
                    .onTouch((event) => {
                      if (!EventUtil.isTouchEvent(event)) {
                        return;
                      }
                      if (event.sourceTool !== SourceTool.Pen &&
                        event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                        return;
                      }
                      if (this.isVolumeOn) {
                        sound.playAudio()
                      }
                      this.doBluetoothOperation(item);
                    })
                    .padding('6lpx')
                    .border(this.focusIndex === index && item.deviceId === this.deviceId && this.isOne ? {
                      width: lpx(2),
                      color: Color.White,
                      radius: lpx(24),
                      style: BorderStyle.Solid
                    } : { width: 0 })

                  }, (item: BluetoothDevice) => JSON.stringify(item));
                }
                .height('auto')
                .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.None)
              }

              Text($r('app.string.bluetooth_available_devices'))
                .fontColor('rgba(255, 255, 255, 0.9)')
                .fontSize(lpx(30))
                .lineHeight(lpx(36))
                .textAlign(TextAlign.Start)
                .width(ConfigData.WH_100_100)
                .padding({
                  top: lpx(24),
                  left: lpx(12),
                  bottom: lpx(12)
                })

              // 可用设备列表
              if (this.availableDevices && this.availableDevices.length >= 1) {
                List({ space: lpx(14), scroller: this.availableScroller }) {
                  LazyForEach(this.availableDevicesList, (item: BluetoothDevice, index: number) => {
                    ListItem() {
                      EntryComponent({
                        isFocus: this.focusIndex === index && item.deviceId === this.deviceId && !this.isOne,
                        settingIcon: getDeviceIconPath(item.deviceType),
                        settingTitle: item.deviceName ? item.deviceName : item.deviceId,
                        settingValue: this.getPairStateText(item),
                        settingArrow: $r('app.media.bg'),
                        settingArrowStyle: 'bluetooth',
                        imageWh: lpx(36),
                        heights: lpx(98),
                        fontSize: lpx(36),
                        maxLines: ComponentConfig.MAX_LINES_1
                      })
                    }
                    .id(item.deviceId)
                    .focusable(true)
                    .onFocus(() => {
                      this.isOne = false
                      this.focusIndex = index
                      this.deviceId = item.deviceId
                      // 添加防抖处理
                      if (this.scrollTimer) {
                        clearTimeout(this.scrollTimer);
                      }
                      this.scrollTimer = setTimeout(() => {
                        if (this.listFlag === 'paired') {
                          this.listFlag = 'available';
                          this.scroller.scrollEdge(Edge.Bottom)
                        }
                        this.availableScroller.scrollToIndex(index, true, ScrollAlign.CENTER)
                      }, 50)
                    })
                    .onKeyEvent((event) => {
                      if (this.isVolumeOn) {
                        sound.playAudio()
                      }
                      if (event.keyCode === KeyCode.KEY_ENTER && event.type == KeyType.Up) {
                        if (this.controlPairing) {
                          this.getUIContext().getFocusController().clearFocus();
                          setTimeout(() => {
                            focusControl.requestFocus(item.deviceId);
                          }, 50)
                          this.pairDevice(item);
                        } else {
                          return promptAction.showToast({
                            message: $r('app.string.exist_connect'),
                            duration: 2000
                          });
                        }
                      }
                    })
                    .onHover(() => {
                      this.isOne = false
                      this.focusIndex = index
                      this.deviceId = item.deviceId
                    })
                    .onTouch((event) => {
                      if (!EventUtil.isTouchEvent(event)) {
                        return;
                      }
                      if (event.sourceTool !== SourceTool.Pen &&
                        event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                        return;
                      }
                    })
                    .onClick(()=>{
                      if (this.isVolumeOn) {
                        sound.playAudio()
                      }
                      if (this.controlPairing) {
                        this.getUIContext().getFocusController().clearFocus();
                        setTimeout(() => {
                          focusControl.requestFocus(item.deviceId);
                        }, 50)
                        this.pairDevice(item);
                      } else {
                        return promptAction.showToast({
                          message: $r('app.string.exist_connect'),
                          duration: 2000
                        });
                      }
                    })
                    .padding('6lpx')
                    .border(this.focusIndex === index && item.deviceId === this.deviceId && !this.isOne ? {
                      width: lpx(2),
                      color: Color.White,
                      radius: lpx(24),
                      style: BorderStyle.Solid
                    } : { width: 0 })

                  }, (item: BluetoothDevice) => JSON.stringify(item));
                }.height(this.pairedDevices.length >= 1 ? lpx(500) : lpx(650))
                .cachedCount(5)
                .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.None)
              } else {
                Text($r('app.string.scanning'))
                  .fontSize(lpx(30))
                  .textCase(TextCase.UpperCase)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#FFFFFF')
                  .height(lpx(48))
              }

            }
          }
        }
        .width(ConfigData.WH_48_100)
        .layoutWeight(ConfigData.LAYOUT_WEIGHT_1)
        .scrollBar(BarState.Off)
        .margin({ left: lpx(84) })


        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
      .alignItems(VerticalAlign.Top)
    }
    .height(ConfigData.WH_100_100)
    .width(ConfigData.WH_100_100)
  }
}


@CustomDialog
struct PairDialog {
  @State focusIndex: number = -1

  dialogController: CustomDialogController;
  private deviceName: string = '';
  private pinCode: string = '';

  action: Function = (accept: boolean) => {
  };

  aboutToAppear(): void {
  }

  build() {
    Column() {
      Text($r('app.string.bluetooth_pairing_request'))
        .fontSize(lpx(40))
        .fontColor(Color.White)
        .fontWeight(500)
        .align(Alignment.Center)
        .margin({
          top: lpx(40),
          bottom: lpx(40)
        })

      Column() {
        if (this.pinCode) {
          Text($r('app.string.bluetooth_pairing_intelligent_device_hit', this.deviceName, this.deviceName))
            .fontSize(lpx(24))
            .fontColor(Color.White)
            .align(Alignment.Center)
            .fontWeight(FontWeight.Regular)
            .margin({
              bottom:lpx(24),
              left: lpx(40),
              right: lpx(40)
            })

          Text(`${this.pinCode}`)
            .fontSize(lpx(40))
            .fontWeight(500)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .margin({bottom:lpx(48)})

        } else {
          Text($r('app.string.bluetooth_pairing_media_device_hit'))
            .fontSize(lpx(24))
            .fontColor(Color.White)
            .margin({bottom:lpx(20)})
          Text(this.deviceName)
            .fontSize(lpx(40))
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .margin({bottom:lpx(40)})
        }

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
          Column() {
            Text($r('app.string.cancel'))
              .textAlign(TextAlign.Center)
              .borderRadius(lpx(200))
              .fontSize(lpx(36))
              .fontColor(this.focusIndex === 1 ? Color.Black : Color.White)
              .backgroundColor(this.focusIndex === 1 ? Color.White : '#666666')
              .fontWeight(500)
              .focusable(true)
              .defaultFocus(true)
              .width(lpx(248))
              .height(lpx(72))
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
              .onFocus(() => {
                this.focusIndex = 1;
              })
              .onClick(()=>{
                this.dialogController.close();
                this.action(false);
              })
              .onTouch((event) => {
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
                if (event.sourceTool !== SourceTool.Pen &&
                  event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                  return;
                }

                this.dialogController.close();
                this.action(false);
              })
          }
          .width(this.focusIndex === 1 ? lpx(266) : lpx(248))
          .height(this.focusIndex === 1 ? lpx(90) : lpx(72))
          .border({
            width: this.focusIndex === 1 ? lpx(2) : 0,
            radius: lpx(200),
            color: Color.White,
            style: BorderStyle.Solid
          })
          .justifyContent(FlexAlign.Center)

          Column() {
            Text($r('app.string.bluetooth_pair_button'))
              .textAlign(TextAlign.Center)
              .borderRadius(lpx(200))
              .width(lpx(248))
              .height(lpx(72))
              .focusable(true)
              .fontSize(lpx(36))
              .fontColor(this.focusIndex === 2 ? Color.Black : Color.White)
              .backgroundColor(this.focusIndex === 2 ? Color.White : '#666666')
              .fontWeight(500)
              .focusable(true)
              .onFocus(() => {
                this.focusIndex = 2
              })
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
              .onClick(()=>{
                this.dialogController.close();
                this.action(true);
              })
              .onTouch((event) => {
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
                if (event.sourceTool !== SourceTool.Pen &&
                  event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                  return;
                }

                this.dialogController.close();
                this.action(true);
              })
          }
          .width(this.focusIndex === 2 ? lpx(266) : lpx(248))
          .height(this.focusIndex === 2 ? lpx(90) : lpx(72))
          .border({
            width: this.focusIndex === 2 ? lpx(2) : 0,
            radius: lpx(200),
            color: Color.White,
            style: BorderStyle.Solid
          })
          .justifyContent(FlexAlign.Center)
        }
        .margin({
          bottom: lpx(40)
        })

      }
      .width(ConfigData.WH_100_100)

    }
    .borderRadius(lpx(24))
    .width($r('app.float.wh_value_410'))
    .backgroundColor('#404040')
  }
}

class AvailableDevicesDataSource extends BasicDataSource {
  private availableDevicesArray: BluetoothDevice[] = [new BluetoothDevice()];

  constructor(availableDevicesArray: BluetoothDevice[]) {
    super();
    this.availableDevicesArray = availableDevicesArray;
  }

  public totalCount(): number {
    if (this.availableDevicesArray) {
      return this.availableDevicesArray.length;
    }
    return 0;
  }

  public getData(index: number): BluetoothDevice {
    if (!this.availableDevicesArray) {
      return new BluetoothDevice();
    }
    if (index < 0 || index >= this.totalCount()) {
      return new BluetoothDevice();
    }
    return this.availableDevicesArray[index];
  }

  public delData(device: BluetoothDevice): void {
    let index = this.availableDevicesArray.indexOf(device);
    this.availableDevicesArray.splice(index, 1)
    this.notifyDataDelete(index)
  }

  public reloadData(data: BluetoothDevice[]): void {
    this.availableDevicesArray = data
    this.notifyDataReload()
  }
}

export function getDeviceIconPath(deviceType: string): string {
  let path: string = '/res/image/ic_bluetooth_device.svg';
  switch (deviceType) {
    case DeviceType.HEADPHONE:
      path = '/res/image/ic_device_earphone_hero.svg';
      break;

    case DeviceType.PHONE:
      path = '/res/image/ic_public_devices_phone.svg';
      break;

    case DeviceType.WATCH:
      path = '/res/image/ic_device_watch.svg';
      break;

    case DeviceType.COMPUTER:
      path = '/res/image/ic_device_matebook.svg';
      break;
  }
  return path;
}
