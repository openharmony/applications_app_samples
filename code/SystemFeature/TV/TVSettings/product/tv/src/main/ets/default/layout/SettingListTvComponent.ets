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

import { KeyCode } from '../../common/constants/KeyCode';
import { SettingItemStyle, SourcetoolConstants } from '../../common/constants/StyleConstants';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemTvComponent } from '../layout/SettingItemTvComponent';
import { SettingItemTvModel } from '../model/SettingItemTvModel';
import lpx from '../../common/Lpx';
import { sound } from '../../model/keyVolumeImpl/KeyControl';
import PreferenceUtils, { BooleanPreferences } from '../../common/UserStorageManager';
import { Content } from '@kit.ArkUI';
import { commonEventDataFunc, commonEvents} from '../../MainAbility/MainAbility';
import { EventUtil } from '../../common/EventUtil';
import { emitter } from '@kit.BasicServicesKit';
import { PointerUtil } from '../../common/PointerUtil';


@Extend(ListItem)
function settingListItemTvDefaultFancy() {
  .backgroundColor('#54575d')
  .height(lpx(50))
  .width(ConfigData.WH_100_100)
  .borderRadius(lpx(4))
}

let preDataFlush = new BooleanPreferences(getContext(Content))
preDataFlush.initialize();

const TAG = 'SettingListTvComponent';

@Component
export struct SettingListTvComponent {
  @Prop isEnable: boolean = true
  @Link settingList: SettingItemTvModel[]
  title: string | Resource = '';
  subTitle: string | Resource = '';
  isShowScrollBar: boolean = true
  isAmplifying: Boolean = false
  isAlignCenter: Boolean = false //内容、标题是否水平居中
  isFocusable: boolean = true
  @StorageLink('isVolumeOn') isVolumeOn: boolean = false
  @State focusIndex: number = -1
  private scroller: Scroller = new Scroller()
  @State listKey: string = 'listKey'
  @Prop isWifiNetwork: boolean = false;
  @State isLeft: boolean = false;
  @State isTouchImg: boolean = false;
  isAutoScreeOff: boolean = false;
  @State isLoading: boolean = false;
  isFirstTouchEvent: boolean = true;
  onClickHandle: Function = (item: SettingItemTvModel) => {
  }
  onKeyEventHandle: Function = (item: SettingItemTvModel, event: KeyEvent) => {
  }
  onToggleChangedHandle: Function = (item: SettingItemTvModel, isOn?: boolean) => {
  }
  onFocusHandle: Function = (item: SettingItemTvModel) => {
  }
  onMouseClickHandle: Function = (item: SettingItemTvModel) => {
  }
  onValueChangeLeftHandle: Function = (item: SettingItemTvModel) => {
  }
  onValueChangeRightHandle: Function = (item: SettingItemTvModel) => {
  }
  aboutToAppear() {
    LogUtil.info(TAG + ' aboutToAppear');
    if (this.isAutoScreeOff) {
      emitter.on('auto_screen_off', (data) => {
        let title: string = String(data?.data);
        if (this.title == title) {
          return
        }
        this.focusIndex = -1;
      })
    }
  }

  setHeight(item: SettingItemTvModel, index: number): number {
    if (this.focusIndex === index) {
      return 118
    }
    if (this.isAmplifying) {
      return 142
    } else {
      if (item.isNeedBg) {
        return 98
      } else {
        return 76
      }
    }
  }

  getStyle(item: SettingItemTvModel) {
    if (item.style === SettingItemStyle.ip) {
      return true;
    } else {
      return false;
    }
  }

  getEnable(item: SettingItemTvModel, index: number) {
    return index === 0 ? true : false;
  }

  onPageShow(): void {
    focusControl.requestFocus(this.title + '-0')
  }

  focusTo(id:string){
    try {
      focusControl.requestFocus(id)
    } catch (error) {
      console.log('SettingListTvComponent','定焦失败')
    }
  }

  build() {
    Column() {
      Text(this.title)
        .height(lpx(75))
        .lineHeight(lpx(75))
        .fontColor(Color.White)
        .fontSize(lpx(64))
        .fontWeight(FontWeight.Medium)
        .textAlign(this.isAlignCenter ? TextAlign.Center : TextAlign.Start)
        .margin({
          top: this.isAlignCenter ? lpx(97) : lpx(48),
          bottom: this.subTitle ? lpx(0) : lpx(48),
          left: lpx(12)
        })
        .visibility(this.title ? Visibility.Visible : Visibility.None)

      Text(this.subTitle)
        .height(lpx(35))
        .fontColor('#99ffffff')
        .fontSize(lpx(30))
        .align(Alignment.Center)
        .margin({
          right: lpx(24),
          top: lpx(36),
          bottom: lpx(36),
          left: lpx(12)
        })
        .visibility(this.subTitle ? Visibility.Visible : Visibility.None)


      List({ space: lpx(24), scroller: this.scroller }) {
        ForEach(this.settingList, (item: SettingItemTvModel, index: number) => {
          ListItem() {
            SettingItemTvComponent({
              title: this.title,
              isEnable: item.isEnable,//this.getEnable(item, index),
              model: item,
              singleChooseClick:this.onMouseClickHandle,
              onToggleChangedHandle: this.onToggleChangedHandle,
              onValueChangeLeftHandle:this.onValueChangeLeftHandle,
              onValueChangeRightHandle:this.onValueChangeRightHandle,
              isFocus: this.focusIndex === index,
              isLeft: this.isLeft,
              isTouchImg: this.isTouchImg,
            })
          }
          .visibility(item.isShow ? Visibility.Visible : Visibility.None)
          .height(lpx(this.setHeight(item, index)))
          .width(lpx(868))
          .margin({bottom:index==this.settingList.length-1?lpx(24):0})
          .border(this.focusIndex === index ? {
            width: lpx(2),
            color: Color.White,
            radius: lpx(24),
            style: BorderStyle.Solid
          } : { width: 0 })
          .id(this.title + '-' + index)
          .focusable(!item.isDisableFocus)
          .defaultFocus(this.getEnable(item, index))
          .onFocus(() => {
            if (this.onFocusHandle) {
              this.onFocusHandle(item);
            }
            animateTo({
              duration: 0
            }, () => {
              this.focusIndex = index;
            })
          })
          .onBlur(() => {
            this.focusIndex = -1;
          })
          .onKeyEvent(async (event) => {
            if (event === undefined) {
              return;
            }
            if (event?.type == KeyType.Up && this.isFirstTouchEvent) {
              this.isFirstTouchEvent = false;
              return;
            } else {
              this.isFirstTouchEvent = false;
            }
            if (this.isVolumeOn && event.type == KeyType.Up) {
              sound.playAudio()
            }
            if(event.keyCode === KeyCode.KEY_ENTER && globalThis.inSwitchForegrounding){
              LogUtil.warn('inSwitchForegrounding with KEY_ENTER');
              globalThis.inSwitchForegrounding = false
              return
            }
            // 回调
            this.onKeyEventHandle(item, event)
          })
          .onHover(() => {
            console.log('===setting-onHover')
            if (item.style == SettingItemStyle.hidden || item.name == '更多设置') {
              return;
            }

            if (!item.isDisableFocus) {
              if (this.onFocusHandle) {
                this.onFocusHandle(item);
              }
              this.focusIndex = index;
              this.focusTo(this.title + '-' + this.focusIndex.toString())
              console.log('===setting-onHover')
            }
            if (this.isAutoScreeOff) {
              emitter.emit('auto_screen_off', { data: this.title })
            }
          })
          .onTouch(async (event) => {
            if (event === undefined) {
              return;
            }
            if (item.isDisableFocus) {
              return;
            }else {
              if (event.type==TouchType.Down) {
                if (this.onFocusHandle) {
                  this.onFocusHandle(item);
                }
                this.focusIndex = index;
                this.focusTo(this.title + '-' + this.focusIndex.toString())
              }
            }
            if (!EventUtil.isTouchEvent(event)) {
              return;
            }
            if (!EventUtil.isPenOrMouseClick(event, SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK)) {
              return;
            }


            this.isFirstTouchEvent = true;
            if (this.isVolumeOn) {
              sound.playAudio()
            }

            let keyCode = KeyCode.KEY_ENTER;
            let keyType = KeyType.Up;
          })
          .onClick(async ()=>{
            if (!item.isDisableFocus) {
              if (this.onFocusHandle) {
                this.onFocusHandle(item);
              }
              this.focusIndex = index;
            }
            // 由于需要监听触控事件，移植到onclick
            if (item.style == SettingItemStyle.switch) {
                if (item.name === '蓝光过滤' || item.name === '护眼模式') {
                } else {
                  item.setIsOn(!item.isOn)
                }
                this.onToggleChangedHandle(item, item.isOn)
                return;
            } else if (item.style == SettingItemStyle.singleChoose) {
                for (let index = 0; index < this.settingList.length; index++) {
                  if (this.settingList[index].name == item.name) {
                    item.setIsSelect(true)
                    try {
                      let preInstance = new PreferenceUtils<string>(getContext(), 'HDMI1')
                      preInstance.setPreValue('inputSourceItem', item.name)
                      commonEvents(item.name)
                    } catch (e) {
                      LogUtil.info(TAG + ' build error: ' + e);
                    }
                  } else {
                    this.settingList[index].setIsSelect(false)
                  }
                }
              }
            this.onMouseClickHandle(item)
          })
        })
      }
      .scrollBar(BarState.Off)
      .alignListItem(this.isAlignCenter ? ListItemAlign.Center : ListItemAlign.Start)
    }
    .alignItems(this.isAlignCenter ? HorizontalAlign.Center : HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .padding(this.isAlignCenter ? { left: lpx(0), bottom: lpx(48) } : { bottom: lpx(48) })
  }
}
