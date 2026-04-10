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
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import { KeyCode } from '../../common/constants/KeyCode';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import lpx from '../../common/Lpx';
import settings from '@ohos.settings';
import audioSetting from '@ohos.tvservice.audioSetting';
import { Duration } from '../../common/constants/Duration';
import router from '@ohos.router';
import { App, promptAction } from '@kit.ArkUI';
interface volumeList {
  audioEffectMode: number,   /*音效模式[0-自动,1-标准,2-影院,3-音乐,4-新闻,5-自定义]*/
}
const TAG = 'effectsIndex'

@Entry
@Component
struct Effects {
  @State referMode:number=1
  @State band:number = 0
  @State gain:number = -10
  @State volParams:number = 0
  @State hSurround:number = 0
  @State vSurround :number= 0
  @State resetData:boolean = false
  @State imageUrl: string = Ratio.resName('icon_volume')
  @State des: string = '音效模式'
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  @State effect: string = '自动'
  effectsMap: Map<string, number> = new Map();
  private pageTranState: boolean = false; //判断是进场动效还是出场动效

  onPageHide(): void {
    this.pageTranState = false
  }

  pageTransition() {
    if (this.pageTranState) {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
    } else {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
    }
  }

  async aboutToAppear() {
    LogUtil.info('settings Effects EntryComponent aboutToAppear in');
    this.initEffectSettingList();
    this.initEffectOption();
  }
  initEffectSettingList() {
    let items: string[] = ['自动', '标准', '影院', '音乐', '新闻', '自定义音效'];
    items.forEach((name) => {
      let model: SettingItemTvModel = new SettingItemTvModel();
      model.name = name;
      this.effect=AppStorage.get('effect') as string
      if (name == this.effect) {
        model.setIsSelect(true);
      }
      model.style = SettingItemStyle.singleChoose;
      this.settingList.push(model);
    })

    let setting7 = new SettingItemTvModel();
    setting7.name = '自定义音效设置';
    setting7.style = SettingItemStyle.default;
    setting7.pageUrl = 'pages/volume/CustomEffects'

    this.settingList.push(setting7);
  }

  initEffectOption() {
    this.effectsMap.set('自动', 0);
    this.effectsMap.set('标准', 1);
    this.effectsMap.set('影院', 2);
    this.effectsMap.set('音乐', 3);
    this.effectsMap.set('新闻', 4);
    this.effectsMap.set('自定义音效', 5);
  }

  build() {
    Column() {
      Stack() {
        SettingBackground()
          .position({ x: 0, y: 0 })
          .height(ConfigData.WH_100_100)
          .width(ConfigData.WH_100_100)
        Row() {
          SettingListTvComponent({
            settingList: this.settingList,
            title: '音效模式',
            onClickHandle: (item: SettingItemTvModel) => {
            },
            onMouseClickHandle: async (item: SettingItemTvModel) => {
              if (item.pageUrl ) {
                if (this.effect != '自定义音效') {
                  promptAction.showToast({ message: '请选择自定义音效!' })
                }else {
                  router.pushUrl({
                    url: item.pageUrl
                  })
                  this.pageTranState = true
                }
              }
              if (item.name!='自定义音效设置') {
                this.effect=item.name
                try {
                  LogUtil.log(TAG+'setAudioEffectValue==:'+this.effectsMap.get(item.name));
                  let setAudioEffect:boolean =
                    await audioSetting.setAudioEffect(this.effectsMap.get(item.name) as number); // 调用厂商api
                  LogUtil.log(TAG+'setAudioEffect SuccessBoolean==:'+JSON.stringify(setAudioEffect));
                  if(!setAudioEffect){
                    promptAction.showToast({ message: `设置${item.name}失败` })
                  }
                } catch (error){
                  LogUtil.log(TAG + 'setAudioEffectFailed=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              }
            },
            onValueChangeLeftHandle: (item: SettingItemTvModel) => {
            },
            onValueChangeRightHandle: (item: SettingItemTvModel) => {
            },
            onKeyEventHandle: async (item: SettingItemTvModel, event: KeyEvent) => {
              if (item.pageUrl && event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Up) {
                if (this.effect != '自定义音效') {
                  promptAction.showToast({ message: '请选择自定义音效!' })
                }else {
                  router.pushUrl({
                    url: item.pageUrl
                  })
                  this.pageTranState = true
                }
              }
              if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Up&&item.name!='自定义音效设置') {
                this.effect=item.name
                try {
                  LogUtil.log(TAG+'setAudioEffectValue==:'+this.effectsMap.get(item.name));
                  let setAudioEffect:boolean =
                    await audioSetting.setAudioEffect(this.effectsMap.get(item.name) as number); // 调用厂商api
                  LogUtil.log(TAG+'setAudioEffect SuccessBoolean==:'+JSON.stringify(setAudioEffect));
                  if(!setAudioEffect){
                    promptAction.showToast({ message: `设置${item.name}失败` })
                  }
                } catch (error){
                  LogUtil.log(TAG + 'setAudioEffectFailed=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              }
            }
          })
            .width(ConfigData.WH_48_100)
            .height(ConfigData.WH_100_100)
            .margin({ left: lpx(84) })

          SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
            .width(ConfigData.WH_48_100)
            .height(ConfigData.WH_100_100)
        }
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
