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
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import LogManager from '../../../common/Log/LogManager';
import dayjs from 'dayjs';
import { tabClick } from '../../Index';
import { inputConsumer, inputEventClient, KeyCode } from '@kit.InputKit';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { fpChangeLpx, TIME_INT, TIME_INT_VIS, vpChangeLpx } from '../models/IssueDetailInfo';
import { emitter } from '@kit.BasicServicesKit';
import { CustomDialogTvComponent, DialogContent } from '../../common/CustomDialogTvComponent';
import { CustomDialogContentStyle } from '../../common/StyleConstants';
import { SettingItemTvModel } from '../../common/SettingItemTvModel';
import { EventUtil } from '../../common/EventUtil';

export enum IssueReporterDetailItemType {
  default = 0, // 默认样式，右侧为文字
  time, // 时间选择器
  filter, // 筛选选择器，比如故障概率等
  edit, // 编辑框
  attachment, // 附件
  attachmentDisplay, //详情展示
  date, //日期选择器
}

export function registerInputConsumer(keyCode: number, callback: () => void): void {
  let onKeyCode: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: keyCode,
    finalKeyDownDuration: 0,
    isFinalKeyDown: true
  };
  inputConsumer.on('key', onKeyCode, () => {
    callback && callback();
    console.log(TAG, 'inputConsumer keyEvent start');
  });
}

export function unregisterInputConsumer(keyCode: number): void {
  let onKeyCode: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: keyCode,
    finalKeyDownDuration: 0,
    isFinalKeyDown: true
  };
  inputConsumer.off('key', onKeyCode);
}

export function enterClick() {
  let keyDownOpt: inputEventClient.KeyEvent = {
    isPressed: true,
    keyCode: KeyCode.KEYCODE_ENTER,
    keyDownDuration: 0,
    isIntercepted: false
  };
  let keyUpOpt: inputEventClient.KeyEvent = {
    isPressed: false,
    keyCode: KeyCode.KEYCODE_ENTER,
    keyDownDuration: 0,
    isIntercepted: false
  };


  try {
    // 触发tab点击，使默认焦点组件多态样式生效
    inputEventClient.injectEvent({ KeyEvent: keyDownOpt });
    inputEventClient.injectEvent({ KeyEvent: keyUpOpt });
  } catch (err) {
    console.error('settingList inputEventClient' + err);
  }
}

const TAG = 'IssueReporterDetailItem';
const sourceToolMouseClick: number = 7;

@Component
export default struct issueReportSelectItem {
  @Prop itemType: IssueReporterDetailItemType = IssueReporterDetailItemType.default;
  title: ResourceStr = '';
  @Prop itemValue: string = '请选择';
  selectedTimeHandle?: (time: string) => void;
  selectedDateHandle?: (time: string) => void;
  selectedFilterHandle?: (filter: string, index: number) => void;
  selectedPhotoHandle?: (photoInfos: photoAccessHelper.PhotoAsset[]) => void;
  @State endTime: string = '';
  @State startTime: string = '';
  @State selectedDate: Date = new Date();
  @Prop filter: string = '';
  filters: string[] = [];
  @State selectedFilterNumber: number | number[] = 0;
  @State isFocus: boolean = false;
  @State titleKey: string = '';
  private dataSelectController: CustomDialogController = new CustomDialogController({
    builder: DataSelect({
      range: this.filters,
      selectedFilterNumber: this.selectedFilterNumber,
      itemValue: this.itemValue,
      filter: this.filter,
      selectedFilterHandle: this.selectedFilterHandle
    }),
    customStyle: true,
  });
  @StorageLink('issueReportTime') issueReportTime: string = '';
  @StorageLink('issueReportDate') issueReportDate: string = '';
  @State settingList: SettingItemTvModel[] = [];
  @State is24Hours: boolean = false;
  dateFormat = new Intl.DateTimeFormat('zh-Cn', { year: 'numeric', month: 'long', day: 'numeric' });
  time12Format = new Intl.DateTimeFormat('zh-Cn', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: true
  });
  time24Format = new Intl.DateTimeFormat('zh-Cn', {
    hour: '2-digit',
    minute: '2-digit',
    hourCycle: 'h23',
    hour12: false
  });
  @State date: string = '';
  @State time: string = '';
  private content: DialogContent = new DialogContent('', '', '', '', 400, 300);
  dateDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: (): void => this.onDateCancel(),
      confirm: (): void => this.onDateConfirm(),
      content: this.content,
      contentStyle: CustomDialogContentStyle.DatePicker
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  });
  timeDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: (): void => this.onTimeCancel(),
      confirm: (): void => this.onTimeConfirm(),
      content: this.content,
      contentStyle: CustomDialogContentStyle.TimePicker
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  });

  onPageShow() {
    this.issueReportTime = '';
    this.issueReportDate = '';
  }

  onDateConfirm() {
    this.setDate();
    this.dateDialogController.close();
  }

  onTimeConfirm() {
    this.setTime();
    this.timeDialogController.close();
  }

  onDateCancel() {
    this.dateDialogController.close();
  }

  onTimeCancel() {
    this.timeDialogController.close();
  }

  // 日期时间显示24小时格式渲染
  setTimeFormat(type: 'date' | 'time', value: boolean, time: number): string {
    if (type === 'date') {
      this.date = this.dateFormat.format(time);
      return this.date;
    } else {
      if (value) {
        this.time = this.time24Format.format(time);
        return this.time;
      } else {
        this.time = this.time12Format.format(time);
        return this.time;
      }
    }
  }

  // 设置时间
  setTime() {
    this.setTimeFormat('time', this.is24Hours, this.content.customTime);
    let time = (new Date(this.content.customTime)).toTimeString();
    let match = time.match(/^(\d{2}:\d{2}:\d{2})/);
    this.issueReportTime = match ? match[1] : '00:00:00';
    this.itemValue = match ? match[1] : '00:00:00';
  }

  setDate() {
    this.setTimeFormat('date', this.is24Hours, this.content.customTime);
    let date = (new Date(this.content.customTime)).toDateString();
    let match = date.replace(/^\w{3}\s+/, '');
    this.itemValue = match;
    this.issueReportDate = match;
  }

  async aboutToAppear() {
    this.titleKey = await getContext(this).resourceManager.getStringValue(this.title as Resource);
    let currentDate = new Date();
    this.endTime = dayjs(currentDate).format('YYYY-MM-DD HH:mm:ss');
    // 显示当前及7天前的可选时间
    let startDate = (new Date()).setDate(currentDate.getFullYear() - 1);
    this.startTime = dayjs(startDate).format('YYYY-MM-DD HH:mm:ss');
    LogManager.hilogIWithTag(TAG,
      `aboutToAppear, currentTime: ${JSON.stringify(this.endTime)}, twoDaysAgoTime: ${JSON.stringify(this.startTime)}`);
    LogManager.hilogIWithTag(TAG,
      `aboutToAppear, itemType: ${JSON.stringify(this.itemType)}, this.itemValue: ${JSON.stringify(this.filter)}`);

    if (this.itemType === IssueReporterDetailItemType.filter && this.filter) {
      this.itemValue = this.filter;
    }

    if (this.itemType === IssueReporterDetailItemType.time && this.itemValue) {
      this.selectedDate = new Date(this.itemValue);
    }


    emitter.on('auto_focus', (data) => {
      let title: string = String(data?.data);
      if (this.getUniqueId().toString() == title) {
        return;
      }
      this.isFocus = false;
    });
  }

  build() {
    Row() {
      Row() {
        Row() {
          Text(this.title)
            .fontSize(fpChangeLpx(36))
            .fontWeight(500)
            .fontColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'))
            .key(this.titleKey)
            .focusable(true)
            .onFocus(() => {
              this.isFocus = true;
            })
            .focusBox({
              margin: LengthMetrics.px(2),
              strokeColor: ColorMetrics.resourceColor($r('app.color.default_white')),
              strokeWidth: LengthMetrics.px(0)
            });
          Text('*')
            .fontColor(Color.Red)
            .fontSize(fpChangeLpx(36));
        };

        Row({ space: vpChangeLpx(39) }) {
          Text(this.itemValue || '请选择')
            .fontColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'))
            .fontSize(fpChangeLpx(36));
          Image($r('app.media.icon_arrow_right'))
            .width(vpChangeLpx(21))
            .height(vpChangeLpx(34))
            .fillColor(this.isFocus ? $r('app.color.global_default_background') : $r('app.color.default_white'));
        };
      }
      .onFocus(() => {
        registerInputConsumer(KeyCode.KEYCODE_DPAD_LEFT, () => {
        });
        registerInputConsumer(KeyCode.KEYCODE_DPAD_RIGHT, () => {
        });
      })
      .onBlur(() => {
        unregisterInputConsumer(KeyCode.KEYCODE_DPAD_LEFT);
        unregisterInputConsumer(KeyCode.KEYCODE_DPAD_RIGHT);
      })
      .onTouch((event) => {
        focusControl.requestFocus(this.titleKey);
        try {
          emitter.emit('auto_focus', { data: this.getUniqueId() });
        } catch (e) {
          console.error(e);
        }
        if (!EventUtil.isTouchEvent(event)) {
          return;
        }
        if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
          return;
        }
      })
      .onClick(() => {
        this.isFocus = true;
        switch (this.itemType) {
          case IssueReporterDetailItemType.date: {
            this.dateDialogController.open();
            setTimeout(() => {
              tabClick();
            }, TIME_INT);
          }
            break;
          case IssueReporterDetailItemType.time: {
            this.timeDialogController.open();
            setTimeout(() => {
              tabClick();
            }, TIME_INT);
          }
            break;

          case IssueReporterDetailItemType.filter: {
            this.dataSelectController.open();
            setTimeout(() => {
              tabClick();
            }, TIME_INT);
          }
            break;

        }
      })

      .height(vpChangeLpx(94))
      .width('100%')
      .backgroundColor(this.isFocus ? $r('app.color.default_white') : $r('app.color.choose_background'))
      .padding({ left: vpChangeLpx(36), right: vpChangeLpx(36) })
      .justifyContent(FlexAlign.SpaceBetween)
      .borderRadius(vpChangeLpx(18))
      .onKeyEvent((event: KeyEvent) => {
        if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT || event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
          setTimeout(() => {
            tabClick();
          }, TIME_INT_VIS);
        }
      });
    }
    .margin({ bottom: vpChangeLpx(24) })
    .focusable(true)
    .onFocus(() => {
      this.isFocus = true;
    })
    .onBlur(() => {
      this.isFocus = false;
    })
    .onHover((isHover: boolean) => {
      focusControl.requestFocus(this.titleKey);
      if (isHover) {
        try {
          emitter.emit('auto_focus', { data: this.getUniqueId() });
        } catch (e) {
          console.error(e);
        }
      }
    })
    .height(vpChangeLpx(114))
    .padding({ left: vpChangeLpx(10), right: vpChangeLpx(10) })
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .border(this.isFocus ? { width: vpChangeLpx(2), color: $r('app.color.default_white'), radius: vpChangeLpx(24) } :
      null);
  }
}

@CustomDialog
struct DataSelect {
  controller: CustomDialogController;
  scroller: Scroller = new Scroller();
  range: string[] = [];
  selectedFilterHandle?: (filter: string, index: number) => void;
  @Link selectedFilterNumber: number | number[];
  @Link filter: string;
  @Link itemValue: string;
  @State valueText: string | string[] = '';
  @State valueIndex: number | number[] = 0;
  @State isFocusCancel: boolean = false;
  @State isFocusAccept: boolean = false;

  build() {
    Column() {
      TextPicker({ range: this.range, selected: this.selectedFilterNumber })
        .divider(null)
        .defaultPickerItemHeight(vpChangeLpx(79))
        .width(vpChangeLpx(739))
        .height(vpChangeLpx(333))
        .disappearTextStyle({
          color: $r('app.color.default_white'),
          font: { size: fpChangeLpx(36), weight: FontWeight.Lighter }
        })
        .textStyle({ color: $r('app.color.default_white'), font: { size: fpChangeLpx(36), weight: FontWeight.Normal } })
        .selectedTextStyle({
          color: $r('app.color.default_white'),
          font: { size: fpChangeLpx(55), weight: FontWeight.Bolder }
        })
        .focusBox({
          margin: LengthMetrics.px(2),
          strokeColor: ColorMetrics.resourceColor($r('app.color.button_transParent')),
          strokeWidth: LengthMetrics.px(2)
        })
        .layoutWeight(1)
        .canLoop(false)
        .onChange((value: string | string[], index: number | number[]) => {
          this.valueText = value;
          this.valueIndex = index;
        })
        .onFocus(() => {
          enterClick();
          registerInputConsumer(KeyCode.KEYCODE_ENTER, () => {
            tabClick();
          });
        })
        .onBlur(() => {
          unregisterInputConsumer(KeyCode.KEYCODE_ENTER);
        });

      Row() {
        Row() {
          Button($r('app.string.cancel'))
            .key('cancel')
            .focusable(true)
            .width('148lpx')
            .height('48lpx')
            .fontSize('32lpx')
            .fontColor(this.isFocusCancel ? $r('app.color.global_default_background') : $r('app.color.default_white'))
            .backgroundColor(this.isFocusCancel ? $r('app.color.default_white') : $r('app.color.button_gray'))
            .stateStyles({
              focused: {
                .border({
                  color: Color.Transparent
                });
              }
            })
            .borderRadius('30lpx')
            .onHover(() => {
              focusControl.requestFocus('cancel');
            })
            .onTouch((event) => {
              focusControl.requestFocus('cancel');
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
                return;
              }
            })
            .onFocus(() => {
              this.isFocusCancel = true;
            })
            .onBlur(() => {
              this.isFocusCancel = false;
            })
            .onClick(() => {
              focusControl.requestFocus('cancel');
              this.controller.close();
            });
        }
        .width('160lpx')
        .height('60lpx')
        .border({
          width: this.isFocusCancel ? '2lpx' : 0,
          radius: '30lpx',
          color: Color.White,
          style: BorderStyle.Solid
        })
        .justifyContent(FlexAlign.Center);

        Row() {
          Button($r('app.string.sure'))
            .key('confirm')
            .width('148lpx')
            .height('48lpx')
            .fontSize('32lpx')
            .borderRadius('30lpx')
            .fontColor(this.isFocusAccept ? $r('app.color.global_default_background') : $r('app.color.default_white'))
            .backgroundColor(this.isFocusAccept ? $r('app.color.default_white') : $r('app.color.button_gray'))
            .focusBox({
              margin: LengthMetrics.lpx(2),
              strokeColor: ColorMetrics.resourceColor($r('app.color.default_white')),
              strokeWidth: LengthMetrics.lpx(0)
            })
            .onFocus(() => {

              this.isFocusAccept = true;
            })
            .onHover(() => {
              focusControl.requestFocus('confirm');
            })
            .onTouch((event) => {
              focusControl.requestFocus('confirm');
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
                return;
              }
            })
            .onBlur(() => {
              this.isFocusAccept = false;
            })
            .onClick(() => {
              focusControl.requestFocus('confirm');
              if (this.valueIndex === 0) {
                this.valueText = this.range[this.valueIndex];
              }
              this.selectedFilterNumber = this.valueIndex;
              // 点击确定后，被选到的文本数据展示到页面
              this.filter = this.valueText as string;

              this.itemValue = this.filter;
              if (this.selectedFilterHandle) {
                this.selectedFilterHandle(this.filter, this.selectedFilterNumber as number);
              }
              this.controller.close();
            });
        }
        .width('160lpx')
        .height('60lpx')
        .border({
          width: this.isFocusAccept ? '2lpx' : 0,
          radius: '30lpx',
          color: Color.White,
          style: BorderStyle.Solid
        })
        .justifyContent(FlexAlign.Center);
      }
      .width('100%')
      .height('60lpx')
      .justifyContent(FlexAlign.SpaceAround);
    }
    .padding({ top: vpChangeLpx(5), bottom: vpChangeLpx(27) })
    .width(vpChangeLpx(739))
    .height(vpChangeLpx(433))
    .borderRadius(vpChangeLpx(24))
    .backgroundColor($r('app.color.custom_background'));
  }
}