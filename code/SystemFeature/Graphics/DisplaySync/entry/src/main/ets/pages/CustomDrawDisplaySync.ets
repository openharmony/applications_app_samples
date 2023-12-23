/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import displaySync from '@ohos.graphics.displaySync';
import router from '@ohos.router';
import Logger from '../utils/Logger';
const TAG = '[CustomDrawDisplaySync]';

@Entry
@Component
struct Index {
  @State drawFirstSize: number = 25;
  @State drawSecondSize: number = 25;
  private backDisplaySyncSlow: displaySync.DisplaySync | undefined = undefined;
  private backDisplaySyncFast: displaySync.DisplaySync | undefined = undefined;
  private isBigger_30:boolean = true;
  private isBigger_60:boolean = true;

  @Builder doSomeRenderFirst() {
    Text('30')
      .fontSize(this.drawFirstSize)
  }

  @Builder doSomeRenderSecond() {
    Text('60')
      .fontSize(this.drawSecondSize)
  }

  CreateDisplaySyncSlow() {
    let range : ExpectedFrameRateRange = {
      expected: 30,
      min: 0,
      max: 120
    };

    let draw30 = (ii: displaySync.IntervalInfo) => {
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
      Logger.info(TAG, '[Draw30] Timestamp:' + ii.timestamp + ' TargetTimeStamp: ' + ii.targetTimestamp);
    };

    this.backDisplaySyncSlow = displaySync.create();
    this.backDisplaySyncSlow.setExpectedFrameRateRange(range);
    this.backDisplaySyncSlow.on("frame", draw30);
  }

  CreateDisplaySyncFast() {
    let range : ExpectedFrameRateRange = {
      expected: 60,
      min: 0,
      max: 120
    };

    let draw60 = (ii: displaySync.IntervalInfo) => {
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

      Logger.info(TAG, '[Draw60] Timestamp:' + ii.timestamp + ' TargetTimeStamp: ' + ii.targetTimestamp);
    };

    this.backDisplaySyncFast= displaySync.create();
    this.backDisplaySyncFast.setExpectedFrameRateRange(range);
    this.backDisplaySyncFast.on("frame", draw60);
  }

  aboutToDisappear() {
    if (this.backDisplaySyncSlow) {
      this.backDisplaySyncSlow.stop();
      this.backDisplaySyncSlow = undefined;
    }
    if (this.backDisplaySyncFast) {
      this.backDisplaySyncFast.stop();
      this.backDisplaySyncFast = undefined;
    }

    Logger.info(TAG, 'DisplaySyncDestructor set all displaySync null');
  }

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