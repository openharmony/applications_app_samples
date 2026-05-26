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
import { HMRouterMgr } from '@hadss/hmrouter';
import {
  DetailItemInfo,
  DeviceLibraryManager,
  DeviceSelectEnum,
  ItemTypeEnum
} from '../../viewmodel/DeviceLibraryManager';

/*
 * 设备库页面-单个设备组件
 * */
@Component
export struct DetailItem {
  @Prop deviceId: string;
  currentTab: DeviceSelectEnum = 0;
  @Prop item: DetailItemInfo;
  @State isSelected: boolean = false;
  focusCallable?: (focused: boolean) => void;
  onDirectionKeyEvent?: (event: KeyEvent) => boolean;

  aboutToAppear(): void {
  }

  build() {
    Column() {
      Row() {
        Image(this.item.itemType === ItemTypeEnum.PLACE_HOLDER_MORE ? $r('app.media.icon_more') :
        this.item?.device?.deviceIcons[0])
          .width('100%')
          .height('100%')
          .syncLoad(true)
          .borderRadius(px2vp(16))
          .autoResize(true)
          .sourceSize({ width: 200, height: 200 });
      }
      .borderRadius(px2vp(18))
      .width(px2vp(200))
      .height(px2vp(200))
      .padding(px2vp(4))
      .justifyContent(FlexAlign.Center)
      .border({ width: this.isSelected ? 2 : 0, color: Color.White });

      Text(this.item.itemType === ItemTypeEnum.PLACE_HOLDER_MORE ? $r('app.string.more') : this.item.title)
        .width(px2vp(200))
        .textAlign(TextAlign.Center)
        .fontSize(this.isSelected ? px2vp(30) : px2vp(28))
        .fontColor(this.isSelected ? $r('app.color.text_color_white') : $r('app.color.default_text_color'))
        .fontWeight(FontWeight.Medium)
        .margin({
          top: px2vp(10),
          bottom: px2vp(10)
        });
    }
    .id(this.deviceId)
    .onFocus(() => {
      this.isSelected = true;
      this.focusCallable && this.focusCallable(true);
    })
    .onBlur(() => {
      this.isSelected = false;
      this.focusCallable && this.focusCallable(false);
    })
    .onHover(() => {
      try {
        this.getUIContext().getFocusController().requestFocus(this.deviceId);
      } catch (e) {
        console.error(e);
      }
    })
    .margin({
      top: px2vp(10),
      bottom: px2vp(10)
    })
    .onClick(() => {
      //跳转到设备详情页
      if (this.item.itemType === ItemTypeEnum.PLACE_HOLDER_MORE) {
        DeviceLibraryManager.getInstance().selectItem = this.item;
        HMRouterMgr.push({
          pageUrl: 'MoreDevicePage', param: {
            selectTab: this.currentTab,
            sideIndex: this.item.sideIndex
          }
        });
      } else {
        DeviceLibraryManager.getInstance().selectItem = this.item;
        HMRouterMgr.push({ pageUrl: 'DeviceLibraryDetailPage' });
      }
    })
    .onKeyEvent((event) => {
      if (this.onDirectionKeyEvent && this.onDirectionKeyEvent(event)) {
        event.stopPropagation();
      }
    });
  }
}
