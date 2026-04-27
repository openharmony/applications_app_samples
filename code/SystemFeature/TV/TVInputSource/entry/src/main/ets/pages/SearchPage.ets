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
import { router } from '@kit.ArkUI';

export interface SearchPageShowDecision {
  shouldOpenDialog: boolean;
  shouldClearPreviousTimer: boolean;
  backDelayMs: number;
}

export interface SearchPageHideDecision {
  shouldClearTimer: boolean;
  nextTimerId: number;
}

export interface SearchProgressPresentation {
  channelCountText: string;
  scanningText: string;
  progressText: string;
}

/**
 * Computes the page-show decision for the auto-search page.
 *
 * @param currentTimerId Existing timer id held by the page.
 * @returns SearchPageShowDecision Dialog and timer policy for the current show cycle.
 */
export function resolveSearchPageShowDecision(currentTimerId: number): SearchPageShowDecision {
  return {
    shouldOpenDialog: true,
    shouldClearPreviousTimer: currentTimerId >= 0,
    backDelayMs: 8000
  };
}

/**
 * Computes whether the current auto-search timer should be cleared on hide.
 *
 * @param currentTimerId Existing timer id held by the page.
 * @returns SearchPageHideDecision Cleanup state for the hide lifecycle.
 */
export function resolveSearchPageHideDecision(currentTimerId: number): SearchPageHideDecision {
  return {
    shouldClearTimer: currentTimerId >= 0,
    nextTimerId: -1
  };
}

/**
 * Builds stable display text for the auto-search status area.
 *
 * @param channelCount Current discovered channel count.
 * @param scanFrequencyMhz Current frequency displayed to users.
 * @param progressPercent Current progress percentage.
 * @param modeLabel Human-readable search mode label.
 * @returns SearchProgressPresentation Ready-to-render text values.
 */
export function buildSearchProgressPresentation(
  channelCount: number,
  scanFrequencyMhz: number,
  progressPercent: number,
  modeLabel: string = '自动搜台'
): SearchProgressPresentation {
  const safeChannelCount = channelCount >= 0 ? channelCount : 0;
  const safeProgress = progressPercent >= 0 ? progressPercent : 0;
  return {
    channelCountText: `${safeChannelCount}`,
    scanningText: `正在搜台 ${scanFrequencyMhz.toFixed(1)} MHz`,
    progressText: `${modeLabel} ${safeProgress}%`
  };
}

//自动搜台
@Entry
@Component
struct SearchPage {
  @State timeId:number=-1
  private readonly searchPresentation: SearchProgressPresentation =
    buildSearchProgressPresentation(0, 0.5, 1);
  searchPageControllerDtv: CustomDialogController = new CustomDialogController({
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
  aboutToAppear() {

  }

  onPageShow() {
    const showDecision = resolveSearchPageShowDecision(this.timeId);
    if (showDecision.shouldClearPreviousTimer) {
      clearTimeout(this.timeId);
    }
    if (showDecision.shouldOpenDialog) {
      this.searchPageControllerDtv.open();
    }
    this.timeId = setTimeout(() => {
      router.back();
    }, showDecision.backDelayMs);
  }

  onPageHide(): void {
    const hideDecision = resolveSearchPageHideDecision(this.timeId);
    if (hideDecision.shouldClearTimer) {
      clearTimeout(this.timeId);
    }
    this.timeId = hideDecision.nextTimerId;
  }

  onBackPress() {

  }
  build() {
    Stack() {
      Column(){
        Stack(){
          Progress({ value: 90, total: 100, type: ProgressType.Ring })
            .width('426lpx').style({ strokeWidth: '36lpx', status: ProgressStatus.LOADING}).backgroundColor('#33ffffff')
            .color(new LinearGradient([{ color: '#e67ba7ff', offset: 0.5 },{ color: '#e60a59f7', offset: 1.0 }]));
          Column({space: '12lpx'}){
            Text(this.searchPresentation.channelCountText)
              .fontSize('144lpx').lineHeight('169lpx').fontWeight(700).fontColor('#dbffffff');
            Text('个频道').fontSize('40lpx').lineHeight('47lpx').fontWeight(500).fontColor('#dbffffff');
          }
        }
        Row(){
          Text(this.searchPresentation.scanningText)
            .fontColor('#dbffffff')
            .fontWeight(500)
            .fontSize('40lpx')
            .lineHeight('47lpx');
        }.padding({top:'48lpx'});
        Row(){
          Text(this.searchPresentation.progressText)
            .fontColor('#99ffffff')
            .fontWeight(500)
            .fontSize('40lpx')
            .lineHeight('47lpx');
        }.padding({top:'24lpx'});
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
