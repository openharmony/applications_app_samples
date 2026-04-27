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

import ConfigData from '../common/ConfigData';
import { missionManager } from '@kit.AbilityKit';
import LogUtil from '../utils/LogUtil';
import { router } from '@kit.ArkUI';

export type MissionBundleName = string | number | undefined;

export interface MissionWantLike {
  abilityName?: string;
  bundleName?: MissionBundleName;
}

export type MissionIdLike = number | string;

export interface MissionInfoLike {
  missionId: MissionIdLike;
  want?: MissionWantLike | null;
}

export interface NoSignalBackAction {
  action: 'routerBack' | 'moveMissionToFront';
  missionId: number;
}

/**
 * Finds the mission that should be resumed when the no-signal page exits.
 *
 * @param missions Active mission list returned by the ability manager.
 * @param pullBundleName Bundle name that launched the input source app.
 * @returns Matching mission id, or `-1` when no resumable mission exists.
 */
export function findReturnMissionId(
  missions?: MissionInfoLike[] | null,
  pullBundleName?: string
): number {
  let missionId = -1;
  if (!missions || missions.length === 0) {
    return missionId;
  }
  missions.forEach((item) => {
    if (typeof item.missionId !== 'number' || !item.want) {
      return;
    }
    if (item.want.abilityName === 'EntryAbility' && item.want.bundleName === 'com.ohos.inputsource') {
      return;
    }
    if (pullBundleName === item.want.bundleName) {
      missionId = item.missionId;
    }
  });
  return missionId;
}

/**
 * Resolves whether the no-signal page should navigate back or resume a mission.
 *
 * @param pullBundleName Bundle name that launched the current page.
 * @param missionId Target mission id resolved from the mission list.
 * @returns Back action descriptor consumed by page logic.
 */
export function resolveNoSignalBackAction(
  pullBundleName?: string | null,
  missionId: number = -1
): NoSignalBackAction {
  if (!pullBundleName || pullBundleName === 'com.ohos.launcher') {
    return {
      action: 'routerBack',
      missionId
    };
  }
  return {
    action: 'moveMissionToFront',
    missionId
  };
}

@Entry
@Component
struct NoSignal {
  @State message: string = 'Hello World';
  missionId: number = -1;
  build() {
    Column() {
      Image($r('app.media.no_signal'));
    }
    .height(ConfigData.WH_100_100)
    .width(ConfigData.WH_100_100);
  }

  getMission() {
    try {
      missionManager.getMissionInfos('', 10, (err, missions) => {

        LogUtil.info(`HmLog missions = ${JSON.stringify(missions)}`);
        this.missionId = findReturnMissionId(
          missions as MissionInfoLike[],
          globalThis.pullBundleName as string | undefined
        );
        LogUtil.info(`HmLog missionId=${this.missionId}`);
      });
    } catch (err) {
      LogUtil.info(`HmLog missions err:${err.message}`);
    }
  }

  onPageShow(): void {
    this.missionId = -1;
    this.getMission();
  }

  onBackPress(): boolean | void {
    const backAction = resolveNoSignalBackAction(globalThis.pullBundleName as string | undefined, this.missionId);
    if (backAction.action === 'routerBack') {
      router.back();
    } else {
      try {
        console.log(`moveMissionToFront missionId:${backAction.missionId}`);
        missionManager.moveMissionToFront(backAction.missionId, (err, data) => {
          if (err) {
            console.error(`moveMissionToFront failed:${err.message}`);
          } else {
            console.info(`moveMissionToFront successfully:${JSON.stringify(data)}`);
          }
        });
      } catch (err) {
        console.error(`moveMissionToFront failed:${err.message}`);
      }
    }
    return true;
  }

}
