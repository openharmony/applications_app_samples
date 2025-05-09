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

// [Start set_dialog_nest]
@CustomDialog
struct CustomDialogExampleTwo {
  controllerTwo?: CustomDialogController;
  @State message: string = 'I am the second dialog box.';
  @State showIf: boolean = false;

  build() {
    Column() {
      Text('this is the second dialog')
        .padding({ top: 24, right: 24, left: 24 })
      Row({ space: 8 }) {
        Button() {
          Text('close dialog')
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_emphasize'))
            .lineHeight(21)
        }
        .onClick(() => {
          this.controllerTwo?.close();
        })
        .layoutWeight(1)
        .backgroundColor(Color.Transparent)
        .width(360)
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

@CustomDialog
struct CustomDialogExample {
  openSecondBox?: () => void;
  controller?: CustomDialogController;

  build() {
    Column() {
      Text('Click Confirm to open the second dialog')
        .padding({ top: 24, right: 24, left: 24 })
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
          this.controller?.close();
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
          this.controller!.close();
          this.openSecondBox!();
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
export struct NestDialog {
  @State inputValue: string = 'Click Me';
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({
      openSecondBox: () => {
        if (this.dialogControllerTwo != null) {
          this.dialogControllerTwo.open()
        }
      }
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })
  dialogControllerTwo: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExampleTwo(),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -25 }
  })

  aboutToDisappear() {
    this.dialogController = null;
    this.dialogControllerTwo = null;
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
          Button(this.inputValue)
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
    .title($r('app.string.CustomDialog_nest'))
  }
}
// [End set_dialog_nest]