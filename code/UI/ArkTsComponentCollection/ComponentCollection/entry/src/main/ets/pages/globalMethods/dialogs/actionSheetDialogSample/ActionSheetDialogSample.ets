/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import ShowToast from '../../../../util/ShowToast';
import { TitleBar } from '../../../../common/TitleBar';

@Extend(Row) function rowStyle() {
  .width('94%')
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
  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
}

@Entry
@Component
struct ListDialogSample {
  private mTextInputController: TextInputController = new TextInputController()

  build() {
    Column() {
      TitleBar({ title: $r('app.string.action_sheet_dialog') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.alert_dialog_location') })
          Row() {
            Button($r('app.string.alert_dialog_top'))
              .commonButtonStyle()
              .onClick(() => {
                ActionSheet.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_top'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_top'))
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'))
                    },
                    sheets: [
                      {
                        title: $r('app.string.text_picker_text_apple'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_apple'))
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_banana'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_banana'))
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_peach'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_peach'))
                        }
                      }
                    ],
                    alignment: DialogAlignment.Top
                  }
                );
              })
              .id('sheet_topButton')
            Button($r('app.string.alert_dialog_center'))
              .commonButtonStyle()
              .onClick(() => {
                ActionSheet.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_center'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_center'));
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'));
                    },
                    sheets: [
                      {
                        title: $r('app.string.text_picker_text_apple'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_apple'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_banana'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_banana'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_peach'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_peach'));
                        }
                      }
                    ],
                    alignment: DialogAlignment.Center
                  }
                );
              })
              .id('sheet_centerButton')
            Button($r('app.string.alert_dialog_bottom'))
              .commonButtonStyle()
              .onClick(() => {
                ActionSheet.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_bottom'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_bottom'));
                      }
                    },
                    sheets: [
                      {
                        title: $r('app.string.text_picker_text_apple'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_apple'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_banana'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_banana'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_peach'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_peach'));
                        }
                      }
                    ],
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'));
                    },
                    alignment: DialogAlignment.Bottom
                  }
                );
              })
              .id('sheet_bottomButton')
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.alert_dialog_auto_cancel') })
          Row() {
            Button($r('app.string.alert_dialog_true'))
              .commonButtonStyle()
              .onClick(() => {
                ActionSheet.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_true'),
                    autoCancel: true,
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_true'));
                      }
                    },
                    sheets: [
                      {
                        title: $r('app.string.text_picker_text_apple'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_apple'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_banana'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_banana'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_peach'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_peach'));
                        }
                      }
                    ],
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'));
                    }
                  }
                );
              })
              .id('sheet_closeableButton')
            Button($r('app.string.alert_dialog_false'))
              .commonButtonStyle()
              .onClick(() => {
                ActionSheet.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_false'),
                    autoCancel: false,
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_false'));
                      }
                    },
                    sheets: [
                      {
                        title: $r('app.string.text_picker_text_apple'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_apple'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_banana'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_banana'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_peach'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_peach'));
                        }
                      }
                    ],
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'));
                    }
                  }
                );
              })
              .id('sheet_noCloseButton')
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.alert_dialog_offset') })
          Row() {
            Button($r('app.string.alert_dialog_left'))
              .commonButtonStyle()
              .onClick(() => {
                ActionSheet.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_left'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_left'));
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'));
                    },
                    alignment: DialogAlignment.Center,
                    sheets: [
                      {
                        title: $r('app.string.text_picker_text_apple'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_apple'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_banana'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_banana'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_peach'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_peach'));
                        }
                      }
                    ],
                    offset: { dx: -20, dy: -150 }
                  }
                );
              })
              .id('sheet_upperLeftButton')
            Button($r('app.string.alert_dialog_right'))
              .commonButtonStyle()
              .onClick(() => {
                ActionSheet.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.alert_dialog_right'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_right'));
                      }
                    },
                    cancel: () => {
                      ShowToast.shortToast($r('app.string.alert_dialog_cancel'));
                    },
                    sheets: [
                      {
                        title: $r('app.string.text_picker_text_apple'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_apple'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_banana'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_banana'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_peach'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_peach'));
                        }
                      }
                    ],
                    offset: { dx: 20, dy: -35 }
                  }
                );
              })
              .id('sheet_lowRightButton')
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.action_sheet_click_sheets') })
          Row() {
            Button($r('app.string.action_sheet_dialog_click_content'))
              .commonButtonStyle()
              .onClick(() => {
                ActionSheet.show(
                  {
                    title: $r('app.string.alert_dialog_prompt'),
                    message: $r('app.string.action_sheet_dialog_click_content'),
                    confirm: {
                      value: $r('app.string.alert_dialog_confirm'),
                      action: () => {
                        ShowToast.shortToast($r('app.string.action_sheet_dialog_click_content'));
                      }
                    },
                    alignment: DialogAlignment.Center,
                    sheets: [
                      {
                        title: $r('app.string.text_picker_text_apple'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_apple'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_banana'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_banana'));
                        }
                      },
                      {
                        title: $r('app.string.text_picker_text_peach'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.text_picker_text_peach'));
                        }
                      }
                    ]
                  }
                );
              })
              .id('sheet_click_contentButton')
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
                .id('btn_test_input')
                .commonButtonStyle()
                .onClick(() => {
                  this.mTextInputController.setTextSelection(1, 2)
                  ActionSheet.show(
                    {
                      title: $r('app.string.alert_dialog_prompt'),
                      message: $r('app.string.alert_dialog_bottom'),
                      confirm: {
                        value: $r('app.string.alert_dialog_confirm'),
                        action: () => {
                          ShowToast.shortToast($r('app.string.alert_dialog_bottom'));
                        }
                      },
                      sheets: [
                        {
                          title: $r('app.string.text_picker_text_apple'),
                          action: () => {
                            ShowToast.shortToast($r('app.string.text_picker_text_apple'));
                          }
                        },
                        {
                          title: $r('app.string.text_picker_text_banana'),
                          action: () => {
                            ShowToast.shortToast($r('app.string.text_picker_text_banana'));
                          }
                        },
                        {
                          title: $r('app.string.text_picker_text_peach'),
                          action: () => {
                            ShowToast.shortToast($r('app.string.text_picker_text_peach'));
                          }
                        }
                      ],
                      cancel: () => {
                        ShowToast.shortToast($r('app.string.alert_dialog_cancel'));
                      },
                      alignment: DialogAlignment.Bottom
                    }
                  );
                })
                .id('sheet_bottomButton')
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