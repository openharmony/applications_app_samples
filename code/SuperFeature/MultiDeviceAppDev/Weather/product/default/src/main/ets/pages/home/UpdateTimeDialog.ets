/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { getUpdateTimes, Style } from '@ohos/common'

@Preview
@CustomDialog
export default struct UpdateTimeDialog {
  private controller: CustomDialogController
  private updateTimes: string[] = getUpdateTimes()
  private handleCancelDialog: () => void
  @StorageLink('curBp') curBp: string = 'md'

  build() {
    GridRow({ columns: { sm: 4, md: 8, lg: 12 },
      gutter: { x: Style.GRID_GUTTER, y: Style.GRID_GUTTER },
      breakpoints: { reference: BreakpointsReference.WindowSize } }) {
      GridCol({ span: 4, offset: { sm: 0, md: 2, lg: 4 } }) {
        Row() {
          Column() {
            Text($r('app.string.update_time'))
              .width('100%')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 14 })
            List() {
              ForEach(this.updateTimes, (item, index) => {
                ListItem() {
                  UpdateTimeItem({index: index, updateTime: item})
                }
              }, item => item)
            }
            .lanes(this.curBp === 'lg' ? 2 : 1)
            .divider({ strokeWidth: 1 })
            .margin({ top: Style.TIME_LIST_MARGIN })
            .width('100%')
            .height(this.calcListHeight())

            Text($r('app.string.cancel'))
              .width('100%')
              .fontSize(16)
              .fontColor('#0A59F7')
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 9, bottom: 25 })
              .onClick(() => {
                this.handleCancelDialog()
              })
          }
          .padding({ left: Style.DIALOG_PADDING, right: Style.DIALOG_PADDING })
          .backgroundColor(Color.White)
          .borderRadius(24)
        }
        .height('100%')
        .alignItems(this.curBp === 'sm' ? VerticalAlign.Bottom : VerticalAlign.Center)
        .padding({
          left: Style.DIALOG_PADDING_OUT,
          right: Style.DIALOG_PADDING_OUT,
          bottom: this.curBp === 'sm' ? Style.DIALOG_PADDING_OUT : 0
        })
      }
    }
  }

  calcListHeight() {
    if (this.curBp === 'lg') {
      return Style.TIME_LIST_HEIGHT * this.updateTimes.length / 2 + Style.TIME_LIST_MARGIN
    } else {
      return Style.TIME_LIST_HEIGHT * this.updateTimes.length + Style.TIME_LIST_MARGIN
    }
  }
}

@Component
struct UpdateTimeItem {
  private index: number = 0
  private updateTime: string = ''
  @StorageLink('curBp') curBp: string = 'md'
  build() {
    Row() {
      Text(this.updateTime)
        .fontSize(16)
      Blank()
      Radio({ group: 'time', value: this.updateTime })
        .width(20)
        .height(20)
    }
    .width('100%')
    .height(Style.TIME_LIST_HEIGHT)
    .padding(this.curBp === 'lg' ? (this.index % 2 === 0 ? { right: 10 } : { left: 10 }) : 0)
  }
}