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

// [Start native-bundle-guidelines_005]
import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message = 'Welcome';
            hilog.info(DOMAIN, 'testTag', 'Test NAPI 2 + 3 = %{public}d', testNapi.add(2, 3));
            let appInfo = testNapi.getCurrentApplicationInfo();
            console.info("bundleNative getCurrentApplicationInfo success, data is " + JSON.stringify(appInfo));
            let appId = testNapi.getAppId();
            console.info("bundleNative getAppId success, appId is " + appId);
            let appIdentifier = testNapi.getAppIdentifier();
            console.info("bundleNative getAppIdentifier success, appIdentifier is " + appIdentifier);
            let mainElement = testNapi.getMainElementName();
            console.info("bundleNative getMainElementName success, data is " + JSON.stringify(mainElement));
            let deviceType = testNapi.getCompatibleDeviceType();
            console.info("bundleNative getCompatibleDeviceType success, deviceType is " + deviceType);
            let isDebugMode = testNapi.isDebugMode();
            console.info("bundleNative isDebugMode success, isDebugMode is " + isDebugMode);
            let moduleMetadata = testNapi.getModuleMetadata();
            console.info("bundleNative getModuleMetadata success, data is " + JSON.stringify(moduleMetadata));
            let fileType: string = '.png';
            let abilityResourceInfo = testNapi.getAbilityResourceInfo(fileType);
            console.info("bundleNative getAbilityResourceInfo success, data is " + JSON.stringify(abilityResourceInfo));
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End native-bundle-guidelines_005]