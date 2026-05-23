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

// [Start layered_image_006]
// [Start layered_image_007]
// [Start layered_image_008]
import { bundleManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [StartExclude layered_image_006]
// [StartExclude layered_image_007]
// [StartExclude layered_image_008]
@Entry
@Component
struct Index {

  build() {
    Scroll() {
      Column() {
        Text("SetAlternateIcon")
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            // [EndExclude layered_image_006]
            // alternateIconName需要替换为app.json5中alternateIcons标签下配置的name字段值
            let alternateIconName: string = 'summer_theme';
            try {
              bundleManager.setAlternateIcon(alternateIconName).then(() => {
                hilog.info(0x0000, 'testTag', 'setAlternateIcon successfully');
              }).catch((err: BusinessError) => {
                hilog.error(0x0000, 'testTag', 'setAlternateIcon failed. Cause: %{public}s', err.message);
              });
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(0x0000, 'testTag', 'setAlternateIcon failed. Cause: %{public}s', message);
            }
            // [End layered_image_006]
          })

        Text("RestoreDefaultIcon")
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            // [EndExclude layered_image_007]
            try {
              bundleManager.setAlternateIcon('').then(() => {
                hilog.info(0x0000, 'testTag', 'restore default icon successfully');
              }).catch((err: BusinessError) => {
                hilog.error(0x0000, 'testTag', 'restore default icon failed. Cause: %{public}s', err.message);
              });
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(0x0000, 'testTag', 'restore default icon failed. Cause: %{public}s', message);
            }
            // [End layered_image_007]
          })

        Text("GetAlternateIcons")
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            // [EndExclude layered_image_008]
            try {
              bundleManager.getAlternateIcons().then((data) => {
                hilog.info(0x0000, 'testTag', 'getAlternateIcons successfully. Data: %{public}s', JSON.stringify(data));
              }).catch((err: BusinessError) => {
                hilog.error(0x0000, 'testTag', 'getAlternateIcons failed. Cause: %{public}s', err.message);
              });
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(0x0000, 'testTag', 'getAlternateIcons failed. Cause: %{public}s', message);
            }
            // [End layered_image_008]
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}