/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import dtvnoChannel from '../common/DtvNoChannel';

export interface ManualSearchPresentation {
  channelCountText: string;
  scanningText: string;
}

/**
 * Normalizes the frequency shown by the manual-search page.
 *
 * @param scanFrequencyMhz Raw frequency value from the entry flow or scan task.
 * @param fallbackFrequencyMhz Default frequency used when the input is invalid.
 * @returns number Stable frequency value safe for UI rendering.
 */
export function normalizeManualSearchFrequency(
  scanFrequencyMhz: number,
  fallbackFrequencyMhz: number = 0.5
): number {
  if (!Number.isFinite(scanFrequencyMhz) || scanFrequencyMhz < 0) {
    return fallbackFrequencyMhz;
  }
  return scanFrequencyMhz;
}

/**
 * Builds stable display text for the manual-search status area.
 *
 * @param channelCount Current discovered channel count.
 * @param scanFrequencyMhz Frequency shown while scanning.
 * @returns ManualSearchPresentation Ready-to-render manual-search text values.
 */
export function buildManualSearchPresentation(
  channelCount: number,
  scanFrequencyMhz: number
): ManualSearchPresentation {
  const safeChannelCount = channelCount >= 0 ? channelCount : 0;
  const safeFrequency = normalizeManualSearchFrequency(scanFrequencyMhz);
  return {
    channelCountText: `${safeChannelCount}`,
    scanningText: `正在搜台 ${safeFrequency.toFixed(1)} MHz`
  };
}
//手动搜台
@Entry
@Component
struct ManualSearch {
  private readonly manualSearchPresentation: ManualSearchPresentation =
    buildManualSearchPresentation(0, 0.5);
  manualSearchControllerDtv: CustomDialogController = new CustomDialogController({
    builder: dtvnoChannel({
      dtvmessage: '请确认 TV 天线接入正常并重新搜台。',
      dtvtitle: '没有搜到任何频道',
    }),
    openAnimation: {
      duration: 500
    },
    gridCount: 12,
    alignment: DialogAlignment.Center,
    customStyle: true,
    autoCancel:false
  });
  onPageShow() {}
  build() {
    Stack() {
      Column(){
        Stack(){
          Progress({ value: 90, total: 100, type: ProgressType.Ring })
            .width('426lpx').style({ strokeWidth: '36lpx', status: ProgressStatus.LOADING}).backgroundColor('#33ffffff')
            .color(new LinearGradient([{ color: '#e67ba7ff', offset: 0.5 },{ color: '#e60a59f7', offset: 1.0 }]));
          Column({space: '12lpx'}){
            Text(this.manualSearchPresentation.channelCountText)
              .fontSize('144lpx').lineHeight('169lpx').fontWeight(700).fontColor('#dbffffff');
            Text('个频道').fontSize('40lpx').lineHeight('47lpx').fontWeight(500).fontColor('#dbffffff');
          }
        }
        Row(){
          Text(this.manualSearchPresentation.scanningText)
            .fontColor('#dbffffff')
            .fontWeight(500)
            .fontSize('40lpx')
            .lineHeight('47lpx');
        }.padding({top:'48lpx'});
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#18181A')
      .position({ x: 0, y: 0 })
      .zIndex(9)
      .justifyContent(FlexAlign.Center);
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black);
  }
}
