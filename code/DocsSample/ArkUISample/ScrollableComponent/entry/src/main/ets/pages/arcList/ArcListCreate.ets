/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute } from '@kit.ArkUI';
import { ComponentCard } from '../../common/Card';

@Entry
@Component
export struct ArcListCreate {
  private watchSize: string = '466px'; // 手表默认宽高：466*466

  build() {
    NavDestination() {
      Column() {
        ComponentCard({ title: $r('app.string.ArcListCreate_title') }) {
          Stack() {
            // [Start arcList_create_start]
            ArcList({
              initialIndex: 2
            }) {
              ArcListItem() {
                // [StartExclude arcList_create_start]
                Row() {
                  Text($r('app.string.First_subassembly')).fontSize('38px').fontColor('#FFFFFFFF')
                }
                // [EndExclude arcList_create_start]
              }
              ArcListItem() {
                // [StartExclude arcList_create_start]
                Row() {
                  Text($r('app.string.Second_subassembly')).fontSize('38px').fontColor('#FFFFFFFF')
                }
                // [EndExclude arcList_create_start]
              }
              // [StartExclude arcList_create_start]
              ArcListItem() {
                Row() {
                  Text($r('app.string.Third_subassembly')).fontSize('38px').fontColor('#FFFFFFFF')
                }
              }
              // [EndExclude arcList_create_start]
            }
            // [End arcList_create_start]
            .digitalCrownSensitivity(CrownSensitivity.MEDIUM)
            .space(LengthMetrics.px(10))
            .scrollBarWidth(LengthMetrics.px(10))
            .scrollBarColor(ColorMetrics.resourceColor(Color.White))
            .borderRadius(this.watchSize)
          }
          .align(Alignment.Center)
          .width(this.watchSize)
          .height(this.watchSize)
          .borderRadius(this.watchSize)
          .backgroundColor(Color.Black)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ArcListCreate_title'))
  }
}