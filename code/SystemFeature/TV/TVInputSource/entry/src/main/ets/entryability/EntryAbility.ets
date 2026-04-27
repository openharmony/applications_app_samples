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

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

import { display, window } from '@kit.ArkUI';
import LogUtil from '../utils/LogUtil';
import { BusinessError } from '@kit.BasicServicesKit';
import displaySetting from '@ohos.tvservice.displaySetting';
import { SourceType } from '../utils/StyleConstants';
const inputSourceMap = new Map([
  ['HDMI1', SourceType.SOURCE_HDMI1],
  ['HDMI2', SourceType.SOURCE_HDMI2],
  ['HDMI3', SourceType.SOURCE_HDMI3],
  ['HDMI4', SourceType.SOURCE_HDMI4],
  ['AV', SourceType.SOURCE_CVBS1],
  ['VGA', SourceType.SOURCE_GRAPHIC]
]);

export default class EntryAbility extends UIAbility {
  public defaultPage:string  = 'pages/Index';
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    globalThis.pullBundleName = '';
    console.log(`onCreate want:${JSON.stringify(want)}, launchParam:${JSON.stringify(launchParam)}`);
    if (want.parameters?.pullBundleName) {
      globalThis.pullBundleName = want.parameters.pullBundleName;
    }
    globalThis.AbilityContext = this.context;

    this.getWantData(want);
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    globalThis.pullBundleName = '';
    console.log(`onNewWant want:${JSON.stringify(want)}`);
    if (want.parameters?.pullBundleName) {
      globalThis.pullBundleName = want.parameters.pullBundleName;
    }
    try {
      globalThis.abilityWant = want;
      globalThis.AbilityLauncherParam = launchParams;
      globalThis.windowStage.loadContent(this.defaultPage);
    }catch (e) {
      console.error(`onNewWant loadContent:${JSON.stringify(e)}`);
    }
  }

 getWantData(want:Want){
   try {
     let wantData = want.parameters;
     console.log('_+_+_+_+_+_+_wantData',JSON.stringify(wantData));
     if (wantData) {
       let inputSource: string[] = wantData['bundleNames'] as string[];
       if (inputSource[0] == 'DTV') { // todo: wait DTV support
         this.defaultPage = 'pages/IndexDtv';
       } else {
         const currentInput = inputSource[0];
         if (inputSourceMap.has(currentInput)) {
           const targetSourceType = inputSourceMap.get(currentInput);
           AppStorage.setOrCreate<number>('sourceId_reboot', targetSourceType!); // 非空断言，因已判断存在;
         }
         this.defaultPage = 'pages/HdmiPage';
       }
     }
   } catch (e) {
     hilog.info(0x0000, 'testTag', 'Fail in get the wantData.');
   }
 }
  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.getMainWindow().then((win) => {
      win.setWindowLayoutFullScreen(true);
      win.setWindowKeepScreenOn(true).then(() => {
      });
      globalThis.windowStage = windowStage;
      getAppWindowSize(win).then((data) => {
        console.log('getAppWindowSize data:' + JSON.stringify(data));
        AppStorage.setOrCreate<number>('screen_px_w', data.pageW);
        AppStorage.setOrCreate<number>('screen_px_h', data.pageH);
        AppStorage.setOrCreate<number>('screen_lpx_w', data.width);
        AppStorage.setOrCreate<number>('screen_lpx_h', data.height);
        AppStorage.setOrCreate<number>('screen_dpi', data.dpi);
        AppStorage.setOrCreate<number>('screen_lpi', data.lpi);
        windowStage.loadContent(this.defaultPage, (err) => {
          if (err.code) {
            hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
            return;
          }
          hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
        });
      });
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
    this.context.terminateSelf();
  }
}

interface GeneratedObjectLiteralInterface_1 {
  width: number;
  height: number;
  pageW: number;
  pageH: number;
  dpi: number;
  lpi: number;
}
async function getAppWindowSize(win: window.Window) {
  let width =1920; // src/main/resources/base/profile/main_pages.json 中的designWidth
  let prop = await win.getWindowProperties();
  let rect = prop.windowRect;
  let height = rect.height * width / rect.width;
  let lpi = parseFloat((rect.width / width).toFixed(3));
  let dis = display.getDefaultDisplaySync();
  let dpi = parseFloat((dis.densityDPI / 160).toFixed(3));
  let res: GeneratedObjectLiteralInterface_1 = {
    width: width,
    height: Math.floor(height),
    pageW: rect.width,
    pageH: rect.height,
    dpi: dpi,
    lpi: lpi
  };
  return res;
}
