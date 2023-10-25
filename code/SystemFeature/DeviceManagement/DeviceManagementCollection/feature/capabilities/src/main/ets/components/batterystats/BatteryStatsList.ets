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

import { BatteryStatsModel } from '../../model/BatteryStatsModel';
import { BatteryStatsDataSource } from '../../model/BatteryStatsDataSource';

/**
 * 耗电信息统计列表
 */
@Component
export struct BatteryStatsList {
  private listData: BatteryStatsDataSource | undefined = undefined;

  build() {
    List() {
      if (this.listData !== undefined && this.listData !== null) {
        LazyForEach(this.listData, (item: BatteryStatsModel) => {
          ListItem() {
            Row() {
              Image(item.icon ? item.icon : item.iconBase64)
                .objectFit(ImageFit.Contain)
                .width(32)
                .height(32)
                .margin({
                  left: 16,
                  right: 16
                })
              Text(item.name ? item.name : item.nameStr)
                .fontSize(20)
                .fontWeight(FontWeight.Medium)
                .fontColor($r("app.color.list_title"))
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
                .layoutWeight(1)
              Text((item.percent * 100).toFixed(0) + '%')
                .fontSize(18)
                .fontColor($r("app.color.list_content"))
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
                .margin({
                  right: 16,
                })
            }
            .height(65)
          }
        }, (item: BatteryStatsModel, index: number) => index + JSON.stringify(item))
      }
    }
    .divider({
      strokeWidth: px2vp(1),
      color: '#f1f1f1',
      startMargin: 16,
      endMargin: 16
    })
    .backgroundColor($r("app.color.white"))
    .borderRadius(20)
  }
}