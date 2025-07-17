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
// [Start display_sync_by_ui_import_module]
import { displaySync } from "@kit.ArkGraphics2D";
// [End display_sync_by_ui_import_module]
import { router } from "@kit.ArkUI";

// [Start display_sync_by_ui_complete_example]
// [Start display_sync_create_object]
@Entry
@Component
struct Index {
  // [StartExclude display_sync_create_object]
  @State drawFirstSize: number = 25;
  @State drawSecondSize: number = 25;
  // [EndExclude display_sync_create_object]
  private backDisplaySyncSlow: displaySync.DisplaySync | undefined = undefined;
  private backDisplaySyncFast: displaySync.DisplaySync | undefined = undefined;
// [End display_sync_create_object]
  private isBigger_30: boolean = true;
  private isBigger_60: boolean = true;

  // [Start display_sync_create_text_component]
  @Builder
  doSomeRenderFirst() {
    Text('30')
      .fontSize(this.drawFirstSize)
  }

  @Builder
  doSomeRenderSecond() {
    Text('60')
      .fontSize(this.drawSecondSize)
  }
  // [End display_sync_create_text_component]

  // [Start display_sync_frame_rate_setting_and_subscription_function_registration]
  CreateDisplaySyncSlow() {
    let range: ExpectedFrameRateRange = {
      expected: 30,
      min: 0,
      max: 120
    };

    let draw30 = (intervalInfo: displaySync.IntervalInfo) => {
      if (this.isBigger_30) {
        this.drawFirstSize += 1;
        if (this.drawFirstSize > 150) {
          this.isBigger_30 = false;
        }
      } else {
        this.drawFirstSize -= 1;
        if (this.drawFirstSize < 25) {
          this.isBigger_30 = true;
        }
      }
    };

    this.backDisplaySyncSlow = displaySync.create();
    this.backDisplaySyncSlow.setExpectedFrameRateRange(range);
    this.backDisplaySyncSlow.on("frame", draw30);
  }
  // [End display_sync_frame_rate_setting_and_subscription_function_registration]

  CreateDisplaySyncFast() {
    let range: ExpectedFrameRateRange = {
      expected: 60,
      min: 0,
      max: 120
    };

    let draw60 = (intervalInfo: displaySync.IntervalInfo) => {
      if (this.isBigger_60) {
        this.drawSecondSize += 1;
        if (this.drawSecondSize > 150) {
          this.isBigger_60 = false;
        }
      } else {
        this.drawSecondSize -= 1;
        if (this.drawSecondSize < 25) {
          this.isBigger_60 = true;
        }
      }
    };

    this.backDisplaySyncFast = displaySync.create();
    this.backDisplaySyncFast.setExpectedFrameRateRange(range);
    this.backDisplaySyncFast.on("frame", draw60);
  }

  // [Start display_sync_call_stop]
  aboutToDisappear() {
    if (this.backDisplaySyncSlow) {
      this.backDisplaySyncSlow.stop();
      this.backDisplaySyncSlow = undefined;
    }
    if (this.backDisplaySyncFast) {
      this.backDisplaySyncFast.stop();
      this.backDisplaySyncFast = undefined;
    }
  }
  // [End display_sync_call_stop]

  build() {
    Column() {
      Row() {
        this.doSomeRenderFirst();
      }
      .height('40%')

      Row() {
        this.doSomeRenderSecond();
      }
      .height('40%')

      Row() {
        // [Start display_sync_start_per_frame_callback]
        Button('Start')
          .id('CustomDrawStart')
          .fontSize(14)
          .fontWeight(500)
          .margin({ bottom: 10, left: 5 })
          .fontColor(Color.White)
          .onClick((): void => {
            if (this.backDisplaySyncSlow == undefined) {
              this.CreateDisplaySyncSlow();
            }
            if (this.backDisplaySyncFast == undefined) {
              this.CreateDisplaySyncFast();
            }
            if (this.backDisplaySyncSlow) {
              this.backDisplaySyncSlow.start();
            }
            if (this.backDisplaySyncFast) {
              this.backDisplaySyncFast.start();
            }
          })
          .width('20%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
        // [End display_sync_start_per_frame_callback]

        // [Start display_sync_stop_per_frame_callback]
        Button('Stop')
          .id('CustomDrawStop')
          .fontSize(14)
          .fontWeight(500)
          .margin({ bottom: 10, left: 5 })
          .fontColor(Color.White)
          .onClick((): void => {
            if (this.backDisplaySyncSlow) {
              this.backDisplaySyncSlow.stop();
            }
            if (this.backDisplaySyncFast) {
              this.backDisplaySyncFast.stop();
            }
          })
          .width('20%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
        // [End display_sync_stop_per_frame_callback]

        Button('Back')
          .id('CustomDrawBack')
          .fontSize(14)
          .fontWeight(500)
          .margin({ bottom: 10, left: 5 })
          .fontColor(Color.White)
          .onClick((): void => {
            if (this.backDisplaySyncSlow) {
              this.backDisplaySyncSlow.stop();
            }
            if (this.backDisplaySyncFast) {
              this.backDisplaySyncFast.stop();
            }
            router.back();
          })
          .width('20%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)
    }
  }
}
// [End display_sync_by_ui_complete_example]