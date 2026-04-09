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

import { inputEventClient, KeyCode } from '@kit.InputKit';
import { settings, systemParameterEnhance } from '@kit.BasicServicesKit';
import LinkDevice from '../../model/linkImpl/LinkDevice';
import { Ratio } from '../../common/Ratio';
import { CustomDialogTvComponent, DialogContent } from '../../default/layout/CustomDialogTvComponent';
import { CustomDialogContentStyle, SourcetoolConstants } from '../../common/constants/StyleConstants';
import LinksModel from '../../model/morelinkImpl/LinksModel';
import { SettingBackground } from '../../default/layout/SettingBackground';
import lpx from '../../common/Lpx';
import EntryComponent from '../../default/layout/EntryComponent';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import BasicDataSource from '../../../../../../../common/utils/src/main/ets/default/model/BasicDataSource';
import { DeviceType } from '../../model/bluetoothImpl/BluetoothModel';
import { Duration } from '../../common/constants/Duration';
import { common } from '@kit.AbilityKit';
import { LengthMetrics, router } from '@kit.ArkUI';
import deviceInfo from '@ohos.deviceInfo';
import { EventUtil } from '../../common/EventUtil';

export interface Param { bluetoothDevice: string }
const DLNA_ENABLE = 'persist.dlnadmr.enable'
const MIRACAST_QUICK_PLAY_KEY = 'settings.wifi.miracast.quickplay';
const CAST_SWITCH = 'settings.cast.switch'
const FALSE = '0';
const TRUE = '1';

class InjectedKeyEventPayload {
}

@Entry
@Component
struct Links {
  @State imageUrl: string = Ratio.resName('icon_links')
  @State des: string = getContext(this).resourceManager.getStringByNameSync('support_screen')
  @State focusIndex: number = -1
  @State isMiraCastOn: boolean = false;
  @State isCastOn: boolean = false;
  private scroller: Scroller = new Scroller()
  @State trustDevices: LinkDevice[] = [];
  @State isConnected: boolean = false;
  @State availableDevices: LinkDevice[] = [];
  @State availableDevicesList: AvailableDevicesDataSource = new AvailableDevicesDataSource(this.availableDevices);
  @State pairPinCode: string = '';
  @State
  isOne: boolean = true
  @State
  isTwo: boolean = true
  @State
  isOneSelect: boolean = true
  @State
  isFirstToggle: boolean = true
  @State isOnfocusExpansion: boolean = false
  private name = settings.getValueSync(getContext(), 'settings.general.name', '');
  private contentOne: DialogContent = new DialogContent('是否移除该信任设备?', '', '', '', 692, 300);
  private contentTwo: DialogContent = new DialogContent('投屏设备名称', `${this.name}`, '', '', 692, 450);
  private dialogOneController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: (): void => this.onOneCancel(),
      confirm: (): void => this.onOneConfirm(),
      content: this.contentOne,
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })
  private dialogTwoController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: (): void => this.onTwoCancel(),
      confirm: (): void => this.onTwoConfirm(),
      content: this.contentTwo,
      contentStyle: CustomDialogContentStyle.titleInput
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  onOneConfirm() {
    this.dialogOneController.close();
  }

  onOneCancel() {
    this.dialogOneController.close();
  }

  onTwoConfirm() {
    this.name = this.contentTwo.getTextInputValue()
    this.contentTwo.content = this.name
    settings.setValueSync(getContext(), ConfigData.SETTINGSDATA_DEVICE_NAME, this.contentTwo.getTextInputValue());
    this.dialogTwoController.close();
  }

  onTwoCancel() {
    this.dialogTwoController.close();
  }

  tabStartClick() {
    let keyDown: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUp: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let eventDown: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventDown, 'KeyEvent', keyDown)
    let eventUp: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventUp, 'KeyEvent', keyUp)
    try {
      inputEventClient.injectEvent(eventDown as never);
      inputEventClient.injectEvent(eventUp as never);
    } catch (e) {
      console.log('tab key event click false')
    }
  }

  aboutToAppear(): void {
    this.getSwitchValue()
  }

  async getSwitchValue(){
    try {
      let res = settings.getValueSync(getContext(this), CAST_SWITCH, '')
      console.log('getSwitchValue',res);
      if (res == TRUE || res == '') {
        console.log('getSwitchValue true')
        this.isCastOn = true
        systemParameterEnhance.set(DLNA_ENABLE, 'true')
        settings.setValueSync(getContext(this), CAST_SWITCH, TRUE)
        settings.setValueSync(getContext(this), MIRACAST_QUICK_PLAY_KEY, TRUE);
      } else if (res === FALSE) {
        console.log('getSwitchValue false')
        this.isCastOn = false
        systemParameterEnhance.set(DLNA_ENABLE, 'false')
        settings.setValueSync(getContext(this), CAST_SWITCH, FALSE)
        settings.setValueSync(getContext(this), MIRACAST_QUICK_PLAY_KEY, FALSE);
      }
    } catch (e) {
      console.log('get dlna error ' + e)
    }
  }



  /**
   * 开关控制
   */
  switchLinks() {
    this.isMiraCastOn = !this.isMiraCastOn
    if (this.isMiraCastOn) {
      LinksModel.setMiraCastStatus('1');
    } else {
      LinksModel.setMiraCastStatus('0');
    }
  }
  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }
  switchCast() {
    try {
      if (this.isCastOn) {
        systemParameterEnhance.setSync('persist.dlnadmr.enable', 'true')
        settings.setValue(getContext(this), MIRACAST_QUICK_PLAY_KEY, TRUE);
        settings.setValueSync(getContext(this), CAST_SWITCH, TRUE)
      } else {
        systemParameterEnhance.setSync('persist.dlnadmr.enable', 'false')
        settings.setValue(getContext(this), MIRACAST_QUICK_PLAY_KEY, FALSE);
        settings.setValueSync(getContext(this), CAST_SWITCH, FALSE)
      }
    } catch (err) {
      console.debug('set dlna close error ' + err)
    }
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        Column() {
          Column() {
            Text('更多连接')
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
                Text($r('app.string.screen_casting'))
                  .height(lpx(98))
                  .fontColor((this.isOneSelect && this.isFirstToggle) ? Color.Black : Color.White)
                  .fontSize(lpx(36))
                  .align(Alignment.Center)
                  .textAlign(TextAlign.Start)
                  .margin({
                    left: lpx(24)
                  })
                Blank()

                Toggle({ type: ToggleType.Switch, isOn: $$this.isCastOn })
                  .width(lpx(83))
                  .height(lpx(46))
                  .selectedColor('#2056f7')
                  .switchPointColor(0xe5ffffff)
                  .align(Alignment.Center)
                  .margin({ right: lpx(24) })
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                  .onChange((isOn)=>{
                    this.switchCast();
                  })
              }
              .id('screen_casting')
              .onClick(() => {
                try {
                  this.getUIContext().getFocusController().requestFocus('screen_casting')
                } catch (error) {
                  console.log('Links','定焦失败')
                }
                this.isCastOn = !this.isCastOn
              })
              .width((this.isOneSelect && this.isFirstToggle) ? lpx(846) : lpx(840))
              .height(lpx(98))
              .backgroundColor((this.isOneSelect && this.isFirstToggle) ? 'rgba(255, 255, 255, 0.86)' :
                'rgba(255, 255, 255, 0.2)')
              .borderRadius(lpx(18))
            }
            .height(lpx(118))
            .width(lpx(868))
            .borderRadius(lpx(18))
            .border({
              width: (this.isOneSelect && this.isFirstToggle) ? lpx(2) : 0,
              color: Color.White,
              radius: lpx(22),
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .focusable(true)
            .defaultFocus(true)
            .onFocus(() => {
              this.isOne = true
              this.isTwo = false
              this.isOneSelect = true
              this.isFirstToggle = true
            })
            .onBlur(() => {
              this.isOneSelect = false
              this.isFirstToggle = false
              this.focusIndex = -1
            })
            .onHover((isHover: boolean)=>{
              this.isOneSelect = isHover;
              this.isFirstToggle = isHover
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

            Row() {
              Row() {
                Text($r('app.string.screen_expansion'))
                  .height(lpx(98))
                  .fontColor(this.isOnfocusExpansion ? Color.Black : Color.White)
                  .fontSize(lpx(36))
                  .align(Alignment.Center)
                  .textAlign(TextAlign.Start)
                  .margin({
                    left: lpx(24)
                  })

                Blank()

                Image($r(Ratio.resName('icon_arrow_right')))
                  .fillColor(this.isOnfocusExpansion ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .width(lpx(24))
                  .height(lpx(48))
                  .opacity(1)
                  .objectFit(ImageFit.Fill)
                  .align(Alignment.Center)
                  .margin({ right: lpx(24) })
                  .focusable(true)
                  .focusBox({
                    strokeWidth: LengthMetrics.px(0)
                  })
              }
              .onClick(() => {
                  try {
                    this.getUIContext().getFocusController().requestFocus('screen_expansion')
                  } catch (error) {
                    console.log('Links','定焦失败')
                  }

                router.pushUrl({ url: 'pages/links/screenExpansion/ScreenExpansion' })
              })
              .focusable(true)
              .width(this.isOnfocusExpansion ? lpx(846) : lpx(840))
              .height(lpx(98))
              .backgroundColor(this.isOnfocusExpansion ? 'rgba(255, 255, 255, 0.86)' :
                'rgba(255, 255, 255, 0.2)')
              .borderRadius(lpx(18))
            }
            .visibility(deviceInfo.productModel != 'Hi3751V352' ? Visibility.Visible : Visibility.None)
            .height(lpx(118))
            .width(lpx(868))
            .borderRadius(lpx(18))
            .border({
              width: this.isOnfocusExpansion ? lpx(2) : 0,
              color: Color.White,
              radius: lpx(22),
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .margin({
              top: lpx(24)
            })
            .id('screen_expansion')
            .focusable(true)
            .onFocus(() => {
              this.isOnfocusExpansion = true
            })
            .onBlur(() => {
              this.isOnfocusExpansion = false
            })
            .onHover((isHover: boolean)=>{
              this.isOnfocusExpansion  = isHover
              this.isOneSelect = false;
            })
            .onTouch((event)=>{
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              if (event.sourceTool !== SourceTool.Pen &&
                event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                return;
              }
            })

            Row() {
              Row() {
                Text('手机投屏')
                  .height(lpx(98))
                  .fontColor((this.isOneSelect && !this.isFirstToggle) ? '#000000' : '#ffffff')
                  .fontSize(lpx(36))
                  .align(Alignment.Center)
                  .textAlign(TextAlign.Start)
                  .margin({
                    left: lpx(24)
                  })
                Blank()

                Toggle({ type: ToggleType.Switch, isOn: this.isMiraCastOn })
                  .width(lpx(83))
                  .height(lpx(46))
                  .selectedColor('#2056f7')
                  .switchPointColor(0xe5ffffff)
                  .align(Alignment.Center)
                  .margin({ right: lpx(24) })
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
              }
              .width((this.isOneSelect && !this.isFirstToggle) ? lpx(846) : lpx(840))
              .height(lpx(98))
              .backgroundColor((this.isOneSelect && !this.isFirstToggle) ? 'rgba(255, 255, 255, 0.86)' :
                'rgba(255, 255, 255, 0.2)')
              .borderRadius(lpx(18))
            }
            .height(lpx(118))
            .width(lpx(868))
            .borderRadius(lpx(18))
            .border({
              width: (this.isOneSelect && !this.isFirstToggle) ? lpx(2) : 0,
              color: Color.White,
              radius: lpx(22),
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .focusable(true)
            .visibility(Visibility.Hidden)
            .onFocus(() => {
              console.log('焦点 获取 手机投屏');
              this.isOne = true
              this.isTwo = false
              this.isOneSelect = true
              this.isFirstToggle = false
            })
            .onBlur(() => {
              console.log('焦点 获取 手机投屏');
              this.isOneSelect = false
              this.focusIndex = -1
            })
            .onKeyEvent((event) => {
              if (event.keyCode == KeyCode.KEYCODE_ENTER && event.type == KeyType.Up) {
                this.switchLinks();
              }
            })
            .onTouch((event) => {
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              if (event.sourceTool !== SourceTool.Pen &&
                event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                return;
              }
              this.switchLinks();
            })
          }
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)

          Column() {
            if (this.isMiraCastOn) {
              Text($r('app.string.links_trust_devices'))
                .fontColor('rgba(255, 255, 255, 0.9)')
                .fontSize(lpx(24))
                .lineHeight(lpx(28))
                .textAlign(TextAlign.Start)
                .width(ConfigData.WH_100_100)
                .padding({
                  top: lpx(24),
                  left: lpx(12),
                  bottom: lpx(12)
                })

              if (this.trustDevices && this.trustDevices.length > 0) {
                List({ space: lpx(24), scroller: this.scroller }) {
                  ForEach(this.trustDevices, (item: LinkDevice, index: number) => {
                    ListItem() {
                      EntryComponent({
                        isFocus: this.focusIndex === index && this.isTwo,
                settingIcon: '/res/image/ic_public_devices_phone.svg',
                        settingTitle: item.deviceName,
                        settingValue: '',
                settingArrow: $r('app.media.icon_arrow_right'),
                        settingArrowStyle: 'bluetooth',
                        imageWh: lpx(36),
                        heights: lpx(98),
                        fontSize: lpx(36)
                      })
                    }
                    .focusable(true)
                    .stateStyles({
                      focused: {
                        .border({
                          color: Color.Transparent
                        })
                      }
                    })
                    .onFocus(() => {
                      console.log('焦点 失去 信任', `index:${index}`);
                      this.isOne = false
                      this.isTwo = true
                      this.focusIndex = index
                    })
                    .borderRadius(lpx(18))
                    .height(this.focusIndex === index && this.isTwo ? lpx(118) : lpx(98))
                    .width(lpx(868))
                    .border({
                      width: this.focusIndex === index && this.isTwo ? lpx(2) : 0,
                      color: Color.White,
                      radius: lpx(22),
                      style: BorderStyle.Solid
                    })
                    .onKeyEvent((e) => {
                      if (e.keyCode === KeyCode.KEYCODE_ENTER && e.type === KeyType.Up) {
                        console.log('Hmlog------KeyType.Down')
                        this.dialogOneController.open()
                      }
                    })
                    .onTouch((event) => {
                      if (!EventUtil.isTouchEvent(event)) {
                        return;
                      }
                      if (event.sourceTool !== SourceTool.Pen &&
                        event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                        return;
                      }
                      this.dialogOneController.open()
                    })
                  }, (item: LinkDevice) => JSON.stringify(item));
                }
              }

            }
          }
          .margin({ left: lpx(30) })
          .height(ConfigData.WH_55_100)
        }
        .width(ConfigData.WH_48_100)
        .height(ConfigData.WH_100_100)
        .margin({ left: lpx(84) })


        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }
    .height(ConfigData.WH_100_100)
    .width(ConfigData.WH_100_100)
  }
}


class AvailableDevicesDataSource extends BasicDataSource {
  private availableDevicesArray: LinkDevice[] = [new LinkDevice()];

  constructor(availableDevicesArray: LinkDevice[]) {
    super();
    this.availableDevicesArray = availableDevicesArray;
  }

  public totalCount(): number {
    if (this.availableDevicesArray) {
      return this.availableDevicesArray.length;
    }
    return 0;
  }

  public getData(index: number): LinkDevice {
    if (!this.availableDevicesArray) {
      return new LinkDevice();
    }
    if (index < 0 || index >= this.totalCount()) {
      return new LinkDevice();
    }
    return this.availableDevicesArray[index];
  }

  public delData(device: LinkDevice): void {
    let index = this.availableDevicesArray.indexOf(device);
    this.availableDevicesArray.splice(index, 1)
    this.notifyDataDelete(index)
  }

  public reloadData(data: LinkDevice[]): void {
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

