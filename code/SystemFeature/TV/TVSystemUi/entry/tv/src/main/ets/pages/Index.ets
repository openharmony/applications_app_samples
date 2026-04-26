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
 

import { i18n } from '@kit.LocalizationKit';
import { BusinessError, commonEventManager, deviceInfo, emitter } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { inputEventClient } from '@kit.InputKit';
import { KeyCode } from '@kit.InputKit';
import { BrightnessDialog } from '../components/Brightness';
import { wifiManager } from '@kit.ConnectivityKit';
import { promptAction } from '@kit.ArkUI';
import Log from '@ohos/common/src/main/ets/default/Log';
import { ethernet } from '@kit.NetworkKit';
import { EventUtil } from '../utils/EventUtil';
import ServiceExtAbility from '../ServiceExtAbility/ServiceExtAbility';
import { Duration } from '../utils/Duration';

class MenuItem  {
  public name: string = ''
}

class KeyEventWrapper {
  public keyEvent: inputEventClient.KeyEvent | null = null
}

const bundleName:string = 'com.ohos.systemui'
const TAG = 'SystemUI_Entry-Index'
const SHARE_BUNDLENAME = 'com.ohos.oneconnect.share'
const SHARE_ABILITYNAME = 'ServiceExtAbility'
const  sourceToolMouseClick: number = 7
@Entry
@Component
struct Index {
  private scroller: ListScroller = new ListScroller()
  controller: TextClockController = new TextClockController() // 文本时钟控制器
  // 亮度对话框
  mBrightnessDialog: CustomDialogController = new CustomDialogController({
    // 自定义弹窗内容构造器。
    builder: BrightnessDialog({
      isShowBrightness: $isShowBrightness
    }),
    alignment: DialogAlignment.CenterStart, // 弹窗在竖直方向上的对齐方式为靠左上下居中。
    isModal: false, // 弹窗是否为模态窗口，模态窗口有蒙层，非模态窗口无蒙层。
    customStyle: true, // 弹窗容器样式是否自定义。
  })
  @State isShow: boolean = true // 控制中心是否显示
  @State wifiIsOn: boolean = true // wifi开关是否打开
  // @State miraCastIsOn: boolean = false // 投屏开关是否打开
  @State bleIsOn: boolean = true // 蓝牙开关是否打开
  @State isShowBrightness: boolean = false // 亮度条是否显示
  @State hasClickTab: boolean = false // tab点击是否执行过
  @State accumulateTime: number = 0 // 当前时间
  @State focusIndex: number = 0 //聚焦的索引
  @State wifiName: string = '' //wifi名称
  @State timerId: number | null = null // 定时器
  @State timeFormat: string = ''
  @State enableEthernet: boolean = true;
  @State scanTaskId: number = -1;
  @State isShareOn: boolean = false
  @StorageLink('isFloatWindowBlur')  isFloatWindowBlur: boolean = false;
  // 菜单项数组
  @State menuArray: MenuItem [] = [
    { name: '设置' },
    { name: 'WIFI' },
    { name: '蓝牙' },
    { name: '输入源' },
    { name: '亮度' },
    { name: '截屏' },
    { name: '录制' },
    { name: '清晰度与流畅度' }
  ]
  context = getContext() as common.UIAbilityContext

  onBackPress(): boolean | void {
    console.log(TAG, 'onBackPress');
    emitter.emit('CONTROLLER_CENTER_EVENT');
    return true;
  }

  async onPageShow(): Promise<void> {
    this.getActiveIface();
    this.getTimeFormat()
    this.wifiName = ''
    this.isShow = true
    if (!this.hasClickTab) {
      setTimeout(() => {
        this.hasClickTab = true
        this.tabClick()
      }, 500)
    }

    this.scanTaskId = setInterval(async () => {
      this.getActiveIface();
    }, 500);

    if(this.isFloatWindowBlur){
      console.log('hsq00120','执行了2')
      this.menuArray.push({ name: '进入操作悬浮窗'})
    }else{
      this.menuArray = this.menuArray.filter(item => item.name !== '进入操作悬浮窗');
    }
  }

  onPageHide(): void {
    this.wifiName = ''
    if (this.mBrightnessDialog) {
      this.isShowBrightness = false
      this.mBrightnessDialog.close()
    }
    clearInterval(this.scanTaskId);
  }

  async getSid() {
    try {
      const res: wifiManager.WifiLinkedInfo = await wifiManager.getLinkedInfo()
      this.wifiName = res!.ssid && res!.ssid.includes('unknown ssid') ? '未连接' : res!.ssid
    } catch (e) {
      this.wifiName = ''
    }
  }

  aboutToAppear(): void {
    this.wifiName = ''
    console.log('deviceInfo.productModel=='+JSON.stringify(deviceInfo.productModel))
    if (deviceInfo.productModel == 'Hi3751V352'){
      this.menuArray = [
        { name: '设置' },
        { name: 'WIFI' },
        { name: '蓝牙' },
        { name: '输入源' },
        { name: '亮度' },
        { name: '截屏' },
          ]
    } else if (deviceInfo.productModel == 'gk6320v100crb_b_vb') {
      this.menuArray = [
        { name: '设置' },
        { name: 'WIFI' },
        { name: '蓝牙' },
        { name: '亮度' },
        { name: '截屏' },
        { name: '录制' },
      ]
    }
    
    // 接收亮度组件通知关闭亮度条
    emitter.on('BRIGHTNESS_DIALOG_TIMER_EVENT', () => {
      if (this.mBrightnessDialog) {
        this.isShowBrightness = false
        this.mBrightnessDialog.close()
      }
    })

    // 启动文本时钟
    this.controller.start()
  }

  // 控制中心窗口打开后，需要手动按下tab键激活焦点，此方法可以模拟手动按tab键的操作
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
    let eventDown: KeyEventWrapper = { keyEvent: keyDownOpt };
    let eventUp: KeyEventWrapper = { keyEvent: keyUpOpt };

    try {
      // 触发tab点击，使默认焦点组件多态样式生效
      inputEventClient.injectEvent({ KeyEvent: eventDown.keyEvent });
      inputEventClient.injectEvent({ KeyEvent: eventUp.keyEvent });
    } catch (e) {
      Log.showInfo(TAG, `手动触发tab点击失败 ${e}`)
    }
  }

  getTimeFormat() {
    let is24HourClock: boolean = i18n.System.is24HourClock()
    Log.showInfo(TAG, `获取小时制 is24HourClock：${is24HourClock}`)
    if (is24HourClock) {
      this.timeFormat = 'HH:mm'
    } else {
      this.timeFormat = 'aa hh:mm'
    }
  }

  getActiveIface() {
    ethernet.getAllActiveIfaces().then((activity: string[]) => {
      Log.showInfo(TAG, 'getAllActiveIfaces promise data.length = ' + JSON.stringify(activity.length));
      if (activity.length === 0) {
        //(无线)
        this.enableEthernet = true
        this.getSid();
      } else {
        //(有线)
        this.enableEthernet = false
        this.wifiName = ''
      }
    }).catch((error: BusinessError) => {
      this.enableEthernet = false
      this.wifiName = ''
      Log.showInfo(TAG, 'getAllActiveIfaces promise error = ' + JSON.stringify(error));
    });
  }

  // 菜单项点击事件
  clickMenuItem(item: MenuItem ) {
    switch (item.name) {
      case '设置': {
        // 拉起设置应用
        this.context.startAbility({
          bundleName: 'com.ohos.settings',
          abilityName: 'com.ohos.settings.MainAbility'
        }).then(() => {
          // 设置拉起后发送通知关闭控制中心窗口
          emitter.emit('CONTROLLER_CENTER_EVENT');
        }).catch((e: string) => {
          Log.showInfo(TAG, `${item.name}拉起失败 ${e}`)
        })
        break;
      }
      case 'WIFI': {
        if (this.enableEthernet) {
          this.context.startAbility({
            bundleName: 'com.ohos.settings',
            abilityName: 'com.ohos.settings.MainAbility',
            parameters: {
              pageUrl: 'WIFI'
            },
          }).then(() => {
            emitter.emit('CONTROLLER_CENTER_EVENT');
          }).catch((e: string) => {
            Log.showInfo(TAG, `${item.name}拉起失败 ${e}`)
          })
        } else {
          promptAction.showToast({
            message: $r('app.string.wifinotAvailable'),
            duration: 2000,
          });
        }
        break;
      }
      case '蓝牙': {
        this.context.startAbility({
          bundleName: 'com.ohos.settings',
          abilityName: 'com.ohos.settings.MainAbility',
          parameters: {
            pageUrl: 'BLUETOOTH'
          },
        }).then(() => {
          emitter.emit('CONTROLLER_CENTER_EVENT');
        }).catch((e: string) => {
          Log.showInfo(TAG, `${item.name}拉起失败 ${e}`)
        })
        break;
      }
      case '截屏': {
        // 拉起截屏应用
        this.context.startAbility({
          bundleName: 'com.ohos.screenshot',
          abilityName: 'com.ohos.screenshot.ServiceExtAbility'
        }).then(() => {
          this.isShow = false;
          this.hasClickTab = false
          setTimeout(() => {
            // 截屏拉起后发通知关闭控制中心窗口
            emitter.emit('CONTROLLER_CENTER_EVENT');
          }, 1000)
        }).catch((e: string) => {
          Log.showInfo(TAG, `${item.name}拉起失败 ${e}`)
        })
        break;
      }
      case '录制': {
        // 拉起录制应用
        this.context.startAbility({
          bundleName: 'ohos.samples.screenrecorder',
          abilityName: 'ScreenRecorderAbility'
        }).then(() => {
          // 录制拉起成功后发通知关闭控制中心窗口
          emitter.emit('CONTROLLER_CENTER_EVENT');
        }).catch((e: string) => {
          Log.showInfo(TAG, `${item.name}拉起失败 ${e}`)
        })
        break;
      }
      case '输入源': {
        // 拉起输入源应用
        this.context.startAbility({
          bundleName: 'com.ohos.inputsource',
          abilityName: 'EntryAbility',
          parameters:
          {
            pullBundleName: AppStorage.get('bundleName')
          }
        }).then(() => {
          // 输入源拉起成功后发通知关闭控制中心窗口
          emitter.emit('CONTROLLER_CENTER_EVENT');
        }).catch((e: string) => {
          Log.showInfo(TAG, `${item.name}拉起失败 ${e}`)
        })
        break;
      }
      case '亮度': {
        // 打开亮度条
        this.isShowBrightness = true
        this.mBrightnessDialog.open()
        // 将控制中心菜单项隐藏
        this.isShow = false
        this.hasClickTab = false
        break;
      }
      case '统一互联分享':
        if (this.isShareOn) {
          Log.showInfo(TAG,`before disableShare`)
          try {
            this.isShareOn = false
            this.killOneConnect()
          } catch (err) {
            Log.showError(TAG,`enableShare err: ${err}, ${JSON.stringify(err)}`)
          }
        } else {
          Log.showInfo(TAG,`before enableShare`)
          try {
            this.isShareOn = true
            this.startOneConnect()
          } catch (err) {
            Log.showError(TAG,`enableShare err: ${err}, ${JSON.stringify(err)}`)
          }
        }

      case '进入操作悬浮窗':{
        try {
          // 公共事件相关信息，以发布有序公共事件为例
          let options: commonEventManager.CommonEventPublishData = {
            parameters: { isFloatWindowFocusReturn: true }
          }
          commonEventManager.publish('isFloatWindowFocusReturn', options, (err: BusinessError) => {
            if (err) {
              console.error('update-->',
                `Failed to publish common event. Code is ${err.code}, message is ${err.message}`);
              return;
            }
            this.isFloatWindowBlur=false
            console.log('update-->', `Succeeded in publishing common event.`);
          });
        } catch (error) {
          console.error('update-->', `Failed to publish common event：` + JSON.stringify(error));
        }
      }
      case '清晰度与流畅度':{
        try {
          this.getUIContext()?.getRouter().pushUrl({ url: 'pages/ClaritySetting' })
        }catch (e) {
          console.debug('清晰度与流畅度',JSON.stringify(e))
        }
      }
      default: {
        break;
      }
    }
    this.getUIContext()?.getFocusController().activate(true)
  }

  startOneConnect(){
    let startWant:Want = {
      bundleName:SHARE_BUNDLENAME,
      abilityName:SHARE_ABILITYNAME,
      parameters:{
        stopFlag: '0'
      }
    }
    this.context.startAbilityForResult(startWant, (err: BusinessError, result: common.AbilityResult) => {
      if (err.code) {
        // 处理业务逻辑错误
        console.error(`startAbilityForResult failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      // 执行正常业务
      console.info('startAbilityForResult succeed');
    });
  }

  killOneConnect(){
    let stopWant:Want = {
      bundleName:SHARE_BUNDLENAME,
      abilityName:SHARE_ABILITYNAME,
      parameters:{
        stopFlag: '1'
      }
    }
    this.context.startAbilityForResult(stopWant, (err: BusinessError, result: common.AbilityResult) => {
      if (err.code) {
        // 处理业务逻辑错误
        console.error(`startAbilityForResult failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      // 执行正常业务
      console.info('startAbilityForResult succeed');
    });
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  build() {
    Row() {
      Column() {}
      .backgroundColor(Color.Transparent)
      .width('66%')
      .height('100%')
      .focusable(false)
      .onClick(() => {
        // 设置拉起后发送通知关闭控制中心窗口
        emitter.emit('CONTROLLER_CENTER_EVENT');
      })
      Column({ space: '48lpx' }) {
        Row() {
          // 以12小时制显示东八区的系统时间，精确到月日星期
          TextClock({ timeZoneOffset: -8, controller: this.controller })
            .format('M月d日  EEEE')
            .onDateChange((value: number) => {
              this.accumulateTime = value
            })
            .fontSize('36lpx')
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
          // 以12小时制显示东八区的系统时间，精确到时分
          TextClock({ timeZoneOffset: -8, controller: this.controller })
            .format(this.timeFormat)
            .fontSize('36lpx')
            .fontWeight(FontWeight.Medium)
            .onDateChange((value: number) => {
              this.accumulateTime = value
            })
            .fontColor('#FFFFFF')
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .padding(5)
        .width('100%')

        List({ space: '24lpx', scroller: this.scroller }) {
          ForEach(this.menuArray, (item: MenuItem , index: number) => {
            ListItem() {
              Row() {
                Text(item.name)
                  .fontSize('30lpx')
                  .fontColor(this.focusIndex === index ? '#000000' : '#FFFFFF')
                  .fontWeight(FontWeight.Medium)
                  .focusable(true)
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                Row() {
                  if (item.name === 'WIFI') {
                    Text(this.wifiName || '未连接')
                      .fontSize('25lpx')
                      .fontColor(this.focusIndex === index ? '#000000' : '#FFFFFF')
                      .fontWeight(FontWeight.Medium)
                      .textOverflow({ overflow: TextOverflow.MARQUEE })
                      .width('200lpx')
                      .textAlign(TextAlign.End)
                  } else if (item.name === '统一互联分享') {
                    Toggle({type:ToggleType.Switch,isOn:this.isShareOn})
                      .width('65lpx')
                      .height('36lpx')
                      .focusable(false)
                      .margin({
                        top: '0lpx',
                        right: '0lpx',
                        bottom: '0lpx',
                        left: '0lpx'
                      })
                  }
                  if (!['截屏', '录制', '亮度', '统一互联分享'].includes(item.name)) {
                    Image(this.focusIndex === index ? $r('app.media.chevron_right_black') :
                    $r('app.media.chevron_right_white'))
                      .width('24lpx')
                      .height('36lpx')
                      .margin({ left: '12lpx' })
                      .focusable(false)
                  }
                }

              }
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .padding('24lpx')
              .backgroundColor(this.focusIndex === index ? '#FFFFFF' : '#20FFFFFF')
              .borderRadius('18lpx')
              .width('100%')
            }
            .onClick(()=>{
              focusControl.requestFocus(item.name)
              setTimeout(() => {
                this.clickMenuItem(item)
              }, 100)
            })
            .backgroundColor(this.focusIndex === index ? '#333333' : Color.Transparent)
            .border({ width: '2lpx', radius: '24lpx', color: this.focusIndex === index ? '#FFFFFF' : Color.Transparent })
            .padding('4lpx')
            .onFocus(() => {
              this.focusIndex = index
              this.scroller.scrollToIndex(index, false)
            })
            .onHover(() => {
              this.focusIndex = index
              this.scroller.scrollToIndex(index, false)
            })
            .key(item.name)
          },
            (item: MenuItem , index: number) => item.name + index.toString())
        }
        .width('100%')
        .scrollBar(BarState.Off)
        .constraintSize({ maxHeight: '85%' })
      }
      .backgroundColor('#000000')
      .borderRadius({ topLeft: '16lpx', bottomLeft: '16lpx' })
      .opacity(0.85)
      .padding('48lpx')
      .width('33.33%')
      .height('100%')
      .visibility(this.isShow ? Visibility.Visible : Visibility.Hidden)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.End)
    .backgroundColor(Color.Transparent)
    .width('100%')
    .height('100%')
  }
}