/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { CertFrameworkModel, IDataInfo } from '../model/CertFrameworkModel'
import promptAction from '@ohos.promptAction';
import Logger from '../model/Logger'
import { TAG } from '../model/Data';

@Component
export struct CertFramework {
  @State certTextInfo: string = '';
  @State originTextInfo: string = '';
  @State signTextInfo: string = '';
  private certFramework: CertFrameworkModel = new CertFrameworkModel();
  private promot = (msg: Resource) => {
    promptAction.showToast(
      {
        message: msg,
        duration: 2000,
        bottom: 122
      }
    )
  };

  build() {
    Column() {
      Column() {
        Text($r('app.string.certificate_data'))
          .fontWeight(500)
          .fontColor($r('sys.color.ohos_id_color_foreground'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .margin({ top: '19.5vp', left: '24vp', bottom: '9.5vp' })
      }
      .width('100%')
      .height('48vp')
      .alignItems(HorizontalAlign.Start)

      Column() {
        Column() {
          Scroll() {
            Text(this.certTextInfo)
              .fontColor($r('sys.color.ohos_id_color_foreground'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .lineHeight('19vp')
              .textAlign(TextAlign.Start)
              .width('100%')
          }
          .height('103vp')
          .margin({ top: '8vp', left: '16vp', right: '16vp' })

          Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
            Text(`${this.certTextInfo.length || 0}`)
              .fontColor($r('sys.color.ohos_id_color_foreground'))
              .fontSize($r('sys.float.ohos_id_text_size_caption'))
              .margin({ top: '8vp', right: '21vp' })
              .lineHeight('14vp')
              .opacity(0.4)
          }
        }
        .height('139vp')
        .backgroundColor($r('app.color.text_bg_color'))
        .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
        .margin({ left: '12vp', right: '12vp' })
        .align(Alignment.TopStart)
      }
      .width('100%')
      .height('139vp')
      .alignItems(HorizontalAlign.Center)

      Column() {
        Text($r('app.string.origin_data'))
          .fontWeight(500)
          .fontColor($r('sys.color.ohos_id_color_foreground'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .margin({ top: '19.5vp', left: '24vp', bottom: '9.5vp' })
      }
      .width('100%')
      .height('48vp')
      .alignItems(HorizontalAlign.Start)

      Column() {
        Column() {
          Scroll() {
            Text(this.originTextInfo)
              .fontColor($r('sys.color.ohos_id_color_foreground'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .lineHeight('19vp')
              .textAlign(TextAlign.Start)
              .width('100%')
          }
          .height('103vp')
          .margin({ top: '8vp', left: '16vp', right: '16vp' })

          Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
            Text(`${this.originTextInfo.length || 0}`)
              .fontColor($r('sys.color.ohos_id_color_foreground'))
              .fontSize($r('sys.float.ohos_id_text_size_caption'))
              .margin({ top: '8vp', right: '21vp' })
              .lineHeight('14vp')
              .opacity(0.4)
          }
        }
        .height('139vp')
        .backgroundColor($r('app.color.text_bg_color'))
        .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
        .margin({ left: '12vp', right: '12vp' })
        .align(Alignment.TopStart)
      }
      .width('100%')
      .height('139vp')
      .alignItems(HorizontalAlign.Center)

      Column() {
        Text($r('app.string.signature_data'))
          .fontWeight(500)
          .fontColor($r('sys.color.ohos_id_color_foreground'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .margin({ top: '19.5vp', left: '24vp', bottom: '9.5vp' })
      }
      .width('100%')
      .height('48vp')
      .alignItems(HorizontalAlign.Start)

      Column() {
        Column() {
          Scroll() {
            Text(this.signTextInfo)
              .fontColor($r('sys.color.ohos_id_color_foreground'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .lineHeight('19vp')
              .textAlign(TextAlign.Start)
              .width('100%')
          }
          .height('103vp')
          .margin({ top: '8vp', left: '16vp', right: '16vp' })

          Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
            Text(`${this.signTextInfo.length || 0}`)
              .fontColor($r('sys.color.ohos_id_color_foreground'))
              .fontSize($r('sys.float.ohos_id_text_size_caption'))
              .margin({ top: '8vp', right: '21vp' })
              .lineHeight('14vp')
              .opacity(0.4)
          }
        }
        .height('139vp')
        .backgroundColor($r('app.color.text_bg_color'))
        .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
        .margin({ left: '12vp', right: '12vp' })
        .align(Alignment.TopStart)
      }
      .width('100%')
      .height('139vp')
      .alignItems(HorizontalAlign.Center)

      Column() {
        Row() {
          Button({ type: ButtonType.Capsule, stateEffect: false }) {
            Text($r('app.string.display_data'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontColor($r('app.color.button_display_title_color'))
              .height('40vp')
          }
          .width('200vp')
          .backgroundColor($r('app.color.button_display_bg_color'))
          .margin({ right: '16vp' })
          .id('dataDispalyButton')
          .onClick(() => {
            this.certFramework.dataDisplay((result: IDataInfo) => {
              this.certTextInfo = result.certInfo;
              this.originTextInfo = result.originInfo;
              this.signTextInfo = result.signatureInfo;
            })
          })

          Button({ type: ButtonType.Capsule, stateEffect: false }) {
            Text($r('app.string.verify'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontColor($r('app.color.button_verify_title_color'))
              .height('40vp')
          }
          .width('200vp')
          .backgroundColor($r('app.color.button_verify_bg_color'))
          .id('verifyButton')
          .onClick(() => {
            this.certFramework.verify((result: boolean) => {
              if (result == true && this.certTextInfo) {
                Logger.info(TAG, 'verify: PASS!!!');
                this.promot($r('app.string.verify_success'))
              } else {
                Logger.info(TAG, 'verify: FAILED!!!');
                this.promot($r('app.string.verify_fail'))
              }
            })
          })
        }
        .margin({ left: '24vp', right: '24vp' })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .margin({ top: '23vp' })

      Column() {
        Row() {
          Button({ type: ButtonType.Capsule, stateEffect: false }) {
            Text($r('app.string.modify_origin_data'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontColor($r('app.color.button_modify_origin_data_title_color'))
              .height('40vp')
          }
          .width('200vp')
          .backgroundColor($r('app.color.button_modify_origin_data_bg_color'))
          .margin({ right: '16vp' })
          .id('modifyOriginDataButton')
          .onClick(() => {
            this.certFramework.modifyOriginData((result: IDataInfo) => {
              this.originTextInfo = result.originInfo;
              this.signTextInfo = result.signatureInfo;
            })
          })

          Button({ type: ButtonType.Capsule, stateEffect: false }) {
            Text($r('app.string.modify_signature_data'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontColor($r('app.color.button_modify_signature_data_title_color'))
              .height('40vp')
          }
          .width('200vp')
          .backgroundColor($r('app.color.button_modify_signature_data_bg_color'))
          .id('modifySignatureDataButton')
          .onClick(() => {
            this.certFramework.modifySignatureData((result: IDataInfo) => {
              this.originTextInfo = result.originInfo;
              this.signTextInfo = result.signatureInfo;
            })
          })
        }
        .margin({ left: '24vp', right: '24vp' })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .margin({ top: '12vp' })
    }
    .width('100%')
    .height('100%')
  }
}