/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[AccessingAVSessionTests]';
const DOMAIN = 0xF816;
const BUNDLE = 'AccessingAVSessionTests_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function navigateToPageAndClickButton(
  pageName: string,
  pageButtonText: string,
  actionButtonText: string,
  delayTime: number,
  description: string,
  done: Function
) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let pageBtn = await driver.findComponent(ON.text(pageButtonText));
  if (pageBtn !== undefined) {
    await pageBtn.click();
    hilog.info(DOMAIN, TAG, BUNDLE + `Navigated to ${pageName} page`);
    await driver.delayMs(1000);
  } else {
    hilog.warn(DOMAIN, TAG, BUNDLE + `Page button "${pageButtonText}" not found`);
    done();
    return;
  }

  let actionBtn = await driver.findComponent(ON.text(actionButtonText));
  if (actionBtn !== undefined) {
    await actionBtn.click();
    hilog.info(DOMAIN, TAG, BUNDLE + `Clicked action button "${actionButtonText}"`);
    await driver.delayMs(delayTime);
  } else {
    hilog.warn(DOMAIN, TAG, BUNDLE + `Action button "${actionButtonText}" not found`);
  }

  await driver.pressBack();
  hilog.info(DOMAIN, TAG, BUNDLE + `Returned to main page`);
  await driver.delayMs(500);

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function accessingAVSessionTest() {
  describe('accessingAVSessionTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.AccessingAVSession',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number AccessingAVSession_CreateAVSession_0001
     * @tc.name AccessingAVSession_CreateAVSession_0001
     * @tc.desc Navigate to CreateAVSession page and create session
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_CreateAVSession_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'CreateAVSession',
        '创建并激活媒体会话',
        'hello world',
        3000,
        'Create and activate AVSession',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_SettingTheLoopMode_0001
     * @tc.name AccessingAVSession_SettingTheLoopMode_0001
     * @tc.desc Navigate to SettingTheLoopMode page and set loop mode
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_SettingTheLoopMode_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'SettingTheLoopMode',
        '设置循环模式',
        'hello world',
        3000,
        'Setting the loop mode',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_SettingTheProgressBar_0001
     * @tc.name AccessingAVSession_SettingTheProgressBar_0001
     * @tc.desc Navigate to SettingTheProgressBar page and set progress bar
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_SettingTheProgressBar_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'SettingTheProgressBar',
        '设置进度条',
        'hello world',
        3000,
        'Setting the progress bar',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_SetAVMetadata_0001
     * @tc.name AccessingAVSession_SetAVMetadata_0001
     * @tc.desc Navigate to SetAVMetadata page and set metadata
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_SetAVMetadata_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'SetAVMetadata',
        '设置元数据',
        'hello world',
        3000,
        'Set AVMetadata',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_AdaptingBluetoothMethodOne_0001
     * @tc.name AccessingAVSession_AdaptingBluetoothMethodOne_0001
     * @tc.desc Navigate to AdaptingToBluetoothMethodOne page and register command listeners
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_AdaptingBluetoothMethodOne_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'AdaptingToBluetoothMethodOne',
        '适配蓝牙方式一：命令监听',
        'hello world',
        3000,
        'Adapting to Bluetooth method one',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_AdaptingBluetoothMethodTwo_0001
     * @tc.name AccessingAVSession_AdaptingBluetoothMethodTwo_0001
     * @tc.desc Navigate to AdaptingToBluetoothMethodTwo page and register key event listeners
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_AdaptingBluetoothMethodTwo_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'AdaptingToBluetoothMethodTwo',
        '适配蓝牙方式二：按键监听',
        'hello world',
        3000,
        'Adapting to Bluetooth method two',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_DisplayTagsOfMediaAssets_0001
     * @tc.name AccessingAVSession_DisplayTagsOfMediaAssets_0001
     * @tc.desc Navigate to DisplayTagsOfMediaAssets page and display tags
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_DisplayTagsOfMediaAssets_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'DisplayTagsOfMediaAssets',
        '显示媒体资源标签',
        'hello world',
        3000,
        'Display tags of media assets',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_FavoritingMediaAssets_0001
     * @tc.name AccessingAVSession_FavoritingMediaAssets_0001
     * @tc.desc Navigate to FavoritingMediaAssets page and favorite media
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_FavoritingMediaAssets_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'FavoritingMediaAssets',
        '收藏媒体资源',
        'hello world',
        3000,
        'Favoriting media assets',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_PerformingProgressControl_0001
     * @tc.name AccessingAVSession_PerformingProgressControl_0001
     * @tc.desc Navigate to PerformingProgressControl page and register seek listener
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_PerformingProgressControl_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'PerformingProgressControl',
        '执行进度控制',
        'hello world',
        3000,
        'Performing progress control',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_SettingFastForward_0001
     * @tc.name AccessingAVSession_SettingFastForward_0001
     * @tc.desc Navigate to SettingFastForward page and set fast forward
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_SettingFastForward_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'SettingFastForward',
        '设置快进快退',
        'hello world',
        3000,
        'Setting fast forward and rewind',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_SettingGeneralStateInformation_0001
     * @tc.name AccessingAVSession_SettingGeneralStateInformation_0001
     * @tc.desc Navigate to SettingGeneralStateInformation page and set playback state
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_SettingGeneralStateInformation_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'SettingGeneralStateInformation',
        '设置通用状态信息',
        'hello world',
        3000,
        'Setting general state information',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_SettingLyrics_0001
     * @tc.name AccessingAVSession_SettingLyrics_0001
     * @tc.desc Navigate to SettingLyrics page and set lyrics
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_SettingLyrics_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'SettingLyrics',
        '设置歌词',
        'hello world',
        3000,
        'Setting lyrics',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_SettingPlaylistInformation_0001
     * @tc.name AccessingAVSession_SettingPlaylistInformation_0001
     * @tc.desc Navigate to SettingPlaylistInformation page and set playlist info
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_SettingPlaylistInformation_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'SettingPlaylistInformation',
        '设置播放列表信息',
        'hello world',
        3000,
        'Setting playlist information',
        done
      );
    });

    /**
     * @tc.number AccessingAVSession_HandlingUnsupportedCommands_0001
     * @tc.name AccessingAVSession_HandlingUnsupportedCommands_0001
     * @tc.desc Navigate to HandlingUnsupportedCommands page and cancel listeners
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AccessingAVSession_HandlingUnsupportedCommands_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'HandlingUnsupportedCommands',
        '处理不支持的命令',
        'hello world',
        3000,
        'Handling unsupported commands',
        done
      );
    });
  });
}
