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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import Logger from '../util/Logger';

const BUNDLE = 'Drag';
const TAG = '[Sample_Drag]';

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      await abilityDelegator.startAbility({
        bundleName: 'com.samples.drag',
        abilityName: 'com.samples.drag.MainAbility'
      });
      done();
      Logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
    })
    // 桌面间图标拖拽
    it(BUNDLE + 'DesktopIconDraged', 0, async function () {
      Logger.info(TAG, `${BUNDLE}DesktopIconDraged begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 将桌面第一个图标拖拽到第二个图标
      await driver.assertComponentExist(ON.id('deskTopIcon0'));
      let cameraIcon = await driver.findComponent(ON.id('deskTopIcon0'));
      await driver.assertComponentExist(ON.id('deskTopIcon1'));
      let photosIcon = await driver.findComponent(ON.id('deskTopIcon1'));
      await driver.assertComponentExist(ON.id(`iconNameComp0`));
      let iconNameComp = await driver.findComponent(ON.id(`iconNameComp0`));
      let iconName = await iconNameComp.getText();
      Logger.info(TAG, `${BUNDLE}DesktopIconDraged ${iconName}`);
      await cameraIcon.dragTo(photosIcon);
      // 获取拖拽之后的第一个图标内容
      let iconNameCompDraged = await driver.findComponent(ON.id(`iconNameComp0`));
      let iconNameDraged = await iconNameCompDraged.getText();
      Logger.info(TAG, `${BUNDLE}DesktopIconDraged ${iconNameDraged}`);
      // 校验是否拖拽成功
      if(iconName === iconNameDraged){
        expect().assertFail();
      }
      Logger.info(TAG, `${BUNDLE}DesktopIconDraged end`);
    })
    // Dock栏间图标拖拽
    it(BUNDLE + 'DockIconDraged', 0, async function () {
      Logger.info(TAG, `${BUNDLE}DockIconDraged begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 将Dock栏第一个图标拖拽到第二个图标
      await driver.assertComponentExist(ON.id('dockIcon0'));
      let phoneIcon = await driver.findComponent(ON.id('dockIcon0'));
      await driver.assertComponentExist(ON.id('dockIcon1'));
      let messageIcon = await driver.findComponent(ON.id('dockIcon1'));
      await phoneIcon.dragTo(messageIcon);
      Logger.info(TAG, `${BUNDLE}DockIconDraged end`);
    })
    // 将桌面图标拖拽到Dock栏
    it(BUNDLE + 'DragToDock', 0, async function () {
      Logger.info(TAG, `${BUNDLE}DragToDock begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 将桌面第一个图标移动到dock栏第一个
      await driver.assertComponentExist(ON.id('deskTopIcon0'));
      let photosIcon = await driver.findComponent(ON.id('deskTopIcon0'));
      await driver.assertComponentExist(ON.id(`iconNameComp0`));
      let iconNameComp = await driver.findComponent(ON.id(`iconNameComp0`));
      let iconName = await iconNameComp.getText();
      await driver.assertComponentExist(ON.id('dockIcon0'));
      let messageIcon = await driver.findComponent(ON.id('dockIcon0'));
      await photosIcon.dragTo(messageIcon);
      await driver.delayMs(1000);
      if(await driver.findComponent(ON.text(iconName))){
        expect().assertFail();
      }
      Logger.info(TAG, `${BUNDLE}DragToDock end`);
    })
    // Dock栏移除图标
    it(BUNDLE + 'RemoveIcon', 0, async function () {
      Logger.info(TAG, `${BUNDLE}RemoveIcon begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 移除Dock栏第一个图标
      await driver.assertComponentExist(ON.id('dockIcon0'));
      let photosIcon = await driver.findComponent(ON.id('dockIcon0'));
      await photosIcon.click();
      await driver.delayMs(1000);
      // fa不支持本地资源化，因此只能出现中文
      await driver.assertComponentExist(ON.text('移除'));
      let removeComp = await driver.findComponent(ON.text('移除'));
      await removeComp.click();
      await driver.assertComponentExist(ON.text('相册'));
      Logger.info(TAG, `${BUNDLE}RemoveIcon end`);
    })
  })
}