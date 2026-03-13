/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { router } from '@kit.ArkUI';

@Entry
@Component
struct PbrPage {
  build() {
    Column({ space: 20 }) {
      Button('PBR material – baseColor')
        .id('pbr_basic')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 15, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'material/pbr_basic'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              console.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            console.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40)

      Button('PBR material – clearcoat')
        .id('pbr_clearcoat')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 15, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'material/pbr_clearcoat'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              console.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            console.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40)

      Button('PBR material – clearcoat normal')
        .id('pbr_clearcoat_normal')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 15, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'material/pbr_clearcoat_normal'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              console.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            console.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40)

      Button('PBR material – ambientOcclusion')
        .id('pbr_ao')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 15, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'material/pbr_ao'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              console.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            console.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40);

      Button('PBR material – emissive')
        .id('pbr_emissive')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 15, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'material/pbr_emissive'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              console.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            console.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40)

      Button('PBR material – material')
        .id('pbr_material')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 15, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'material/pbr_material'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              console.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            console.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40)

      Button('PBR material – normal')
        .id('pbr_normal')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 15, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'material/pbr_normal'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              console.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            console.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40)

      Button('PBR material – sheen')
        .id('pbr_sheen')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 15, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'material/pbr_sheen'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              console.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            console.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40)

      Button('PBR material – specular')
        .id('pbr_specular')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 15, left: 6 })
        .onClick((): void => {
          router.pushUrl({
            url: 'material/pbr_specular'
          }, router.RouterMode.Standard, (err) => {
            if (err) {
              console.error('Invoke replaceUrl failed, code is %{public}s, message is %{public}s');
              return;
            }
            console.info('Invoke replaceUrl succeeded.');
          });
        })
        .width('80%')
        .height(40)

      Button('back')
        .id('back')
        .fontSize(16)
        .fontWeight(500)
        .margin({ top: 15, left: 6 })
        .onClick(() => {
          router.back();
        })
        .width('80%')
        .height(40);
    }
    .width('100%');
  }
}
