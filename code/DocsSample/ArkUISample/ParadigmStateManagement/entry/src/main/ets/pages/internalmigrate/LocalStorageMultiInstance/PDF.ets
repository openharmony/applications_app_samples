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

// [Start Internal_localStorage_multi_instance_4]
// PDF.ets
import PDFData from './model/PDFData';

@Entry
@ComponentV2
struct PDF {
  @Local message: string = 'uri';

  build() {
    Column() {
      Text(this.message)
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.Pink)
    .height('100%')
    .width('100%')
  }

  aboutToAppear(): void {
    // 此处只做简略显示uri，实际功能为打开渲染PDF文件
    const key: string = PDFData.getInstance().getFlag();
    // 根据唯一标识，从单例中获取页面对应数据
    this.message = PDFData.getInstance().getData().get(key) || '';
  }
}
// [End Internal_localStorage_multi_instance_4]