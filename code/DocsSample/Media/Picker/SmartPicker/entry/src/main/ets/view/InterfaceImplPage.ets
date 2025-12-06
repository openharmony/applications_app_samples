/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { photoAccessHelper } from '@kit.MediaLibraryKit';
import SmartPhotoPickerUtils from '../common/utils/SmartPhotoPickerUtils';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Builder
export function InterfaceImplPageBuilder() {
  InterfaceImplPage()
}

@Component
struct InterfaceImplPage {
  @State content: string = '';
  @State recommendationType: number = 4;
  @State type: string = this.getUIContext().getHostContext()!.resourceManager.getStringSync($r('app.string.identity_card').id);

  @Builder
  selectMenuBuilder() {
    Menu() {
      MenuItem({ content: $r('app.string.identity_card') })
        .borderRadius(12)
        .padding({
          left: 8,
          right: 8
        })
        .onClick(() => {
          this.type = this.getUIContext().getHostContext()!.resourceManager.getStringSync($r('app.string.identity_card').id);
          this.recommendationType = photoAccessHelper.RecommendationType.ID_CARD;
        })
      MenuItem({ content: $r('app.string.QR_code') })
        .borderRadius(12)
        .padding({
          left: 8,
          right: 8
        })
        .onClick(() => {
          this.type = this.getUIContext().getHostContext()!.resourceManager.getStringSync($r('app.string.QR_code').id);
          this.recommendationType = photoAccessHelper.RecommendationType.QR_CODE;
        })
    }
  }

  build() {
    NavDestination() {
      Column() {
        Button($r('app.string.no_image_recommendation'))
          .width('100%')
          .height('40vp')
          .onClick(() => {
            SmartPhotoPickerUtils.photoPicker();
          })
        Row() {
          Text($r('app.string.Service_specific_recommendations'))
            .font({
              size: 14,
              weight: 500
            })
          Select([])
            .value(this.type)
            .bindMenu(this.selectMenuBuilder())
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height('40vp')
        .margin({ top: 24 })

        Button($r('app.string.Service_specific_recommendations'))
          .width('100%')
          .height('40vp')
          .margin({ top: 8 })
          .onClick(() => {
            SmartPhotoPickerUtils.smartPhotoPickerByRecommendType(this.recommendationType);
          })
        Row() {
          Text($r('app.string.text_recommendations'))
            .font({
              size: 14,
              weight: 500
            })
            .width('100%')
        }
        .width('100%')
        .margin({
          top: 24,
          bottom: 8
        })

        TextArea({ placeholder: $r('app.string.textInput') })
          .width('100%')
          .height('88vp')
          .lineHeight('20vp')
          .borderRadius(16)
          .margin({ bottom: 8 })
          .onChange((value: string) => {
            this.content = value;
          })
        Button($r('app.string.text_recommendations'))
          .width('100%')
          .height('40vp')
          .onClick(() => {
            SmartPhotoPickerUtils.smartPhotoPickerByTextInfo(this.content);
          })
      }
      .height('100%')
      .width('100%')
      .padding({
        left: 16,
        right: 16
      })
    }
    .title(this.resourceToString($r('app.string.Interface_recommendation')))
    .height('100%')
    .width('100%')
  }

  resourceToString(resource: Resource): string {
    let result = '';
    try {
      result = this.getUIContext()!.getHostContext()!.resourceManager.getStringSync(resource.id);
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x0000, 'TopTabContent', `getStringSync failed, error code=${err.code}, message=${err.message}`);
    }
    return result;
  }
}