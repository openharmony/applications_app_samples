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

import { CertManagerModel } from '../model/Model'
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Index {
  @State certTextInfo: string = '';
  @State originTextInfo: string = '';
  @State signTextInfo: string = '';
  private certManagerModel: CertManagerModel = new CertManagerModel();
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
        Text($r('app.string.module_desc'))
          .fontColor($r('sys.color.ohos_id_color_foreground'))
          .fontSize($r('sys.float.ohos_id_text_size_headline7'))
          .fontWeight(FontWeight.Bold)
          .margin({ top: '12vp', left: '24vp', bottom: '11vp' })
      }
      .width('100%')
      .height('56vp')
      .alignItems(HorizontalAlign.Start)

      Column() {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text($r('app.string.certificate_data'))
            .fontWeight(500)
            .fontColor($r('sys.color.ohos_id_color_foreground'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .margin({ top: '19.5vp', left: '24vp', bottom: '9.5vp' })

          Button({ type: ButtonType.Capsule, stateEffect: false }) {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($r('app.media.empties'))
                .width($r('sys.float.ohos_id_text_size_body3'))
                .margin({ right: '6vp' })
              Text($r('app.string.display_data'))
                .fontWeight(500)
                .fontSize($r('sys.float.ohos_id_text_size_body3'))
                .fontColor($r('app.color.button_display_title_color'))
            }
          }
          .width('100vp')
          .height('28vp')
          .backgroundColor($r('app.color.button_display_bg_color'))
          .margin({ right: '24vp' })
          .id('dispalyButton')
          .onClick(() => {
            const result = this.certManagerModel.dataDisplay();
            this.originTextInfo = result.originInfo;
            this.certTextInfo = result.certTextInfo;
            this.signTextInfo = '';
          })
        }
      }
      .width('100%')
      .height('48vp')

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
            Text(`${this.certTextInfo.length || 0}/100`)
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
            Text(`${this.originTextInfo.length || 0}/100`)
              .fontColor($r('sys.color.ohos_id_color_foreground'))
              .fontSize($r('sys.float.ohos_id_text_size_caption'))
              .margin({ top: '7vp', right: '21vp' })
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
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text($r('app.string.signature_data'))
            .fontWeight(500)
            .fontColor($r('sys.color.ohos_id_color_foreground'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .margin({ top: '19.5vp', left: '24vp', bottom: '9.5vp' })
          Button({ type: ButtonType.Capsule, stateEffect: false }) {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($r('app.media.presentation'))
                .width($r('sys.float.ohos_id_text_size_body3'))
                .margin({ right: '6vp' })
              Text($r('app.string.sign'))
                .fontWeight(500)
                .fontSize($r('sys.float.ohos_id_text_size_body3'))
                .fontColor($r('app.color.button_sign_title_color'))
            }
          }
          .width('100vp')
          .height('28vp')
          .backgroundColor($r('app.color.button_sign_bg_color'))
          .id('signButton')
          .margin({ right: '24vp' })
          .onClick(async () => {
            const result = await this.certManagerModel.sign();
            if (result.code == 200) {
              this.promot($r('app.string.sign_success'));
              this.signTextInfo = result.data;
            } else {
              this.promot($r('app.string.sign_fail'));
            }
          })
        }
      }
      .width('100%')
      .height('48vp')

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
            Text(`${this.signTextInfo.length || 0}/100`)
              .fontColor($r('sys.color.ohos_id_color_foreground'))
              .fontSize($r('sys.float.ohos_id_text_size_caption'))
              .lineHeight('14vp')
              .margin({ top: '7vp', right: '21vp' })
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
            Text($r('app.string.cert_install'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontColor($r('app.color.button_install_title_color'))
              .fontWeight(FontWeight.Medium)
              .height('40vp')
          }
          .width('200vp')
          .backgroundColor($r('app.color.button_install_bg_color'))
          .margin({ right: '16vp' })
          .id('installButton')
          .onClick(async () => {
            const result = await this.certManagerModel.install();
            if (result.code === 200) {
              this.promot($r('app.string.install_success'));
            } else {
              this.promot($r('app.string.install_fail'));
            }
          })

          Button({ type: ButtonType.Capsule, stateEffect: false }) {
            Text($r('app.string.verify'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontColor($r('app.color.button_verify_title_color'))
              .fontWeight(FontWeight.Medium)
              .height('40vp')
          }
          .width('200vp')
          .backgroundColor($r('app.color.button_verify_bg_color'))
          .id('verifyButton')
          .onClick(async () => {
            const result = await this.certManagerModel.verify();
            if (result.code == 200) {
              this.promot($r('app.string.verify_success'));
              this.signTextInfo = result.data;
            } else {
              this.promot($r('app.string.verify_fail'));
            }
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
              .fontWeight(FontWeight.Medium)
              .height('40vp')
          }
          .width('200vp')
          .backgroundColor($r('app.color.button_modify_origin_data_bg_color'))
          .margin({ right: '16vp' })
          .id('modifyOriginButton')
          .onClick(() => {
            const result = this.certManagerModel.modifyOriginData();
            this.originTextInfo = result.originInfo;
            this.signTextInfo = result.signatureInfo;
          })

          Button({ type: ButtonType.Capsule, stateEffect: false }) {
            Text($r('app.string.modify_signature_data'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontColor($r('app.color.button_modify_signature_data_title_color'))
              .fontWeight(500)
              .height('40vp')
          }
          .width('200vp')
          .backgroundColor($r('app.color.button_modify_signature_data_bg_color'))
          .id('modifySignatureButton')
          .onClick(async () => {
            const result = await this.certManagerModel.modifySignatureData()
            this.originTextInfo = result.originInfo;
            this.signTextInfo = result.signatureInfo;
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
    .backgroundColor($r('app.color.homepage_bg_color'))
  }
}