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
// [Start create_sub_window2_index]
// Index.ets
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';

const DOMAIN = 0X0000;
const TAG : string = '[Sample_CreatSubWindow2]';

let windowStage_: window.WindowStage | undefined = undefined;
let sub_windowClass: window.Window | undefined = undefined;
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private createSubWindow(){
    // 获取windowStage
    windowStage_ = AppStorage.get('windowStage');
    // 1.创建应用子窗口。
    if (windowStage_ == null) {
      hilog.error(DOMAIN, TAG, `Failed to create the subwindow. Cause: windowStage_ is null`);
    }
    else {
      windowStage_.createSubWindow("mySubWindow", (err: BusinessError, data) => {
        let errCode: number = err.code;
        if (errCode) {
          hilog.error(DOMAIN, TAG, `Failed to create the subwindow. Cause: ${JSON.stringify(err)}`);
          return;
        }
        sub_windowClass = data;
        if (!sub_windowClass) {
          hilog.error(DOMAIN, TAG, `sub_windowClass is null`);
          return;
        }
        hilog.info(DOMAIN, TAG, `Succeeded in creating the subwindow. Data: ${JSON.stringify(data)}`);
        // 2.子窗口创建成功后，设置子窗口的位置、大小及相关属性等。
        sub_windowClass.moveWindowTo(300, 300, (err: BusinessError) => {
          let errCode: number = err.code;
          if (errCode) {
            hilog.error(DOMAIN, TAG, `Failed to move the window. Cause: ${JSON.stringify(err)}`);
            return;
          }
          hilog.info(DOMAIN, TAG, `Succeeded in moving the window.`);
        });
        sub_windowClass.resize(500, 500, (err: BusinessError) => {
          let errCode: number = err.code;
          if (errCode) {
            hilog.error(DOMAIN, TAG, `Failed to change the window size. Cause: ${JSON.stringify(err)}`);
            return;
          }
          hilog.info(DOMAIN, TAG, `Succeeded in changing the window size.`);
        });
        // 3.为子窗口加载对应的目标页面。
        sub_windowClass.setUIContent("pages/SubWindow", (err: BusinessError) => {
          let errCode: number = err.code;
          if (errCode) {
            hilog.error(DOMAIN, TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
            return;
          }
          hilog.info(DOMAIN, TAG, `Succeeded in loading the content.`);
          if (!sub_windowClass) {
            hilog.error(DOMAIN, TAG, `sub_windowClass is null`);
            return;
          }
          // 3.显示子窗口。
          sub_windowClass.showWindow((err: BusinessError) => {
            let errCode: number = err.code;
            if (errCode) {
              hilog.error(DOMAIN, TAG, `Failed to show the window. Cause: ${JSON.stringify(err)}`);
              return;
            }
            hilog.info(DOMAIN, TAG, `Succeeded in showing the window.`);
          });
        });
      })
    }
  }
  private destroySubWindow(){
    if (!sub_windowClass) {
      hilog.error(DOMAIN, TAG, `sub_windowClass is null`);
      return;
    }
    // 4.销毁子窗口。当不再需要子窗口时，可根据具体实现逻辑，使用destroy对其进行销毁。
    sub_windowClass.destroyWindow((err: BusinessError) => {
      let errCode: number = err.code;
      if (errCode) {
        hilog.error(DOMAIN, TAG, `Failed to destroy the window. Cause: ${JSON.stringify(err)}`);
        return;
      }
      hilog.info(DOMAIN, TAG, `Succeeded in destroying the window.`);
    });
  }
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button(){
          Text('CreateSubWindow')
            .fontSize(24)
            .fontWeight(FontWeight.Normal)
        }.width(220).height(68)
        .margin({left:10, top:60})
        .onClick(() => {
          this.createSubWindow()
        })
        Button(){
          Text('destroySubWindow')
            .fontSize(24)
            .fontWeight(FontWeight.Normal)
        }.width(220).height(68)
        .margin({left:10, top:60})
        .onClick(() => {
          this.destroySubWindow()
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End create_sub_window2_index]