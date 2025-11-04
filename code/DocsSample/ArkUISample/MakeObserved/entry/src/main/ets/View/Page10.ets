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
// [Start getTarget_observedObj]
import { UIUtils } from '@kit.ArkUI';
class Info {
  public id: number = 0;
}

@Entry
@Component
struct Page10 {
  observedObj: Info = UIUtils.makeObserved(new Info());
  build() {
    Column() {
      Text(`${this.observedObj.id}`)
        .id('textobservedObj1')
        .fontSize(50)
        .onClick(() => {
          // 通过getTarget获取其原始对象，将this.observedObj赋值为不可观察的数据
          let rawObj: Info= UIUtils.getTarget(this.observedObj);
          // 不会触发UI刷新，但数据会正常赋值
          rawObj.id = 20;
        })

      Text(`${this.observedObj.id}`)
        .id('textobservedObj2')
        .fontSize(50)
        .onClick(() => {
          // 触发UI刷新，Text显示21
          this.observedObj.id++;
        })
    }
  }
}
// [End getTarget_observedObj]