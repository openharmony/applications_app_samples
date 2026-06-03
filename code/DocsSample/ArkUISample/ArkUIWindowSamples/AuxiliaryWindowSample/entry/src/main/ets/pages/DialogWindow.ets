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
import { window } from '@kit.ArkUI';

@Entry
@Component
struct DialogWindow {
  @State message: string = 'DialogWindow';

  destroyDialogWindow() {
    let dialog_windowClass: window.Window | undefined = undefined;
    dialog_windowClass = window.findWindow("DialogWindow");
    if (!dialog_windowClass) {
      console.error('dailog_windowClass is null');
      return;
    }
    // [Start destroy_dialog_window]
    // 4.销毁子窗口。当不再需要子窗口时，可根据具体实现逻辑，使用destroy对其进行销毁。
    dialog_windowClass.destroyWindow((err: BusinessError) => {
      let errCode: number = err.code;
      if (errCode) {
        console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in destroying the window.');
    });
    // [End destroy_dialog_window]
  }

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('DialogWindowHelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

      Button("销毁模态窗")
        .onClick(async () => {
          this.destroyDialogWindow();
        }).margin(5)
    }
    .height('100%')
    .width('100%')
  }
}