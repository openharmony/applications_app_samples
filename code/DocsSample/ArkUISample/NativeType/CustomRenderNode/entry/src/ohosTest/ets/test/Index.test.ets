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
import { describe, it, expect, beforeAll } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MouseButton,MatchPattern, UiDirection, Component } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { Point } from '@ohos.UiTest';
import { hilog } from '@kit.PerformanceAnalysisKit';


const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;
const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[uitest]';

export async function getResourceString(str: string): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  try {
    let textString: string = manage.getStringByNameSync(str);
    return textString;
  } catch (error) {
    hilog.error(0x0000, 'testTag', 'Failed to get resource string: %{public}s', error.toString());
    return ''
  }
}

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_001
     * @tc.name testOperationNodeTree
     * @tc.desc 操作节点树。
     */
    it('OperationNodeTree', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testOperationNodeTree begin');
      let driver = Driver.create();

      let str = await getResourceString('OperationNodeTree');
      let componentButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      let button = await driver.findComponent(ON.text('getNextSibling', MatchPattern.CONTAINS));
      expect(button === null).assertFalse();
      await button.click();

      await driver.pressBack();
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testOperationNodeTree end');
      done();
    })

    /**
     * @tc.number UiTest_002
     * @tc.name testRenderingProperties
     * @tc.desc 设置和获取渲染相关属性。
     */
    it('RenderingProperties', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testRenderingProperties begin');
      let driver = Driver.create();
      let str = await getResourceString('RenderingProperties');
      let componentButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();
      let positionButton = await driver.findComponent(ON.text('position', MatchPattern.CONTAINS));
      expect(positionButton === null).assertFalse();
      await positionButton.click();
      let pivotButton = await driver.findComponent(ON.text('pivot', MatchPattern.CONTAINS));
      expect(pivotButton === null).assertFalse();
      await pivotButton.click();
      let scaleButton = await driver.findComponent(ON.text('scale', MatchPattern.CONTAINS));
      expect(scaleButton === null).assertFalse();
      await scaleButton.click();
      let translationButton = await driver.findComponent(ON.text('translation', MatchPattern.CONTAINS));
      expect(translationButton === null).assertFalse();
      await translationButton.click();
      let rotationButton = await driver.findComponent(ON.text('rotation', MatchPattern.CONTAINS));
      expect(rotationButton === null).assertFalse();
      await rotationButton.click();
      let transformButton = await driver.findComponent(ON.text('transform', MatchPattern.CONTAINS));
      expect(transformButton === null).assertFalse();
      await transformButton.click();
      let shadowButton = await driver.findComponent(ON.text('shadow', MatchPattern.CONTAINS));
      expect(shadowButton === null).assertFalse();
      await shadowButton.click();
      let shadowRadiusButton = await driver.findComponent(ON.text('shadowRadius', MatchPattern.CONTAINS));
      expect(shadowRadiusButton === null).assertFalse();
      await shadowRadiusButton.click();
      let borderButton = await driver.findComponent(ON.text('border', MatchPattern.CONTAINS));
      expect(borderButton === null).assertFalse();
      await borderButton.click();
      let shapeMaskButton = await driver.findComponent(ON.text('shapeMask', MatchPattern.CONTAINS));
      expect(shapeMaskButton === null).assertFalse();
      await shapeMaskButton.click();
      let shapeClipButton = await driver.findComponent(ON.text('shapeClip', MatchPattern.CONTAINS));
      expect(shapeClipButton === null).assertFalse();
      await shapeClipButton.click();
      await driver.pressBack();
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testRenderingProperties end');
      done();
    })

    /**
     * @tc.number UiTest_003
     * @tc.name testCustomDraw
     * @tc.desc 自定义绘制。
     */
    it('CustomDraw', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testCustomDraw begin');
      let driver = Driver.create();

      let str = await getResourceString('CustomDraw');
      let componentButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      let button = await driver.findComponent(ON.text('Invalidate', MatchPattern.CONTAINS));
      expect(button === null).assertFalse();
      await button.click();

      await driver.pressBack();
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testCustomDraw end');
      done();
    })

    /**
     * @tc.number UiTest_004
     * @tc.name testCustomDrawCanvas
     * @tc.desc 调整自定义绘制Canvas的变换矩阵。
     */
    it('CustomDrawCanvas', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testCustomDrawCanvas begin');
      let driver = Driver.create();

      let str = await getResourceString('CustomDrawCanvas');
      let componentButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.pressBack();
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testCustomDrawCanvas end');
      done();
    })

    /**
     * @tc.number UiTest_005
     * @tc.name testCustomDrawCanvasNative
     * @tc.desc C++获取Canvas，并进行自定义绘制操作。
     */
    it('CustomDrawCanvasNative', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testCustomDrawCanvasNative begin');
      let driver = Driver.create();

      let str = await getResourceString('CustomDrawCanvasNative');
      let componentButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.pressBack();
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testCustomDrawCanvasNative end');
      done();
    })

    /**
     * @tc.number UiTest_006
     * @tc.name testSetLabel
     * @tc.desc 设置标签。
     */
    it('SetLabel', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testSetLabel begin');
      let driver = Driver.create();

      let str = await getResourceString('SetLabel');
      let componentButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      await driver.pressBack();
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testSetLabel end');
      done();
    })

    /**
     * @tc.number UiTest_007
     * @tc.name testCheckRanderNodeDisposed
     * @tc.desc 查询当前RenderNode是否解除引用。
     */
    it('CheckRanderNodeDisposed', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testCheckRanderNodeDisposed begin');
      let driver = Driver.create();

      let str = await getResourceString('CheckRanderNodeDisposed');
      let componentButton = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      expect(componentButton === null).assertFalse();
      await componentButton.click();

      let isDisposedButton = await driver.findComponent(ON.text('RenderNode isDisposed', MatchPattern.CONTAINS));
      expect(isDisposedButton === null).assertFalse();
      await isDisposedButton.click();

      let disposedButton = await driver.findComponent(ON.text('RenderNode dispose', MatchPattern.CONTAINS));
      expect(disposedButton === null).assertFalse();
      await disposedButton.click();

      await isDisposedButton.click();

      await driver.pressBack();
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testCheckRanderNodeDisposed end');
      done();
    })

  })
}