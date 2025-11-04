/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0xF811;
const TAG = '[Sample_ArkTSRouter]';

// [Start home_param1]
class DataModelInfo {
  public age: number = 0;
}

class DataModel {
  public id: number = 0;
  public info: DataModelInfo | null = null;
}
// [End home_param1]

@Entry
@Component
struct IndexPara {
  // [Start home_param2]
  onJumpClick(): void {
    // 在Home页面中
    let paramsInfo: DataModel = {
      id: 123,
      info: {
        age: 20
      }
    };

    this.getUIContext().getRouter().pushUrl({
      url: 'pages/pageRouter/jumpPage/DetailPara', // 目标url
      params: paramsInfo // 添加params属性，传递自定义参数
    }, (err) => {
      if (err) {
        hilog.error(DOMAIN, TAG,`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      hilog.error(DOMAIN, TAG,'Invoke pushUrl succeeded.');
    });
  }
  // [End home_param2]

  @State message: string = 'Home Page Pass Params';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('Pass Params to Detail', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.onJumpClick();
          })
      }.width('100%')
    }.height('100%')
  }
}