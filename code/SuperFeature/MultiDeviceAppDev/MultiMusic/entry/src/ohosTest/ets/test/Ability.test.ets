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

import { describe, it } from '@ohos/hypium';
import { Driver, ON, ResizeDirection } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { logger } from '../util/Logger';

const TAG: string = '[Sample_MultiMusic]';
const BUNDLE = 'MultiMusic_';

/**
 * 拖拽窗口
 */
async function dragWindow(width: number) {
  try {
    let driver = Driver.create();
    let windowObj = await driver.findWindow({ actived: true });
    let rectInfo = await windowObj.getBounds();
    let windowHeight = rectInfo.bottom - rectInfo.top;
    await windowObj.resize(width, windowHeight, ResizeDirection.LEFT);
  } catch (err) {
    logger.info(TAG, `dragWindow err ${JSON.stringify(err)}`);
  }
}

/**
 * 按钮点击事件
 */
async function buttonClick(componentId: string) {
  try {
    let driver = Driver.create();
    let btn = await driver.findComponent(ON.id(componentId));
    await driver.delayMs(300);
    await btn.click();
  } catch (err) {
    logger.info(TAG, `buttonClick err ${JSON.stringify(err)}`);
  }
}

/**
 * 拉起应用
 */
async function startAbility() {
  try {
    let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    await abilityDelegator.startAbility({
      bundleName: 'com.sample.multimusic',
      abilityName: 'EntryAbility'
    });
  } catch (err) {
    logger.info(TAG, `StartAbility err ${JSON.stringify(err)}`);
  }
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起应用，点击"我的"页签，窗口拖拽至1080vp
     */
    it(BUNDLE + 'testAbility_006', 0, async (done: Function) => {
      let driver = Driver.create();
      await startAbility();
      await driver.delayMs(1000);
      await buttonClick('tabs3');
      await driver.delayMs(1000);
      await dragWindow(vp2px(1080));
      await driver.delayMs(1000);
      done();
    })

    /**
     * 拉起应用，点击"我的"页签，窗口拖拽至800vp
     */
    it(BUNDLE + 'testAbility_005', 0, async (done: Function) => {
      let driver = Driver.create();
      await startAbility();
      await driver.delayMs(1000);
      await buttonClick('tabs3');
      await driver.delayMs(1000);
      await dragWindow(vp2px(800));
      await driver.delayMs(1000);
      done();
    })

    /**
     * 拉起应用，点击"我的"页签，窗口拖拽至360vp
     */
    it(BUNDLE + 'testAbility_004', 0, async (done: Function) => {
      let driver = Driver.create();
      await startAbility();
      await driver.delayMs(1000);
      await buttonClick('tabs3');
      await driver.delayMs(1000);
      await dragWindow(vp2px(360));
      await driver.delayMs(1000);
      done();
    })

    /**
     * 拉起应用，拖拽窗口至1080vp
     */
    it(BUNDLE + 'testAbility_003', 0, async (done: Function) => {
      let driver = Driver.create();
      await startAbility();
      await driver.delayMs(1000);
      await dragWindow(vp2px(1080));
      await driver.delayMs(1000);
      done();
    })

    /**
     * 拉起应用，拖拽窗口至800vp
     */
    it(BUNDLE + 'testAbility_002', 0, async (done: Function) => {
      let driver = Driver.create();
      await startAbility();
      await driver.delayMs(1000);
      await dragWindow(vp2px(800));
      await driver.delayMs(1000);
      done();
    })

    /**
     * 拉起应用，拖拽窗口至360vp
     */
    it(BUNDLE + 'testAbility_001', 0, async (done: Function) => {
      let driver = Driver.create();
      await startAbility();
      await driver.delayMs(1000);
      await dragWindow(vp2px(360));
      await driver.delayMs(1000);
      done();
    })
  })
}
