/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
 
// [Start navigation_ability]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const TAG = 'NavigationAbility';
const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  private windowStage: window.WindowStage | null = null;

  private uri?: string;
  private destinationLatitude?: number;
  private destinationLongitude?: number;
  private destinationName?: string;
  private originName?: string;
  private originLatitude?: number;
  private originLongitude?: number;
  private vehicleType?: number;
  private destinationPoiId?: string;
  private originPoiId?: string;
    // [Start navigation_ability_on_create]
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // [End navigation_ability_on_create]
    hilog.info(DOMAIN, TAG, `onCreate, want=${JSON.stringify(want)}`);
    super.onCreate(want, launchParam);
    this.parseWant(want);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, TAG, `onNewWant, want=${JSON.stringify(want)}`);
    super.onNewWant(want, launchParam);
    this.parseWant(want);
    if (!this.windowStage) {
      hilog.error(DOMAIN, TAG, 'windowStage is null');
      this.context.terminateSelf();
      return;
    }
    this.loadPage(this.windowStage);
  }

  private parseWant(want: Want): void {
    this.uri = want.uri as string | undefined;
    this.destinationLatitude = want.parameters?.destinationLatitude as number | undefined;
    this.destinationLongitude = want.parameters?.destinationLongitude as number | undefined;
    this.destinationName = want.parameters?.destinationName as string | undefined;
    this.originName = want.parameters?.originName as string | undefined;
    this.originLatitude = want.parameters?.originLatitude as number | undefined;
    this.originLongitude = want.parameters?.originLongitude as number | undefined;
    this.vehicleType = want.parameters?.vehicleType as number | undefined;
    this.destinationPoiId = want.parameters?.destinationPoiId as string | undefined;
    this.originPoiId = want.parameters?.originPoiId as string | undefined;
  }

  private loadPage(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, `loadPage, uri=${this.uri}`);
    if (this.uri === 'maps://navigation') {
      // 构建导航场景参数
      const storage: LocalStorage = new LocalStorage({
        'destinationLatitude': this.destinationLatitude,
        'destinationLongitude': this.destinationLongitude,
        'destinationPoiId': this.destinationPoiId
      } as Record<string, Object>);
      // 拉起导航页面
      windowStage.loadContent('pages/NavigationPage', storage)
    } else if (this.uri === 'maps://routePlan') {
      // 构建路径规划场景参数
      const storage: LocalStorage = new LocalStorage({
        'destinationLatitude': this.destinationLatitude,
        'destinationLongitude': this.destinationLongitude,
        'destinationName': this.destinationName,
        'originName': this.originName,
        'originLatitude': this.originLatitude,
        'originLongitude': this.originLongitude,
        'vehicleType': this.vehicleType,
        'destinationPoiId': this.destinationPoiId,
        'originPoiId': this.originPoiId
      } as Record<string, Object>);
      // 拉起路径规划页面
      windowStage.loadContent('pages/RoutePlanPage', storage)
    }  else if (this.uri === 'maps://search') {
      // 构建位置搜索场景参数
      const storage: LocalStorage = new LocalStorage({
        'destinationName': this.destinationName
      } as Record<string, Object>);
      // 拉起位置搜索页面
      windowStage.loadContent('pages/PlaceSearchPage', storage)
    } else {
      // 默认拉起首页
      windowStage.loadContent('pages/Index', (err) => {
        if (err.code) {
          hilog.error(DOMAIN, TAG, 'Failed to load the content. Cause: %{public}s',
            JSON.stringify(err) ?? '');
          return;
        }
        hilog.info(DOMAIN, TAG, 'Succeeded in loading the content.');
      });
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, TAG, `onDestroy`);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, `onWindowStageCreate`);
    this.windowStage = windowStage;
    this.loadPage(this.windowStage);
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onBackground');
  }
}
// [End navigation_ability]