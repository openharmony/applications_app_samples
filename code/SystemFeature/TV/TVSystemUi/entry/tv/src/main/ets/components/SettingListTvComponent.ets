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
 

import { SettingItemTvComponent } from './SettingItemTvComponent';
import { SettingItemTvModel } from '../model/SettingItemTvModel';
import lpx from '../utils/Lpx';
import { Content } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { KeyCode } from '@kit.InputKit';
import { SettingItemStyle, SourcetoolConstants } from '../utils/StyleConstants';
import { BooleanPreferences } from '../model/UserStorageManager';
import { EventUtil } from '../utils/EventUtil';

@Extend(ListItem)
function settingListItemTvDefaultFancy() {
  .backgroundColor('#54575d')
  .height('50lpx')
  .width('100%')
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
  onToggleChangedHandle: Function = (item: SettingItemTvModel, isOn: boolean) => {
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

  getEnable(item: SettingItemTvModel, index: number) {
    return index === 0 ? true : false;
  }

  onPageShow(): void {
    this.getUIContext().getFocusController().requestFocus(this.title +'-0')
  }
  focusTo(id:string){
    try {
      this.getUIContext().getFocusController().requestFocus(id)
    } catch (error) {
      console.log('SettingListTvComponent','定焦失败')
    }
  }

  build() {
    Column() {
      Text(this.title)
        .height(lpx(30))
        .lineHeight(lpx(30))
        .fontColor(Color.White)
        .fontSize(lpx(36))
        .fontWeight(FontWeight.Medium)
        .textAlign(this.isAlignCenter ? TextAlign.Center : TextAlign.Start)
        .margin({
          top: this.isAlignCenter ? lpx(97) : lpx(48),
          bottom: this.subTitle ? lpx(0) : lpx(48),
          left: lpx(12)
        })
        .visibility(this.title ? Visibility.Visible : Visibility.None)
      List({ space: '24lpx', scroller: this.scroller }) {
        ForEach(this.settingList, (item: SettingItemTvModel, index: number) => {
          ListItem() {
            SettingItemTvComponent({
              title: this.title,
              isEnable: item.isEnable, //this.getEnable(item, index),
              model: item,
              onValueChangeLeftHandle: this.onValueChangeLeftHandle,
              onValueChangeRightHandle: this.onValueChangeRightHandle,
              isFocus: this.focusIndex === index,
              isLeft: this.isLeft,
              isTouchImg: this.isTouchImg,
            })
          }
          .id(this.title + '-' + index)
          .backgroundColor(this.focusIndex === index ? '#333333' : Color.Transparent)
          .border({ width: 2, radius: '24lpx', color: this.focusIndex === index ? '#FFFFFF' : Color.Transparent })
          .padding('4lpx')
          .id(this.title + '-' + index)
          .focusable(true)
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

            // 回调
            this.onKeyEventHandle(item, event)
          })
          .onHover(() => {
            if (item.isEnable) {
              if (this.onFocusHandle) {
                this.onFocusHandle(item);
              }
              this.focusIndex = index;
              this.focusTo(this.title + '-' + this.focusIndex.toString())
            }
            if (this.isAutoScreeOff) {
              emitter.emit('auto_screen_off', { data: this.title })
            }
          })
          .onTouch(async (event) => {
            if (event.type == TouchType.Down) {
              if (this.onFocusHandle) {
                this.onFocusHandle(item);
              }
              this.focusIndex = index;
              this.focusTo(this.title + '-' + this.focusIndex.toString())
            }
            if (!EventUtil.isTouchEvent(event)) {
              return;
            }
            if (event.sourceTool !== SourceTool.Pen &&
              event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
              return;
            }

          })
          .onClick(() => {
            this.focusIndex = index;
            this.onMouseClickHandle(item)

          })
        })
      }
      .scrollBar(BarState.Off)
      .constraintSize({ maxHeight: '85%' })
      .width('100%')
      .alignListItem(this.isAlignCenter ? ListItemAlign.Center : ListItemAlign.Start)
    }
    .alignItems(this.isAlignCenter ? HorizontalAlign.Center : HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .padding(this.isAlignCenter ? { left: lpx(0) } : {})
  }
}