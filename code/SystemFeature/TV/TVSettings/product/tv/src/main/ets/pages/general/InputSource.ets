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
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import inputSourceModel from '../../model/general/InputSourceModel';
import displaySetting from '@ohos.tvservice.displaySetting';
import inputSourceOnModel from '../../model/general/InputSourceOnModel';
import { Duration } from '../../common/constants/Duration';
import { commonEventDataFunc, commonEvents } from '../../MainAbility/MainAbility';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { BooleanPreferences } from '../../common/UserStorageManager';
import { Content } from '@kit.ArkUI';

const EVENT_DEFAULT_INPUT_SRC: string = 'InputSourceType';
const TAG = 'DefaultInputSource'

interface srcTypeParam {
  inputSourceType: string;
  moduleName: string;
}

@Entry
@Component
struct InputSource {
  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  build() {
    Column() {
      InputSourceComponent()
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
let preDataFlush = new BooleanPreferences(getContext(Content))
preDataFlush.initialize();

@Component
struct InputSourceComponent {
  @State imageUrl: string = Ratio.resName('icon_inputsource')
  isShowScrollBar: boolean = false
  @State des: string = '输入源选项'
  @State focusIndex: number = -1
  @StorageLink('InputSourceOption') inputSourceOption: string = 'HDMI1'
  @State settingList: SettingItemTvModel[] = []
  @State inputSourceList: SettingItemTvModel[] = []
  irOptionMap: Map<string, number> = new Map();
  @State isInSourceEnabled: boolean = false;
  @State isOnTemp: boolean = false;
  scroller: Scroller = new Scroller();
  inputSrcSubscriber: commonEventManager.CommonEventSubscriber | undefined;
  onClickHandle: (item: SettingItemTvModel) => void = () => {
  }
  onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => void = () => {
  }
  onToggleChangedHandle: (item: SettingItemTvModel, isOn: boolean) => void = () => {
  }
  onFocusHandle: (item: SettingItemTvModel) => void = () => {
  }
  @State isOn: boolean = true;
  inputSourceMap: Map<string, number> = new Map();

  async aboutToAppear() {
    let inputSourceItem: string =
      await inputSourceModel.getInputSource() ? await inputSourceModel.getInputSource() : 'HDMI1'
    LogUtil.log(`${TAG}  1` + inputSourceItem);
    AppStorage.setOrCreate('inputSourceItem', inputSourceItem)
    commonEvents(inputSourceItem)
    this.isOnTemp = AppStorage.get('defaultInputSource') ? AppStorage.get('defaultInputSource') as boolean : false;
    this.initInputSourceList();
    this.initInsert()
    this.inputSrcSubscriber = commonEventManager.createSubscriberSync(this.subscribeInfo)
    commonEventManager.subscribe(this.inputSrcSubscriber,
      (error: BusinessError, data: commonEventManager.CommonEventData) => {
        if (data) {
          if (data.event === EVENT_DEFAULT_INPUT_SRC) {
            let eventSrcType = data.parameters as srcTypeParam
            let inputSourceType =
              (data.parameters as Record<string, string>)['InputSourceType'] ?? eventSrcType.inputSourceType
            console.log(TAG, 'InputSourceType: ' + inputSourceType)
            inputSourceModel.setInputSource(inputSourceType)
            this.inputSourceOption = inputSourceType
            AppStorage.set('inputSourceItem', inputSourceType)
          }
        }
      })
  }

  initInputSourceList() {
    this.settingList = [];
    let inputSourceItem = AppStorage.get('inputSourceItem') as string | undefined;
    this.inputSourceOption = inputSourceItem ? inputSourceItem : 'HDMI1';
    this.isOn = inputSourceOnModel.getInputStatus() === '1';

    let item0 = new SettingItemTvModel();
    item0.name = '开机默认进入输入源';
    item0.style = SettingItemStyle.switch;
    item0.value = this.des;
    item0.isOn = AppStorage.get('defaultInputSource') ? AppStorage.get('defaultInputSource') as boolean : this.isOnTemp;

    this.settingList.push(item0)
  }

  getSourceNameById(id: number): string {
    switch (id) {
      case 0:
        return 'MEDIA';
      case 1:
        return 'HDMI1';
      case 2:
        return 'HDMI2';
      case 3:
        return 'HDMI3';
      case 4:
        return 'HDMI4';
      case 5:
        return 'AV';
      case 6:
      case 7:
      case 8:
        return 'DTV';
      case 9: // 投屏
      case 10: // 图形输入
        return 'VGA';
      case 11: // 流媒体
      default:
        break;
    }
    return 'HDMI1';
  }

  async initInsert() {
    // 支持的源列表
    let supportSourceList: displaySetting.SourceType[] = []
    try {
      supportSourceList = await displaySetting.GetSupportSourceList()
      console.log('supportSourceList==' + JSON.stringify(supportSourceList))
      // 过滤掉MEDIA
      supportSourceList = supportSourceList.filter(sourceType => sourceType != 0)
      console.log('supportSourceList MEDIA==' + JSON.stringify(supportSourceList))
      const convertedArray = supportSourceList.map(id => this.getSourceNameById(id));
      console.log('supportSourceList convertedArray==' + JSON.stringify(convertedArray))
      convertedArray.forEach((name) => {
        let model: SettingItemTvModel = new SettingItemTvModel();
        model.name = name;
        let inputSourceItem = AppStorage.get('inputSourceItem') as string;
        if (name == inputSourceItem) {
          model.setIsSelect(true);
        }
        model.style = SettingItemStyle.singleChoose;
        model.isEnable = true
        model.isDisableFocus = false;
        this.inputSourceList.push(model)
      })
    } catch (err) {
      console.error('GetSupportSourceList err', JSON.stringify(err))
    }
  }

  updateAppList() {
    this.settingList.forEach((item: SettingItemTvModel, index: number) => {
      if (!this.settingList[0].isOn) {
        item.setIsSelect(false);
      }
      if (index > 1) {
        item.setIsDisableFocus(!this.settingList[0].isOn)
        item.setIsEnable(this.settingList[0].isOn)
      }
    })
  }

  subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      EVENT_DEFAULT_INPUT_SRC,
    ]
  };

  switchInputSourceActiveStatus() {
    this.isInSourceEnabled = !this.isInSourceEnabled;

    //todo: 待补充的输入源检测功能
  }

  build() {

    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        Column() {
          SettingListTvComponent({
            settingList: this.settingList,
            title: '输入源',
            onToggleChangedHandle: async (item: SettingItemTvModel) => {
              commonEventDataFunc(item.isOn)
              // 保存值
              await preDataFlush.saveBoolean('defaultInputSource',item.isOn);
              AppStorage.setOrCreate('defaultInputSource', item.isOn)

              this.isOnTemp = AppStorage.get('defaultInputSource') as boolean;
            },
            onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
              if (item.style == SettingItemStyle.switch) {
                if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Up) { // enter 点击中处理
                }
              }
              // 回调
              this.onKeyEventHandle(item, event)
            }
          })
            .height(lpx(350))

          if (this.isOnTemp) {
            SettingListTvComponent({
              settingList: this.inputSourceList,
              title: '',
              onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
                if (item.style == SettingItemStyle.singleChoose) {
                  if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Up) { // enter
                    for (let index = 0; index < this.inputSourceList.length; index++) {
                      if (this.inputSourceList[index].name == item.name) {
                        item.setIsSelect(true)
                        inputSourceModel.setInputSource(item.name)
                      } else {
                        this.inputSourceList[index].setIsSelect(false)
                      }
                    }
                  }
                }
                // 回调
                this.onKeyEventHandle(item, event)
              }
            })
              .layoutWeight(1)
          }
        }
        .width(ConfigData.WH_52_100)
        .height(ConfigData.WH_100_100)
        .padding({ left: lpx(84) })

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)

  }
}
