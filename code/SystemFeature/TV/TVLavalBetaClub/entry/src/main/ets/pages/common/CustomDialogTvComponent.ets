import { KeyCode } from './KeyCode'
import InputMethod from '@ohos.inputMethod';
import {
  CustomDialogButtonStyle, CustomDialogContentStyle, StyleConstants
} from './StyleConstants'
import promptAction from '@ohos.promptAction';
import { inputEventClient } from '@kit.InputKit';
import { i18n } from '@kit.LocalizationKit';
import { ColorMetrics } from '@kit.ArkUI';
import { EventUtil } from './EventUtil';

const sourceToolMouseClick: number = 7
const TAG = 'CustomDialogTvComponent';

@Entry
@CustomDialog
export struct CustomDialogTvComponent {
  content: DialogContent = new DialogContent('标题', '内容', '取消', '确认', 0, 0)
  controller: CustomDialogController
  buttonStyle: CustomDialogButtonStyle = CustomDialogButtonStyle.default
  contentStyle: CustomDialogContentStyle = CustomDialogContentStyle.default
  @State focusIndex: number = -1
  @State userInputs: string = '';
  @State userCustomTime: number = 0
  @State selectDate: Date = new Date()
  @State is24TimeFormat: boolean = false
  dateFormat = new Intl.DateTimeFormat('zh-Cn', {
    dateStyle: 'full'
  })
  timeFormat = new Intl.DateTimeFormat('zh-Cn', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: !this.is24TimeFormat
  })
  cancel: Function = () => {
  }
  confirm: Function = () => {
  }

  onPageShow(): void {
    this.tabClick();
  }

  tabClick() {
    let keyDownOpt: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUpOpt: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };


    try {
      // 触发tab点击，使默认焦点组件多态样式生效
      inputEventClient.injectEvent({ KeyEvent: keyDownOpt });
      inputEventClient.injectEvent({ KeyEvent: keyUpOpt });
      console.log('手动触发tab点击成功')
    } catch (e) {
      console.log('手动触发tab点击失败')
    }
  }

  get24HourFormat() {
    this.is24TimeFormat = i18n.System.is24HourClock()
  }

  aboutToAppear() {
    console.info(TAG + 'aboutToAppear' + '宽度' + this.content.dialogWidth + '高度' + this.content.dialogHeight)
    this.get24HourFormat()
    this.userCustomTime = this.selectDate.getTime()
    if (this.content.content == '此操作将会连接当前wifi') {
      this.tabClick();
    }
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        if (this.contentStyle == CustomDialogContentStyle.titleInput ||
          this.contentStyle == CustomDialogContentStyle.titleContent) {
          Text(this.content.title)
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
            .fontSize('40lpx')
            .margin({
              bottom: '48lpx'
            })
        }

        if (this.contentStyle == CustomDialogContentStyle.default ||
          this.contentStyle == CustomDialogContentStyle.titleContent) {
          Text(this.content.content)
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
            .fontSize('24lpx')
            .margin({
              bottom: '48lpx'
            })
        }

        if (this.contentStyle == CustomDialogContentStyle.titleInput ||
          this.contentStyle == CustomDialogContentStyle.input) {
          TextInput({ placeholder: this.content.content, text: this.userInputs })
            .width('90%')
            .height('90lpx')
            .backgroundColor('#434343')
            .fontSize('36lpx')
            .margin({
              bottom: '48lpx'
            })
            .maxLength(30)
            .fontColor(Color.White)
            .placeholderColor('#80ffffff')
            .placeholderFont({ size: '36lpx' })
            .caretColor(Color.White)
            .defaultFocus(true)
            .border({
              width: this.focusIndex == 0 ? 2 + 'lpx' : 0,
              radius: globalThis.screenHeight * 0.05 + 'lpx',
              color: Color.White,
              style: BorderStyle.Solid
            })
            .key('textInput')
            .enableKeyboardOnFocus(true)
            .focusable(true)
            .onFocus(() => {
              this.focusIndex = 0;
              console.info(TAG + 'textInput:' + this.focusIndex);
            })
            .onBlur(() => {
              this.focusIndex = -1;
            })
            .onKeyEvent((event) => {
              if (event.keyCode == KeyCode.KEY_DPAD_UP || event.keyCode == KeyCode.KEY_DPAD_LEFT ||
                event.keyCode == KeyCode.KEY_DPAD_RIGHT) {
                event.stopPropagation();
              }

              switch (event.keyCode) {
                case KeyCode.KEY_0:
                case KeyCode.KEY_1:
                case KeyCode.KEY_2:
                case KeyCode.KEY_3:
                case KeyCode.KEY_4:
                case KeyCode.KEY_5:
                case KeyCode.KEY_6:
                case KeyCode.KEY_7:
                case KeyCode.KEY_8:
                case KeyCode.KEY_9:
                  if (event.type == KeyType.Up) {
                    this.userInputs += event.keyCode % 2000;
                    console.info(TAG + ':input value:' + this.userInputs);
                    if (this.userInputs.length > 30) {
                      this.userInputs.substring(0, 30);
                      promptAction.showToast({
                        message: '自定义名称超长',
                        duration: 2000,
                        bottom: globalThis.screenHeight / 4
                      })
                      return;
                    }
                  }
                  break;
                case KeyCode.KEY_ENTER:
                  focusControl.requestFocus('textInput')
                  break;
                case KeyCode.KEY_DPAD_DOWN:
                  focusControl.requestFocus('confirm')
                  event.stopPropagation()
                  break;
              }
            })
            .onChange((value) => {
              this.userInputs = value.trim();
            })
            .onSubmit((enterKey) => {
              InputMethod.getInputMethodController().stopInput()
                .then((ret) => {
                  console.debug(` enterType: ${enterKey}, stopInput: ${ret}`);
                });
            })
        }

        //自定义日期选择弹窗
        if (this.contentStyle == CustomDialogContentStyle.DatePicker) {
          Column() {
            Text(this.dateFormat.format(this.selectDate))
              .fontColor(('rgb(255, 255, 255)'))
              .fontSize('32lpx')
              .margin({
                bottom: '20lpx'
              })
            DatePicker({ selected: this.selectDate })
              .focusBox({ strokeColor: ColorMetrics.rgba(255, 255, 255, 0.86) })
              .disappearTextStyle({ color: ('rgba(255, 255, 255, 0.50)'), font: { size: '18lpx' } })
              .textStyle({ color: ('rgba(255, 255, 255, 0.70)'), font: { size: '18lpx' } })
              .selectedTextStyle({ color: ('rgb(255, 255, 255)'), font: { size: '24lpx' } })
              .width('100%')
              .layoutWeight(1)
              .onDateChange((date) => {
                this.selectDate = new Date(date.getTime())
                this.userCustomTime = date.getTime()
                console.info(TAG + '--日期选择器onchange-result：' + date as string)
                console.log(TAG + 'date change数据' + this.selectDate)
              })
              .focusable(true)
              .onFocus(() => {
                this.focusIndex = 0;
                console.info(TAG + 'textInput:' + this.focusIndex);
              })
              .onKeyEvent((event) => {
                if (event.keyCode === KeyCode.KEY_ENTER && event.type === KeyType.Up) {
                  focusControl.requestFocus('confirm')
                  event.stopPropagation()
                }
              })
              .onHover(() => {
                focusControl.requestFocus('Cancel')
              })
              .onTouch((event) => {
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
              })
              .margin({
                bottom: '20lpx',
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('rgb(64, 64, 64)')
          .borderRadius('24lpx')

        }

        //自定义时间选择弹窗
        if (this.contentStyle == CustomDialogContentStyle.TimePicker) {

          Column() {
            Text(this.dateFormat.format(new Date()))
              .fontColor(('rgb(255, 255, 255)'))
              .fontSize('32lpx')
            TimePicker()
              .focusBox({ strokeColor: ColorMetrics.rgba(255, 255, 255, 0.86) })
              .useMilitaryTime(this.is24TimeFormat)
              .disappearTextStyle({ color: ('rgba(255, 255, 255, 0.50)'), font: { size: '18lpx' } })
              .textStyle({ color: ('rgba(255, 255, 255, 0.70)'), font: { size: '18lpx' } })
              .selectedTextStyle({
                color: ('rgb(255, 255, 255)'),
                font: { size: '24lpx' }
              })
              .width('100%')
              .layoutWeight(1)
              .loop(true)
              .onChange((result) => {
                console.info(TAG + '滑动时间')
                let currentTime = new Date()
                let time =
                  new Date(currentTime.getFullYear(), currentTime.getMonth(), currentTime.getDay(), result.hour,
                    result.minute, result.second)
                currentTime.setHours(result.hour, result.minute)
                this.selectDate = new Date()
                this.userCustomTime = currentTime.getTime()
                console.info(TAG + '--时间选择器onchange-result：' + JSON.stringify(result) + '--' + time.toString())
              })
              .focusable(true)
              .onFocus(() => {
                this.focusIndex = 0;
                console.info(TAG + 'textInput:' + this.focusIndex);
              })
              .onKeyEvent((event) => {
                if (event.keyCode === KeyCode.KEY_ENTER && event.type === KeyType.Up) {
                  focusControl.requestFocus('confirm')
                  event.stopPropagation()
                }
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('rgb(64, 64, 64)')
          .borderRadius('24lpx')

        }

        //按钮
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
          if (this.buttonStyle == CustomDialogButtonStyle.default) {
            Column() {
              Text(this.content.firstValue)
                .width('148lpx')
                .height('48lpx')
                .textAlign(TextAlign.Center)
                .fontColor(this.focusIndex === 1 ? Color.Black : Color.White)
                .fontSize('32lpx')
                .borderRadius('200lpx')
                .backgroundColor(this.focusIndex === 1 ? Color.White : '#666666')
                .key('Cancel')
                .defaultFocus(true)
                .focusable(true)
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.Transparent
                    })
                  }
                })
                .onFocus(() => {
                  this.focusIndex = 1;
                })
                .onBlur(() => {
                  this.focusIndex = -1
                })
                .onKeyEvent((event) => {
                  if (event.keyCode == KeyCode.KEY_DPAD_LEFT || event.keyCode == KeyCode.KEY_DPAD_DOWN ||
                    (event.keyCode == KeyCode.KEY_DPAD_UP &&
                      (this.contentStyle == CustomDialogContentStyle.titleContent ||
                        this.contentStyle == CustomDialogContentStyle.default))) {
                    event.stopPropagation();
                  }
                  if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Down) {
                    this.cancel();
                    event.stopPropagation();
                  }
                })
                .onClick(() => {
                  focusControl.requestFocus('Cancel')
                  this.cancel();
                })
                .onTouch((event) => {
                  focusControl.requestFocus('Cancel')
                  if (!EventUtil.isTouchEvent(event)) {
                    return;
                  }
                  if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
                    return;
                  }
                })
                .onHover(() => {
                  focusControl.requestFocus('Cancel')
                })
            }
            .width(this.focusIndex === 1 ? '160lpx' : '150lpx')
            .height(this.focusIndex === 1 ? '60lpx' : '50lpx')
            .border({
              width: this.focusIndex === 1 ? '2lpx' : 0,
              radius: '30lpx',
              color: Color.White,
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Center)
          }

          Column() {
            Text(this.content.secondValue)
              .width('148lpx')
              .height('48lpx')
              .textAlign(TextAlign.Center)
              .borderRadius('200lpx')
              .key('confirm')
              .fontColor(this.focusIndex === 2 ? Color.Black : Color.White)
              .fontSize('32lpx')
              .backgroundColor(this.focusIndex === 2 ? Color.White : '#666666')
              .focusable(true)
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
              .onTouch((event) => {
                focusControl.requestFocus('confirm')
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
                if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
                  return;
                }
              })
              .onFocus(() => {
                this.focusIndex = 2;
              })
              .onBlur(() => {
                this.focusIndex = -1
              })
              .onKeyEvent((event) => {
                if (event.keyCode == KeyCode.KEY_DPAD_RIGHT || event.keyCode == KeyCode.KEY_DPAD_DOWN ||
                  (event.keyCode == KeyCode.KEY_DPAD_UP &&
                    (this.contentStyle == CustomDialogContentStyle.titleContent ||
                      this.contentStyle == CustomDialogContentStyle.default))) {
                  event.stopPropagation();
                }
                if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Up) {
                  this.content.setTextInputValue(this.userInputs);
                  this.content.setCustomTime(this.userCustomTime)
                  this.confirm();
                  event.stopPropagation();
                }
              })
              .onClick(() => {
                focusControl.requestFocus('confirm')
                this.content.setTextInputValue(this.userInputs);
                this.content.setCustomTime(this.userCustomTime)
                this.confirm();
              })
              .onHover(() => {
                focusControl.requestFocus('confirm')
              })
            /*.onTouch((event) => {
              if (!EventUtil.isTouchEvent(event) || event.sourceTool !== 2) {
                return;
              }

              this.content.setTextInputValue(this.userInputs);
              this.content.setCustomTime(this.userCustomTime)
              this.confirm();
            })*/
          }
          .width(this.focusIndex === 2 ? '160lpx' : '150lpx')
          .height(this.focusIndex === 2 ? '60lpx' : '50lpx')
          .border({
            width: this.focusIndex === 2 ? '2lpx' : 0,
            radius: '200lpx',
            color: Color.White,
            style: BorderStyle.Solid
          })
          .justifyContent(FlexAlign.Center)
        }
        .height('80lpx')
        .onAppear(() => {
          focusControl.requestFocus('Cancel')
        })

      }
      .padding({
        top: '48lpx',
        bottom: '48lpx'
      })
      .height(this.content.dialogHeight)
      .width(this.content.dialogWidth)
      .backgroundColor(StyleConstants.DEFAULT_SETTING)
      .borderRadius('24lpx')
      .onAppear(() => {
        if (!(this.contentStyle == CustomDialogContentStyle.input ||
          this.contentStyle == CustomDialogContentStyle.titleInput ||
          this.contentStyle == CustomDialogContentStyle.DatePicker ||
          this.contentStyle == CustomDialogContentStyle.TimePicker)) {
          focusControl.requestFocus('Cancel');
        }
      })

    }
    .height('100%')
    .width('100%')
    .padding({
      right: 0,

    })
    .backgroundColor('#b3000000')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)

  }
}

export class DialogContent {
  public title: string;
  public content: string;
  public textInputValue: string = '';
  public firstValue: string;
  public secondValue: string;
  public dialogWidth: Length;
  public dialogHeight: Length
  public customTime: number = 0;

  constructor(title: string, content: string, firstValue: string, secondValue: string, dialogWidth: Length,
    dialogHeight: Length) {
    this.title = title;
    this.content = content;
    this.firstValue = firstValue === '' ? '取消' : firstValue;
    this.secondValue = secondValue === '' ? '确认' : secondValue;
    this.dialogWidth =
      dialogWidth as number === 0 ? `${(globalThis.screenWidth / 2)}lpx` : `${(Number(dialogWidth))}lpx`;
    this.dialogHeight =
      dialogHeight as number === 0 ? `${(globalThis.screenHeight / 2)}lpx` : `${(Number(dialogHeight))}lpx`;
  }

  public setTextInputValue(value: string) {
    this.textInputValue = value;
  }

  public getTextInputValue() {
    return this.textInputValue;
  }

  public setCustomTime(value: number) {
    this.customTime = value
  }

  public getCustomTime() {
    return this.customTime
  }
}
