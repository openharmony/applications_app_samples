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

import promptAction from '@ohos.promptAction';
import { CertChainModel } from '../model/CertChainModel';
import Logger from '../model/Logger';

@Component
export struct CertChain {
  @State certChainData: string = '';
  @State certChainRoot: string = '';
  @State certChainCRL: string = '';
  @State hasCrl: boolean = false
  private certChain: CertChainModel = new CertChainModel();
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
        Text($r('app.string.certchain_data'))
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
            Text(this.certChainData)
              .fontColor($r('sys.color.ohos_id_color_foreground'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .lineHeight('19vp')
              .textAlign(TextAlign.Start)
              .width('100%')
          }
          .height('103vp')
          .margin({ top: '8vp', left: '16vp', right: '16vp' })

          Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
            Text(`${this.certChainData.length || 0}`)
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
        Text($r('app.string.certchain_root'))
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
            Text(this.certChainRoot)
              .fontColor($r('sys.color.ohos_id_color_foreground'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .lineHeight('19vp')
              .textAlign(TextAlign.Start)
              .width('100%')
          }
          .height('103vp')
          .margin({ top: '8vp', left: '16vp', right: '16vp' })

          Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
            Text(`${this.certChainRoot.length || 0}`)
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
        Text($r('app.string.certchain_crl'))
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
            Text(this.certChainCRL)
              .fontColor($r('sys.color.ohos_id_color_foreground'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .lineHeight('19vp')
              .textAlign(TextAlign.Start)
              .width('100%')
          }
          .height('103vp')
          .margin({ top: '8vp', left: '16vp', right: '16vp' })

          Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
            Text(`${this.certChainCRL.length || 0}`)
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
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text($r('app.string.certchain_verify_crl'))
            .fontWeight(500)
            .fontColor($r('sys.color.ohos_id_color_foreground'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          Toggle({ type: ToggleType.Switch, isOn: false })
            .id('toggleSwitchCrl')
            .onChange((isOn: boolean) => {
              this.hasCrl = isOn
            })
        }
        .height('100%')
      }
      .height('56vp')
      .padding({ left: '12vp', right: '12vp' })
      .margin({ top: '12vp', left: '12vp', right: '12vp' })
      .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
      .backgroundColor($r('app.color.text_bg_color'))

      Column() {
        Row() {
          Button({ type: ButtonType.Capsule, stateEffect: false }) {
            Text($r('app.string.display_data'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontColor($r('sys.color.ohos_id_color_emphasize'))
              .height('40vp')
          }
          .width('200vp')
          .backgroundColor($r('app.color.button_modify_origin_data_bg_color'))
          .margin({ right: '16vp' })
          .id('certchainDataButton')
          .onClick(async () => {
            const res = await this.certChain.dataDisplay()
            this.certChainData = res.certChainData;
            this.certChainRoot = res.certChainRoot;
            this.certChainCRL = res.certChainCRL;
          })

          Button({ type: ButtonType.Capsule, stateEffect: false }) {
            Text($r('app.string.certchain_title'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontColor($r('app.color.button_verify_title_color'))
              .height('40vp')
          }
          .width('200vp')
          .backgroundColor($r('app.color.button_verify_bg_color'))
          .id('certchainValidateButton')
          .onClick(async () => {
            const res = await this.certChain.validate(this.hasCrl)
            if (res.code === 200 && this.certChainCRL) {
              this.promot($r('app.string.verify_success'));
            } else {
              this.promot($r('app.string.verify_fail'));
            }
          })
        }
        .margin({ left: '24vp', right: '24vp' })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .margin({ top: '7vp' })
    }
    .width('100%')
    .height('100%')
  }
}