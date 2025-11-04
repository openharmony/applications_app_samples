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
import common from '@ohos.app.ability.common';
// [Start build_a_office_services_grid_of_foreach]
@Entry
@Component
export struct DataInGrid {
  @State services: Array<string> = [];
  // [StartExclude build_a_office_services_grid_of_foreach]
  aboutToAppear(): void {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const meeting = context.resourceManager.getStringByNameSync('Meeting')
    this.services.push(meeting)
    const check = context.resourceManager.getStringByNameSync('Check_in')
    this.services.push(check)
    const voting = context.resourceManager.getStringByNameSync('Voting')
    this.services.push(voting)
    const printing = context.resourceManager.getStringByNameSync('Printing')
    this.services.push(printing)
  }
  // [EndExclude build_a_office_services_grid_of_foreach]

  build() {
    // [StartExclude build_a_office_services_grid_of_foreach]
    NavDestination() {
      // [EndExclude build_a_office_services_grid_of_foreach]
      Column({ space: 12 }) {
        // [StartExclude build_a_office_services_grid_of_foreach]
        ComponentCard({ title: $r('app.string.DataInGrid_titleOfficeServices') }) {
          // $r('app.string.build_a_office_services_grid')需要替换为开发者所需的字符串资源
          // [Start build_a_office_services_grid]
          // [Start build_a_office_services_meeting]
          Grid() {
            GridItem() {
              // $r('app.string.Meeting')需要替换为开发者所需的资源文件
              Text($r('app.string.Meeting'))
              // [StartExclude build_a_office_services_meeting]
                .fontSize(24)
              // [EndExclude build_a_office_services_meeting]
            }

            GridItem() {
              // $r('app.string.Check_in')需要替换为开发者所需的资源文件
              Text($r('app.string.Check_in'))
              // [StartExclude build_a_office_services_meeting]
                .fontSize(24)
              // [EndExclude build_a_office_services_meeting]
            }

            GridItem() {
              // $r('app.string.Voting')需要替换为开发者所需的资源文件
              Text($r('app.string.Voting'))
              // [StartExclude build_a_office_services_meeting]
                .fontSize(24)
              // [EndExclude build_a_office_services_meeting]
            }

            GridItem() {
              // $r('app.string.Printing')需要替换为开发者所需的资源文件
              Text($r('app.string.Printing'))
              // [StartExclude build_a_office_services_meeting]
                .fontSize(24)
              // [EndExclude build_a_office_services_meeting]
            }
          }
          // [StartExclude build_a_office_services_meeting]
          // [StartExclude build_a_office_services_grid]
          .height(200)
          // [EndExclude build_a_office_services_grid]
          .columnsGap(6)
          .rowsGap(6)
          // [EndExclude build_a_office_services_meeting]
          .rowsTemplate('1fr 1fr')
          .columnsTemplate('1fr 1fr')
          // [End build_a_office_services_meeting]
          // [End build_a_office_services_grid]
        }

        // $r('app.string.DataInGrid_titleForEach')需要替换为开发者所需的资源文件
        ComponentCard({ title: $r('app.string.DataInGrid_titleForEach') }) {
          // [EndExclude build_a_office_services_grid_of_foreach]
          Grid() {
            ForEach(this.services, (service: string) => {
              GridItem() {
                Text(service)
              }.backgroundColor('#FFF1F3F5')
            }, (service: string): string => service)
          }
          .rowsTemplate(('1fr 1fr') as string)
          .columnsTemplate(('1fr 1fr') as string)
          // [StartExclude build_a_office_services_grid_of_foreach]
          .height(200)
          .columnsGap(6)
          .rowsGap(6)
          // [EndExclude build_a_office_services_grid_of_foreach]
        }
      }
      // [End build_a_office_services_grid_of_foreach]
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.DataInGrid_title'))
  }
}