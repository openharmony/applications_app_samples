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

import { UIUtils } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Observed
class Translate {
  public translateX: number = 20;
}

@Component
struct Title {
  @ObjectLink translateObj: Translate;

  build() {
    Row() {
      // $r('app.media.background')需要替换为开发者所需的资源文件。
      Image($r('app.media.background'))
        .width(50)
        .height(50)
        .translate({
          x: this.translateObj.translateX // this.translateObj.translateX 绑定在Image和Text组件上。
        })
      Text('Title')
        .fontSize(20)
        .translate({
          x: this.translateObj.translateX
        })
    }
  }
}

@Entry
@Component
struct Page {
  @State translateObj: Translate = new Translate();

  build() {
    Column() {
      Title({
        translateObj: this.translateObj
      })
      Stack() {
      }
      .backgroundColor('black')
      .width(200)
      .height(400)
      .translate({
        x: this.translateObj.translateX //this.translateObj.translateX 绑定在Stack和Button组件上。
      })

      // [Start control_counter_error]
      Button('move')
        .translate({
          x: this.translateObj.translateX
        })
        .onClick(() => {
          this.getUIContext().animateTo({
            duration: 50
          }, () => {
            // 在修改状态变量之前，调用canBeObserved接口获取状态变量关联的组件
            hilog.info(0x00, 'test_log', `res: ${JSON.stringify(UIUtils.canBeObserved(this.translateObj))}`);
            this.translateObj.translateX = (this.translateObj.translateX + 50) % 150;
          });
        })
      // [End control_counter_error]
    }
  }
}