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
import {
  DetailItemInfo,
  DeviceLibraryManager,
  DeviceMoreDataSource,
  DeviceSelectEnum,
  TabBarDataSource,
  TopTabItemInfo
} from '../../viewmodel/DeviceLibraryManager';
import { DetailMultipleComponent, DetailSingComponent } from '../library/DetailComponent';
import { HMPageParam, HMParamType, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { CommonConstants, PageViewUtils } from '@ohos/common';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { DetailListsComponent } from '../library/DetailListsComponent';
import { DetailItem } from '../library/DetailItem';

/*
 * 设备库页面UI组件
 * */
@HMRouter({ pageUrl: 'MoreDevicePage', singleton: true, lifecycle: 'MoreDevicePageLifecycle' })
@Component
export struct MoreDevicePage {
  @State tabTitle: ResourceStr = '';
  @State sideTitle: ResourceStr = '';
  private deviceColumns: number = 6;
  private selectTab: DeviceSelectEnum = 0;
  private sideIndex: number = 0;
  private moreDataSource?: DeviceMoreDataSource;

  aboutToAppear(): void {
    const params = HMRouterMgr.getCurrentParam(HMParamType.all) as HMPageParam;
    this.selectTab = params.data['selectTab'];
    this.sideIndex = params.data['sideIndex'];
    this.tabTitle = DeviceLibraryManager.getInstance().getTopListData()[this.selectTab].title;
    this.sideTitle = DeviceLibraryManager.getInstance().getSideDataArray(this.selectTab)[this.sideIndex];
    this.moreDataSource = new DeviceMoreDataSource(this.selectTab, this.sideIndex);
    this.moreDataSource?.loadData();
    PageViewUtils.tabClick();

  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Row() {
        Text(this.tabTitle)
          .fontSize(px2vp(36))
          .fontColor(Color.White)
          .textAlign(TextAlign.Start);
        Text(' > ')
          .fontSize(px2vp(36))
          .fontColor(Color.White)
          .textAlign(TextAlign.Start);
        Text(this.sideTitle)
          .fontSize(px2vp(36))
          .fontColor(Color.White)
          .textAlign(TextAlign.Start);
      }
      .width('100%');

      Grid() {
        LazyForEach(this.moreDataSource, (item: DetailItemInfo, index: number) => {
          GridItem() {
            DetailItem({
              item: item, focusCallable: (focused) => {
                if (focused) {
                }
              }
            });
          }.margin({ left: 10, top: 10, right: 10 })
          .focusBox({
            strokeWidth: LengthMetrics.px(0)
          });
        }, (item: DetailItemInfo, index?: number) => index + JSON.stringify(item));
      }
      .margin({ top: px2vp(54) })
      .cachedCount(40)
      .id('DetailList')
      .alignSelf(ItemAlign.Center)
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .scrollBar(BarState.Off)
      .columnsTemplate('1fr '.repeat(this.deviceColumns));
    }
    .width('100%')
    .height('100%')
    .padding({
      top: px2vp(54),
      bottom: px2vp(54),
      right: px2vp(76),
      left: px2vp(76),
    })
    .backgroundColor($r('app.color.page_background'));
  }
}