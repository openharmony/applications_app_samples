/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import pointer from '@ohos.multimodalInput.pointer';

@Entry
@Component
struct Main {
  @State primaryButton: string = '向左键';
  @State isAble: boolean = true;
  @State initSize: number = 1;
  @State isInitColor: boolean = true;
  @State isInitStyle: boolean = true;
  private colorBlack: number = 0x171717;
  private leftButton: string = '向左键';
  private rightButton: string = '向右键';

  aboutToAppear(): void {
    try {
      pointer.getMousePrimaryButton((error: Error, primary: pointer.PrimaryButton) => {
        this.primaryButton = primary == pointer.PrimaryButton.LEFT ? this.leftButton : this.rightButton;
        console.log(`Get mouse primary button success, primary: ${JSON.stringify(primary)}`);
      });
    } catch (error) {
      console.log(`Get mouse primary button failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }

    try {
      pointer.getHoverScrollState((error: Error, state: boolean) => {
        this.isAble = state;
        console.log(`Get the mouse hover scroll success, state: ${JSON.stringify(state)}`);
      })
    } catch (error) {
      console.log(`Get the mouse hover scroll failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }

    try {
      pointer.getPointerSize((error: Error, size: number) => {
        this.initSize = size;
        console.log(`getPointerSize success, size: ${JSON.stringify(size)}`);
      })
    } catch (error) {
      console.log(`getPointerSize failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }

    try {
      pointer.getPointerColor((error: Error, color: number) => {
        this.isInitColor = color == this.colorBlack ? true : false;
        console.log(`getPointerColor success, color: ${JSON.stringify(color)}`);
        console.info('getPointerColor iSInitColor::' + this.isInitColor);
      })
    } catch (error) {
      console.log(`getPointerColor failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }

    try {
      pointer.getPointerStyle(-1, (error: Error, style: pointer.PointerStyle) => {
        this.isInitStyle = style == pointer.PointerStyle.DEFAULT ? true : false;
        console.log(`getPointerStyle success, style: ${JSON.stringify(style)}`);
        console.info('getPointerStyle isInitStyle::' + this.isInitStyle);
      })
    } catch (error) {
      console.log(`getPointerStyle failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text($r('app.string.mouse_setting'))
            .fontSize(24)
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
        }
        .height(56)
        .width('100%')
        .padding({ top: 12, bottom: 12, left: 12, right: 24 })
        .margin({ top: 16, bottom: 8 })

        Column() {
          Row() {
            Text($r('app.string.mouse_pointer_primaryButton'))
              .height(48)
              .textAlign(TextAlign.Start)
              .fontSize(16)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)

            Blank()

            Select([{ value: $r('app.string.mouse_pointer_primaryButton_left') }, {
              value: $r('app.string.mouse_pointer_primaryButton_right')
            }])
              .value(this.primaryButton)
              .font({ size: 16, weight: 400 })
              .margin({ right: 4 })
              .onSelect((index: number) => {
                console.info('Select:' + index);
                let primary = index == 0 ? pointer.PrimaryButton.LEFT : pointer.PrimaryButton.RIGHT;
                try {
                  pointer.setMousePrimaryButton(primary).then(() => {
                    console.log(`Set mouse primary button success`);
                  });
                } catch (error) {
                  console.log(`Set mouse primary button failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                }
              })
          }
          .width('100%').height(48)

          Divider().strokeWidth(1).color('#F1F3F5').padding({ right: 12 })

          Row() {
            Text($r('app.string.mouse_pointer_hoverScroll'))
              .textAlign(TextAlign.Start)
              .fontSize(16)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)

            Blank()

            Toggle({ type: ToggleType.Switch, isOn: this.isAble })
              .selectedColor('#007DFF')
              .switchPointColor('#FFFFFF')
              .margin({ right: 12 })
              .onChange((isOn: boolean) => {
                console.info('Component status:' + isOn);
                try {
                  pointer.setHoverScrollState(isOn).then(() => {
                    console.log(`Set the mouse hover scroll success`);
                  })
                } catch (error) {
                  console.log(`Set the mouse hover scroll failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                }
              })
          }
          .width('100%').height(48)
        }
        .borderRadius(24)
        .padding({ top: 4, bottom: 4, left: 12 })
        .backgroundColor(Color.White)
        .width('100%')
        .height(104)

        Row() {
          Text($r('app.string.mouse_pointer_size'))
            .fontSize(14)
            .fontColor('#000000')
            .fontWeight(FontWeight.Medium)
            .padding({ top: 19.5, bottom: 9.5, left: 12, right: 24 })
            .textAlign(TextAlign.Start)
            .opacity(0.6)
        }.height(48).width('100%')

        Row() {
          Image($r('app.media.ic_mouse_small'))
            .width(40)
            .height(40)
            .objectFit(ImageFit.Contain)

          Row() {
            Slider({
              value: this.initSize,
              step: 1,
              min: 1,
              max: 7,
              style: SliderStyle.OutSet
            }).onTouch((event?: TouchEvent) => {
              if (event) {
                event.stopPropagation?.();
              }
            })
              .showTips(true, this.initSize.toFixed(0).toString())
              .onChange((value: number, mode: SliderChangeMode) => {
                this.initSize = value
                try {
                  pointer.setPointerSize(value, (error: Error) => {
                    if (error) {
                      console.log(`setPointerSize failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                      return;
                    }
                    console.log(`setPointerSize success`);
                  })
                } catch (error) {
                  console.log(`setPointerSize failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                }
                console.info('value:' + value);
              })
          }
          .layoutWeight(1)

          Image($r('app.media.ic_mouse_big'))
            .width(72)
            .height(72)
            .objectFit(ImageFit.Contain)
        }
        .borderRadius(24)
        .padding({ top: 4, bottom: 4, left: 12, right: 12 })
        .backgroundColor(Color.White)
        .width('100%')
        .height(80)

        Row() {
          Text($r('app.string.mouse_pointer_color'))
            .fontSize(14)
            .fontColor('#000000')
            .fontWeight(FontWeight.Medium)
            .padding({ top: 19.5, bottom: 9.5, left: 12, right: 24 })
            .textAlign(TextAlign.Start)
            .opacity(0.6)
        }.height(48).width('100%')

        Column() {
          Row() {
            this.deviceShow($r('app.media.ic_mouse_black'), $r('app.string.mouse_pointer_color_black'))
            Blank()
            Radio({ value: "mouse_pointer_color", group: "mouse_pointer_color" })
              .checked(this.isInitColor)
              .height(20)
              .width(20)
              .margin({ top: 14, bottom: 14, left: 14, right: 14 })
              .onChange((isChecked: boolean) => {
                console.log('Radio status is ' + isChecked)
                try {
                  pointer.setPointerColor(this.colorBlack, (error: Error) => {
                    if (error) {
                      console.log(`setPointerColor failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                      return;
                    }
                    console.log(`setPointerColor success`);
                  })
                } catch (error) {
                  console.log(`setPointerColor failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                }
              })
          }
          .height(56)
          .width('100%')

          Divider().strokeWidth(1).color('#F1F3F5').padding({ right: 12 })
          Row() {
            this.deviceShow($r('app.media.ic_mouse_white'), $r('app.string.mouse_pointer_color_white'))
            Blank()
            Radio({ value: "mouse_pointer_color", group: "mouse_pointer_color" })
              .checked(!this.isInitColor)
              .height(20)
              .width(20)
              .margin({ top: 14, bottom: 14, left: 14, right: 14 })
              .onChange((isChecked: boolean) => {
                console.log('Radio status is ' + isChecked)
                try {
                  pointer.setPointerColor(0xffffff, (error: Error) => {
                    if (error) {
                      console.log(`setPointerColor failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                      return;
                    }
                    console.log(`setPointerColor success`)
                  })
                } catch (error) {
                  console.log(`setPointerColor failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                }
              })
          }
          .height(56)
          .width('100%')
        }
        .borderRadius(24)
        .padding({ top: 4, bottom: 4, left: 12 })
        .backgroundColor(Color.White)

        Row() {
          Text($r('app.string.mouse_pointer_style'))
            .fontSize(14)
            .fontColor('#000000')
            .fontWeight(FontWeight.Medium)
            .padding({ top: 19.5, bottom: 9.5, left: 12, right: 24 })
            .textAlign(TextAlign.Start)
            .opacity(0.6)
        }.height(48).width('100%')

        Column() {
          Row() {
            this.deviceShow($r("app.media.ic_mouse_default"), $r('app.string.mouse_pointer_default'))
            Blank()
            Radio({ value: "mouse_pointer_style", group: "mouse_pointer_style" })
              .checked(this.isInitStyle)
              .height(20)
              .width(20)
              .margin({ top: 14, bottom: 14, left: 14, right: 14 })
              .onChange((isChecked: boolean) => {
                console.log('Radio status is ' + isChecked)
                try {
                  pointer.setPointerStyle(-1, pointer.PointerStyle.DEFAULT).then(() => {
                    console.log(`Set pointer style success`);
                  })
                } catch (error) {
                  console.log(`Set pointer style failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                }
              })
          }
          .height(56)
          .width('100%')

          Divider().strokeWidth(1).color('#F1F3F5').padding({ right: 12 })
          Row() {
            this.deviceShow($r("app.media.ic_mouse_loading"), $r('app.string.mouse_pointer_loading'))
            Blank()
            Radio({ value: "mouse_pointer_style", group: "mouse_pointer_style" })
              .checked(!this.isInitStyle)
              .height(20)
              .width(20)
              .margin({ top: 14, bottom: 14, left: 14, right: 14 })
              .onChange((isChecked: boolean) => {
                console.log('Radio status is ' + isChecked);
                try {
                  pointer.setPointerStyle(-1, pointer.PointerStyle.LOADING).then(() => {
                    console.log(`Set pointer style success`);
                  })
                } catch (error) {
                  console.log(`Set pointer style failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                }
              })
          }
          .height(56)
          .width('100%')
        }
        .borderRadius(24)
        .padding({ top: 4, bottom: 4, left: 12 })
        .backgroundColor(Color.White)
      }
      .constraintSize({ minWidth: 584 })
      .margin({ left: 12, right: 12 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }

  @Builder deviceShow(device: Resource, info: Resource) {
    Image(device)
      .width(40)
      .height(40)
      .margin({ right: 12 })
      .backgroundColor('#F1F3F5')
      .borderRadius(8)

    Text(info)
      .fontSize(16)
      .fontColor('#182431')
      .fontWeight(FontWeight.Medium)
  }
}