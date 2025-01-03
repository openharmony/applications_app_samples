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

import { ComponentCard } from '../../common/Card';

@Entry
@Component
export struct DataInGrid {
  @State services: Array<string> = ['Meeting', 'Voting', 'Check-in', 'Printing'];

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.DataInGrid_titleOfficeServices') }) {
          Grid() {
            GridItem() {
              Text('Meeting')
                .fontSize(24)
            }.backgroundColor('#FFF1F3F5')

            GridItem() {
              Text('Check-in')
                .fontSize(24)
            }.backgroundColor('#FFF1F3F5')

            GridItem() {
              Text('Voting')
                .fontSize(24)
            }.backgroundColor('#FFF1F3F5')

            GridItem() {
              Text('Printing')
                .fontSize(24)
            }.backgroundColor('#FFF1F3F5')
          }
          .height(200)
          .columnsGap(6)
          .rowsGap(6)
          .rowsTemplate('1fr 1fr')
          .columnsTemplate('1fr 1fr')
        }

        ComponentCard({ title: $r('app.string.DataInGrid_titleForEach') }) {
          Grid() {
            ForEach(this.services, (service: string) => {
              GridItem() {
                Text(service)
              }.backgroundColor('#FFF1F3F5')
            }, (service: string): string => service)
          }
          .height(200)
          .columnsGap(6)
          .rowsGap(6)
          .rowsTemplate(('1fr 1fr') as string)
          .columnsTemplate(('1fr 1fr') as string)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.DataInGrid_title'))
  }
}