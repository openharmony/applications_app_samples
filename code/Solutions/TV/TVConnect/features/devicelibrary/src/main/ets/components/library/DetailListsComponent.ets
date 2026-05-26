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
import { DetailItem } from './DetailItem';
import {
  DetailItemInfo,
  DeviceLibraryDataSource,
  DeviceLibraryManager,
  DeviceSelectEnum,
  ItemTypeEnum,
  TopTabItemInfo,
} from '../../viewmodel/DeviceLibraryManager';
import emitter from '@ohos.events.emitter';
import { LengthMetrics } from '@kit.ArkUI';
import { Logger } from '@ohos/common';
import { KeyCode } from '@kit.InputKit';
import { FocusLayerType } from '../page/DeviceLibraryPage';

const DEVICE_PREFIX = 'device_';
const TAG = 'device_item';

/*
 * 设备库页面所有设备列表组件
 * */
@Component
export struct DetailListsComponent {
  @Prop currentTab: number = 0;
  @Prop deviceColumns: number = 5;
  private currentContentData = new DeviceLibraryDataSource(this.currentTab);
  @Link sideListIndex: number;
  scroller: Scroller | undefined = undefined;
  @Consume @Watch('focusLayerChange') focusLayers: FocusLayerType;

  focusLayerChange() {
    if (this.focusLayers === FocusLayerType.DEVICE_LIST) {
      this.requestFocusBtn(this.sideListIndex, 0);
    }
  }

  requestFocusBtn(sideIndex: number, subIndex: number): boolean {
    const focusId: string = `${DEVICE_PREFIX}${sideIndex}_${subIndex}`;
    let isSuccess = focusControl.requestFocus(focusId);
    if (isSuccess) {
      setTimeout(() => {
        let index = this.currentContentData.getAllData().findIndex((data) => {
          return data.sideIndex === sideIndex && data.subIndex === subIndex && data.itemType !== ItemTypeEnum.TITLE_ITEM;
        });
        Logger.info(TAG, `requestFocus scrollToIndex = ${index}  focusId = ${focusId}`);
        index !== -1 && this.scroller?.scrollToIndex(index, true, ScrollAlign.CENTER);
      }, 50);
    } else {
      Logger.error(TAG, `requestFocus is failed , focusIndex = ${focusId}`);
    }
    return isSuccess;
  }

  directionKeyEvent(e: KeyEvent, item: DetailItemInfo): boolean {
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
      if (item.subIndex % this.deviceColumns > 0) {
        this.requestFocusBtn(item.sideIndex, item.subIndex - 1);
      } else {
        if (this.currentTab !== DeviceSelectEnum.CERTIFIED) {
          this.focusLayers = FocusLayerType.SUB_MENU;
        }
      }
      return true;
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
      if ((item.subIndex + 1) % this.deviceColumns > 0) {
        this.requestFocusBtn(item.sideIndex, item.subIndex + 1);
      }
      return true;
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
      const upItem = this.getUpItem(item);
      if (upItem) {
        this.requestFocusBtn(upItem.sideIndex, upItem.subIndex);
      } else {
        this.focusLayers = FocusLayerType.MAIN_MENU;
      }
      return true;
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
      const downItem = this.getDownItem(item);
      if (downItem) {
        this.requestFocusBtn(downItem.sideIndex, downItem.subIndex);
      }
    }
    return false;
  }

  findNextItemId(item: DetailItemInfo, keycode: KeyCode): string | undefined {
    if (keycode === KeyCode.KEYCODE_DPAD_LEFT) {
      if (item.subIndex % this.deviceColumns > 0) {
        return `${DEVICE_PREFIX}${item.sideIndex}_${item.subIndex - 1}`;
      }
    }
    if (keycode === KeyCode.KEYCODE_DPAD_RIGHT) {
      if ((item.subIndex + 1) % this.deviceColumns > 0) {
        return `${DEVICE_PREFIX}${item.sideIndex}_${item.subIndex + 1}`;
      }
    }
    if (keycode === KeyCode.KEYCODE_DPAD_UP) {
      const upItem = this.getUpItem(item);
      if (upItem) {
        return `${DEVICE_PREFIX}${upItem.sideIndex}_${upItem.subIndex}`;
      }
    }
    if (keycode === KeyCode.KEYCODE_DPAD_DOWN) {
      const downItem = this.getDownItem(item);
      if (downItem) {
        return `${DEVICE_PREFIX}${downItem.sideIndex}_${downItem.subIndex}`;
      }
    }

    return undefined;
  }

  /**
   * 查找上方设备，无设备返回undefined,有设备优先返回正上方设备，正上方没有返回上面一行行末设备
   * @param item
   * @returns
   */
  getUpItem(item: DetailItemInfo): DetailItemInfo | undefined {
    const currentSideData = this.currentContentData.getSideData(item.sideIndex);
    if (currentSideData) {
      if (item.subIndex >= this.deviceColumns) {
        return currentSideData[item.subIndex - this.deviceColumns];
      } else {
        let upSideData = this.currentContentData.getSideData(item.sideIndex - 1);
        if (upSideData) {
          if (upSideData.length > this.deviceColumns) {
            upSideData = upSideData.slice(this.deviceColumns);
          }
          return upSideData[Math.min(item.subIndex, upSideData.length - 1)];
        }
      }
    }
    return undefined;
  }

  /**
   * 查找下方设备，无设备返回undefined,有设备优先返回正下方设备，正下方没有返回下面一行行末设备
   * @param item
   * @returns
   */
  getDownItem(item: DetailItemInfo): DetailItemInfo | undefined {
    const currentSideData = this.currentContentData.getSideData(item.sideIndex);
    if (currentSideData) {
      if (item.subIndex < this.deviceColumns && currentSideData.length > this.deviceColumns) {
        const downRow = currentSideData.slice(this.deviceColumns);
        return downRow[Math.min(item.subIndex, downRow.length - 1)];
      } else {
        const downSideData = this.currentContentData.getSideData(item.sideIndex + 1);
        if (downSideData) {
          return downSideData[Math.min(item.subIndex % this.deviceColumns, downSideData.length - 1)];
        }
      }
    }
    return undefined;
  }

  async scrollList(info: TopTabItemInfo) {
    let index = this.currentContentData.getAllData().findIndex((data) => data.title == info.title);
    this.scroller?.scrollToIndex(index, true, ScrollAlign.START);
  }

  aboutToAppear(): void {
    this.currentContentData.reloadData();
    DeviceLibraryManager.getInstance().registerSideClickListener(this.currentTab, (info: TopTabItemInfo) => {
      if (this.focusLayers !== FocusLayerType.DEVICE_LIST) {
        this.scrollList(info);
      }
    });
    emitter.on({ eventId: DeviceLibraryManager.EMITTER_DEVICE_LIBRARY_UPDATE_EVENT }, () => {
      this.currentContentData.reloadData();
    });
  }

  aboutToDisappear(): void {
    DeviceLibraryManager.getInstance().unRegisterSideClickListener(this.currentTab);
    emitter.off(DeviceLibraryManager.EMITTER_DEVICE_LIBRARY_UPDATE_EVENT);
  }

  build() {
    Grid(this.scroller) {
      LazyForEach(this.currentContentData, (item: DetailItemInfo, index: number) => {
        if (item.itemType == ItemTypeEnum.TITLE_ITEM) {
          GridItem() {
            Row() {
              Text(item.title)
                .height(22)
                .fontSize(16)
                .fontColor('#C0C7D9')
                .fontWeight(CommonConstants.DETAIL_LIST_FONT_WEIGHT);
            }
            .width(CommonConstants.FULL_WIDTH_PERCENT)
            .justifyContent(FlexAlign.Start);
          }
          .margin({ left: 10, top: 10, right: 10 })
          .columnStart(0)
          .columnEnd(this.deviceColumns - 1);
        } else {
          GridItem() {
            DetailItem({
              deviceId: `${DEVICE_PREFIX}${item.sideIndex}_${item.subIndex}`,
              currentTab: this.currentTab,
              item: item,
              focusCallable: (focused) => {
                if (focused) {
                  this.sideListIndex = item.sideIndex;
                }
              },
              onDirectionKeyEvent: (event) => {
                return this.directionKeyEvent(event, item);
              }
            });
          }.margin({ left: 10, top: 10, right: 10 })
          .focusBox({
            strokeWidth: LengthMetrics.px(0)
          });
        }
      }, (item: DetailItemInfo, index?: number) => index + JSON.stringify(item));
    }
    .cachedCount(30)
    .id('DetailList')
    .alignSelf(ItemAlign.Center)
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height('100%')
    .scrollBar(BarState.Off)
    .columnsTemplate('1fr '.repeat(this.deviceColumns));
  }
}
