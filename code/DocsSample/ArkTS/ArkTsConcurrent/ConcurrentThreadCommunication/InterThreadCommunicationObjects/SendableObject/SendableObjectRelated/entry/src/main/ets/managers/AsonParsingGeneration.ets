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

// [Start example_serialize]
import { ArkTSUtils, collections } from '@kit.ArkTS';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          console.info(ArkTSUtils.ASON.parse('{}'));
          console.info(ArkTSUtils.ASON.stringify(new collections.Array(1, 2, 3)));

          let options2: ArkTSUtils.ASON.ParseOptions = {
            bigIntMode: ArkTSUtils.ASON.BigIntMode.PARSE_AS_BIGINT,
            parseReturnType: ArkTSUtils.ASON.ParseReturnType.MAP,
          }
          let jsonText = '{"largeNumber":112233445566778899}';
          let map = ArkTSUtils.ASON.parse(jsonText, undefined, options2);
          // 执行结果为：{"largeNumber":112233445566778899}
          console.info(ArkTSUtils.ASON.stringify(map));
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End example_serialize]
