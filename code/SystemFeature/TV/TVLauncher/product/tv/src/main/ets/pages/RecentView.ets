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

import { windowManager } from '@ohos/common/src/main/ets/default/manager/WindowManager';
import { appManager, common, launcherBundleManager, missionManager } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';
import { inputEventClient, KeyCode } from '@kit.InputKit';
import { LengthMetrics } from '@kit.ArkUI';
import { EventUtil } from '../common/utils/EventUtil';
import lazy { BusinessError,emitter } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';

const TAG = 'RecentView';
const TAG_ITEM = TAG + "_ITEM";

const RATIO: number = globalThis.screenWidth / globalThis.screenHeight
const MOVEUP_TRANSLATE_Y: number = -1000
const MOVEUP_DURATION = 500
const GET_MISSIONS_NUMS = 20

interface FilterApp {
  bundleName: string,
  abilityName: string,
  icon: string
}

const iconList: FilterApp[] = [
  { bundleName: 'com.ohos.note', abilityName: 'MainAbility', icon: 'app.media.bwl' }, //备忘录
  { bundleName: 'com.ohos.demandplayer', abilityName: 'MainAbility', icon: 'app.media.spbfq1' }, //视频播放器
  { bundleName: 'com.ohos.aiface', abilityName: 'MainAbility', icon: 'app.media.rl' }, //ai人脸
  { bundleName: 'com.ohos.dtvplayer', abilityName: 'MainAbility', icon: 'app.media.db' }, //点播
  { bundleName: 'com.samples.album', abilityName: 'MainAbility', icon: 'app.media.tuku' }, //图库
  { bundleName: 'ohos.samples.browser1', abilityName: 'MainAbility', icon: 'app.media.llq' }, //浏览器
  {
    bundleName: 'ohos.samples.distributedmusicplayer',
    abilityName: 'ohos.samples.distributedmusicplayer.MainAbility',
    icon: 'app.media.yy'
  }, //音乐
  { bundleName: 'com.ohos.inputsource', abilityName: 'EntryAbility', icon: 'app.media.sry1' }, //输入源
  { bundleName: 'com.samples.camera', abilityName: 'EntryAbility', icon: 'app.media.xj' }, //相机
  { bundleName: 'com.ohos.settings', abilityName: 'com.ohos.settings.MainAbility', icon: 'app.media.shezhi' },//设置
]
const sourceToolSeven = 7;
@Entry
@Component
struct RecentView {
  scroller: ListScroller = new ListScroller();
  @State
  missions: missionManager.MissionInfo[] = []
  @State
  snapShots: Map<number, missionManager.MissionSnapshot> = new Map<number, missionManager.MissionSnapshot>();
  @State
  focusIndex: number = -1
  @State
  translateY: number = 0
  @State
  opacityValue: number = 1
  @State
  clearAllFocused: boolean = false
  @State
  hadMove: boolean = false
  @State
  context:common.ApplicationContext = getContext() as common.ApplicationContext

  aboutToAppear(): void {
    setTimeout(()=>{
       this.tabStartClick()
    },300)

    console.log(TAG, 'aboutToAppear')
  }

  aboutToDisappear(): void {
    console.log(TAG, 'aboutToDisappear')
  }

  onPageShow(): void {
    console.log(TAG, 'onPageShow')
    this.getMissionList()
  }

  onPageHide(): void {
    console.log(TAG, 'onPageHide')
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

    try {
      // 触发tab点击，使默认焦点组件多态样式生效
      inputEventClient.injectEvent({ KeyEvent: keyDown });
      inputEventClient.injectEvent({ KeyEvent: keyUp });
    } catch (e) {
      console.log('tab key event click false')
    }
  }

  onBackPress(): boolean | void {
    windowManager.destroyWindow(windowManager.RECENT_WINDOW_NAME)
    console.log(TAG, 'onBackPress' + ' success destroyWindow')
  }

  getMissionList() {
    missionManager.getMissionInfos('', GET_MISSIONS_NUMS).then((list: missionManager.MissionInfo[]) => {
      console.log(TAG, 'watchMissions = ' + JSON.stringify(list.map((m: missionManager.MissionInfo) => m.label)))
      let del: missionManager.MissionInfo[] = []
      list.forEach(m => {
        let appIcon = RecentItem.handleIcon(m!.want.bundleName!);
        if (!appIcon) {
          let curAppInfo: launcherBundleManager.LauncherAbilityInfo =
            launcherBundleManager.getLauncherAbilityInfoSync(m?.want.bundleName, 100)[0]
          console.log(TAG, 'curAppInfo = ' + curAppInfo)
          if (curAppInfo === undefined) {
            del.push(m)
          }
        }
      })
      console.log(TAG, 'del = ' + JSON.stringify(del.map(d => d.label)))
      list = list.filter(m =>!del.includes(m))
      this.missions = list.reverse()
      this.lockAllMission()
    })
  }

  scrollToPostion() {
    setTimeout(()=>{
      this.scroller.scrollToIndex(this.focusIndex,true, ScrollAlign.CENTER)
    }, 50)
  }

  marginLeft(missions: missionManager.MissionInfo[]) {
    let appWidth = lpx2px(770)
    let space = lpx2px(25)
    let padding = lpx2px(50)
    let size = missions.length
    if (size >= 3) {
      return 0
    } else if (size == 2) {
      return 0
    } else {
      return 0
    }
  }

  focusUnClock(missionID:number){
    missionManager.unlockMission(missionID, (err, data) => {
      if (err) {
        console.error(`unlockMission failed: ${err.message}`);
      } else {
        console.info(`unlockMission successfully: ${JSON.stringify(data)}`);
      }
    });
  }

  lockAllMission() {
    for (let i = 0; i < this.missions.length; i++) {
      let missionID = this.missions[i].missionId
      if (missionID == this.missions[i].missionId) {
        try {
          missionManager.lockMission(missionID, (err, data) => {
            if (err) {
              console.error(`lockMission failed: ${err.message}`);
            } else {
              console.info(`lockMission successfully: ${JSON.stringify(data)}`);
            }
          });
        } catch (err) {
          console.error(`lockMission failed: ${err.message}`);
        }
      }
    }
  }

  unLockAllMission(){
    for (let index = 0; index < this.missions.length; index++) {
      const element = this.missions[index].missionId
      this.focusUnClock(element)
    }
  }

  lockMission(missionID: number) {
    try {
      missionManager.lockMission(missionID, (err, data) => {
        if (err) {
          console.error(`lockMission failed: ${err.message}`);
        } else {
          console.info(`lockMission successfully: ${JSON.stringify(data)}`);
        }
      });
    } catch (err) {
      console.error(`lockMission failed: ${err.message}`);
    }
  }
  async terminateFloatWindowExplicitly(): Promise<void> {
    try {
      const want: Want = {
        bundleName: 'com.samples.camera',  // 目标应用的包名
        abilityName: 'FloatWindowAbility',
        parameters: {
          action: 'terminate_float_window'
        }
      };
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      try {
        // stopServiceExtensionAbility
        context.stopServiceExtensionAbility(want).then(() => {
          console.info(`stopServiceExtensionAbility success.`);
        }).catch((error: BusinessError) => {
          console.error(`stopServiceExtensionAbility failed, err code: ${error.code}, err msg: ${error.message}.`);
        })
      } catch (err) {
        let code = (err as BusinessError).code;
        let msg = (err as BusinessError).message;
        console.error(`stopServiceExtensionAbility failed, err code: ${code}, err msg: ${msg}.`);
      }

    } catch (error) {
      console.error('Explicit terminate failed:', error);
    }
  }
  moveUp() {
    this.hadMove = true
    focusControl.requestFocus('remove_tips') // 向上移动时先占位 以免让docker的app获焦
    animateTo({
      duration: MOVEUP_DURATION,
      playMode: PlayMode.Normal,
      curve: Curve.EaseOut,
      tempo: 1,
      onFinish: async () => {
        console.info('play end')
        let missionId = this.missions[this.focusIndex].missionId
        let missionLabel = this.missions[this.focusIndex].label
       if (missionLabel=='相机'){
        await this.terminateFloatWindowExplicitly()
       }
        this.focusUnClock(missionId)
          missionManager.clearAllMissions(err => {
            if (err) {
              console.error('clearAllMissions failed: ${err.message}');
            } else {
              console.info('clearAllMissions successfully.');
            }
          this.translateY = 0
          this.opacityValue = 1
          this.missions.splice(this.focusIndex, 1)
          if (this.missions.length == 0) {
            this.onBackPress()
          } else {
            let componentId: string
            if (this.missions[this.focusIndex]) {
              componentId = this.missions[this.focusIndex].missionId + "_" + this.focusIndex
            } else {
              componentId = this.missions[this.focusIndex - 1].missionId + "_" + (this.focusIndex - 1)
            }
            console.log(TAG, 'requestFocus :' + componentId)

            setTimeout(()=>{
              focusControl.requestFocus(componentId)
              this.hadMove = false
            },500)
          }
        })
      }
    }, () => {
      this.translateY = MOVEUP_TRANSLATE_Y
      this.opacityValue = 0
    })
  }

  async clearAllMissions() {
    this.unLockAllMission()
    const settingMission = this.missions.find(m => m.label == '设置');
    if (settingMission){
      AppStorage.setOrCreate('settingMission', settingMission)
    }
    // 查找"相机"应用的任务
    const cameraMission = this.missions.find(m => m.label == '相机')
    if(cameraMission){
      await this.terminateFloatWindowExplicitly()
    }
    missionManager.clearAllMissions((error) => {
      if (error) {
        console.error(TAG, 'clearAllMissions error' + JSON.stringify(error))
      } else {
        emitter.emit("clearMissionSuccess", {});
      }
      this.onBackPress()
    })
  }

  build() {
    Stack() {
      if (this.missions.length > 0) {
        Row() {
          Blank().layoutWeight(1)
          Text($r('app.string.remove_mission_up'))
            .id('remove_tips')
            .textAlign(TextAlign.End)
            .fontSize('36lpx')
            .fontColor('#ffffff')
            .margin({ right: '100lpx' })
            .focusable(true)
            .enabled(this.hadMove)
            .focusBox({
              strokeWidth: LengthMetrics.px(0)
            })
        }
        .width('100%')
        .position({ y: '10%' })

        Stack() {
          List({space: px2vp(25), scroller: this.scroller }) {
            ForEach(this.missions, (mission: missionManager.MissionInfo, index) => {
              ListItem() {
                RecentItem({
                  mission: mission,
                  missionLength: this.missions.length,
                  index: index,
                  focusIndex: this.focusIndex,
                  scrollToPostion: () => {
                    this.scrollToPostion()
                  },
                  moveUp: () => {
                    this.moveUp()
                  },
                  close: () => {
                    // this.controller.close()
                    this.onBackPress()
                  },
                  unlockMission: () => {
                    this.focusUnClock(mission.missionId)
                  }
                })
                  .margin({
                    left: index == 0 ? px2vp(50) : 0,
                    right: index == this.missions.length - 1 && this.missions.length != 1 ? px2vp(50) : 0
                  })
                  .focusable(true)
                  .translate({ y: this.focusIndex == index ? this.translateY : 0 })
                  .opacity(this.focusIndex == index ? this.opacityValue : 1)
              }

            }, (mission: missionManager.MissionInfo) => {
              return String(mission.missionId)
            })
          }
          .alignListItem(ListItemAlign.Center)
          .scrollBar(BarState.Off)
          .listDirection(Axis.Horizontal)
          .margin({ left: this.marginLeft(this.missions) })
          .focusable(true)
          .onAppear(() => {
            console.log(TAG, 'list onAppear')
            let lastId = this.missions[this.missions.length - 1].missionId + '_' + (this.missions.length - 1)
            this.scroller.scrollToIndex(this.missions.length - 1)
            setTimeout(() => {
              focusControl.requestFocus(lastId)
            }, 500)
          })
          .width('100%')
          .height('100%')
          .focusable(true)

          Column() {
            Image(this.clearAllFocused ? $r('app.media.ic_public_clear_onfocus') :
            $r("app.media.ic_public_clear_offfocus"))
              .width(px2vp(80))
              .aspectRatio(1)
              .focusable(true)
              .onClick(() => {
                this.clearAllMissions()
              })
              .onFocus(() => {
                this.focusIndex = -1
                this.clearAllFocused = true
              })
              .onBlur(() => {
                this.clearAllFocused = false
              })
              .focusBox({
                strokeWidth: LengthMetrics.px(0)
              })
              .onTouch((event) => {
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
                if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolSeven) {
                  return ;
                }
                this.clearAllMissions()
              })
              .onHover((isHover) => {
                if(isHover) {
                  this.focusIndex = -1
                  this.clearAllFocused = true
                } else {
                  this.clearAllFocused = false
                }
              })
            Text($r('app.string.remove_all_mission'))
              .fontSize(px2lpx(36))
              .fontColor('#ffffff')
              .margin({ top: '15lpx' })
              .fontSize(px2vp(36))
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .position({ y: '80%' })
          .focusable(true)
        }
      } else {
        Text($r('app.string.recent_no_app'))
          .fontSize(px2vp(36))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.immersive_app_name'))
          .width('100%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .visibility(this.hadMove ? Visibility.None : Visibility.Visible)
      }
    }
    .width('100%')
    .height('100%')
    .focusable(true)
   }
}

@Component
struct RecentItem {
  @State startX: number = 0;
  @State startY: number = 0;
  @State isTracking: boolean = false;
  mission: missionManager.MissionInfo | undefined
  missionLength: number = 0
  @State
  snapShot: image.PixelMap | undefined = undefined
  @Prop
  index: number
  @Link
  focusIndex: number
  @State
  appIcon: string = ''
  scrollToPostion: () => void = () => {
  }
  moveUp: () => void = () => {
  }
  close: () => void = () => {
  }
  unlockMission: () => void = () => {
  }

  aboutToAppear(): void {
    console.log(TAG_ITEM, `item  ${JSON.stringify(this.mission)}`);
    missionManager.getMissionSnapShot('', this.mission?.missionId, (error, snapShot) => {
      if (error) {
        console.error(TAG,
          `getMissionSnapShot ${this.mission?.missionId + '  ' + this.mission?.label} failed. Cause: ${error.message}`);
      } else {
        console.log(TAG, `getMissionSnapShot ${this.mission?.missionId + ' ' + this.mission?.label +
        this.mission?.want.bundleName} sucess`)
        this.snapShot = snapShot.snapshot
        console.log(TAG, 'snapShot = ' + JSON.stringify(this.snapShot))
      }
    })
    this.getIcon()
  }

  onPageShow(): void {
    console.log(TAG_ITEM, 'onPageShow')
  }

  onPageHide(): void {
    console.log(TAG_ITEM, 'onPageHide')
  }

  getIcon() {
    this.appIcon = RecentItem.handleIcon(this.mission!.want.bundleName!);
    if (!this.appIcon) {
      let curAppInfo: launcherBundleManager.LauncherAbilityInfo =
        launcherBundleManager.getLauncherAbilityInfoSync(this.mission?.want.bundleName, 100)[0]
      let moduleContext: Context =
        globalThis.desktopContext.createModuleContext(curAppInfo.elementName.bundleName,
          curAppInfo?.elementName?.moduleName);
      if (moduleContext != null) {
        this.appIcon = moduleContext.resourceManager.getMediaContentBase64Sync(curAppInfo.iconId);
      }
    }
  }

  static handleIcon(app: string): string {
    let filterApp: FilterApp | undefined = iconList.find(i => i.bundleName == app)
    let icon: string | undefined = filterApp?.icon
    return icon ?? ''
  }

  aboutToDisappear(): void {
    console.log(TAG_ITEM, 'aboutToDisappear')
    this.snapShot?.release()
  }
  private getSwipeDirection(startX: number, startY: number, endX: number, endY: number): string {
    console.log("111startX"+startX)
    console.log("111startY"+startY)
    console.log("111endX"+endX)
    console.log("111endY"+endY)
    const deltaX = endX - startX;
    const deltaY = endY - startY;
    const minDistance = 50;

    if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > minDistance) {
      return deltaX > 0 ? 'left-to-right' : 'right-to-left';
    } else if (Math.abs(deltaY) > minDistance) {
      return deltaY > 0 ? 'top-to-bottom' : 'bottom-to-top';
    }

    return 'tap'; // 点击或微小移动
  }

  // 统一处理触摸动作
  private handleTouchAction(sourceTool: number, direction: string): void {
    console.log(`设备类型: ${sourceTool}, 滑动方向: ${direction}`);
    if (sourceTool == TouchType.Up) {
      // 根据滑动方向执行不同操作
      switch (direction) {
        case 'left-to-right':
          this.onSwipeLeftToRight();
          break;
        case 'right-to-left':
          this.onSwipeRightToLeft();
          break;
        case 'top-to-bottom':
          this.onSwipeTopToBottom();
          break;
        case 'bottom-to-top':
          this.onSwipeBottomToTop();
          break;
        case 'tap':
          this.onTap();
          break;
      }
    }
  }

  // 具体的滑动处理函数
  private onSwipeLeftToRight(): void {
    console.log("处理从左到右滑动");
    // 例如：切换到下一个任务
  }

  private onSwipeRightToLeft(): void {
    console.log("处理从右到左滑动");
    // 例如：切换到上一个任务
  }

  private onSwipeTopToBottom(): void {
    console.log("处理从上到下滑动");
    // 例如：关闭当前任务
  }

  private onSwipeBottomToTop(): void {
    console.log("处理从下到上滑动");
    // 例如：打开任务详情
    this.moveUp();
  }

  private onTap(): void {
    console.log("处理点击事件");
    // 例如：选中当前任务
  }
  build() {
    Stack() {
      Column() {
        Row() {
          Stack({ alignContent: Alignment.Center }) {
            Row()
              .position({
                x: 0,
                y: 0
              })
              .backgroundColor(this.focusIndex == this.index ? '#ffffffff' : '#33ffffff')
              .borderRadius(px2vp(6))
              .width(px2vp(83))
              .aspectRatio(1.8)
              .focusable(false)

            Image(JSON.stringify(this.appIcon).length > 18 ? this.appIcon : $r(this.appIcon as string))
              .height(px2vp(30))
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .interpolation(ImageInterpolation.High)
              .syncLoad(true)
              .focusable(false)
          }
          .focusable(false)
          .padding('5lpx')

          Text(this.mission?.label)
            .margin({ left: px2vp(6) })
            .fontSize(px2vp(36))
            .fontColor($r('app.color.mission_label_color'))
            .focusable(false)
        }
        .focusable(false)
        .onClick(()=>{
          this.focusIndex = this.index
          this.scrollToPostion()
        })


        Stack() {
          Image(this.snapShot ?? '')
            .width('100%')
            .aspectRatio(RATIO)
            .focusable(true)
            .objectFit(ImageFit.Fill)
            .id(this.mission?.missionId + '_' + this.index)
            .onClick(() => {
              if (this.mission?.label == "设置") {
                let want: Want = {
                  bundleName: "com.ohos.settings",
                  abilityName: "com.ohos.settings.MainAbility",
                }
                console.info(TAG, `onKeyEvent want: ` + JSON.stringify(want))
                this.unlockMission()
                missionManager.clearAllMissions((error) => {
                  if (error) {
                    return;
                  }
                  globalThis.desktopContext.startAbility(want).then(() => {
                    console.log('success:');
                    this.close()
                  }).catch((error: BusinessError) => {
                    console.log('failed:' + JSON.stringify(error));
                  });
                })
              }
              missionManager.moveMissionToFront(this.mission?.missionId, (error) => {
                console.log(TAG, `moveMissionToFront missionid = ${this.mission?.missionId}}`)
                this.close()
              })
            })
              .focusBox({
                strokeWidth: LengthMetrics.px(0)
              })
            .borderRadius(px2vp(24))
            .onFocus(() => {
              this.focusIndex = this.index
              this.scrollToPostion()
              console.log(TAG, `scrollToPostion listItem onFocus index = ${this.index}`)
            })

            .onTouch((event) => {
              console.info("onTouch begin="+JSON.stringify(event.sourceTool))
              if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolSeven) {
                return;
              }
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              console.info("onTouch end="+JSON.stringify(event.sourceTool))
              if(event.sourceTool== SourceTool.Pen ){
                missionManager.moveMissionToFront(this.mission?.missionId, (error) => {
                  this.close()
                })
              }
            })
            // 上滑触发该手势事件
            .gesture(
              PanGesture(new PanGestureOptions({ direction: PanDirection.Up}))
                .onActionEnd((event: GestureEvent) => {
                  console.info('onActionEnd=' + JSON.stringify(event.sourceTool));
                  if (event.sourceTool == SourceTool.Finger) {
                    this.moveUp();
                  }
                })
            )
            .onHover((isHover) => {
              if(isHover) {
                this.focusIndex = this.index
                this.scrollToPostion()
              }
            })

            .onKeyEvent((event: KeyEvent) => {
              if (event.keyCode === KeyCode.KEYCODE_DPAD_UP && event.type === KeyType.Down) {
                this.moveUp()
              } else if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT && event.type === KeyType.Down) {
                if (this.focusIndex == 0) {
                  event.stopPropagation()
                }
              } else if (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT && event.type === KeyType.Down) {
                if (this.focusIndex == this.missionLength - 1) {
                  event.stopPropagation()
                }
              }
            })
        }.padding(this.focusIndex == this.index ? px2vp(10) : px2vp(20))
        .margin({ top: '20lpx' })
        .border(this.focusIndex == this.index ? { width: px2vp(4), color: '#A09E9E' } :
          { width: '0' }).borderRadius(px2vp(30))
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
    }
    .width(px2vp(770))
    .focusable(true)
    .onAppear(() => {
      console.log(TAG_ITEM,
        `listItem onAppear  = ${this.mission?.label + ' ' + this.mission?.missionId + '_' + this.index}`)
    })
  }
}

