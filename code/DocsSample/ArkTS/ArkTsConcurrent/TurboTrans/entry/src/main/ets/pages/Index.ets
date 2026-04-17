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
import { test_pb } from '../protobuf/test_pb';
import { LayoutS } from '../turbotrans_JSON/layout';
import { taskpool } from '@kit.ArkTS';
import { observeJSON1, observeProtobuf } from './concurrentFunc';
import { UIUtils } from '@kit.ArkUI';

// [Start tranferabledObject_Text]
@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Hello World';
  @Local layout: LayoutS = new LayoutS();
  @Local pb: test_pb = test_pb.create();

  build() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })

      Button('运行TaskPool测试')
        .width('80%')
        .height(50)
        .margin({ top: 20, bottom: 20 })
        .onClick(() => {
          this.runTests();
        })

      Scroll() {
        Column() {
          Text(`TestProtobuf: ${this.pb.value_string}`)
            .fontSize(14)
            .textAlign(TextAlign.Start)
            .backgroundColor(Color.White)
            .padding(10)
            .borderRadius(8)
            .margin({ bottom: 10 })
            .width('100%')

          Text(`TestJSON: ${this.layout.type}`)
            .fontSize(14)
            .textAlign(TextAlign.Start)
            .backgroundColor(Color.White)
            .padding(10)
            .borderRadius(8)
            .margin({ bottom: 10 })
            .width('100%')
        }
        .width('100%')
        .padding(10)
      }
      .height('60%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .padding(20)
    .backgroundColor('#F5F5F5')
  }

// [StartExclude tranferabledObject_Text]
// [Start tranferabledObject_makeObserved]
  runTests() {
    taskpool.execute(observeProtobuf).then((res: test_pb) => {
      this.pb = UIUtils.makeObserved(res);
    })
    taskpool.execute(observeJSON1).then((res) => {
      this.layout = UIUtils.makeObserved(res as LayoutS);
    })
  }
// [End tranferabledObject_makeObserved]
// [EndExclude tranferabledObject_Text]
}
// [End tranferabledObject_Text]