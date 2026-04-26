/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Log from '../../../../../../../common/src/main/ets/default/Log';
import HeadComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/headComponent';
import ConfigData from '../common/constants';
import { deviceInfo } from '@kit.BasicServicesKit';
import { concatTime } from '../../../../../../../common/src/main/ets/default/TimeManager';
import ItemComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/itemComponent';
import {
  DoNotDisturbType
} from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/common/constants';
import NoDisturbingModel
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/noDisturbingModel';
import ViewModel from '../vm/noDisturbViewModel';

const deviceTypeInfo = deviceInfo.deviceType;
const TAG = 'NotificationManagement-NoDisturb';
const GROUP_REPEAT_MODE = 'repeatMode';

@Entry
@Component
export default struct NoDisturb {
  @State @Watch('onChange') mViewModel: ViewModel = new ViewModel();
  @State headName: Resource = $r('app.string.noDisturb');
  @State repeatTitle: Resource = $r('app.string.repeat');
  @State startDateTitle: Resource = $r('app.string.startDate');
  @State endDateTitle: Resource = $r('app.string.endDate');
  @State startTitle: Resource = $r('app.string.startTime');
  @State endTitle: Resource = $r('app.string.endTime');
  @State arrow: Resource = $r('app.media.ic_settings_arrow');
  @State repeatName: Resource | string = this.mViewModel.repeatName
  @State startDateClue: string = this.mViewModel.startDateClue
  @State startTimeClue: string = this.mViewModel.startTimeClue
  @State endDateClue: string = this.mViewModel.endDateClue
  @State endTimeClue: string = this.mViewModel.endTimeClue
  mPrevData: string = '';

  onChange() {
    this.repeatName = this.mViewModel.repeatName
    this.startDateClue = this.mViewModel.startDateClue
    this.startTimeClue = this.mViewModel.startTimeClue
    this.endDateClue = this.mViewModel.endDateClue
    this.endTimeClue = this.mViewModel.endTimeClue
    Log.showInfo(TAG, `mViewModel onChange repeatName: ${this.mViewModel.repeatName} startDateClue: ${this.mViewModel.startDateClue}
        endDateClue: ${this.mViewModel.endDateClue} endTimeClue: ${this.mViewModel.endTimeClue}`)
  }

  startDateDialogController: CustomDialogController = new CustomDialogController({
    builder: DateDialog({
      action: (data: string): void => this.setStartDate(data),
      title: $r('app.string.startDate'),
      defaultDate: this.mViewModel.defaultStartTime
    }),
    autoCancel: false,
    cancel: () => this.mViewModel.onCancel(),
    alignment: deviceTypeInfo === 'phone' ? DialogAlignment.Bottom : DialogAlignment.Center,
    offset: ({ dx: 0, dy: deviceTypeInfo === 'phone' ? '-16dp' : 0 }),
    customStyle: true
  });
  startTimeDialogController: CustomDialogController = new CustomDialogController({
    builder: TimeDialog({
      action: (data: string): void => this.setStartTime(data),
      title: $r('app.string.startTime'),
      defaultDate: this.mViewModel.defaultStartTime
    }),
    autoCancel: false,
    cancel: () => this.mViewModel.onCancel(),
    alignment: deviceTypeInfo === 'phone' ? DialogAlignment.Bottom : DialogAlignment.Center,
    offset: ({ dx: 0, dy: deviceTypeInfo === 'phone' ? '-16dp' : 0 }),
    customStyle: true
  });
  endDateDialogController: CustomDialogController = new CustomDialogController({
    builder: DateDialog({
      action: (data: string): void => this.setEndDate(data),
      title: $r('app.string.endDate'),
      defaultDate: this.mViewModel.defaultEndTime
    }),
    autoCancel: false,
    cancel: () => this.mViewModel.onCancel(),
    alignment: deviceTypeInfo === 'phone' ? DialogAlignment.Bottom : DialogAlignment.Center,
    offset: ({ dx: 0, dy: deviceTypeInfo === 'phone' ? '-16dp' : 0 }),
    customStyle: true
  });
  endTimeDialogController: CustomDialogController = new CustomDialogController({
    builder: TimeDialog({
      action: (data: string): void => this.setEndTime(data),
      title: $r('app.string.endTime'),
      defaultDate: this.mViewModel.defaultEndTime
    }),
    autoCancel: false,
    cancel: () => this.mViewModel.onCancel(),
    alignment: deviceTypeInfo === 'phone' ? DialogAlignment.Bottom : DialogAlignment.Center,
    offset: ({ dx: 0, dy: deviceTypeInfo === 'phone' ? '-16dp' : 0 }),
    customStyle: true
  });
  repeatDialogController: CustomDialogController = new CustomDialogController({
    builder: RepeatModeDialog({
      action: (data: number): void => this.setRepeatMode(data),
      title: $r('app.string.repeat'),
      selectMode: this.mViewModel.repeatMode
    }),
    autoCancel: false,
    cancel: () => this.mViewModel.onCancel(),
    alignment: deviceTypeInfo === 'phone' ? DialogAlignment.Bottom : DialogAlignment.Center,
    offset: ({ dx: 0, dy: 0 }),
    customStyle: true
  });

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Column() {
        GridContainer({
          columns: 12,
          sizeType: SizeType.Auto,
          gutter: vp2px(1) === 2 ? '12vp' : '0vp',
          margin: vp2px(1) === 2 ? '12vp' : '0vp'
        }) {
          Row() {
            Column() {
              HeadComponent({ headName: $headName, isActive: true })
              Row() {
                ItemComponent({
                  title: $repeatTitle,
                  value: $repeatName,
                  arrow: $arrow
                })
              }.onClick(() => {
                this.repeatDialogController.open()
              }).margin({ bottom: $r('app.float.itemComp_margin_b') })

              if (this.mViewModel.repeatMode == DoNotDisturbType.TYPE_CLEARLY) {
                List() {
                  ListItem() {
                    Row() {
                      ItemComponent({
                        title: $startDateTitle,
                        value: $startDateClue,
                        arrow: $arrow
                      })
                    }.onClick(() => {
                      this.startDateDialogController.open()
                    })
                  }

                  ListItem() {
                    Row() {
                      ItemComponent({
                        title: $startTitle,
                        value: $startTimeClue,
                        arrow: $arrow
                      })
                    }.onClick(() => {
                      this.startTimeDialogController.open()
                    })
                  }
                }
                .divider({
                  strokeWidth: 1,
                  color: $r('app.color.divider_color'),
                  startMargin: $r('app.float.divider_margin_l'),
                  endMargin: $r('app.float.divider_margin_r')
                })
                .width(ConfigData.WH_100_100)
                .visibility(Visibility.Visible)
                .zIndex(0)
                .border({ width: $r('app.float.border_width'), color: Color.White,
                  radius: $r('app.float.border_radius') })
                .backgroundColor(Color.White)
                .margin({ bottom: $r('app.float.itemComp_margin_b') })
                .flexShrink(1)

                List() {
                  ListItem() {
                    Row() {
                      ItemComponent({
                        title: $endDateTitle,
                        value: $endDateClue,
                        arrow: $arrow
                      })
                    }.onClick(() => {
                      this.endDateDialogController.open()
                    })
                  }

                  ListItem() {
                    Row() {
                      ItemComponent({
                        title: $endTitle,
                        value: $endTimeClue,
                        arrow: $arrow
                      })
                    }.onClick(() => {
                      this.endTimeDialogController.open()
                    })
                  }
                }
                .divider({
                  strokeWidth: 1,
                  color: $r('app.color.divider_color'),
                  startMargin: $r('app.float.divider_margin_l'),
                  endMargin: $r('app.float.divider_margin_r')
                })
                .width(ConfigData.WH_100_100)
                .visibility(Visibility.Visible)
                .zIndex(0)
                .border({ width: $r('app.float.border_width'), color: Color.White,
                  radius: $r('app.float.border_radius') })
                .backgroundColor(Color.White)
                .margin({ bottom: $r('app.float.itemComp_margin_b') })
                .flexShrink(1)
              } else {
                Row() {
                  ItemComponent({
                    title: $startTitle,
                    value: $startTimeClue,
                    arrow: $arrow
                  })
                }.onClick(() => {
                  this.mPrevData = this.mViewModel.startTime
                  this.startTimeDialogController.open()
                }).margin({ bottom: $r('app.float.itemComp_margin_b') })

                Row() {
                  ItemComponent({
                    title: $endTitle,
                    value: $endTimeClue,
                    arrow: $arrow
                  })
                }.onClick(() => {
                  this.mPrevData = this.mViewModel.endTime
                  this.endTimeDialogController.open()
                }).margin({ bottom: $r('app.float.itemComp_margin_b') })
              }
            }
            .width(ConfigData.WH_100_100)
            .height(ConfigData.WH_100_100)
            .padding({
              left: $r('sys.float.ohos_id_default_padding_start'),
              right: $r('sys.float.ohos_id_default_padding_end')
            })
            .useSizeType({
              xs: { span: 12, offset: 0 }, sm: { span: 12, offset: 0 },
              md: { span: 12, offset: 0 }, lg: { span: 8, offset: 2 }
            })
          }
          .width(ConfigData.WH_100_100)
          .height(ConfigData.WH_100_100)
        }
      }
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100);
    }
    .width(ConfigData.WH_100_100)
  }

  setRepeatMode(data: number) {
    this.mViewModel.onRepeatModeAccect(data);
  }

  setStartDate(data: string) {
    let dataSource = this.mViewModel.setDateIntoDateTime(this.mViewModel.defaultStartTime, data);
    this.mViewModel.onStartTimeAccept(dataSource);
  }

  setStartTime(data: string) {
    let dataSource = data;
    if (this.mViewModel.repeatMode == DoNotDisturbType.TYPE_CLEARLY) {
      dataSource = this.mViewModel.setTimeIntoDateTime(this.mViewModel.defaultStartTime, data);
    } else if (this.mViewModel.repeatMode == DoNotDisturbType.TYPE_NONE) {
      dataSource = this.mPrevData;
    }
    this.mViewModel.onStartTimeAccept(dataSource);
  }

  setEndDate(data: string) {
    let dataSource = this.mViewModel.setDateIntoDateTime(this.mViewModel.defaultEndTime, data);
    this.mViewModel.onEndTimeAccept(dataSource);
  }

  setEndTime(data: string) {
    let dataSource = data;
    if (this.mViewModel.repeatMode == DoNotDisturbType.TYPE_CLEARLY) {
      dataSource = this.mViewModel.setTimeIntoDateTime(this.mViewModel.defaultEndTime, data);
    } else if (this.mViewModel.repeatMode == DoNotDisturbType.TYPE_NONE) {
      dataSource = this.mPrevData;
    }
    this.mViewModel.onEndTimeAccept(dataSource);
  }

  aboutToAppear(): void {
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.viewModelInit()
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
  }
}

/**
 * select date dialog
 */
@CustomDialog
struct DateDialog {
  public controller: CustomDialogController
  public action: (data: string) => void = () => {
  }
  private selectedDate: string = ''
  private title: string | Resource = ''
  private defaultDate: Date = new Date()
  private minDate: Date = new Date('2008-01-01');
  private maxDate: Date = new Date('2037-12-31');

  build() {
    Column() {
      Column() {
        Column() {
          Text(this.title)
            .height($r('app.float.dialog_title_height'))
            .width(ConfigData.WH_100_100)
            .textAlign(TextAlign.Center)
            .fontSize($r('sys.float.ohos_id_text_size_headline8'))
            .fontWeight(FontWeight.Medium)
          DatePicker({ start: this.minDate, end: this.maxDate, selected: this.defaultDate })
            .onChange((date: DatePickerResult) => {
              if(date.year && date.month){
                let dateSource = new Date(date.year, date.month, date.day);
                this.selectedDate = NoDisturbingModel.formatDate(dateSource);
              }
            })
            .width(ConfigData.WH_100_100)
            .height($r('app.float.timeDialog_datePicker_height'))
        }

        Row() {
          Column() {
            Text($r('app.string.cancel'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('app.color.font_color_007DFF'))
              .fontWeight(FontWeight.Medium)

          }.onClick(() => {
            this.controller.close();
          })
          .alignItems(HorizontalAlign.Center)
          .width(ConfigData.WH_50_100);
          Divider()
            .vertical(true)
            .color($r('app.color.divider_color'))
            .strokeWidth(1)
            .height($r('app.float.divider_height'))
          Column() {
            Text($r('app.string.confirm'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('app.color.font_color_007DFF'))
              .fontWeight(FontWeight.Medium)
          }.onClick(() => {
            Log.showDebug(TAG, `confirm button of DateDialog on click`)
            this.controller.close();
            if (this.selectedDate != '') {
              this.action(this.selectedDate);
            }
          })
          .alignItems(HorizontalAlign.Center)
          .width(ConfigData.WH_50_100)
        }
        .width(ConfigData.WH_100_100)
        .margin({ top: $r('app.float.noDisturb_margin_16'), bottom: $r('app.float.noDisturb_margin_16') })
      }
      .padding({
        left: $r('app.float.repeatDialog_padding'),
        right: $r('app.float.repeatDialog_padding')
      })
      .alignItems(HorizontalAlign.Center)
      .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
      .borderRadius($r('app.float.border_radius'))
    }
    .width(deviceTypeInfo === 'phone' ? ConfigData.WH_100_100 : $r('app.float.repeatDialog_width'))
  }
}

/**
 * select time dialog
 */
@CustomDialog
struct TimeDialog {
  public controller: CustomDialogController
  public action: (data: string) => void = ()=>{}
  private selectedTime: string = ''
  private title: string | Resource = ''
  private defaultDate: Date = new Date()

  build() {
    Column() {
      Column() {
        Column() {
          Text(this.title)
            .height($r('app.float.dialog_title_height'))
            .width(ConfigData.WH_100_100)
            .textAlign(TextAlign.Center)
            .fontSize($r('sys.float.ohos_id_text_size_headline8'))
            .fontWeight(FontWeight.Medium)
          TimePicker({ selected: this.defaultDate, })
            .useMilitaryTime(false)
            .onChange((date: TimePickerResult) => {
              this.selectedTime = concatTime(date.hour, date.minute);
            })
            .width(ConfigData.WH_100_100)
            .height($r('app.float.timeDialog_datePicker_height'))
        }.padding({ left: $r('sys.float.ohos_id_max_padding_start'), right: $r('sys.float.ohos_id_max_padding_end') })

        Row() {
          Column() {
            Text($r('app.string.cancel'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('app.color.font_color_007DFF'))
              .fontWeight(FontWeight.Medium)
          }.onClick(() => {
            this.controller.close();
          })
          .alignItems(HorizontalAlign.Center)
          .width(ConfigData.WH_50_100);
          Divider()
            .vertical(true)
            .color($r('app.color.divider_color'))
            .strokeWidth(1)
            .height($r('app.float.divider_height'))
          Column() {
            Text($r('app.string.confirm'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('app.color.font_color_007DFF'))
              .fontWeight(FontWeight.Medium)
          }.onClick(() => {
            Log.showDebug(TAG, `confirm button of TimeDialog on click`)
            this.controller.close();
            if (this.selectedTime != '') {
              this.action(this.selectedTime);
            }
          })
          .alignItems(HorizontalAlign.Center)
          .width(ConfigData.WH_50_100)
        }
        .width(ConfigData.WH_100_100)
        .margin({ top: $r('app.float.noDisturb_margin_16'), bottom: $r('app.float.noDisturb_margin_16') })
      }
      .padding({
        left: $r('app.float.repeatDialog_padding'),
        right: $r('app.float.repeatDialog_padding')
      })
      .alignItems(HorizontalAlign.Center)
      .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
      .borderRadius($r('app.float.border_radius'))
    }
    .width(deviceTypeInfo === 'phone' ? ConfigData.WH_100_100 : $r('app.float.repeatDialog_width'))
  }
}

/**
 * select repeat Mode dialog
 */
@CustomDialog
struct RepeatModeDialog {
  public controller: CustomDialogController
  public action: (data: number) => void = ()=>{}
  private title: string | Resource = ''
  private prevModeSetCnt: number = 0
  @State selectMode: number = DoNotDisturbType.TYPE_NONE
  itSelectedBefore: number = -1

  build() {
    Column() {
      Column() {
        Column() {
          Text(this.title)
            .width(ConfigData.WH_100_100)
            .height($r('app.float.dialog_title_height'))
            .fontFamily('HarmonyHeiTi')
            .textAlign(TextAlign.Center)
            .fontSize($r('sys.float.ohos_id_text_size_headline8'))
            .fontWeight(FontWeight.Medium)

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text($r('app.string.noDisturb_none'))
              .fontFamily('HarmonyHeiTi')
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
            Radio({ value: '' + DoNotDisturbType.TYPE_NONE, group: GROUP_REPEAT_MODE })
              .checked(this.selectMode == DoNotDisturbType.TYPE_NONE)
              .touchable(false)
              .width($r('app.float.toggle_check_width'))
              .height($r('app.float.toggle_check_width'))
              .onChange((select: boolean) => {
                if (select) {
                  if (this.prevModeSetCnt == 0) {
                    this.itSelectedBefore = this.selectMode;
                  }
                  this.prevModeSetCnt++
                  this.selectMode = DoNotDisturbType.TYPE_NONE;
                }
              })
          }
          .height($r('app.float.appitem_icon_height'))
          .onClick(() => {
            if (this.prevModeSetCnt == 0) {
              this.itSelectedBefore = this.selectMode;
            }
            this.prevModeSetCnt++
            this.selectMode = DoNotDisturbType.TYPE_NONE;
          })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text($r('app.string.noDisturb_once'))
              .fontFamily('HarmonyHeiTi')
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
            Radio({ value: '' + DoNotDisturbType.TYPE_ONCE, group: GROUP_REPEAT_MODE })
              .checked(this.selectMode == DoNotDisturbType.TYPE_ONCE)
              .touchable(false)
              .width($r('app.float.toggle_check_width'))
              .height($r('app.float.toggle_check_width'))
              .onChange((select: boolean) => {
                if (select) {
                  if (this.prevModeSetCnt == 0) {
                    this.itSelectedBefore = this.selectMode;
                  }
                  this.prevModeSetCnt++
                  this.selectMode = DoNotDisturbType.TYPE_ONCE;
                }
              })
          }
          .height($r('app.float.appitem_icon_height'))
          .onClick(() => {
            if (this.prevModeSetCnt == 0) {
              this.itSelectedBefore = this.selectMode;
            }
            this.prevModeSetCnt++
            this.selectMode = DoNotDisturbType.TYPE_ONCE;
          })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text($r('app.string.noDisturb_daily'))
              .fontFamily('HarmonyHeiTi')
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
            Radio({ value: '' + DoNotDisturbType.TYPE_DAILY, group: GROUP_REPEAT_MODE })
              .checked(this.selectMode == DoNotDisturbType.TYPE_DAILY)
              .touchable(false)
              .width($r('app.float.toggle_check_width'))
              .height($r('app.float.toggle_check_width'))
              .onChange((select: boolean) => {
                if (select) {
                  if (this.prevModeSetCnt == 0) {
                    this.itSelectedBefore = this.selectMode;
                  }
                  this.prevModeSetCnt++
                  this.selectMode = DoNotDisturbType.TYPE_DAILY;
                }
              })
          }
          .height($r('app.float.appitem_icon_height'))
          .onClick(() => {
            if (this.prevModeSetCnt == 0) {
              this.itSelectedBefore = this.selectMode;
            }
            this.prevModeSetCnt++
            this.selectMode = DoNotDisturbType.TYPE_DAILY;
          })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text($r('app.string.noDisturb_clearly'))
              .fontFamily('HarmonyHeiTi')
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
            Radio({ value: '' + DoNotDisturbType.TYPE_CLEARLY, group: GROUP_REPEAT_MODE })
              .checked(this.selectMode == DoNotDisturbType.TYPE_CLEARLY)
              .touchable(false)
              .width($r('app.float.toggle_check_width'))
              .height($r('app.float.toggle_check_width'))
              .onChange((select: boolean) => {
                if (select) {
                  if (this.prevModeSetCnt == 0) {
                    this.itSelectedBefore = this.selectMode;
                  }
                  this.prevModeSetCnt++
                  this.selectMode = DoNotDisturbType.TYPE_CLEARLY;
                }
              })
          }
          .height($r('app.float.appitem_icon_height'))
          .onClick(() => {
            if (this.prevModeSetCnt == 0) {
              this.itSelectedBefore = this.selectMode;
            }
            this.prevModeSetCnt++
            this.selectMode = DoNotDisturbType.TYPE_CLEARLY;
          })
        }

        Row() {
          Column() {
            Text($r('app.string.cancel'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
              .fontWeight(FontWeight.Medium)
          }.onClick(() => {
            this.controller.close();
          })
          .alignItems(HorizontalAlign.Center)
          .width(ConfigData.WH_50_100);
          Divider()
            .vertical(true)
            .color($r('app.color.divider_color'))
            .strokeWidth(1)
            .height($r('app.float.divider_height'))
          Column() {
            Text($r('app.string.confirm'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
              .fontWeight(FontWeight.Medium)
          }.onClick(() => {
            Log.showDebug(TAG, `confirm button of TimeDialog on click`)
            this.controller.close();
            if (this.itSelectedBefore != -1 && this.itSelectedBefore != this.selectMode) {
              this.action(this.selectMode);
            }
          })
          .alignItems(HorizontalAlign.Center)
          .width(ConfigData.WH_50_100)
        }
        .width(ConfigData.WH_100_100)
        .margin({ top: $r('app.float.noDisturb_margin_16'), bottom: $r('app.float.noDisturb_margin_16') })
      }
      .padding({
        left: $r('app.float.repeatDialog_padding'),
        right: $r('app.float.repeatDialog_padding')
      })
      .alignItems(HorizontalAlign.Center)
      .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
      .borderRadius($r('app.float.border_radius'))
    }
    .width(deviceTypeInfo === 'phone' ? ConfigData.WH_100_100 : $r('app.float.repeatDialog_width'))
  }
}
