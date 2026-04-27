/**
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

import iEventPublisher from '../model/EventPublisher';
import lazy { http } from '@kit.NetworkKit';
import { common } from '@kit.AbilityKit';
import lazy { OpenLinkOptions } from '@kit.AbilityKit';
import { settings } from '@kit.BasicServicesKit';
import { GET_RESOURSE_TIME, GET_RESOURSE_TIME_INTERVAL } from '../../common/baseUtil/storage';
import { inputConsumer } from '@kit.InputKit';
import lazy { KeyCode } from '@kit.InputKit';
import { AppItemInfo } from '../../common/bean/AppItemInfo';
import { LengthMetrics } from '@kit.ArkUI';

const TAG = "DesktopImmersiveLayout";
const TRUE = "1"
const FALSE = "0"
const FUNUI_SWITCH = "settings.funui.enable"
const DELAY_SECONDS = 2000
const SETTINGS_DELAY_SECONDS = 5000
export class DataItem {
  id: number;
  name: string;
  aword: string;
  poster: string;
  still: string;
  bg_img: string;
  link: string;

  constructor(id: number, name: string, aword: string, poster: string, still: string, bg_img: string,link: string) {
    this.id = id;
    this.name = name;
    this.aword = aword;
    this.poster = poster;
    this.still = still;
    this.bg_img = bg_img;
    this.link = link;
  }
}

export function registerInputConsumer(keyCode: number, callback: () => void): void {
  let onKeyCode: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: keyCode,
    finalKeyDownDuration: 0,
    isFinalKeyDown: true
  }
  inputConsumer.on('key', onKeyCode, () => {
    callback && callback()
    console.log(TAG, 'inputConsumer keyEvent start');
  });
}

export function unregisterInputConsumer(keyCode: number): void {
  let onKeyCode: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: keyCode,
    finalKeyDownDuration: 0,
    isFinalKeyDown: true
  }
  inputConsumer.off('key', onKeyCode);
}

@Component
export struct DesktopImmersiveLayout {
  appDefaultImg: Map<string, string> = new Map();
  @State appName: string = "";
  @State currentImageIndex: number = 0; // 当前显示的图片索引
  private timerId: number | undefined = undefined; // 定时器ID
  private timer: number = -1; // 延时器ID
  @State funshionData: DataItem[] = [];
  @State imageOpacity: number = 1; // 图片透明度
  @State removeFocused: boolean = false;
  @State bgImgName:string = ""; //背景图片名
  @State bgScale:number = 1; //背景图片缩放比例
  outTime:number = 0 //背景淡出动画时长
  inTime:number = 800 //背景淡入动画时长
  private getTimerId: number = -1;
  private getTimer: number = -1;
  @StorageProp('network_ok') @Watch('networkFluctuations') isNetworkStateOk: boolean = false
  @State isFetching: boolean = false;
  animationDuration: number = 400
  lastFocus:string = ''
  isTrimApp: string = FALSE
  @State
  app:AppItemInfo | undefined= undefined


  aboutToAppear() {
    setTimeout(()=>{
      this.initIsTrimApp()
    },SETTINGS_DELAY_SECONDS)
    //输入源、视频播放器、FUNUI影视、设置、图库、相机、音乐、全部应用
    this.appDefaultImg = new Map<string, string>([
      ["com.ohos.inputsource", "/common/pics/dtvdefault.png"],
      ["com.ohos.demandplayer", "/common/pics/videoPlayerdefault.png"],
      ["com.funshion.launcher", "/common/pics/funshiondefault.png"],
      ["com.ohos.settings", "/common/pics/settingsdefault.png"],
      ["com.samples.album", "/common/pics/picViewdefault.png"],
      ["com.samples.camera", "/common/pics/cameradefault.png"],
      ["ohos.samples.distributedmusicplayer", "/common/pics/musicdefault.png"],
      ["com.ohos.applicationmanager", "/common/pics/appsdefault.png"],
      ["ohos.samples.browser1", "/common/pics/browserdefault.png"],
      ["tv.fun.appstore", "/common/pics/funstoredefault.png"],
      ["com.ohos.file.manager", "/common/pics/filemanagerdefault.png"],
      ["com.huawei.ohos.connect", "/common/pics/connectdefault.png"],
      ["com.laval.betaclub", "/common/pics/betaclubdefault.png"],
      ["com.ohos.aiface", "/common/pics/aidefault.png"]
    ]);

    iEventPublisher.on("APP_CHANGE", (appItem: AppItemInfo) => {
      if (this.lastFocus == appItem.bundleName){
        return
      }
      console.log(TAG, 'APP_CHANGE + ' + JSON.stringify(appItem))
      this.app = appItem
      this.lastFocus = appItem.bundleName!
      this.bgImgName = appItem.appName!
      this.appName = appItem.appName!
      if (this.bgImgName === "FUNUI影视" && this.isTrimApp == TRUE) {
        this.timer = setTimeout(() => {
          this.startImageRotation()
        }, GET_RESOURSE_TIME)
      } else {
        if (this.isTrimApp == TRUE) {
          clearTimeout(this.timer)
          this.stopImageRotation()
        }
        animateTo({
          duration: this.outTime, // 淡出动画时长
          curve: Curve.Ease,
          onFinish: () => {
            animateTo({
              duration: this.inTime, // 淡入动画时长
              curve: Curve.EaseInOut
            }, () => {
              this.imageOpacity = 1;
              this.bgScale = 1;
            });
          }
        }, () => {
          this.imageOpacity = 0;
          this.bgScale = 1.1;
        });
      }
    })
  }

  aboutToDisappear(): void {
    if (this.isTrimApp == TRUE) {
      clearInterval(this.getTimer)
      clearInterval(this.getTimerId)
    }
  }

  initIsTrimApp(){
    try {
      let switchVal = settings.getValueSync(getContext(), FUNUI_SWITCH, '', settings.domainName.DEVICE_SHARED)
      if (switchVal != ""){
        if (switchVal == TRUE) {
          this.isTrimApp = TRUE
          this.getFunUIResource()
        }else if (switchVal == FALSE){
          this.isTrimApp = FALSE
        }
        this.observerFunUISwitch()
        return
      }
      settings.setValueSync(getContext(),FUNUI_SWITCH, TRUE, settings.domainName.DEVICE_SHARED)
      this.isTrimApp = TRUE
      this.getFunUIResource()
      this.observerFunUISwitch()
    } catch (e) {
      console.log(TAG, `getTrimApp err, ${e}`);
    }
  }

  onFunUISwitchChange(){
    this.isTrimApp = settings.getValueSync(getContext(this),FUNUI_SWITCH,settings.domainName.DEVICE_SHARED)
    if (this.isTrimApp == TRUE) {
      this.getFunUIResource()
    }else if (this.isTrimApp == FALSE){
      this.funshionData = []
    }
  }

  observerFunUISwitch(){
    let res = settings.registerKeyObserver(getContext(this),FUNUI_SWITCH,settings.domainName.DEVICE_SHARED,()=>{
      this.onFunUISwitchChange()
    })
    if (!res) {
      setTimeout(()=>{
        this.observerFunUISwitch()
      },DELAY_SECONDS)
    }
  }

  getFunUIResource(){
    this.getTimerId = setInterval(() => {
      if (this.isNetworkStateOk) {
        if (!this.isFetching) { // 检查是否正在请求
          this.isFetching = true; // 设置为正在请求
          this.getResourse('https://openapi-tv.funshion.com/v2/ohos/launcher/rec', () => {
            if (this.funshionData.length > 0) {
              clearInterval(this.getTimerId);
              this.getTimer = setInterval(() => {
                if (!this.isFetching) { // 检查是否正在请求
                  this.isFetching = true; // 设置为正在请求
                  this.getResourse('https://openapi-tv.funshion.com/v2/ohos/launcher/rec').finally(() => {
                    this.isFetching = false; // 请求完成，设置为未请求
                  });
                }
              }, GET_RESOURSE_TIME_INTERVAL);
            }
            this.isFetching = false; // 请求完成，设置为未请求
          });
        }
      }
    }, GET_RESOURSE_TIME)
  }

  networkFluctuations() {
    if (this.isNetworkStateOk) {
      this.startImageRotation()
    } else {
      this.stopImageRotation()
    }
  }

  async getResourse(url: string, callback?: () => void) {
    // 创建 HTTP 请求对象
    const httpRequest = http.createHttp();
    console.log(TAG, 'httpRequest createHttp success')
    try {
      // 发起 GET 请求
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.STRING,
      });

      // 检查请求是否成功
      if (response.responseCode === http.ResponseCode.OK) {
        // 获取图片的二进制数据
        const result = response.result as string
        console.log(TAG, 'resourse data:' + result)
        let data = JSON.parse(result) as Record<string, object | string>
        if (data.retCode as string !== "200") {
          return
        }

        this.funshionData = data.data as DataItem[]
        callback && callback()
        console.log(TAG, 'resourse funshionData:' + JSON.stringify(this.funshionData))

      } else {
        throw new Error(`Failed to fetch image: HTTP ${response.responseCode}`);
      }
    } catch (error) {
      console.error('Error fetching image:', JSON.stringify(error));
    } finally {
      // 销毁 HTTP 请求对象
      httpRequest.destroy();
      this.isFetching = false
      console.log(TAG, 'httpRequest destroy success')
    }
  }

  startImageRotation() {
    if (this.funshionData.length > 0 && !this.timerId && this.bgImgName === "FUNUI影视" && this.isNetworkStateOk) {
      this.timerId = setInterval(() => {
        this.animationEffects(() => {
          this.currentImageIndex = (this.currentImageIndex + 1) % this.funshionData.length
        })
        console.log(TAG, 'currentImageIndex:' + this.currentImageIndex)
        console.log(TAG, 'currentImageIndex -- funshionData:' + JSON.stringify(this.funshionData))
      }, GET_RESOURSE_TIME); // 每4秒切换一次图片
    }
  }

  stopImageRotation() {
    if (this.timerId !== null && this.timerId !== undefined) {
      clearInterval(this.timerId);
      this.timerId = undefined;
    }
  }

  animationEffects(callback?: () => void) {
    animateTo({
      duration: this.animationDuration, // 淡出动画时长
      curve: Curve.EaseInOut,
      onFinish: () => {
        callback && callback()
        animateTo({
          duration: this.animationDuration, // 淡入动画时长
          curve: Curve.EaseInOut
        }, () => {
          this.imageOpacity = 1;
        });
      }
    }, () => {
      this.imageOpacity = 0;
    })
  }

  openLink(url: string) {
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    let link: string = url
    let openLinkOptions: OpenLinkOptions = {
      appLinkingOnly: false
    };
    console.info(TAG, "open link str link:" + link);
    try {
      context.openLink(link, openLinkOptions).then(() => {
        console.info(TAG, "open link success.");
      }).catch(() => {
      });
    } catch (paramError) {
      console.info(TAG, "openLink error:" + JSON.stringify(paramError));
    }
  }

  build() {
    Column() {
      Column({ space: 10 }) {
        Column() {
          Text(this.appName)
            .fontSize('72lpx')
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.font_color_white'))

          if (this.appName === "FUNUI影视" && this.isNetworkStateOk) {
            Text(this.funshionData.length > 0 ? this.funshionData[this.currentImageIndex].name : '')
              .fontSize(36 + 'lpx')
              .fontWeight(FontWeight.Regular)
              .fontColor($r('app.color.font_color_white'))
              .width('38%')
              .margin({ top: 24 + 'lpx' , bottom: 24 + 'lpx'})

            Text(this.funshionData.length > 0 ? this.funshionData[this.currentImageIndex].aword : '')
              .fontSize(24 + 'lpx')
              .fontWeight(FontWeight.Regular)
              .fontColor($r('app.color.font_color_white'))
              .width('38%')
          }
        }
        .position({ x: '3%', y: '15%' })
        .zIndex(2)
        .focusable(false)
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)

        Image((this.funshionData.length > 0 && this.bgImgName === "FUNUI影视" && this.isNetworkStateOk) ?
        this.funshionData[this.currentImageIndex].bg_img :
          this.appDefaultImg.get(this.app?.bundleName) ?? "/common/pics/appsdefault.png")  // 没有海报的应用使用全部应用的海报
          .focusable(false)
          .position({ x: 0, y: 0 })
          .objectFit(ImageFit.Fill)
          .size({
            width: "100%",
            height: "100%"
          })
          .scale({
            x: this.bgScale,
            y: this.bgScale,
            centerX: "50%",
            centerY: "50%"
          })

        // 渐变遮罩层
        if (this.bgImgName === "FUNUI影视"){
          if (this.funshionData.length > 0  && this.isNetworkStateOk){
            Row() {
              Button('立即播放')
                .width(210 + 'lpx')
                .height(56 + 'lpx')
                .fontSize(28 + 'lpx')
                .fontWeight(FontWeight.Medium)
                .fontColor(this.removeFocused ? $r('app.color.font_color_black') : $r('app.color.font_color_white'))
                .backgroundColor(this.removeFocused ? $r('app.color.default_white') : $r('app.color.background_color_gray'))
                .zIndex(2)
                .borderRadius(78 + 'lpx')
                .focusable((this.appName === "FUNUI影视" && this.funshionData.length > 0 && this.isNetworkStateOk))
                .focusBox({
                  strokeWidth: LengthMetrics.px(0)
                })
                .id('play_btn')
            }

            .position({ x: '3%', y: '47%' })
            .zIndex(2)
            .focusable((this.appName === "FUNUI影视" && this.funshionData.length > 0 && this.isNetworkStateOk))
            .border(this.removeFocused ? {
              width: 2 + 'lpx',
              color: $r('app.color.default_white'),
              radius: 40
            } : null)
            .width(220 + 'lpx')
            .height(66 + 'lpx')
            .justifyContent(FlexAlign.Center)
            .onFocus(() => {
              this.removeFocused = true;
              this.stopImageRotation()
              registerInputConsumer(KeyCode.KEYCODE_DPAD_LEFT, () => {
                this.animationEffects(() => {
                  this.currentImageIndex = (this.currentImageIndex - 1 + this.funshionData.length) % this.funshionData.length
                })
              })
              registerInputConsumer(KeyCode.KEYCODE_DPAD_RIGHT, () => {
                this.animationEffects(() => {
                  this.currentImageIndex = (this.currentImageIndex + 1) % this.funshionData.length;
                })
              })
            })
            .onBlur(() => {
              this.removeFocused = false;
              this.startImageRotation()
              unregisterInputConsumer(KeyCode.KEYCODE_DPAD_LEFT)
              unregisterInputConsumer(KeyCode.KEYCODE_DPAD_RIGHT)
            })
            .onClick(() => {
              focusControl.requestFocus('play_btn')
              this.openLink(this.funshionData.length > 0 ? this.funshionData[this.currentImageIndex].link : '')
            })
            .onHover((isHover: boolean) => {
              if (isHover) {
                focusControl.requestFocus('play_btn')
                this.removeFocused = true;
                this.stopImageRotation()
              } else {
                this.removeFocused = false;
                this.startImageRotation()
              }
            })

            Row() {
              ForEach(this.funshionData, (item: DataItem, index: number) => {
                Row(){}
                .width(this.currentImageIndex === index ? 14 + 'lpx' : 10 + 'lpx')
                .height(this.currentImageIndex === index ? 14 + 'lpx' : 10 + 'lpx')
                .backgroundColor(this.currentImageIndex === index ? $r('app.color.default_white') : $r('app.color.default_Gray') )
                .borderRadius('50%')
                .margin({ right: 12 + 'lpx' })
                .animation({
                  curve: Curve.Ease,
                })
              })
            }
            .justifyContent(FlexAlign.Center)
            .position({ x: 0, y: '65%' })
            .width('100%')
            .zIndex(2)

          }

          Row()
            .position({ x: 0, y: 0 })
            .size({ width: '40%', height: '100%' })
            .linearGradient({
              direction: GradientDirection.Right,
              colors: [['#cc000000', 0.0], ['#aa000000', 0.6], ['#00000000', 1.0]]
            })
            .zIndex(1)
        }
      }
      .width('100%')
      .height('100%')
    }
  }

}