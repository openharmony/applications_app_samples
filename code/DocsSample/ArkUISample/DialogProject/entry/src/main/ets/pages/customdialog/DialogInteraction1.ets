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

// [Start dialog_route_jump]
@CustomDialog
struct CustomDialogExample {
  @Link textValue: string;
  controller?: CustomDialogController;
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };

  build() {
    Column() {
      if (this.textValue != '') {
            Text(`The next content is：${this.textValue}`)
              .padding({ top: 24, right: 24, left: 24 })
          } else {
            Text('Whether to get the content of the second page')
              .padding({ top: 24, right: 24, left: 24 })
          }
      Row({ space: 8 }) {
        Button() {
          Text('refuse')
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_emphasize'))
            .lineHeight(21)
        }
        .onClick(() => {
          if (this.controller != undefined) {
                      this.controller.close();
                      this.cancel();
                    };
        })
        .layoutWeight(1)
        .backgroundColor(Color.Transparent)
        .width(180)
        .height(40)

        Button() {
          Text('confirm')
            .fontFamily('HarmonyHeiIi')
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_emphasize'))
        }
        .onClick(() => {
          if (this.controller != undefined && this.textValue != '') {
            this.controller.close();
          } else if (this.controller != undefined) {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/Index2'
            });
            this.controller.close();
          }
        })
        .layoutWeight(1)
        .backgroundColor(Color.Transparent)
        .width(180)
        .height(40)
      }
      .padding({
        top: 8,
        bottom: 16,
        left: 16,
        right: 16
      })
    }.width(400)

  }
}


@Entry
@Component
export struct DialogInteraction1 {
  @State textValue: string = ''
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: () => {
        this.onCancel();
      },
      confirm: () => {
        this.onAccept();
      },
      textValue: $textValue
    })
  })

  // 在自定义组件即将析构销毁时将dialogController置空
  aboutToDisappear() {
    this.dialogController = null; // 将dialogController置空
  }

  onPageShow() {
    const params = this.getUIContext().getRouter().getParams() as Record<string, string>; // 获取传递过来的参数对象
    if (params) {
      this.dialogController?.open();
      this.textValue = params.info as string; // 获取info属性的值
    }
  }

  onCancel() {
    console.info('Callback when the first button is clicked');
  }

  onAccept() {
    console.info('Callback when the second button is clicked');
  }

  exitApp() {
    console.info('Click the callback in the blank area');
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column() {
          Button('click me')
            .onClick(() => {
              if (this.dialogController != null) {
                this.dialogController.open();
              }
            }).backgroundColor(0x317aff)
        }.width('100%').margin({ top: 5 })

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CustomDialog_interaction1'))
  }
}
// [End dialog_route_jump]
