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

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import ShowToast from '../../../../util/ShowToast'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Row) function rowStyle () {
  .width('100%')
  .borderRadius(24)
  .margin({ top: 8, bottom: 8 })
  .justifyContent(FlexAlign.SpaceBetween)
}

@Extend(Button) function buttonStyle () {
  .margin(8)
  .fontSize(18)
  .fontColor($r('app.color.background_blue'))
  .backgroundColor($r('app.color.pop_up_background'))
  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
}

@Entry
@Component
struct WarningSample {
  build() {
    Column() {
      TitleBar({ title: $r('app.string.alert_dialog') })
      IntroductionTitle({ introduction: $r('app.string.alert_dialog_type') })
      Row() {
        Button($r('app.string.alert_dialog_type_one'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_prompt'),
                message: $r('app.string.alert_dialog_type_one'),
                confirm: {
                  value: $r('app.string.alert_dialog_confirm'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click confirm button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                }
              }
            )
          })
        Button($r('app.string.alert_dialog_type_two'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_warning'),
                message: $r('app.string.alert_dialog_info'),
                primaryButton: {
                  value: $r('app.string.alert_dialog_cancel'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click primary button', 100)
                  }
                },
                secondaryButton: {
                  value: $r('app.string.alert_dialog_confirm'),
                  fontColor: Color.Red,
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click secondary button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                }
              }
            )
          })
      }
      .rowStyle()

      IntroductionTitle({ introduction: $r('app.string.alert_dialog_location') })
      Row() {
        Button($r('app.string.alert_dialog_top'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_prompt'),
                message: $r('app.string.alert_dialog_top'),
                confirm: {
                  value: $r('app.string.alert_dialog_confirm'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click confirm button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                },
                alignment: DialogAlignment.Top
              }
            )
          })
        Button($r('app.string.alert_dialog_center'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_prompt'),
                message: $r('app.string.alert_dialog_center'),
                confirm: {
                  value: $r('app.string.alert_dialog_confirm'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click confirm button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                },
                alignment: DialogAlignment.Center
              }
            )
          })
        Button($r('app.string.alert_dialog_bottom'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_prompt'),
                message: $r('app.string.alert_dialog_bottom'),
                confirm: {
                  value: $r('app.string.alert_dialog_confirm'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click confirm button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                },
                alignment: DialogAlignment.Bottom
              }
            )
          })
      }
      .rowStyle()

      IntroductionTitle({ introduction: $r('app.string.alert_dialog_auto_cancel') })
      Row() {
        Button($r('app.string.alert_dialog_true'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_prompt'),
                message: $r('app.string.alert_dialog_true'),
                autoCancel: true,
                confirm: {
                  value: $r('app.string.alert_dialog_confirm'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click confirm button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                }
              }
            )
          })
        Button($r('app.string.alert_dialog_false'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_prompt'),
                message: $r('app.string.alert_dialog_false'),
                autoCancel: false,
                confirm: {
                  value: $r('app.string.alert_dialog_confirm'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click confirm button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                }
              }
            )
          })
      }
      .rowStyle()

      IntroductionTitle({ introduction: $r('app.string.alert_dialog_offset') })
      Row() {
        Button($r('app.string.alert_dialog_left'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_prompt'),
                message: $r('app.string.alert_dialog_left'),
                confirm: {
                  value: $r('app.string.alert_dialog_confirm'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click confirm button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                },
                offset: { dx: -20, dy: -150 }
              }
            )
          })
        Button($r('app.string.alert_dialog_right'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_prompt'),
                message: $r('app.string.alert_dialog_right'),
                confirm: {
                  value: $r('app.string.alert_dialog_confirm'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click confirm button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                },
                offset: { dx: 20, dy: 150 }
              }
            )
          })
      }
      .rowStyle()

      IntroductionTitle({ introduction: $r('app.string.alert_dialog_grid') })
      Row() {
        Button($r('app.string.alert_dialog_grid_two'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_prompt'),
                message: $r('app.string.alert_dialog_grid_two'),
                confirm: {
                  value: $r('app.string.alert_dialog_confirm'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click confirm button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                },
                gridCount: 2
              }
            )
          })
        Button($r('app.string.alert_dialog_grid_three'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_prompt'),
                message: $r('app.string.alert_dialog_grid_three'),
                confirm: {
                  value: $r('app.string.alert_dialog_confirm'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click confirm button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                },
                gridCount: 3
              }
            )
          })
        Button($r('app.string.alert_dialog_grid_four'))
          .buttonStyle()
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.alert_dialog_prompt'),
                message: $r('app.string.alert_dialog_grid_four'),
                confirm: {
                  value: $r('app.string.alert_dialog_confirm'),
                  backgroundColor: $r('app.color.background_grey'),
                  action: () => {
                    ShowToast.showToast('click confirm button', 100)
                  }
                },
                cancel: () => {
                  ShowToast.showToast('click cancel', 100)
                },
                gridCount: 4
              }
            )
          })
      }
      .rowStyle()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}