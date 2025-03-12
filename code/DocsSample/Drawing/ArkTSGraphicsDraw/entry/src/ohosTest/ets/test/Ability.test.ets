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

import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import Logger from '../utils/Logger';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';


const TAG = '[Sample_ArkTSGraphicsDraw]';
const DELAY_SHORT = 400;
const DELAY_LONG = 1000;

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

function getString(resourceData: Resource): string {
  let manage = delegator.getAppContext().resourceManager;
  return manage.getStringSync(resourceData);
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * @tc.number  StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it('ArkTSGraphicsDraw_StartAbility_001',0, async (done: Function) => {
      console.info('StartAbility_001 begin');
      //start tested ability
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(DELAY_LONG);
      //check top display ability
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      console.info('StartAbility_001 end');
    })

    /**
     * @tc.number:CanvasGetResult_001
     * @tc.name:CanvasGetResult_001
     * @tc.desc:直接画布与离屏画布的获取与绘制结果测试
     */
    it('ArkTSGraphicsDraw_CanvasGetResult_001', 0, async (done: Function) => {
      Logger.info(TAG, 'CanvasGetResult_001 begin');
      let driver = Driver.create();
      let canvasGetResultStr = getString($r('app.string.CanvasGetResult'));
      // 断言“画布的获取与绘制结果的显示”页面导航组件是否存在于主页上
      await driver.assertComponentExist(ON.text(canvasGetResultStr));
      // 获取该导航组件
      let canvasButton = await driver.findComponent(ON.text(canvasGetResultStr));
      // 点击导航组件，跳转至“画布的获取与绘制结果的显示”页面
      await canvasButton.click();
      await driver.delayMs(DELAY_LONG);

      await driver.assertComponentExist(ON.text(getString($r('app.string.DirectCanvas'))));
      await driver.assertComponentExist(ON.text(getString($r('app.string.OffScreenCanvas'))));

      // 返回主页
      await driver.pressBack();
      done();
      Logger.info(TAG, 'CanvasGetResult_001 end');
    });

    /**
     * @tc.number:CanvasOperationState_001
     * @tc.name:CanvasOperationState_001
     * @tc.desc:画布操作与状态操作结果测试
     */
    it('ArkTSGraphicsDraw_CanvasOperationState_001', 0, async (done: Function) => {
      Logger.info(TAG, 'CanvasOperationState_001 begin');
      let driver = Driver.create();
      let canvasOperationStr = getString($r('app.string.CanvasOperationState'));
      await driver.assertComponentExist(ON.text(canvasOperationStr));
      let canvasOperationButton = await driver.findComponent(ON.text(canvasOperationStr));
      await canvasOperationButton.click();
      await driver.delayMs(DELAY_SHORT);

      let clipOperationStr = getString($r('app.string.ClipOperation'));
      await driver.assertComponentExist(ON.text(clipOperationStr));
      let clipOperationButton = await driver.findComponent(ON.text(clipOperationStr));
      await clipOperationButton.click();
      await driver.delayMs(DELAY_SHORT);

      let translationOperationStr = getString($r('app.string.TranslationOperation'));
      await driver.assertComponentExist(ON.text(translationOperationStr));
      let translationOperationButton = await driver.findComponent(ON.text(translationOperationStr));
      await translationOperationButton.click();
      await driver.delayMs(DELAY_SHORT);

      let rotationOperationStr = getString($r('app.string.RotationOperation'));
      await driver.assertComponentExist(ON.text(rotationOperationStr));
      let rotationOperationButton = await driver.findComponent(ON.text(rotationOperationStr));
      await rotationOperationButton.click();
      await driver.delayMs(DELAY_SHORT);

      let scaleOperationStr = getString($r('app.string.ScaleOperation'));
      await driver.assertComponentExist(ON.text(scaleOperationStr));
      let scaleOperationButton = await driver.findComponent(ON.text(scaleOperationStr));
      await scaleOperationButton.click();
      await driver.delayMs(DELAY_SHORT);

      let stateOperationStr = getString($r('app.string.StateOperation'));
      await driver.assertComponentExist(ON.text(stateOperationStr));
      let stateOperationButton = await driver.findComponent(ON.text(stateOperationStr));
      await stateOperationButton.click();
      await driver.delayMs(DELAY_SHORT);

      await driver.pressBack();
      done();
      Logger.info(TAG, 'CanvasOperationState_001 end');
    });

    /**
     * @tc.number:BasicEffect_001
     * @tc.name:BasicEffect_001
     * @tc.desc:基础绘制效果结果测试
     */
    it('ArkTSGraphicsDraw_BasicEffect_001', 0, async (done: Function) => {
      Logger.info(TAG, 'BasicEffect_001 begin');
      let driver = Driver.create();
      let basicEffectStr = getString($r('app.string.BasicEffect'));
      await driver.assertComponentExist(ON.text(basicEffectStr));
      let basicEffectButton = await driver.findComponent(ON.text(basicEffectStr));
      await basicEffectButton.click();
      await driver.delayMs(DELAY_SHORT);

      let fillingStr = getString($r('app.string.Filling'));
      await driver.assertComponentExist(ON.text(fillingStr));
      let fillingButton = await driver.findComponent(ON.text(fillingStr));
      await fillingButton.click();
      await driver.delayMs(DELAY_SHORT);

      let strokeStr = getString($r('app.string.Stroke'));
      await driver.assertComponentExist(ON.text(strokeStr));
      let strokeButton = await driver.findComponent(ON.text(strokeStr));
      await strokeButton.click();
      await driver.delayMs(DELAY_SHORT);

      await driver.pressBack();
      done();
      Logger.info(TAG, 'BasicEffect_001 end');
    });

    /**
     * @tc.number:ComplexEffect_001
     * @tc.name:ComplexEffect_001
     * @tc.desc:复杂绘制效果结果测试
     */
    it('ArkTSGraphicsDraw_ComplexEffect_001', 0, async (done: Function) => {
      Logger.info(TAG, 'ComplexEffect_001 begin');
      let driver = Driver.create();
      let complexEffectStr = getString($r('app.string.ComplexEffect'));
      await driver.assertComponentExist(ON.text(complexEffectStr));
      let complexEffectButton = await driver.findComponent(ON.text(complexEffectStr));
      await complexEffectButton.click();
      await driver.delayMs(DELAY_SHORT);

      let mixedModeStr = getString($r('app.string.MixedMode'));
      await driver.assertComponentExist(ON.text(mixedModeStr));
      let mixedModeButton = await driver.findComponent(ON.text(mixedModeStr));
      await mixedModeButton.click();
      await driver.delayMs(DELAY_SHORT);

      let pathEffectStr = getString($r('app.string.PathEffect'));
      await driver.assertComponentExist(ON.text(pathEffectStr));
      let pathEffectButton = await driver.findComponent(ON.text(pathEffectStr));
      await pathEffectButton.click();
      await driver.delayMs(DELAY_SHORT);

      let linearGradientStr = getString($r('app.string.LinearGradient'));
      await driver.assertComponentExist(ON.text(linearGradientStr));
      let linearGradientButton = await driver.findComponent(ON.text(linearGradientStr));
      await linearGradientButton.click();
      await driver.delayMs(DELAY_SHORT);

      let pathGradientStr = getString($r('app.string.PathGradient'));
      await driver.assertComponentExist(ON.text(pathGradientStr));
      let pathGradientButton = await driver.findComponent(ON.text(pathGradientStr));
      await pathGradientButton.click();
      await driver.delayMs(DELAY_SHORT);

      let sectorGradientStr = getString($r('app.string.SectorGradient'));
      await driver.assertComponentExist(ON.text(sectorGradientStr));
      let sectorGradientButton = await driver.findComponent(ON.text(sectorGradientStr));
      await sectorGradientButton.click();
      await driver.delayMs(DELAY_SHORT);

      let colorFilterStr = getString($r('app.string.ColorFilter'));
      await driver.assertComponentExist(ON.text(colorFilterStr));
      let colorFilterButton = await driver.findComponent(ON.text(colorFilterStr));
      await colorFilterButton.click();
      await driver.delayMs(DELAY_SHORT);

      let imageFilterStr = getString($r('app.string.ImageFilter'));
      await driver.assertComponentExist(ON.text(imageFilterStr));
      let imageFilterButton = await driver.findComponent(ON.text(imageFilterStr));
      await imageFilterButton.click();
      await driver.delayMs(DELAY_SHORT);

      let maskFilterStr = getString($r('app.string.MaskFilter'));
      await driver.assertComponentExist(ON.text(maskFilterStr));
      let maskFilterButton = await driver.findComponent(ON.text(maskFilterStr));
      await maskFilterButton.click();
      await driver.delayMs(DELAY_SHORT);

      await driver.pressBack();
      done();
      Logger.info(TAG, 'ComplexEffect_001 end');
    });

    /**
     * @tc.number:ShapeDrawing_001
     * @tc.name:ShapeDrawing_001
     * @tc.desc:几何形状绘制结果测试
     */
    it('ArkTSGraphicsDraw_ShapeDrawing_001', 0, async (done: Function) => {
      Logger.info(TAG, 'ShapeDrawing_001 begin');
      let driver = Driver.create();
      let shapeDrawingStr = getString($r('app.string.Shape_Drawing'));
      await driver.assertComponentExist(ON.text(shapeDrawingStr));
      let shapeDrawingButton = await driver.findComponent(ON.text(shapeDrawingStr));
      await shapeDrawingButton.click();
      await driver.delayMs(DELAY_SHORT);

      let pointStr = getString($r('app.string.Point'));
      await driver.assertComponentExist(ON.text(pointStr));
      let pointButton = await driver.findComponent(ON.text(pointStr));
      await pointButton.click();
      await driver.delayMs(DELAY_SHORT);

      let arcStr = getString($r('app.string.Arc'));
      await driver.assertComponentExist(ON.text(arcStr));
      let arcButton = await driver.findComponent(ON.text(arcStr));
      await arcButton.click();
      await driver.delayMs(DELAY_SHORT);

      let circleStr = getString($r('app.string.Circle'));
      await driver.assertComponentExist(ON.text(circleStr));
      let circleButton = await driver.findComponent(ON.text(circleStr));
      await circleButton.click();
      await driver.delayMs(DELAY_SHORT);

      let pathStr = getString($r('app.string.Path'));
      await driver.assertComponentExist(ON.text(pathStr));
      let pathButton = await driver.findComponent(ON.text(pathStr));
      await pathButton.click();
      await driver.delayMs(DELAY_SHORT);

      let regionStr = getString($r('app.string.Region'));
      await driver.assertComponentExist(ON.text(regionStr));
      let regionButton = await driver.findComponent(ON.text(regionStr));
      await regionButton.click();
      await driver.delayMs(DELAY_SHORT);

      let rectStr = getString($r('app.string.Rect'));
      await driver.assertComponentExist(ON.text(rectStr));
      let rectButton = await driver.findComponent(ON.text(rectStr));
      await rectButton.click();
      await driver.delayMs(DELAY_SHORT);

      let roundRectStr = getString($r('app.string.RoundRect'));
      await driver.assertComponentExist(ON.text(roundRectStr));
      let roundRectButton = await driver.findComponent(ON.text(roundRectStr));
      await roundRectButton.click();
      await driver.delayMs(DELAY_SHORT);

      await driver.pressBack();
      done();
      Logger.info(TAG, 'ShapeDrawing_001 end');
    });

    /**
     * @tc.number:PixelMapDrawing_001
     * @tc.name:PixelMapDrawing_001
     * @tc.desc:图片绘制结果测试
     */
    it('ArkTSGraphicsDraw_PixelMapDrawing_001', 0, async (done: Function) => {
      Logger.info(TAG, 'PixelMapDrawing_001 begin');
      let driver = Driver.create();
      let pixelMapDrawingStr = getString($r('app.string.PixelMap_Drawing'));
      await driver.assertComponentExist(ON.text(pixelMapDrawingStr));
      let pixelMapDrawingButton = await driver.findComponent(ON.text(pixelMapDrawingStr));
      await pixelMapDrawingButton.click();
      await driver.delayMs(DELAY_SHORT);

      let pixelMapStr = getString($r('app.string.PixelMap'));
      await driver.assertComponentExist(ON.text(pixelMapStr));
      let pixelMapButton = await driver.findComponent(ON.text(pixelMapStr));
      await pixelMapButton.click();
      await driver.delayMs(DELAY_SHORT);

      let editMiddlePixelMapStr = getString($r('app.string.EditMiddlePixel'));
      await driver.assertComponentExist(ON.text(editMiddlePixelMapStr));
      let editMiddlePixelMapButton = await driver.findComponent(ON.text(editMiddlePixelMapStr));
      await editMiddlePixelMapButton.click();
      await driver.delayMs(DELAY_SHORT);

      await driver.pressBack();
      done();
      Logger.info(TAG, 'PixelMapDrawing_001 end');
    });

    /**
     * @tc.number:TextBlockDrawing_001
     * @tc.name:TextBlockDrawing_001
     * @tc.desc:字块绘制结果测试
     */
    it('ArkTSGraphicsDraw_TextBlockDrawing_001', 0, async (done: Function) => {
      Logger.info(TAG, 'TextBlockDrawing_001 begin');
      let driver = Driver.create();
      let textBlockDrawingStr = getString($r('app.string.TextBlock_Drawing'));
      await driver.assertComponentExist(ON.text(textBlockDrawingStr));
      let textBlockDrawingButton = await driver.findComponent(ON.text(textBlockDrawingStr));
      await textBlockDrawingButton.click();
      await driver.delayMs(DELAY_SHORT);

      let baseTextStr = getString($r('app.string.BaseText'));
      await driver.assertComponentExist(ON.text(baseTextStr));
      let baseTextButton = await driver.findComponent(ON.text(baseTextStr));
      await baseTextButton.click();
      await driver.delayMs(DELAY_SHORT);

      let strokeTextStr = getString($r('app.string.StrokeText'));
      await driver.assertComponentExist(ON.text(strokeTextStr));
      let strokeTextButton = await driver.findComponent(ON.text(strokeTextStr));
      await strokeTextButton.click();
      await driver.delayMs(DELAY_SHORT);

      let gradientTextStr = getString($r('app.string.GradientText'));
      await driver.assertComponentExist(ON.text(gradientTextStr));
      let gradientTextButton = await driver.findComponent(ON.text(gradientTextStr));
      await gradientTextButton.click();
      await driver.delayMs(DELAY_SHORT);

      await driver.pressBack();
      done();
      Logger.info(TAG, 'TextBlockDrawing_001 end');
    });
  })
}