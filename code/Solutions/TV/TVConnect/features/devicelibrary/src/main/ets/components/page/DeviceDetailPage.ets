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
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { NavBar, PageViewUtils } from '@ohos/common';
import { DetailItemInfo, DeviceDetailInfo, DeviceLibraryManager } from '../../viewmodel/DeviceLibraryManager';
import { KeyCode } from '@kit.InputKit';
import { LengthMetrics, router } from '@kit.ArkUI';

/*
 * 设备详情页
 * */
@HMRouter({ pageUrl: 'DeviceLibraryDetailPage' })
@Component
export struct DeviceDetailPage {
  @State egDivider: DividerTmp = new DividerTmp(1, 10, 10, '#ffe9f0f0');
  scroller: Scroller = new Scroller();
  @State deviceDetailInfo: DetailItemInfo | undefined = undefined;

  aboutToAppear(): void {
    setTimeout(() => {
      PageViewUtils.tabClick();
    }, 100);
    this.deviceDetailInfo = DeviceLibraryManager.getInstance().selectItem;
  }

  @Builder
  DeviceImage() {
    Row() {
      Row() {
        Image(this.deviceDetailInfo?.device?.deviceIcons[0]).width('100%').objectFit(ImageFit.Contain);
      }.padding(20).width(200).height(200);
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center);
  }

  @Builder
  DeviceInfoItem(item: [string, string]) {
    Row() {
      Text(item[0])
        .fontColor('#CDCDCD')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
        .textAlign(TextAlign.Start)
        .margin(10);
      Blank();
      Text(item[1])
        .fontColor('#CDCDCD')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
        .textAlign(TextAlign.End)
        .margin(10);
    }.width('50%').padding({ left: 10, right: 10 });
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
      Row() {
        Text(this.deviceDetailInfo?.title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .focusable(true)
          .focusBox({
            strokeWidth: LengthMetrics.px(0)
          })
          .onClick(() => {
            HMRouterMgr.pop();
          });
      }
      .width('100%')
      .justifyContent(FlexAlign.Center);

      this.DeviceImage();

      Column() {
        Row() {
          Text($r('app.string.device_information'))
            .margin({
              left: 20,
              right: 20,
              top: 10,
              bottom: 5
            })
            .fontSize(17)
            .fontColor('#CDCDCD')
            .fontWeight(FontWeight.Medium);
        }.width('100%');

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
          ForEach(new DeviceDetailInfo(this.deviceDetailInfo).infos, (item: [string, string]) => {
            this.DeviceInfoItem(item);
          });
        }
        .width('100%')
        .height('100%');
      }
      .width('100%')
      .height('35%')
      .height('35%')
      .borderRadius({ topLeft: 20, topRight: 20 })
      .backgroundColor('#3B3B3B')
      .padding({
        top: 10,
        bottom: 10,
        left: 10,
        right: 10
      });

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
    .padding({ top: $r('app.string.default_page_padding') })
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        HMRouterMgr.pop();
      }
    });
  }
}

/*
 * 分割线样式
 * */
class DividerTmp {
  public strokeWidth: Length = 1;
  public startMargin: Length = 10;
  public endMargin: Length = 10;
  public color: ResourceColor = '#ffe9f0f0';

  constructor(strokeWidth: Length, startMargin: Length, endMargin: Length, color: ResourceColor) {
    this.strokeWidth = strokeWidth;
    this.startMargin = startMargin;
    this.endMargin = endMargin;
    this.color = color;
  }
}