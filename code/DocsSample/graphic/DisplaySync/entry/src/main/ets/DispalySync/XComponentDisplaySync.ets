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
// [Start display_sync_create_xcomponent]
import XComponentContext from '../interface/XComponentContext';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  private xComponentContext1: XComponentContext | undefined = undefined;
  private xComponentContext2: XComponentContext | undefined = undefined;

  build() {
    Column() {
      Row() {
        // [StartExclude display_sync_create_xcomponent]
        Text('30fps')
          .fontWeight(FontWeight.Bold)
          .fontSize(12)
          .fontColor(Color.Red)
          .textAlign(TextAlign.End)
          .width(40)
          .height(30)
        // [EndExclude display_sync_create_xcomponent]

        XComponent({
          id: 'xcomponentId_30',
          type: XComponentType.SURFACE,
          libraryname: 'entry'
        })
          .onLoad((xComponentContext) => {
            this.xComponentContext1 = xComponentContext as XComponentContext;
          }).width('640px')
          .backgroundColor(Color.White)


      }.height('40%')


      Row() {
        // [StartExclude display_sync_create_xcomponent]
        Text('120fps')
          .fontWeight(FontWeight.Bold)
          .fontSize(12)
          .fontColor(Color.Red)
          .textAlign(TextAlign.End)
          .width(40)
          .height(30)
        // [EndExclude display_sync_create_xcomponent]

        XComponent({
          id: 'xcomponentId_120',
          type: XComponentType.SURFACE,
          libraryname: 'entry'
        })
          .onLoad((xComponentContext) => {
            this.xComponentContext2 = xComponentContext as XComponentContext;
          }).width('640px')
          .backgroundColor(Color.White)
      }.height('40%')
      // [End display_sync_create_xcomponent]

      // [Start display_sync_start_and_stop_per_frame_callback]
      Row() {
        Button('Start')
          .id('Start')
          .fontSize(14)
          .fontWeight(500)
          .margin({ bottom: 20, right: 6, left: 6 })
          .onClick(() => {
            if (this.xComponentContext1) {
              this.xComponentContext1.register();
            }
            if (this.xComponentContext2) {
              this.xComponentContext2.register();
            }
          })
          .width('30%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button('Stop')
          .id('Stop')
          .fontSize(14)
          .fontWeight(500)
          .margin({ bottom: 20, left: 6 })
          .onClick(() => {
            if (this.xComponentContext1) {
              this.xComponentContext1.unregister();
            }
            if (this.xComponentContext2) {
              this.xComponentContext2.unregister();
            }
          })
          .width('30%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
        // [End display_sync_start_and_stop_per_frame_callback]

        Button('Back')
          .id('Back')
          .fontSize(14)
          .fontWeight(500)
          .margin({ bottom: 20, left: 6 })
          .onClick((): void => {
            if (this.xComponentContext1) {
              this.xComponentContext1.unregister();
            }
            if (this.xComponentContext2) {
              this.xComponentContext2.unregister();
            }
            router.back();
          })
          .width('30%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
      }
      .width('100%')
      .height('20%')
    }
  }
}