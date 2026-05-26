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

import { CommonConstants } from '@ohos/common';
import { curves } from '@kit.ArkUI';
import { AddDevicesManager } from '../viewmodel/AddDevicesManager';
import { AddDeviceItem } from '../viewmodel/AddDeviceItem';
import { HMRouterMgr } from '@hadss/hmrouter';
import { scale } from '../util/ScreenAdaptation';

export class ParamCls {
  public currentItem?: AddDeviceItem;
  public addDevicesModel?: AddDevicesManager;
}

@Component
export struct AddDevicesListView {
  @Consume addDevicesModel: AddDevicesManager;
  @State title: Resource = $r('app.string.add_device');
  //item转场效果
  private effect: object =
    TransitionEffect.OPACITY
      .combine(TransitionEffect.scale({ x: 0, y: 0 })
        .animation({
          curve: curves.springMotion(0.6, 1.2)
        }))
      .combine(TransitionEffect.translate({ x: scale(150), y: scale(150) })
        .combine(TransitionEffect.move(TransitionEdge.END))
        .animation({
          curve: curves.springMotion()
        }))
      .combine(TransitionEffect.asymmetric(TransitionEffect.scale({ x: 0, y: 0 }), TransitionEffect.rotate({
        angle: 90
      })));

  getRadiusConfig(index: number): BorderRadiuses | null {
    if (index == 0) {
      return {
        topLeft: $r('app.string.vp_20'),
        topRight: $r('app.string.vp_20'),
      };
    } else if (index == this.addDevicesModel.showDevices.totalCount() - 1) {
      return {
        bottomLeft: $r('app.string.vp_20'),
        bottomRight: $r('app.string.vp_20'),
      };
    } else {
      return null;
    }
  }

  @Builder
  getListItem(item: AddDeviceItem) {
    Row() {
      Image(item.getImageResource())
        .width($r('app.string.vp_25'))
        .height($r('app.string.vp_25'));

      Text(item.deviceName)
        .fontSize($r('app.string.fp_15'))
        .margin({
          left: $r('app.string.vp_10')
        })
        .layoutWeight(1)
        .align(Alignment.Start)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis });
      Button($r('app.string.add'))
        .fontSize($r('app.string.fp_12'))
        .fontColor($r('app.color.add_text_color'))
        .height($r('app.string.add_font_height'))
        .backgroundColor($r('app.color.add_button_backgroundColor'))
        .borderRadius($r('app.string.vp_14'));
    }
    .padding({
      left: $r('app.string.vp_12'),
      right: $r('app.string.vp_12'),
      top: $r('app.string.vp_6'),
      bottom: $r('app.string.vp_6')
    })
    .height($r('app.string.add_device_item_height'))
    .justifyContent(FlexAlign.SpaceBetween)
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .onClick(() => {
      HMRouterMgr.push({
        pageUrl: 'ConfigureDevicePage',
        param: { currentItem: item, addDevicesModel: this.addDevicesModel }
      });
    });
  }

  build() {
    Column() {
      List() {
        LazyForEach(this.addDevicesModel.showDevices, (item: AddDeviceItem) => {
          ListItem() {
            this.getListItem(item);
          }.transition(this.effect);
        }, (item: AddDeviceItem, index: number) => JSON.stringify(item) + index);
      }
      .divider({
        strokeWidth: $r('app.string.vp_1'),
        startMargin: $r('app.string.vp_60'),
        endMargin: $r('app.string.vp_10'),
        color: $r('app.color.divider_color')
      })
      .borderRadius($r('app.string.vp_14'))
      .backgroundColor($r('app.color.white'))
      .margin({ left: $r('app.string.vp_30'), right: $r('app.string.vp_30') })
      .scrollBar(BarState.Off);
    }.padding({ bottom: $r('app.string.vp_6') })
    .justifyContent(FlexAlign.Start)
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_WIDTH_PERCENT);
  }
}