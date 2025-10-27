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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let driver: Driver;
let want: Want;

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      // 启动应用
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);

      // 验证当前页面是否正确
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /**
     * @tc.number CanvasRenderingContext2D_001
     * @tc.name testCanvasRenderingContext2D
     * @tc.desc 测试CanvasRenderingContext2D对象在Canvas画布上绘制是否成功
     */
    it('testCanvasRenderingContext2D', 0, async (done: Function) => {
      console.info('CanvasRenderingContext2DTest: testCanvasRenderingContext2D begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('CanvasRenderingContext2D'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('CanvasRenderingContext2DTest: testCanvasRenderingContext2D end');
      done();
    });

    /**
     * @tc.number OffScreenDrawing_002
     * @tc.name testOffScreenDrawing
     * @tc.desc 测试离屏绘制在Canvas画布上绘制是否成功
     */
    it('testOffScreenDrawing', 0, async (done: Function) => {
      console.info('OffScreenDrawingTest: testOffScreenDrawing begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('OffScreenDrawing'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('OffScreenDrawingTest: testOffScreenDrawing end');
      done();
    });

    /**
     * @tc.number InitCanvasComponent_003
     * @tc.name testInitCanvasComponent
     * @tc.desc 测试初始化画布组件是否成功
     */
    it('testInitCanvasComponent', 0, async (done: Function) => {
      console.info('InitCanvasComponentTest: testInitCanvasComponent begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('InitCanvasComponent'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('InitCanvasComponentTest: testInitCanvasComponent end');
      done();
    });

    /**
     * @tc.number CanvasComponentDrawingMethod_004
     * @tc.name testCanvasComponentDrawingMethod
     * @tc.desc 测试画布组件绘制方式是否成功
     */
    it('testCanvasComponentDrawingMethod', 0, async (done: Function) => {
      console.info('CanvasComponentDrawingMethodTest: testCanvasComponentDrawingMethod begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('CanvasComponentDrawingMethod'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('CanvasComponentDrawingMethodTest: testCanvasComponentDrawingMethod end');
      done();
    });

    /**
     * @tc.number CanvasComponentBasicShapes_005
     * @tc.name testCanvasComponentBasicShapes
     * @tc.desc 测试画布组件常用方法绘制基础形状是否成功
     */
    it('testCanvasComponentBasicShapes', 0, async (done: Function) => {
      console.info('CanvasComponentBasicShapesTest: testCanvasComponentBasicShapes begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('CanvasComponentBasicShapes'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('CanvasComponentBasicShapesTest: testCanvasComponentBasicShapes end');
      done();
    });

    /**
     * @tc.number CanvasComponentText_006
     * @tc.name testCanvasComponentText
     * @tc.desc 测试画布组件常用方法绘制文本是否成功
     */
    it('testCanvasComponentText', 0, async (done: Function) => {
      console.info('CanvasComponentTextTest: testCanvasComponentText begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('CanvasComponentText'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('CanvasComponentTextTest: testCanvasComponentText end');
      done();
    });

    /**
     * @tc.number CanvasComponentTextBorder_007
     * @tc.name testCanvasComponentTextBorder
     * @tc.desc 测试画布组件常用方法绘制文本边框是否成功
     */
    it('testCanvasComponentTextBorder', 0, async (done: Function) => {
      console.info('CanvasComponentTextBorderTest: testCanvasComponentTextBorder begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('CanvasComponentTextBorder'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('CanvasComponentTextBorderTest: testCanvasComponentTextBorder end');
      done();
    });

    /**
     * @tc.number CanvasComponentCustomFontsDrawText_008
     * @tc.name testCanvasComponentCustomFontsDrawText
     * @tc.desc 测试画布组件常用方法使用自定义字体绘制文本是否成功
     */
    it('testCanvasComponentCustomFontsDrawText', 0, async (done: Function) => {
      console.info('CanvasComponentCustomFontsDrawTextTest: testCanvasComponentCustomFontsDrawText begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('CanvasComponentCustomFontsDrawText'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('CanvasComponentCustomFontsDrawTextTest: testCanvasComponentCustomFontsDrawText end');
      done();
    });

    /**
     * @tc.number CanvasComponentDrawingPictureAndImagePixel_009
     * @tc.name testCanvasComponentDrawingPictureAndImagePixel
     * @tc.desc 测试画布组件常用方法绘制图片和图像像素信息处理是否成功
     */
    it('testCanvasComponentDrawingPictureAndImagePixel', 0, async (done: Function) => {
      console.info('CanvasComponentDrawingPictureAndImagePixelTest: testCanvasComponentDrawingPictureAndImagePixel begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('CanvasComponentDrawingPictureAndImagePixel'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('CanvasComponentDrawingPictureAndImagePixelTest: testCanvasComponentDrawingPictureAndImagePixel end');
      done();
    });

    /**
     * @tc.number CanvasComponentOtherMethods_010
     * @tc.name testCanvasComponentOtherMethods
     * @tc.desc 测试画布组件常用方法其他功能是否成功
     */
    it('testCanvasComponentOtherMethods', 0, async (done: Function) => {
      console.info('CanvasComponentOtherMethodsTest: testCanvasComponentOtherMethods begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('CanvasComponentOtherMethods'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('CanvasComponentOtherMethodsTest: testCanvasComponentOtherMethods end');
      done();
    });

    /**
     * @tc.number CanvasContentUpdate_011
     * @tc.name testCanvasContentUpdate
     * @tc.desc 测试画布组件使用状态变量驱动画布刷新是否成功
     */
    it('testCanvasContentUpdate', 0, async (done: Function) => {
      console.info('CanvasContentUpdateTest: testCanvasContentUpdate begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('CanvasContentUpdate'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('CanvasContentUpdateTest: testCanvasContentUpdate end');
      done();
    });

    /**
     * @tc.number DrawingRegularBaseShape_012
     * @tc.name testDrawingRegularBaseShape
     * @tc.desc 测试画布组件场景示例绘制规则基础形状是否成功
     */
    it('testDrawingRegularBaseShape', 0, async (done: Function) => {
      console.info('DrawingRegularBaseShapeTest: testDrawingRegularBaseShape begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('DrawingRegularBaseShape'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('DrawingRegularBaseShapeTest: testDrawingRegularBaseShape end');
      done();
    });

    /**
     * @tc.number DrawIrregularFigures_013
     * @tc.name testDrawIrregularFigures
     * @tc.desc 测试画布组件场景示例绘制不规则图形是否成功
     */
    it('testDrawIrregularFigures', 0, async (done: Function) => {
      console.info('DrawIrregularFiguresTest: testDrawIrregularFigures begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('DrawIrregularFigures'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('DrawIrregularFiguresTest: testDrawIrregularFigures end');
      done();
    });

    /**
     * @tc.number DrawDraggableCursor_014
     * @tc.name testDrawDraggableCursor
     * @tc.desc 测试画布组件场景示例绘制可拖动的光标是否成功
     */
    it('testDrawDraggableCursor', 0, async (done: Function) => {
      console.info('DrawDraggableCursorTest: testDrawDraggableCursor begin');
      let driver = Driver.create();

      const title = await driver.findComponent(ON.text('DrawDraggableCursor'));
      expect(title === null).assertFalse();
      await title.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      console.info('DrawDraggableCursorTest: testDrawDraggableCursor end');
      done();
    });
  });
}