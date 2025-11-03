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
// [Start styledStringBaselineOffsetStyle_start]
import { LengthMetrics } from '@kit.ArkUI';

// xxx.ets
@Entry
@Component
struct styled_string_demo5 {
  @State str: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringSync($r('app.string.CreateApply_Text_Third_Five')) as string;
  mutableStyledString: MutableStyledString = new MutableStyledString(this.str, [
    {
      start: 0,
      length: 3,
      styledKey: StyledStringKey.BASELINE_OFFSET,
      styledValue: new BaselineOffsetStyle(LengthMetrics.px(20))
    }
  ]);
  controller: TextController = new TextController();

  async onPageShow() {
    this.controller.setStyledString(this.mutableStyledString);
  }

  build() {
    Column() {
      // 显示属性字符串
      Text(undefined, { controller: this.controller })
    }
    .width('100%')
  }
}
// [End styledStringBaselineOffsetStyle_start]