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

import { Ratio } from '../../common/Ratio';
import router from '@ohos.router';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { KeyCode } from '../../common/constants/KeyCode';
import lpx from '../../common/Lpx';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import wifiManager from '@ohos.wifiManager';
import { EventUtil } from '../../common/EventUtil';
import hotspotUtils from '../hotspot/utils/HotspotUtils';
import { CustomDialogComponent, DialogContent } from './CustomDialogComponent';
import { CustomDialogContentStyle} from '../../common/constants/StyleConstants';
import { settings } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';

const MAXCONNECTEDNUMBER = 9
const DIALOGWIDTH = 692
const DIALOGHEIGHT = 400
//提取公共样式
@Extend(Text)
function aboutContent() {
  .fontColor('rgba(255, 255, 255, 0.9)')
  .fontSize(lpx(30))
  .lineHeight(lpx(36))
  .textAlign(TextAlign.Start)
  .width(ConfigData.WH_100_100)
  .padding({
    top: lpx(24),
    left: lpx(48),
    bottom: lpx(24),
    right:lpx(48)
  })
}

@Extend(Text)
function hotspotItem() {
  .height(lpx(98))
  .fontSize(lpx(36))
  .align(Alignment.Center)
  .textAlign(TextAlign.Start)
  .margin({
    left: lpx(24)
  })
  .focusable(true)
  .borderColor(Color.Transparent)
  .stateStyles({
    focused: {
      .border({
        color: Color.Transparent
      })
    }
  })
}

@Extend(Image)
function rightArrowIcon() {
  .width(lpx(24))
  .height(lpx(48))
  .objectFit(ImageFit.Fill)
  .align(Alignment.Center)
  .margin({ right: lpx(24) })
}
// Miracast相关
const MIRACAST_QUICK_PLAY_KEY = 'settings.wifi.miracast.quickplay';
const FALSE = "0";
const TRUE = "1";
@Entry
@Component
struct hotspot {
  @StorageLink('hotspotStatus') isUsedHotSpot: boolean = false;
  @State isShowAbout: boolean = false
  @State isOpenDialog: boolean = false
  @State deviceName: string = ''
  @State hotspotPWD: string = ''
  @State connectedDeviceNumber: number = 0
  @State focusIndex: number = 0
  //二维码传入的字符串
  @State str1: string = 'WIFI:S:'
  @State str2: string = ';T:WPA;P:'
  @State str3: string = ';;'
  @State shareHotspot: string = this.str1 + this.deviceName + this.str2 + this.hotspotPWD + this.str3
  //热点开关
  @State isHotSpotEnabled: boolean = false;
  @State model: SettingItemTvModel = new SettingItemTvModel()
  private pageTranState: boolean = false; //判断是进场动效还是出场动效
  @State connectNumber: number = 0
  //判断当前是否在处理onkeyevent事件
  @State isProcess: boolean = false
  @State isClicking: boolean = false;
  @State isWiFiEnabled:boolean = false
  @State is5G:boolean = false
  private content: DialogContent = new DialogContent("开启热点", "开启热点，将关闭WLAN，且投屏无法使用", "", "", DIALOGWIDTH, DIALOGHEIGHT);
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogComponent({
      cancel: (): void => this.onCancel(),
      confirm: (): void => this.onConfirm(),
      content: this.content,
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })
  onConfirm() {
    wifiManager.disableWifi()
    this.isWiFiEnabled = false
    this.SetWifiStatus()
    this.SetStatus()
    hotspotUtils.SwitchHotspotState(this.isHotSpotEnabled)
    hotspotUtils.StartHotspotListen()
    hotspotUtils.StartWifiHotspot()
    console.log('热点打开 this.isHotSpotEnabled wifiManager.isWifiActive()', this.isHotSpotEnabled,
      wifiManager.isWifiActive())
    this.dialogController.close();
  }

  onCancel() {
    this.isHotSpotEnabled = !this.isHotSpotEnabled
    hotspotUtils.SwitchHotspotState(this.isHotSpotEnabled)
    this.SetStatus()
    this.dialogController.close();
  }
  recvHotspotStaJoinFunc = (result:wifiManager.StationInfo) => {
    try {
      this.connectedDeviceNumber = wifiManager.getStations().length
      console.log("Connect Device List: connectedDeviceNumber" ,this.connectedDeviceNumber);
    } catch (error) {
      console.log("failed:" + JSON.stringify(error));
    }
  }
  aboutToAppear() {
    //主动获焦
    this.getFocusFun(this.focusIndex)
    console.log("进入个人热点页面 aboutToAppear")
    //开启热点监听
    hotspotUtils.StartHotspotListen()
    wifiManager.on("hotspotStaJoin", this.recvHotspotStaJoinFunc.bind(this));
    wifiManager.on("hotspotStaLeave", this.recvHotspotStaJoinFunc.bind(this));
    //设置最大可连接8台设备
    let Info = wifiManager.getHotspotConfig()
    Info.maxConn = MAXCONNECTEDNUMBER
    wifiManager.setHotspotConfig(Info)

    this.GetStatus()
    hotspotUtils.SwitchHotspotState(this.isHotSpotEnabled)
    if(this.isHotSpotEnabled){
      this.setDiscoverableFalse()
      hotspotUtils.StartWifiHotspot()
    }else {
      this.setDiscoverableTrue()
      hotspotUtils.StopWifiHotspot()
    }
  }
  aboutToDisappear() {
    //关闭热点监听
    hotspotUtils.StoptHotspotListen()
    wifiManager.off("hotspotStaJoin", this.recvHotspotStaJoinFunc.bind(this));
    wifiManager.off("hotspotStaLeave", this.recvHotspotStaJoinFunc.bind(this));
  }
  toggleClickEvent(){
    if (this.isClicking) {
      return;
    }
    this.isClicking = true;
    this.isHotSpotEnabled = !this.isHotSpotEnabled;
    try {
      if (this.isHotSpotEnabled) {
        this.setDiscoverableFalse()
        this.GetWifiStatus()
        if (this.isWiFiEnabled) {
          this.dialogController.open()
        } else {
          this.SetStatus()
          hotspotUtils.SwitchHotspotState(this.isHotSpotEnabled)
          hotspotUtils.StartHotspotListen()
          hotspotUtils.StartWifiHotspot()
          console.log('热点打开 this.isHotSpotEnabled wifiManager.isWifiActive()', this.isHotSpotEnabled,
            wifiManager.isWifiActive())
        }

      } else {
        hotspotUtils.SwitchHotspotState(this.isHotSpotEnabled)
        this.SetStatus()
        this.setDiscoverableTrue()
        hotspotUtils.StopWifiHotspot()
        hotspotUtils.StoptHotspotListen()
        console.log("热点关闭 this.isHotSpotEnabled", this.isHotSpotEnabled)
      }
    } catch (e) {
      console.log("热点异常")
    } finally {
      this.isClicking = false;
      this.isShowAbout = false;
    }
  }

  onPageShow() {
    this.GetStatus()
    this.getFocusFun(this.focusIndex)
    //进入页面后，刷新热点配置
    this.deviceName = wifiManager.getHotspotConfig().ssid
    this.hotspotPWD = wifiManager.getHotspotConfig().preSharedKey
    this.shareHotspot = this.str1 + this.deviceName + this.str2 + this.hotspotPWD + this.str3
    this.is5G = wifiManager.getHotspotConfig().band == 2
    //获取已连接设备的数量
    this.connectedDeviceNumber = hotspotUtils.GetConnectedDevicesNumber()
    console.log("hotspotConfig 热点名称 热点密码 连接数量" + this.deviceName, this.hotspotPWD,
      this.connectedDeviceNumber)
    //查询热点是否使能
    hotspotUtils.hotspotStatus()
  }
  onBackPress(): boolean | void {
    return this.allBackFun();
  }
  setDiscoverableFalse() {
    settings.setValue(getContext(this), MIRACAST_QUICK_PLAY_KEY, FALSE);
    console.log(`Wifi: set discoverable false`)
  }

  setDiscoverableTrue() {
    settings.setValue(getContext(this), MIRACAST_QUICK_PLAY_KEY, TRUE);
    console.log(`Wifi: set discoverable true`)
  }

  // 统一返回封装
  allBackFun(): boolean | void {
    if (this.isShowAbout) {
      this.isShowAbout = false;
      return true
    }
  }
  getFocusFun(index: number) {
    focusControl.requestFocus(index.toString())
  }
  //存储热点状态
  async SetStatus(){
    const context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    await new Promise<String>(()=>{
      settings.setValue(context, 'hotspotStatus', JSON.stringify(this.isHotSpotEnabled), (status) => {
        console.info('Callback return whether value is set. this.isHotSpotEnabled',this.isHotSpotEnabled);
      });
    })
  }
  //获取热点状态
  GetStatus(){
    // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext。
    const context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const value = settings.getValueSync(context,'hotspotStatus','false')
    console.log(`get hotspotStatus:${value}`);
    if(value == 'true'){
      this.isHotSpotEnabled = true
      console.log('GetStatus this.isHotSpotEnabled true ',this.isHotSpotEnabled)
    }else {
      this.isHotSpotEnabled = false
      console.log('GetStatus this.isHotSpotEnabled false ',this.isHotSpotEnabled)
    }
  }

  GetWifiStatus(){
    const context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const value = settings.getValueSync(context,'WifiStatus','false')
    if(value == 'true'){
        this.isWiFiEnabled = true
        console.log('GetStatus this.isWifiEnabled true ',this.isWiFiEnabled)
      }else {
        this.isWiFiEnabled = false
        console.log('GetStatus this.isisWifiEnabled false ',this.isWiFiEnabled)
      }
  }
  async SetWifiStatus(){
    const context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    await new Promise<string>(()=>{
      settings.setValue(context, 'WifiStatus', JSON.stringify(this.isWiFiEnabled), (status) => {
        console.info('Callback return whether value is set. this.isWifiEnabled',this.isWiFiEnabled);
      });
    })
  }

  build() {
    Stack() {
      Row() {
        Column() {
          Text("个人热点")
            .width(lpx(868))
            .height(lpx(75))
            .lineHeight(lpx(75))
            .fontColor(Color.White)
            .fontSize(lpx(64))
            .fontWeight(500)
            .textAlign(TextAlign.Start)
            .alignSelf(ItemAlign.Start)
            .margin({
              top: lpx(48),
              bottom: lpx(48),
              left: lpx(12)
            })

          Row() {
            Row() {
              Text("个人热点")
                .hotspotItem()
                .fontColor(this.focusIndex == 0 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                .onFocus(() => {
                  this.focusIndex = 0
                  console.log("个人热点获得焦点 this.focusIndex" + this.focusIndex)
                })
                .onBlur(() => {
                  console.log("个人热点失去焦点 this.focusIndex" + this.focusIndex)
                })
                .key('0')
                .defaultFocus(true)
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.Transparent
                    })
                  }
                })
                .onKeyEvent((event: KeyEvent) => {
                  this.isProcess = true
                  if (event.type === KeyType.Down) {
                    console.log("event0")
                    if (this.focusIndex === 0) {
                      // toggle的按键事件
                      if (event.keyCode === KeyCode.KEY_DPAD_UP) {
                        console.log("已经在最上面了")
                      } else if (event.keyCode === KeyCode.KEY_DPAD_DOWN && this.isHotSpotEnabled) {
                        // 向下键
                        this.focusIndex = 1
                        this.getFocusFun(this.focusIndex)
                      } else if (event.keyCode === KeyCode.KEY_ENTER) {
                        this.toggleClickEvent()
                        event.stopPropagation()
                      }
                    }
                    setTimeout(() => {
                      this.isProcess = false;
                    }, 100);
                  }
                })
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: this.isHotSpotEnabled })
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
                .onClick((event:ClickEvent) => {
                  this.toggleClickEvent();
                })
            }
            .width(lpx(840))
            .height(lpx(98))
            .backgroundColor(this.focusIndex === 0 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
            .borderRadius(lpx(18))
            .onHover((isHover: boolean) => {
              this.focusIndex = 0;
              this.getFocusFun(this.focusIndex)
            })
            .onTouch((event: TouchEvent) => {
              this.focusIndex = 0;
              this.getFocusFun(this.focusIndex)
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
            })
            .onClick(() => {
              this.toggleClickEvent();
            })
          }
          .padding(lpx(6))
          .border({
            width: lpx(2),
            color: this.focusIndex == 0 ? Color.White : Color.Transparent,
            radius: lpx(24),
            style: BorderStyle.Solid
          })
          .stateStyles({
            focused: {
              .border({
                color: Color.White
              })
            }
          })
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .focusable(true)

          // 热点菜单列表
          Text("热点")
            .fontColor('rgba(255, 255, 255, 0.9)')
            .fontSize(lpx(30))
            .lineHeight(lpx(36))
            .textAlign(TextAlign.Start)
            .width(ConfigData.WH_100_100)
            .padding({
              top: lpx(16),
              left: lpx(12),
              bottom: lpx(16)
            })
            .visibility(this.isHotSpotEnabled ? Visibility.Visible : Visibility.Hidden)
          Column() {
            Row() {
              Row() {
                Text("设备名称")
                  .hotspotItem()
                  .fontColor(this.focusIndex == 1 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .key('1')
                  .onFocus(() => {
                    this.focusIndex = 1
                    console.log("设备名称获得焦点 this.focusIndex" + this.focusIndex)
                  })
                  .onBlur(() => {
                    console.log("设备名称失去焦点 this.focusIndex" + this.focusIndex)
                  })
                  .onKeyEvent((event: KeyEvent) => {
                    this.isProcess = true
                    if (event.type === KeyType.Down) {
                      console.log("event1")
                      if (this.focusIndex === 1) {
                        // toggle的按键事件
                        if (event.keyCode === KeyCode.KEY_DPAD_UP) {
                          // 向上键
                          this.focusIndex = 0
                          this.getFocusFun(this.focusIndex)
                        } else if (event.keyCode === KeyCode.KEY_DPAD_DOWN) {
                          // 向下键
                          this.focusIndex = 2
                          this.getFocusFun(this.focusIndex)
                        } else if (event.keyCode === KeyCode.KEY_ENTER) {
                          this.isShowAbout = false;
                          // 确认键
                          console.log("跳转到修改设备名称页面");
                          router.pushUrl({
                            url: "pages/hotspot/DeviceName",
                            params: {
                            }
                          },router.RouterMode.Single)
                          this.pageTranState = true;
                          event.stopPropagation()
                        }
                      }
                      setTimeout(() => {
                        this.isProcess = false;
                      }, 100);
                    }
                  })
                Blank()
                Text(this.deviceName)
                  .height(lpx(98))
                  .fontColor(this.focusIndex == 1 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .fontSize(lpx(32))
                  .align(Alignment.Center)
                  .textAlign(TextAlign.Start)
                  .margin({
                    right: lpx(18)
                  })
                Image($r(Ratio.resName('icon_arrow_right')))
                  .rightArrowIcon()
                  .fillColor(this.focusIndex == 1 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .opacity(this.model.isEnable ? 1 : 0.25)
                  .visibility(this.model.arrowVisible)
              }
              .width(lpx(840))
              .height(lpx(98))
              .backgroundColor(this.focusIndex === 1 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
              .borderRadius(lpx(18))
              .onHover((isHover: boolean) => {
                this.focusIndex = 1;
                this.getFocusFun(this.focusIndex);
              })
              .onTouch((event:TouchEvent) => {
                this.focusIndex = 1;
                this.getFocusFun(this.focusIndex);
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
              })
              .onClick(()=>{
                this.isShowAbout = false;
                // 确认键
                console.log("跳转到修改设备名称页面");
                router.pushUrl({
                  url: "pages/hotspot/DeviceName",
                  params: {
                  }
                },router.RouterMode.Single)
                this.pageTranState = true;
              })
            }
            .padding(lpx(6))
            .border({
              width: lpx(2),
              color: this.focusIndex == 1 ? Color.White : Color.Transparent,
              radius: lpx(24),
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)
            .onAppear(() => {

            })
            .stateStyles({
              focused: {
                .border({
                  color: Color.White
                })
              }
            })

            Row() {
              Row() {
                Text("密码")
                  .hotspotItem()
                  .fontColor(this.focusIndex == 2 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .borderColor(Color.Transparent)
                  .onFocus(() => {
                    this.focusIndex = 2
                    console.log("密码获得焦点 this.focusIndex" + this.focusIndex)
                  })
                  .onBlur(() => {
                    console.log("密码失去焦点 this.focusIndex" + this.focusIndex)
                  })
                  .focusable(true)
                  .key("2")
                  .onKeyEvent((event: KeyEvent) => {
                    this.isProcess = true
                    if (event.type === KeyType.Down) {
                      console.log("event2")
                      if (this.focusIndex === 2) {
                        // toggle的按键事件
                        if (event.keyCode === KeyCode.KEY_DPAD_UP) {
                          // 向上键
                          this.focusIndex = 1
                          this.getFocusFun(this.focusIndex)
                        } else if (event.keyCode === KeyCode.KEY_DPAD_DOWN) {
                          // 向下键
                          this.focusIndex = 3
                          this.getFocusFun(this.focusIndex)
                        } else if (event.keyCode === KeyCode.KEY_ENTER){
                          this.isShowAbout = false;
                          console.log("进入修改热点密码页面");
                          // 确认键
                          router.pushUrl({
                            url: "pages/hotspot/HotspotPWD",
                            params: {
                            }
                          }, router.RouterMode.Single)
                          this.pageTranState = true;
                          event.stopPropagation()
                        }
                      }
                      setTimeout(() => {
                        this.isProcess = false;
                      }, 100);
                    }
                  })
                Blank()
                Text(this.hotspotPWD)
                  .height(lpx(98))
                  .fontColor(this.focusIndex == 2 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .fontSize(lpx(32))
                  .align(Alignment.Center)
                  .textAlign(TextAlign.Start)
                  .margin({
                    right: lpx(18)
                  })
                Image($r(Ratio.resName('icon_arrow_right')))
                  .fillColor(this.focusIndex == 2 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .opacity(this.model.isEnable ? 1 : 0.25)
                  .visibility(this.model.arrowVisible)
                  .rightArrowIcon()
              }
              .width(lpx(840))
              .height(lpx(98))
              .backgroundColor(this.focusIndex === 2 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
              .borderRadius(lpx(18))
              .onHover((isHover: boolean) => {
                this.focusIndex = 2;
                this.getFocusFun(this.focusIndex);
              })
              .onTouch((event:TouchEvent) => {
                this.focusIndex = 2;
                this.getFocusFun(this.focusIndex);
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
              })
              .onClick(() => {
                this.isShowAbout = false;
                console.log("进入修改热点密码页面");
                // 确认键
                router.pushUrl({
                  url: "pages/hotspot/HotspotPWD",
                  params: {
                  }
                }, router.RouterMode.Single)
                this.pageTranState = true;
              })
            }
            .padding(lpx(6))
            .border({
              width: lpx(2),
              color: this.focusIndex == 2 ? Color.White : Color.Transparent,
              radius: lpx(24),
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .focusable(true)

            Row() {
              Row() {
                Text("已连接设备")
                  .height(lpx(98))
                  .fontSize(lpx(36))
                  .align(Alignment.Center)
                  .textAlign(TextAlign.Start)
                  .margin({
                    left: lpx(24)
                  })
                  .focusable(true)
                  .borderColor(Color.Transparent)
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                  .hotspotItem()
                  .fontColor(this.focusIndex == 3 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .onFocus(() => {
                    this.focusIndex = 3
                    console.log("已连接设备获得焦点 this.focusIndex" + this.focusIndex)
                  })
                  .onBlur(() => {
                    console.log("已连接设备失去焦点 this.focusIndex" + this.focusIndex)
                  })
                  .focusable(true)
                  .key("3")
                  .onKeyEvent((event: KeyEvent) => {
                    this.isProcess = true
                    if (event.type === KeyType.Down) {
                      console.log("event4")
                      if (this.focusIndex === 3) {
                        // toggle的按键事件
                        if (event.keyCode === KeyCode.KEY_DPAD_UP) {
                          // 向上键
                          this.focusIndex = 2
                          this.getFocusFun(this.focusIndex)
                        } else if (event.keyCode === KeyCode.KEY_DPAD_DOWN) {
                          // 向下键
                          this.focusIndex = 4
                          this.getFocusFun(this.focusIndex)
                        } else if (event.keyCode === KeyCode.KEY_ENTER) {
                          this.isShowAbout = false;
                          console.log("已连接设备列表")
                          console.log("进入已连接设备列表")
                          // 确认键
                          router.pushUrl({
                            url: "pages/hotspot/ConnectedDeviceList",
                            params: {
                            }
                          }, router.RouterMode.Single)
                          this.pageTranState = true;
                          event.stopPropagation()
                        }
                      }
                      setTimeout(() => {
                        this.isProcess = false;
                      }, 100);
                    }

                  })
                Blank()
                Text(`${this.connectedDeviceNumber}台`)
                  .height(lpx(98))
                  .fontColor(this.focusIndex == 3 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .fontSize(lpx(32))
                  .align(Alignment.Center)
                  .textAlign(TextAlign.Start)
                  .margin({
                    right: lpx(18)
                  })
                Image($r(Ratio.resName('icon_arrow_right')))
                  .rightArrowIcon()
                  .fillColor(this.focusIndex === 3 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .opacity(this.model.isEnable ? 1 : 0.25)
                  .visibility(this.model.arrowVisible)
              }
              .width(lpx(840))
              .height(lpx(98))
              .backgroundColor(this.focusIndex === 3 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
              .borderRadius(lpx(18))
              .onHover((isHover: boolean) => {
                this.focusIndex = 3;
                this.getFocusFun(this.focusIndex)
              })
              .onTouch((event:TouchEvent) => {
                this.focusIndex = 3;
                this.getFocusFun(this.focusIndex)
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
              })
              .onClick(() => {
                this.isShowAbout = false;
                console.log("已连接设备列表")
                console.log("进入已连接设备列表")
                // 确认键
                router.pushUrl({
                  url: "pages/hotspot/ConnectedDeviceList",
                  params: {
                  }
                }, router.RouterMode.Single)
                this.pageTranState = true;
              })
            }
            .padding(lpx(6))
            .border({
              width: lpx(2),
              color: this.focusIndex == 3 ? Color.White : Color.Transparent,
              radius: lpx(24),
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)

            Row() {
              Row() {
                Text("AP频段")
                  .hotspotItem()
                  .fontColor(this.focusIndex == 4 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .onFocus(() => {
                    this.focusIndex = 4
                    console.log("AP频段获得焦点 this.focusIndex" + this.focusIndex)
                  })
                  .onBlur(() => {
                    console.log("AP频段失去焦点 this.focusIndex" + this.focusIndex)
                  })
                  .focusable(true)
                  .key("4")
                  .onKeyEvent((event: KeyEvent) => {
                    this.isProcess = true
                    if (event.type === KeyType.Down) {
                      console.log("event5")
                      if (this.focusIndex === 4) {
                        // toggle的按键事件
                        if (event.keyCode === KeyCode.KEY_DPAD_UP) {
                          // 向上键
                          this.focusIndex = 3
                          this.getFocusFun(this.focusIndex)
                        } else if (event.keyCode === KeyCode.KEY_DPAD_DOWN) {
                          // 向下键
                          this.focusIndex = 5
                          this.getFocusFun(this.focusIndex)
                        } else if (event.keyCode === KeyCode.KEY_ENTER) {
                          this.getFocusFun(this.focusIndex)
                          console.log("修改AP频段")
                          // 确认键
                          this.is5G = !this.is5G
                          let config =wifiManager.getHotspotConfig()
                          if(this.is5G){
                            config.band =2
                            config.channel = 36
                            try {
                              wifiManager.setHotspotConfig(config)
                              wifiManager.disableHotspot()
                              wifiManager.enableHotspot()
                              console.log("热点频段成功切换到5G")
                            }catch (e) {
                              console.log("热点频段切换到5G失败 error ",JSON.stringify(e))
                            }
                          }else {
                            config.band =1
                            config.channel = 1
                            try {
                              wifiManager.setHotspotConfig(config)
                              wifiManager.disableHotspot()
                              wifiManager.enableHotspot()
                              console.log("热点频段成功切换到2.4G")
                            }catch (e) {
                              console.log("热点频段切换到2.4G失败 error ",JSON.stringify(e))
                            }
                          }
                          event.stopPropagation()
                          this.pageTranState = true
                        }
                      }
                      setTimeout(() => {
                        this.isProcess = false;
                      }, 100);
                    }
                  })
                Blank()
                Image($r(Ratio.resName('icon_arrow_left')))
                  .fillColor(this.focusIndex === 4  ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .width(lpx(24))
                  .height(lpx(48))
                  .opacity(this.model.isEnable ? 1 : 0.25)
                  .objectFit(ImageFit.Fill)
                  .align(Alignment.Center)
                  .margin({ right: lpx(24) })
                  .focusable(false)
                  .visibility(this.model.arrowVisible)
                  .onClick(() => {
               this.getFocusFun(this.focusIndex)
               this.is5G =false
               let config =wifiManager.getHotspotConfig()
                 config.band =1
                 config.channel = 1
                 try {
                   wifiManager.setHotspotConfig(config)
                   console.log("热点频段成功切换到2.4G")
                 }catch (e) {
                   console.log("热点频段切换到2.4G失败 error ",JSON.stringify(e))
                 }
                })
                Text(this.is5G ? "5G" : "2.4G")
                  .height(lpx(98))
                  .fontColor(this.focusIndex == 4 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .fontSize(lpx(32))
                  .align(Alignment.Center)
                  .textAlign(TextAlign.Start)
                  .margin({
                    right: lpx(18)
                  })
                Image($r(Ratio.resName('icon_arrow_right')))
                  .rightArrowIcon()
                  .fillColor(this.focusIndex ==4 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .opacity(this.model.isEnable ? 1 : 0.25)
                  .focusable(false)
                  .onClick(() => {
                    this.getFocusFun(this.focusIndex)
                    this.is5G = true
                    let config =wifiManager.getHotspotConfig()
                      config.band =2
                      config.channel = 36
                      try {
                        wifiManager.setHotspotConfig(config)
                        console.log("热点频段成功切换到5G")
                      }catch (e) {
                        console.log("热点频段切换到5G失败 error ",JSON.stringify(e))
                      }
                  })
                  .visibility(this.model.arrowVisible)
              }
              .width(lpx(840))
              .height(lpx(98))
              .backgroundColor(this.focusIndex === 4 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
              .borderRadius(lpx(18))
              .onHover((isHover: boolean) => {
                this.focusIndex = 4;
                this.getFocusFun(this.focusIndex);
              })
              .onTouch(()=>{
                this.focusIndex = 4;
                this.getFocusFun(this.focusIndex);
              })
            }
            .padding(lpx(6))
            .border({
              width: lpx(2),
              color: this.focusIndex == 4 ? Color.White : Color.Transparent,
              radius: lpx(24),
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .focusable(true)

            Row() {
              Row() {
                Text("关于")
                  .hotspotItem()
                  .fontColor(this.focusIndex == 5 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .onFocus(() => {
                    this.focusIndex = 5
                    console.log("关于获得焦点 this.focusIndex" + this.focusIndex)
                  })
                  .onBlur(() => {
                    console.log("关于失去焦点 this.focusIndex" + this.focusIndex)
                  })
                  .focusable(true)
                  .key("5")
                  .onKeyEvent((event: KeyEvent) => {
                    this.isProcess = true
                    if (event.type === KeyType.Down) {
                      console.log("event6")
                      if (this.focusIndex === 5) {
                        // toggle的按键事件
                        if (event.keyCode === KeyCode.KEY_DPAD_UP) {
                          // 向上键
                          this.focusIndex = 4
                          this.getFocusFun(this.focusIndex)
                        } else if (event.keyCode === KeyCode.KEY_DPAD_DOWN) {
                          // 向下键
                          console.log("已经是最下面")
                        } else if (event.keyCode === KeyCode.KEY_ENTER) {
                          this.isShowAbout = !this.isShowAbout;
                          event.stopPropagation()
                        }
                      }
                    }
                    setTimeout(() => {
                      this.isProcess = false;
                    }, 100);
                  })
                Blank()
                Image($r(Ratio.resName('icon_arrow_right')))
                  .rightArrowIcon()
                  .fillColor(this.focusIndex == 5 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                  .opacity(this.model.isEnable ? 1 : 0.25)
                  .visibility(this.model.arrowVisible)
              }
              .width(lpx(840))
              .height(lpx(98))
              .backgroundColor(this.focusIndex === 5 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
              .borderRadius(lpx(18))
              .onHover((isHover: boolean) => {
                this.focusIndex = 5
                this.getFocusFun(this.focusIndex);
              })
              .onTouch((event:TouchEvent) => {
                this.focusIndex = 5
                this.getFocusFun(this.focusIndex);
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
              })
              .onClick(() => {
                // 确认键
                this.isShowAbout = !this.isShowAbout;
              })
            }
            .padding(lpx(6))
            .border({
              width: lpx(2),
              color: this.focusIndex == 5 ? Color.White : Color.Transparent,
              radius: lpx(24),
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
          }.alignItems(HorizontalAlign.Start)
          .visibility(this.isHotSpotEnabled ? Visibility.Visible : Visibility.Hidden)
        }
        .width(ConfigData.WH_100_100)
        .alignItems(HorizontalAlign.Start)
        .margin({
          bottom: lpx(178),
        })
        .height(ConfigData.WH_58_100)
      }
      .zIndex(1)
      .backgroundColor('rgb(24, 24, 26)')
      .alignItems(VerticalAlign.Top)
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
      .margin({ left: lpx(84) })
      .opacity(this.isShowAbout ? 0.5 : 1)
      .justifyContent(FlexAlign.SpaceAround)

      Column() {
        if (this.isHotSpotEnabled) {
          QRCode(this.shareHotspot)
            .color(Color.Black)
            .width(lpx(400))
            .height(lpx(400))
            .borderRadius(lpx(64))
            .focusable(false)
            .border({ color: Color.White, width: '12lpx', radius: '24lpx' })
        } else {
          Image($r('app.media.icon_hostpot'))
            .width(lpx(400))
            .height(lpx(400))
            .focusable(false)
        }
        Text(this.isHotSpotEnabled ? "扫一扫连接此热点" : '个人热点')
          .hotspotItem()
          .fontColor('rgba(255, 255, 255, 0.2)')
          .fontSize(lpx(36))
          .lineHeight(lpx(48))
          .textAlign(TextAlign.Start)
      }
      .zIndex(1)
      .width(lpx(400))
      .focusable(false)
      .margin({
        left: ConfigData.WH_50_100
      })

      Column() {
        Text("关于")
          .fontColor('rgba(255, 255, 255, 0.9)')
          .fontSize(lpx(48))
          .lineHeight(lpx(60))
          .textAlign(TextAlign.Start)
          .width(ConfigData.WH_100_100)
          .padding({
            top: lpx(32),
            left: lpx(12),
            bottom: lpx(16)
          })
          .width("100%")
          .textAlign(TextAlign.Center)
        Text("1、开启个人热点，可将移动网络或WLAN网络共享给其他设备。")
          .aboutContent()
        Text("2、共享移动网络会消耗数据流量，最多支持8个设备接入。")
          .aboutContent()
        Text("3、连接WLAN时不消耗数据流量，最多支持8个设备接入。")
          .aboutContent()
        Text("4、开启个人热点，会消耗更多电量。")
          .aboutContent()
        Text("5、如遇设备无法接入共享网络，可以尝试将更多共享设置中AP频段设置为2.4GHz以获得更好兼容性。")
          .aboutContent()
      }
      .zIndex(2)
      .alignItems(HorizontalAlign.Start)
      .width(ConfigData.WH_40_100)
      .height(ConfigData.WH_70_100)
      .padding(lpx(6))
      .border({
        width: lpx(2),
        color: Color.Transparent,
        radius: lpx(48),
        style: BorderStyle.Solid
      })
      .defaultFocus(this.isShowAbout ? true : false)
      .focusable(true)
      .key('6')
      .onFocus(() => {
        this.focusIndex = 6;
        console.log("关于页面获得了焦点" + this.isShowAbout)
      })
      .onBlur(()=> {
        this.focusIndex = 5;
      })
      .onTouch((event:TouchEvent) => {
        this.focusIndex = 6;
        this.getFocusFun(this.focusIndex);
        if (!EventUtil.isTouchEvent(event)) {
          return;
        }
      })
      .onHover((isHover: boolean) => {
        this.focusIndex = 6;
        this.getFocusFun(this.focusIndex);
      })
      .onClick(() => {
        this.isShowAbout = false;
      })
      .backgroundColor("#3c3c3c")
      .visibility(this.isShowAbout ? Visibility.Visible : Visibility.Hidden)
    }
    .backgroundColor
    ('rgb(24, 24, 26)'
    )
    .alignContent
    (Alignment
      .Center
    )
    .width
    (ConfigData
      .WH_100_100
    )
    .height
    (ConfigData
      .WH_100_100
    )
  }
}
