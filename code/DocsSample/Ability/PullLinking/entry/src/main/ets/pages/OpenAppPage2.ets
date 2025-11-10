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
// [Start can_open]
import { bundleManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

// [StartExclude can_open]
import { common, Want, wantConstant } from '@kit.AbilityKit';

const TAG: string = '[Page_UIAbilityComponentsInteractive]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct OpenAppPage2 {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  aboutToAppear() {
  // [EndExclude can_open]
    try {
      let link = 'app1Scheme://test.example.com/home'; // 此处为实际应用链接
      let canOpen = bundleManager.canOpenLink(link);
      hilog.info(0x0000, 'testTag', 'canOpenLink successfully: %{public}s', JSON.stringify(canOpen));
    } catch (err) {
      let message = (err as BusinessError).message;
      hilog.error(0x0000, 'testTag', 'canOpenLink failed: %{public}s', message);
    }
  // [StartExclude can_open]
  }
  build() {
    Column() {
      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            Button('MyAbility')
              .onClick(() => {
              })
          }
        }
      }
    }
  }
}
// [EndExclude can_open]
// [End can_open]