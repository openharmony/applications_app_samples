'use static'
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

import { Entry, Text, Column, Component, $r, List, ListItem, LengthMetrics } from '@kit.ArkUI';
import { CustomCard } from './Card';

@Entry
@Component
struct Index {
  contentList: Map<string, string> = new Map<string, string>([
    ['出行前第7天', '确定旅行目的地,出行方式(自家/高铁/飞机)'],
    ['出行前第6天', '预定往返交通票,目的地住宿.预约热门经典门票,规划行程路线'],
    ['出行前第5天', '检查各种证件,充电宝等必备物品.列出物资清单(衣物,洗漱用品,常用药物)'],
  ]);

  build() {
    Column() {
      Text('行程规划')
        .height(44)
      List() {
        this.contentList.forEach((value: string, key: string) => {
          ListItem() {
            // 进行自定义组件调用
            CustomCard({ title: `${key}`, description: `${value}` })
          }
          .width('100%')
          .padding({ top: 10 })
        })
      }
      .padding({ start: LengthMetrics.vp(16), end: LengthMetrics.vp(16), bottom: LengthMetrics.vp(44) })
      .height('100%')
      .width('100%')
      .backgroundColor($r('sys.color.comp_background_focus'))
    }
  }
}