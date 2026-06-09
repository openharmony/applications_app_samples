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
// [Start transferableObject_Text]
import { LayoutS } from '../turbotrans_JSON/layout';
import { taskpool } from '@kit.ArkTS';
import { observeJSON1 } from './concurrentFunc';
import { UIUtils } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Hello World';
  // 替换成 pb: test_pb = test_pb.create(); 则用于observeProtobuf返回Sendable对象的场景
  @Local layout: LayoutS = new LayoutS();

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
        .id('button')

      Scroll() {
        Column() {

          Text(`TestJSON: ${this.layout.type}`)
            .fontSize(24)
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

// [StartExclude transferableObject_Text]
// [Start transferableObject_makeObserved]
  runTests() {
    taskpool.execute(observeJSON1).then((res) => {
      this.layout = UIUtils.makeObserved(res as LayoutS);
    })
  }
// [End transferableObject_makeObserved]
// [EndExclude transferableObject_Text]
}
// [End transferableObject_Text]