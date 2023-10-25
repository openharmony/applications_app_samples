/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import systemParameter from '@ohos.systemParameterEnhance';
import { ColumnOperation } from '../components/ColumnOperation';
import { BusinessError } from '@ohos.base';

@Preview
@Component
export struct SystemParameter {
  @State result: string = '';

  build() {
    Scroll() {
      Column() {
        Row() {
          Text(this.result)
            .fontWeight(FontWeight.Medium)
            .fontSize(20)
        }
        .alignItems(VerticalAlign.Top)
        .width('100%')
        .backgroundColor($r("app.color.white"))
        .height(160)
        .padding(16)
        .borderRadius(20)
        .margin({ top: 16 })
        ColumnOperation({ operationRes: $r('app.strarray.system_parameter'), doOperation: this.doOperation })
      }
      .width('100%')
      .padding(4)
    }
    .scrollBar(BarState.Off)
  }

  doOperation = async (index: number) => {
    switch (index) {
      case 0:
        try {
          let that = this;
          systemParameter.set("const.parameter.test_key", "test", (err: BusinessError) => {
            if (err == undefined) {
              that.result = `set const.parameter.test_key success`;
            } else {
              that.result = `set const.parameter.test_key fail:${JSON.stringify(err)}`;
            }
          })
        } catch (err) {
          this.result = `set const.parameter.test_key err:${JSON.stringify(err)}`;
        }
        break
      case 1:
        try {
          let that = this;
          systemParameter.get("const.parameter.test_key", (err: BusinessError, data: string) => {
            if (err == undefined) {
              that.result = `get const.parameter.test_key success:${data}`;
            } else {
              that.result = `get const.parameter.test_key fail:${JSON.stringify(err)}`;
            }
          })
        } catch (err) {
          this.result = `get const.parameter.test_key err:${JSON.stringify(err)}`;
        }
        break
      default:
        break
    }
  }
}