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
import { CommonConstants } from '../../constants/CommonConstants';
import { DeviceLibraryManager, SideListDataSource, TopTabItemInfo } from '../../viewmodel/DeviceLibraryManager';
import emitter from '@ohos.events.emitter';
import { LengthMetrics } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import { Logger } from '@ohos/common';
import { FocusLayerType } from '../page/DeviceLibraryPage';

const SUB_MENU_PREFIX = 'subMenuLevel_';
const TAG = 'device_sub_menu';

/*
 * 侧边栏组件
 * */
@Component
export struct SideListComponent {
  @Consume scrollerIndex: number;
  @Prop currentTab: number = 0;
  @Link @Watch('sideScroller') sideListIndex: number;
  private currentSideListData = new SideListDataSource(this.currentTab);
  private scroller: Scroller = new Scroller();
  @Consume isFou: boolean;
  @Consume @Watch('focusLayerChange') focusLayers: FocusLayerType;
  @State focusIndex: number = -1;

  focusLayerChange() {
    Logger.info(TAG, 'focus layer change to =' + this.focusLayers + '    tab = ' + this.currentTab);
    if (this.focusLayers === FocusLayerType.SUB_MENU && this.scrollerIndex === this.currentTab) {
      this.requestFocusBtn(this.sideListIndex);
    }
  }

  requestFocusBtn(index: number): boolean {
    Logger.info(TAG, 'requestFocusBtn to =' + index);
    let isSuccess = focusControl.requestFocus(`${SUB_MENU_PREFIX}${index}`);
    if (isSuccess) {
    } else {
      Logger.error(TAG, `requestFocus is failed , focusIndex = ${SUB_MENU_PREFIX}${index}`);
    }
    return isSuccess;
  }

  directionKeyEvent(e: KeyEvent, index: number): boolean {
    if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
      if (index > 0) {
        index--;
        this.requestFocusBtn(index);
        return true;
      } else if (index === 0) {
        this.focusLayers = FocusLayerType.MAIN_MENU;
        return true;
      }
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
      if (index < this.currentSideListData.totalCount() - 1) {
        index++;
        this.requestFocusBtn(index);
        return true;
      }
    }

    if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
      this.focusLayers = FocusLayerType.DEVICE_LIST;
      return true;
    }
    return false;
  }

  aboutToAppear(): void {
    this.currentSideListData.loadData();
    emitter.on({ eventId: DeviceLibraryManager.EMITTER_DEVICE_LIBRARY_UPDATE_EVENT }, () => {
      this.currentSideListData.loadData();
    });
  }

  aboutToDisappear(): void {
    emitter.off(DeviceLibraryManager.EMITTER_DEVICE_LIBRARY_UPDATE_EVENT);
  }

  private sideScroller() {
    Logger.info(TAG, 'sideScroller to =' + this.sideListIndex);
    this.scroller.scrollToIndex(this.sideListIndex, true, ScrollAlign.CENTER);
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      List({ scroller: this.scroller }) {
        LazyForEach(this.currentSideListData, (item: string, index: number) => {
          ListItem() {
            Column() {
              Text(item)
                .id(`${SUB_MENU_PREFIX}${index}`)
                .fontColor(this.focusIndex == index ? $r('app.color.text_color_focus') :
                $r('app.color.default_text_color'))
                .fontSize(this.focusIndex == index ? 18 : 16)
                .textAlign(TextAlign.Start)
                .onClick(() => {
                  this.sideListIndex = index;
                  let info = new TopTabItemInfo();
                  info.index = index;
                  info.title = item;
                  DeviceLibraryManager.getInstance().dispatchSideClickListener(this.currentTab, info);
                })
                .focusable(true)
                .focusBox({
                  strokeWidth: LengthMetrics.px(0)
                })
                .onFocus(() => {
                  this.focusIndex = index;
                })
                .onBlur(() => {
                  this.focusIndex = -1;
                })
                .onHover(() => {
                  this.getUIContext().getFocusController().requestFocus(`${SUB_MENU_PREFIX}${index}`);
                })
                .onKeyEvent((e) => {
                  if (this.directionKeyEvent(e, index)) {
                    e.stopPropagation();
                  }
                });
            }
            .padding({ bottom: px2vp(10) })
            .borderWidth({ bottom: this.sideListIndex == index ? 3 : 0 })
            .borderStyle(BorderStyle.Solid)
            .borderColor(this.focusIndex == index ? $r('app.color.text_color_focus') :
            $r('app.color.default_text_color'));
          }
          .width('90%')
          .padding({ bottom: px2vp(40) })
          .align(Alignment.Start)
          .focusable(true)
          .onFocus(() => {
            this.isFou = false;
            this.sideListIndex = index;
            let info = new TopTabItemInfo();
            info.index = index;
            info.title = item;
            DeviceLibraryManager.getInstance().dispatchSideClickListener(this.currentTab, info);
          });
        }, (item: string, index?: number) => index + JSON.stringify(item));
      }
      .constraintSize({
        minWidth: 50
      })
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .height(CommonConstants.FULL_HEIGHT_PERCENT)
      .scrollBar(BarState.Off);

      /*
       * 侧边栏与设备列表之间的分割线
       * */
      Divider()
        .vertical(true)
        .color($r('app.color.side_list_divider'))
        .strokeWidth(CommonConstants.DIVIDER_STROKE_WIDTH)
        .margin({ left: 5, right: 5 });
    }.focusScopeId('SideList', true).padding({ top: px2vp(40) });
  }
}
