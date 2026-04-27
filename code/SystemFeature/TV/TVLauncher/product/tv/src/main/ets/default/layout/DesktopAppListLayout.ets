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

import { AppItemInfo } from '../../common/bean/AppItemInfo';
import DesktopAppItem from './DesktopAppItem';
import { inputConsumer } from '@kit.InputKit';
import { display } from '@kit.ArkUI';
import { Throttle } from '../../common/baseUtil/throttle';
import { infoList } from '../../common/baseUtil/storage';
import { BusinessError, commonEventManager, emitter } from '@kit.BasicServicesKit';
import lazy { launcherAbilityManager } from '@ohos/common';
import { commonEventParma } from '../../MainAbility/MainAbility';
import PreferenceUtils from '../../common/baseUtil/PreferenceUtil';
import { Content, LengthMetrics, promptAction } from '@kit.ArkUI';
import lazy { missionManager } from '@kit.AbilityKit';
import dockerAppStorage, { DockerAppStorage } from '../../common/baseUtil/dockerAppStorage';

const TAG = "DesktopAppListLayout";
const ADD_DOCKER_SHORTCUTS: string = 'ADD_DOCKER_SHORTCUTS'
const REMOVE_DOCKER_SHORTCUTS: string = 'REMOVE_DOCKER_SHORTCUTS'
const DEFAULT_INPUT_SOURCE: string = 'defaultInputSource'
const INPUT_SOURCE_TYPE: string = 'InputSourceType'
const SETUP_WIZARD: string = 'setupWizardComplete'
const DISPLAY_1080P:number = 1920
const DISPLAY_4K:number = 3840


// 添加图标宽度常量
const ICON_WIDTH_1080P:number = 310
const ICON_WIDTH_4K:number = 700  // 4K分辨率下图标宽度，稍微缩小间距但保持不重叠

// 添加两个阈值变量
const VISIBLE_THRESHOLD_1080P: number = 4
const SCROLL_THRESHOLD_1080P: number = 5
const VISIBLE_THRESHOLD_4K: number = 3
const SCROLL_THRESHOLD_4K: number = 4

interface SetupWizardParams {
  setupWizardComplete: boolean;
}

interface InputSourceParams {
  defaultInputSource: boolean;
}

interface InputSourceTypeParams {
  InputSourceType: string;
}

interface SetupWizardEventData {
  event: string;
  bundleName: string;
  code: number;
  data: string;
  parameters: SetupWizardParams;
}

interface InputSourceEventData {
  event: string;
  bundleName: string;
  code: number;
  data: string;
  parameters: InputSourceParams;
}

interface InputSourceTypeEventData {
  event: string;
  bundleName: string;
  code: number;
  data: string;
  parameters: InputSourceTypeParams;
}

// PersistentStorage.persistProp('appListName',
//   ["输入源", "视频播放器", "FUNUI影视", "设置", "图库", "相机", "音乐", "全部应用"]);

let PreData = new PreferenceUtils<boolean>(getContext(Content), true)

// 1920 * 1080
@Component
export struct DesktopAppListLayout {
  private scroller: Scroller = new ListScroller()
  @State appList: AppItemInfo[] = []
  @State isEdit: boolean = false
  @State @Watch('updateIndex') focusIdx: number = 2
  @State isOneSecond: boolean = false
  @State focusNumber: number = 0
  @State translateX: number[] = []
  translateDistance: number = 0
  @State itemEnable:boolean = true
  @State iconWidth: number = ICON_WIDTH_1080P  // 添加动态图标宽度状态
  shortCutsSubscriber: commonEventManager.CommonEventSubscriber | undefined;

  aboutToAppear() {
    this.initAppList()
    this.subscribeListener()
    getContext(globalThis.desktopContext).eventHub.on('subscribeListener', () => {
      this.subscribeListener()

    })
    getContext(globalThis.desktopContext).eventHub.on('unSubscribeListener', () => {
      this.unSubscribeListener()
      this.focusNumber = 0
    })

    emitter.on('startAllApp', () => {
      let bundleNames = this.appList.map(v => v.bundleName ?? '');
      launcherAbilityManager.startLauncherAbility('MainAbility', 'com.ohos.applicationmanager', '', bundleNames);
    })

    emitter.on("clearMissionSuccess", ()=>{
      promptAction.showToast({
        message: getContext().resourceManager.getStringSync($r('app.string.clear_mission_tips').id),
        bottom: globalThis.screenHeight / 4
      })
    });

    emitter.on('removeShortcuts', (data) => {
      console.log(TAG, 'removeShortcuts  ' + JSON.stringify(data));
      /**
       * 移除快捷方式后 需将焦点移动到上一个app
       * 1.根据当前移除快捷方式应用的bundlename查找上一个app的组件id
       * 2.applist中移除对应的app
       * 3.上一个app获取焦点
       */
      let bundleName = String(data.data);
      let app = this.appList.find(i => i.bundleName == bundleName);
      console.log(TAG, 'removeShortcuts  app' + JSON.stringify(app));
      let preIndex = this.appList.findIndex((info) => info.bundleName == bundleName) - 1
      const preItem = this.appList[preIndex];
      if (!preItem || preItem.appName == undefined) {
        return;
      }
      let preName = preItem.appName;
      let preComponentId = preName + '_' + preIndex;
      console.log(TAG, 'removeShortcuts  preComponentId ' + preComponentId);
      this.appList = this.appList.filter((info) => info.bundleName != bundleName);
      this.focusIdx = preIndex;
      this.pressBack();
      focusControl.requestFocus(preComponentId);
    })

    let shortCutsSubscriberInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [ADD_DOCKER_SHORTCUTS, REMOVE_DOCKER_SHORTCUTS,DEFAULT_INPUT_SOURCE,SETUP_WIZARD,INPUT_SOURCE_TYPE]
    };
    this.shortCutsSubscriber = commonEventManager.createSubscriberSync(shortCutsSubscriberInfo)
    commonEventManager.subscribe(this.shortCutsSubscriber, (error, data) => {
      console.log(TAG, 'shortCuts CommonEvent: ' + JSON.stringify(data.data))
      if (data) {
        if (data.event == REMOVE_DOCKER_SHORTCUTS) { // 全部应用中卸载app 需要同步docker删除
          let bundleName = String(data.data);
          console.log(TAG, 'focusIdex = ' + this.focusIdx + '  ' + JSON.stringify(this.appList))
          let focusAppName = infoList[5] // 总是从全部应用app跳转过去
          this.appList = this.appList.filter((info) => info.bundleName != bundleName);
          let focusIndex = this.appList.findIndex(a => a.appName == focusAppName)
          let focusComponentId = focusAppName + '_' + focusIndex;
          console.log(TAG, 'removeShortcuts  focusComponentId ' + focusComponentId);
          this.focusIdx = focusIndex;
          focusControl.requestFocus(focusComponentId);
        } else if (data.event == ADD_DOCKER_SHORTCUTS) { // 全部应用中添加app到docker
          let shortCutsBundleName: string = data.data!;
          console.log(TAG, 'recive addShortCutsBundleName = ' + JSON.stringify(shortCutsBundleName));
          launcherAbilityManager.getLauncherAbilityInfo(shortCutsBundleName).then((commonInfos) =>{
            if (commonInfos?.length > 0) {
              let info = new AppItemInfo()
              info.cover(commonInfos[0])
              DockerAppStorage.appInit(info)
              let isExist = this.appList.filter((i) => i.bundleName == info.bundleName)?.length > 0
              if (isExist) {
                console.log(TAG,
                  'recive addShortCutsBundleName isExist : bundleName = ' + JSON.stringify(shortCutsBundleName));
                return;
              }

              // 添加的app快捷方式组件id在最后一位
              let addComponentId = info.appName + "_" + (this.appList.length);
              console.log(TAG, 'addShortCuts  addComponentId ' + addComponentId);

              this.isEdit = true;
              focusControl.requestFocus('placeholder')

              this.focusIdx = this.appList.length;
              this.appList.push(info);

              setTimeout(() => {
                this.scroller.scrollTo({ xOffset: 2000, yOffset: 0 })
              }, 200)

              setTimeout(()=>{
                this.itemEnable = true
                focusControl.requestFocus(addComponentId)
              },500)
            }
          })
        } else if (data.event === SETUP_WIZARD) {
          let isValue = data as SetupWizardEventData
          PreData.setPreValue(SETUP_WIZARD, isValue.parameters.setupWizardComplete)
          console.log(TAG, 'killSetupProcess setupWizardComplete' + JSON.stringify(isValue))
          if (!isValue.parameters.setupWizardComplete) {
            console.log(TAG, 'killSetupProcess setupWizardComplete start')
            this.killSetupProcess()
          }
        } else if (data.event === DEFAULT_INPUT_SOURCE) {
          let isValue = data as InputSourceEventData
          PreData.setPreValue(DEFAULT_INPUT_SOURCE, isValue.parameters.defaultInputSource)
        } else if (data.event === INPUT_SOURCE_TYPE) {
          let value = data as InputSourceTypeEventData
          let Pre = new PreferenceUtils<string>(getContext(), 'HDMI1')
          Pre.setPreValue(INPUT_SOURCE_TYPE, value.parameters.InputSourceType)
        }
      }
    });

    let dis = display.getDefaultDisplaySync()
    console.log(TAG, `getDefaultDisplaySync = ${dis.width}`)
    if (dis.width === DISPLAY_4K) {
      this.translateDistance = px2vp(ICON_WIDTH_4K)
      this.iconWidth = ICON_WIDTH_4K  // 4K分辨率下使用更大的图标宽度
    } else if (dis.width === DISPLAY_1080P) {
      this.translateDistance = px2vp(ICON_WIDTH_1080P)
      this.iconWidth = ICON_WIDTH_1080P  // 1080P分辨率下使用默认图标宽度
    }
    
    // 设置全局图标宽度供其他组件使用
    AppStorage.setOrCreate('iconWidth', this.iconWidth)

   // this.translateDistance = px2vp(MOVE_DIS_1080P)
  }

  updateIndex() {
    console.log(TAG, 'updateIndex:', JSON.stringify(this.focusIdx))
  }

  killSetupProcess() {
    try {
      missionManager.getMissionInfos('', 20).then((data) => {
        console.info(`getMissionInfos successfully. Data: ${JSON.stringify(data)}`);
        data.forEach((item) => {
          if (item.want.bundleName == 'com.ohos.setupwizard') {
            console.log(TAG, 'getMissionInfos com.ohos.setupwizard', JSON.stringify(item.missionId))
            this.cleanProcess(item.missionId)
          }
        })
      }).catch((error: BusinessError) => {
        console.error(`getMissionInfos failed. Cause--: ${error.message}`);
      });
    } catch (error) {
      console.error(`getMissionInfos failed. Cause: ${error.message}`);
    }
  }

  cleanProcess(missionId: number) {
    try {
      missionManager.clearMission(missionId, (err, data) => {
        if (err) {
          console.error(`clearMission failed: ${err.message}`);
        } else {
          console.info(`clearMission successfully: ${JSON.stringify(data)}`);
        }
      });
    } catch (err) {
      console.error(`clearMission failed: ${err.message}`);
    }
  }

  aboutToDisappear(): void {
    commonEventManager.unsubscribe(this.shortCutsSubscriber);
  }

  subscribeListener() {
    inputConsumer.on("key", {
      preKeys: [],
      finalKey: 2067,
      isFinalKeyDown: false,
      finalKeyDownDuration: 1000
    }, () => {
      let idx = AppStorage.get('focusIdx') as number
      if (!this.appList[idx]?.canMove) {
        let toast: string = getContext().resourceManager.getStringSync($r('app.string.app_cannot_edit').id)
        promptAction.showToast({
          message: toast,
          bottom: globalThis.screenHeight / 4
        })
        return
      } else {
        this.isEdit = true
      }
    })
  }

  unSubscribeListener() {
    inputConsumer.off("key", {
      preKeys: [],
      finalKey: 2067,
      isFinalKeyDown: false,
      finalKeyDownDuration: 1000
    })
  }

  subscribeBack() {
    inputConsumer.on("key", {
      preKeys: [],
      finalKey: 2,
      isFinalKeyDown: false,
      finalKeyDownDuration: 1000
    }, () => {
    })
  }

  unSubscribeBack() {
    inputConsumer.off("key", {
      preKeys: [],
      finalKey: 2,
      isFinalKeyDown: false,
      finalKeyDownDuration: 1000
    })
  }

  async initAppList() {
    dockerAppStorage.getDockerAppItemInfos().then((apps:AppItemInfo[]) =>{
      this.appList = apps
      this.translateX = new Array(this.appList.length).fill(0)
      setTimeout(() => {
        focusControl.requestFocus(`${this.appList[2].appName}_2`); //默认第三个选中
      }, 500)
    })
  }

  moveItemToRight(focusIndex: number) {
    if (!Throttle.canInvoke('DesktopAppListLayout_moveItemToRight', 400)) {
      return
    }
    if (focusIndex >= this.appList.length - 1) {
      let toast: string = getContext().resourceManager.getStringSync($r('app.string.app_cannot_move').id)
      promptAction.showToast({
        message: toast,
        bottom: globalThis.screenHeight / 4
      })
      return
    }
    this.subscribeBack()
    const focIdx = focusIndex + 1
    if (focIdx >
      (display.getDefaultDisplaySync().width == DISPLAY_1080P ? VISIBLE_THRESHOLD_1080P : VISIBLE_THRESHOLD_4K)) {
      let xOffset = 0
      xOffset = (focIdx -
        (display.getDefaultDisplaySync().width == DISPLAY_1080P ? SCROLL_THRESHOLD_1080P : SCROLL_THRESHOLD_4K)) *
      this.translateDistance
      this.scroller.scrollTo({ xOffset: xOffset, yOffset: 0 })
    }
    this.itemEnable = false
    focusControl.requestFocus('placeholder')

    animateTo({
      duration: 100,
      playMode: PlayMode.Normal,
      curve: Curve.EaseIn,
      tempo: 0.5,
      onFinish: () => {
        let translateXList = this.translateX;
        translateXList[focusIndex] = 0
        translateXList[focusIndex + 1] = 0
        this.translateX = translateXList
        let appListData = this.appList;
        let temp = appListData[focusIndex + 1]
        appListData[focusIndex + 1] = appListData[focusIndex]
        appListData[focusIndex] = temp
        this.appList = appListData
        animateTo({
          duration: 0
        }, () => {
          this.focusIdx = focIdx
        })
        this.unSubscribeBack()
        setTimeout(()=>{
          this.itemEnable = true
          let focusId = `${this.appList[this.focusIdx].appName}_${this.focusIdx}`
          focusControl.requestFocus(focusId)
        }, 300)
      }
    }, () => {
      let translateXList = this.translateX;
      translateXList[focusIndex] = this.translateDistance
      translateXList[focusIndex + 1] = -this.translateDistance
      this.translateX = translateXList
    })

  }

  moveItemToLeft(focusIndex: number) {
    if (!Throttle.canInvoke('DesktopAppListLayout_moveItemToLeft', 400)) {
      return
    }
    if (focusIndex <= 2) {
      let toast: string = getContext().resourceManager.getStringSync($r('app.string.app_cannot_move').id)
      promptAction.showToast({
        message: toast,
        bottom: globalThis.screenHeight / 4
      })
      return
    }
    this.subscribeBack()
    const focIdx = focusIndex - 1
    if (focIdx >= 4) {
      let xOffset = 0
      xOffset = (focIdx - 4) * this.translateDistance
      this.scroller.scrollTo({ xOffset: xOffset, yOffset: 0 })
    }
    this.itemEnable = false
    focusControl.requestFocus('placeholder')

    animateTo({
      duration: 100,
      playMode: PlayMode.Normal,
      curve: Curve.EaseIn,
      tempo: 0.5,
      onFinish: () => {
        let translateXList = this.translateX;
        translateXList[focusIndex] = 0
        translateXList[focusIndex - 1] = 0
        this.translateX = translateXList
        let appListData = this.appList;
        let temp = appListData[focusIndex - 1]
        appListData[focusIndex - 1] = appListData[focusIndex]
        appListData[focusIndex] = temp
        this.appList = appListData
        animateTo({
          duration: 0
        }, () => {
          this.focusIdx = focIdx
        })
        this.unSubscribeBack()
        setTimeout(()=>{
          this.itemEnable = true
          let focusId = `${this.appList[this.focusIdx].appName}_${this.focusIdx}`
          focusControl.requestFocus(focusId)
        }, 300)
      }
    }, () => {
      let translateXList = this.translateX;
      translateXList[focusIndex] = -this.translateDistance
      translateXList[focusIndex - 1] = this.translateDistance
      this.translateX = translateXList
    })
  }

  pressBack() {
    this.isEdit = false
    let orderBundleNames = this.appList.map(a => a.bundleName!)
    dockerAppStorage.setOrderBundleNames(orderBundleNames)
  }

  translateDis(index: number) {
    return this.translateX[index]
  }

  build() {
    Column() {
      List({ scroller: this.scroller }) {
        ForEach(this.appList, (app: AppItemInfo, index: number) => {
          ListItem() {
            DesktopAppItem({
              app: app,
              idx: index,
              scroller: this.scroller,
              isEdit: $isEdit,
              focusIdx: $focusIdx,
              focusNumber: $focusNumber,
              itemEnable: $itemEnable,
              moveToLeft: () => {
                this.moveItemToLeft(index)
              },
              moveToRight: () => {
                this.moveItemToRight(index)
              },
              pressBack: () => {
                this.pressBack()
              }
            })
          }
          .translate({
            x: this.translateDis(index)
          })
          .height('100%')
          .width(px2vp(this.iconWidth))  // 使用动态图标宽度
          .focusable(true)
        }, (item: AppItemInfo) => {
          return `${item.appName}`
        })
      }
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
      .focusable(true)
      .position({ x: 0, y: 0 })
      .zIndex(1)
      .width('100%')

      Text('')
        .id('placeholder')
        .fontSize('72lpx')
        .focusable(true)
        .onFocus(()=>{
          console.log(TAG,' placeholder onfocuss')
        }).enabled(this.isEdit)
        .focusBox({
        strokeWidth: LengthMetrics.px(0)
      })
    }
    .height('100%')
    .width('100%')
    .focusable(true)
  }
}
