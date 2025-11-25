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
// [Start Index_start]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN_NUMBER: number = 0XFF00;
const TAG: string = '[Sample_StateTrack]';
class Info {
  public name: string = 'Jack';
  public age: number = 12;
}

@Entry
@Component
struct Index {
  @State info: Info = new Info();

  // 借助getFontSize的日志打印，可以分辨哪个组件触发了渲染
  getFontSize(id: number): number {
    hilog.info(DOMAIN_NUMBER, TAG, `Component ${id} render`);
    return 30;
  }

  build() {
    Column() {
      Text(`name: ${this.info.name}`)
        .fontSize(this.getFontSize(1))
      Text(`age: ${this.info.age}`)
        .fontSize(this.getFontSize(2))

      // 点击当前Button，可以发现当前虽然仅改变了name属性
      // 但是依旧会触发两个Text的刷新
      // Text(`age: ${this.info.age}`)是冗余刷新
      Button('change name').onClick(() => {
        this.info.name = 'Jane';
      })

      // 点击当前Button，可以发现当前虽然仅改变了age属性
      // 但是依旧会触发两个Text的刷新
      // Text(`name: ${this.info.name}`)是冗余刷新
      Button('change age').onClick(() => {
        this.info.age++;
      })
    }
    .height('100%')
    .width('100%')
  }
}
// [End Index_start]