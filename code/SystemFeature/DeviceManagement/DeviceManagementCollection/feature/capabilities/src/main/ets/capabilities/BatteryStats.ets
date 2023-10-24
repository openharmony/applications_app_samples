/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import BatteryStatsUtil from '../util/BatteryStatsUtil';
import { BatteryStatsDataSource } from '../model/BatteryStatsDataSource';
import { BatteryStatsList } from '../components/batterystats/BatteryStatsList';

interface HeaderType {
  title: Resource
  visible: boolean
  callback: Function
}

@Preview
@Component
export struct BatteryStats {
  @State hardListData: BatteryStatsDataSource = new BatteryStatsDataSource([]);
  @State softListData: BatteryStatsDataSource = new BatteryStatsDataSource([]);
  @State hardTotal: string = '0';
  @State softTotal: string = '0';
  @State visibleHard: boolean = true;
  @State visibleSoft: boolean = true;
  private scroller: Scroller = new Scroller();

  async aboutToAppear() {
    let hardList = await BatteryStatsUtil.getHardwareListData();
    this.hardListData = new BatteryStatsDataSource(hardList);
    this.hardTotal = BatteryStatsUtil.getTotalPercent(this.hardListData.getList());

    let softList = await BatteryStatsUtil.getSoftListData();
    this.softListData = new BatteryStatsDataSource(softList);
    this.softTotal = BatteryStatsUtil.getTotalPercent(this.softListData.getList());
  }

  @Builder header($$: HeaderType) {
    Row() {
      Text($$.title)
        .fontSize(18)
        .fontColor($r("app.color.list_content"))
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)

      Image($$.visible ? $r("app.media.ic_arrow_up") : $r("app.media.ic_arrow_down"))
        .objectFit(ImageFit.Contain)
        .width(32)
        .height(32)
    }.margin({
      left: 16,
      right: 16,
      top: 16
    })
    .height(48)
    .onClick(() => {
      $$.callback();
    })
  }

  callback = ()=>{
    this.visibleHard = !this.visibleHard;
  }

  build() {
    Scroll(this.scroller) {
      Column() {
        this.header({
          title: $r('app.string.battery_stats_hardware', this.hardTotal),
          visible: this.visibleHard,
          callback: (): void => this.callback()
        })
        if (this.visibleHard) {
          BatteryStatsList({
            listData: this.hardListData
          })
        }


        this.header({
          title: $r("app.string.battery_stats_software", this.softTotal),
          visible: this.visibleSoft,
          callback: (): void => this.callback()
        })
        if (this.visibleSoft) {
          if (this.softListData.totalCount() > 0) {
            BatteryStatsList({
              listData: this.softListData
            })
          } else {
            LoadingProgress().width(100).height(100)
          }
        }
      }
      .margin(4)
    }
    .padding({
      bottom: 16
    })
    .scrollBar(BarState.Off)
    .scrollable(ScrollDirection.Vertical)
  }
}