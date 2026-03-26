/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import { describe, beforeAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const CASE = 'ImageCAPIGuide';
const DOMAIN = 0x3200;
const TAG = '[ImageCAPIGuide_Test]';
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    
    beforeAll(async () => {
      const want: Want = { bundleName: bundleName, abilityName: 'EntryAbility' };
      await abilityDelegatorRegistry.getAbilityDelegator().startAbility(want);
      await driver.delayMs(1000);
    });

    it(CASE + '应用启动测试', 0, async (done: Function) => {
      const ability: UIAbility = await abilityDelegatorRegistry.getAbilityDelegator().getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      hilog.info(DOMAIN, TAG, 'Ability started successfully');
      done();
    });

    it(CASE + '显示Native图片组件', 0, async (done: Function) => {
      await driver.assertComponentExist(ON.id('btn'));
      const btn = await driver.findComponent(ON.id('btn'));
      
      if (await btn.getText() === 'Hide Native UI') {
        await btn.click();
        await driver.delayMs(1000);
      }
      
      await btn.click();
      await driver.delayMs(2000);
      
      expect(await btn.getText()).assertEqual('Hide Native UI');
      done();
    });

    it(CASE + '隐藏Native图片组件', 0, async (done: Function) => {
      const btn = await driver.findComponent(ON.id('btn'));
      
      if (await btn.getText() === 'Show Native UI') {
        await btn.click();
        await driver.delayMs(2000);
      }
      
      await btn.click();
      await driver.delayMs(1000);
      
      expect(await btn.getText()).assertEqual('Show Native UI');
      done();
    });
  });
}