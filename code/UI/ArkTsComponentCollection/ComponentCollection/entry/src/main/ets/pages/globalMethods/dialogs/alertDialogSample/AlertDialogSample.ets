/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

@Extend(Row) function rowStyle() {
  .width('100%')
  .borderRadius(24)
  .margin({ top: 8, bottom: 8 })
  .justifyContent(FlexAlign.SpaceBetween)
}

@Extend(Column) function columnStyle() {
  .width('100%')
  .borderRadius(24)
  .margin({ top: 8, bottom: 8 })
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor(Color.White)
  .padding(15)
}

@Extend(Button) function commonButtonStyle() {
  .margin(8)
  .fontSize(16)
  .layoutWeight(1)
  .fontColor($r('app.color.background_blue'))
  .backgroundColor($r('app.color.pop_up_background'))
  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
}

@Entry
@Component
struct WarningDialogSample {
  private mTextInputController: TextInputController = new TextInputController()

  build() {
    Column() {
      TitleBar({ title: $r('app.string.alert_dialog') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.alert_dialog_type') })
          Row() {
            Button($r('app.string.alert_dialog_type_one'))
              .commonButtonStyle()
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_type_one'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      backgroundColor: $r('app.color.background_grey'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_type_one'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    }
                  }
                )
              }).id('test_oneButton')
            Button($r('app.string.alert_dialog_type_two'))
              .commonButtonStyle()
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: $r('app.string.alert_dialog_warning'),
                    message: $r('app.string.alert_dialog_info'),
                    primaryButton: {
                      value: $r('app.string.alert_dialog_cancel'),
                      backgroundColor: $r('app.color.background_grey'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_type_two'))
                      }
                    },
                    secondaryButton: {
                      value: $r('app.string.alert_dialog_confirm'),
                      fontColor: Color.Red,
                      backgroundColor: $r('app.color.background_grey'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_type_two'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    }
                  }
                )
              }).id('test_twoButton')
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.alert_dialog_location') })
          Row() {
            Button($r('app.string.alert_dialog_top'))
              .commonButtonStyle()
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_top'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      backgroundColor: $r('app.color.background_grey'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_top'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    },
                    alignment: DialogAlignment.Top
                  }
                )
              }).id('test_topButton')
            Button($r('app.string.alert_dialog_center'))
              .commonButtonStyle()
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_center'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      backgroundColor: $r('app.color.background_grey'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_center'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    },
                    alignment: DialogAlignment.Center
                  }
                )
              }).id('test_centerButton')
            Button($r('app.string.alert_dialog_bottom'))
              .commonButtonStyle()
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_bottom'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      backgroundColor: $r('app.color.background_grey'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_bottom'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    },
                    alignment: DialogAlignment.Bottom
                  }
                )
              }).id('test_bottomButton')
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.alert_dialog_auto_cancel') })
          Row() {
            Button($r('app.string.alert_dialog_true'))
              .commonButtonStyle()
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
                        ShowToast.shortToast($r('app.string.alert_dialog_true'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    }
                  }
                )
              }).id('test_closeableButton')
            Button($r('app.string.alert_dialog_false'))
              .commonButtonStyle()
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
                        ShowToast.shortToast($r('app.string.alert_dialog_false'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    }
                  }
                )
              }).id('test_noCloseButton')
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.alert_dialog_offset') })
          Row() {
            Button($r('app.string.alert_dialog_left'))
              .commonButtonStyle()
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_left'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      backgroundColor: $r('app.color.background_grey'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_left'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    },
                    offset: { dx: -20, dy: -150 }
                  }
                )
              }).id('test_upperLeftButton')
            Button($r('app.string.alert_dialog_right'))
              .commonButtonStyle()
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_right'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      backgroundColor: $r('app.color.background_grey'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_right'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    },
                    offset: { dx: 50, dy: -50 }
                  }
                )
              }).id('test_lowRightButton')
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.alert_dialog_grid') })
          Row() {
            Button($r('app.string.alert_dialog_grid_two'))
              .commonButtonStyle()
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_grid_two'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      backgroundColor: $r('app.color.background_grey'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_grid_two'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    },
                    gridCount: 2
                  }
                )
              }).id('test_2GridButton')
            Button($r('app.string.alert_dialog_grid_three'))
              .commonButtonStyle()
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_grid_three'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      backgroundColor: $r('app.color.background_grey'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_grid_three'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    },
                    gridCount: 3
                  }
                )
              }).id('test_3GridButton')
            Button($r('app.string.alert_dialog_grid_four'))
              .commonButtonStyle()
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_grid_four'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      backgroundColor: $r('app.color.background_grey'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_grid_four'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    },
                    gridCount: 4
                  }
                )
              }).id('test_4GridButton')
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.avoiding_input_method_testing') })
          Column() {
            Row() {
              TextInput({
                controller: this.mTextInputController,
                placeholder: $r('app.string.avoiding_input_method_testing')
              })
                .layoutWeight(1).height(50).id('test_input')
            }.rowStyle()

            Row() {
              Button($r('app.string.alert_dialog_bottom'))
                .commonButtonStyle()
                .onClick(() => {
                  this.mTextInputController.setTextSelection(1, 2)
                  AlertDialog.show(
                    {
                      title: $r('app.string.alert_dialog_prompt'),
                      message: $r('app.string.alert_dialog_bottom'),
                      confirm: {
                        value: $r('app.string.alert_dialog_confirm'),
                        backgroundColor: $r('app.color.background_grey'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.alert_dialog_bottom'))
                        }
                      },
                      cancel: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                      },
                      alignment: DialogAlignment.Bottom
                    }
                  )
                }).id('test_bottomButton')
            }.rowStyle()
          }.columnStyle().margin({ bottom: 80 })
        }
        .padding(12)
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}