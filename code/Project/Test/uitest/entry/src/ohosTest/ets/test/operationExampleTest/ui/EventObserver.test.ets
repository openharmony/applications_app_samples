/**
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

// [Start eventObserver_sample]
  import { describe, it, TestType, Size, Level } from '@ohos/hypium';
  // 导入测试依赖kit
  import { Driver, UIElementInfo } from '@kit.TestKit';

  export default function abilityTest() {
    describe('eventObserver_sample', () => {
      // 监听Toast控件出现
      it("toastObserver", TestType.FUNCTION, async () => {
        let driver = Driver.create();
        let observer = driver.createUIEventObserver();
        let callback = (uiElementInfo : UIElementInfo) => {
          let bundleName = uiElementInfo.bundleName;
          let text = uiElementInfo.text;
          let type = uiElementInfo.type;
        }
        observer.once('toastShow', callback);
      })
    })
  }
  // [End eventObserver_sample]