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


const TAG = '[Sample_NDKAPIDrawing]';
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
    it('NDKAPIDrawing_StartAbility_001',0, async (done: Function) => {
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
     * @tc.number:drawing_brush_001
     * @tc.name:drawing_brush_001
     * @tc.desc:drawing_brush测试
     */
    it('NDKAPIDrawing_drawing_brush_001', 0, async (done: Function) => {
      Logger.info(TAG, 'drawing_brush_001 begin');
      let driver = Driver.create();
      let pageStr = getString($r('app.string.DrawingBrushAccess'));
      await driver.assertComponentExist(ON.text(pageStr));
      let canvasButton = await driver.findComponent(ON.text(pageStr));
      await canvasButton.click();
      await driver.delayMs(DELAY_LONG);

      let btnStr1 = getString($r('app.string.DrawingBrushBasic'));
      await driver.assertComponentExist(ON.text(btnStr1));
      let btn1 = await driver.findComponent(ON.text(btnStr1));
      await btn1.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr2 = getString($r('app.string.DrawingBlendMode'));
      await driver.assertComponentExist(ON.text(btnStr2));
      let btn2 = await driver.findComponent(ON.text(btnStr2));
      await btn2.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr3 = getString($r('app.string.DrawingColorFilter'));
      await driver.assertComponentExist(ON.text(btnStr3));
      let btn3 = await driver.findComponent(ON.text(btnStr3));
      await btn3.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr4 = getString($r('app.string.DrawingShaderEffect'));
      await driver.assertComponentExist(ON.text(btnStr4));
      let btn4 = await driver.findComponent(ON.text(btnStr4));
      await btn4.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr5 = getString($r('app.string.DrawingMaskFilter'));
      await driver.assertComponentExist(ON.text(btnStr5));
      let btn5 = await driver.findComponent(ON.text(btnStr5));
      await btn5.click();
      await driver.delayMs(DELAY_SHORT);

      // 返回主页
      await driver.pressBack();
      done();
      Logger.info(TAG, 'CanvasGetResult_001 end');
    });

    /**
     * @tc.number:drawing_pen_001
     * @tc.name:drawing_pen_001
     * @tc.desc:drawing_pen测试
     */
    it('NDKAPIDrawing_drawing_pen_001', 0, async (done: Function) => {
      Logger.info(TAG, 'drawing_pen_001 begin');
      let driver = Driver.create();
      let pageStr = getString($r('app.string.DrawingPenAccess'));
      await driver.assertComponentExist(ON.text(pageStr));
      let canvasButton = await driver.findComponent(ON.text(pageStr));
      await canvasButton.click();
      await driver.delayMs(DELAY_LONG);

      let btnStr1 = getString($r('app.string.DrawingPenBasic'));
      await driver.assertComponentExist(ON.text(btnStr1));
      let btn1 = await driver.findComponent(ON.text(btnStr1));
      await btn1.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr2 = getString($r('app.string.DrawingCapJoin'));
      await driver.assertComponentExist(ON.text(btnStr2));
      let btn2 = await driver.findComponent(ON.text(btnStr2));
      await btn2.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr3 = getString($r('app.string.DrawingMiterLimit'));
      await driver.assertComponentExist(ON.text(btnStr3));
      let btn3 = await driver.findComponent(ON.text(btnStr3));
      await btn3.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr4 = getString($r('app.string.DrawingImageFilter'));
      await driver.assertComponentExist(ON.text(btnStr4));
      let btn4 = await driver.findComponent(ON.text(btnStr4));
      await btn4.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr5 = getString($r('app.string.DrawingPathEffect'));
      await driver.assertComponentExist(ON.text(btnStr5));
      let btn5 = await driver.findComponent(ON.text(btnStr5));
      await btn5.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr6 = getString($r('app.string.DrawingShaderEffect'));
      await driver.assertComponentExist(ON.text(btnStr6));
      let btn6 = await driver.findComponent(ON.text(btnStr6));
      await btn6.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr7 = getString($r('app.string.DrawingMaskFilter'));
      await driver.assertComponentExist(ON.text(btnStr7));
      let btn7 = await driver.findComponent(ON.text(btnStr7));
      await btn7.click();
      await driver.delayMs(DELAY_SHORT);

      // 返回主页
      await driver.pressBack();
      done();
      Logger.info(TAG, 'CanvasGetResult_001 end');
    });

    /**
     * @tc.number:drawing_rect_001
     * @tc.name:drawing_rect_001
     * @tc.desc:drawing_rect测试
     */
    it('NDKAPIDrawing_drawing_rect_001', 0, async (done: Function) => {
      Logger.info(TAG, 'drawing_rect_001 begin');
      let driver = Driver.create();
      let pageStr = getString($r('app.string.DrawingRectAccess'));
      await driver.assertComponentExist(ON.text(pageStr));
      let canvasButton = await driver.findComponent(ON.text(pageStr));
      await canvasButton.click();
      await driver.delayMs(DELAY_LONG);

      let btnStr1 = getString($r('app.string.DrawingRectBasic'));
      await driver.assertComponentExist(ON.text(btnStr1));
      let btn1 = await driver.findComponent(ON.text(btnStr1));
      await btn1.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr2 = getString($r('app.string.DrawingIntersect'));
      await driver.assertComponentExist(ON.text(btnStr2));
      let btn2 = await driver.findComponent(ON.text(btnStr2));
      await btn2.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr3 = getString($r('app.string.DrawingJoin'));
      await driver.assertComponentExist(ON.text(btnStr3));
      let btn3 = await driver.findComponent(ON.text(btnStr3));
      await btn3.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr4 = getString($r('app.string.DrawingRoundRect'));
      await driver.assertComponentExist(ON.text(btnStr4));
      let btn4 = await driver.findComponent(ON.text(btnStr4));
      await btn4.click();
      await driver.delayMs(DELAY_SHORT);

      // 返回主页
      await driver.pressBack();
      done();
      Logger.info(TAG, 'CanvasGetResult_001 end');
    });

    /**
     * @tc.number:drawing_path_001
     * @tc.name:drawing_path_001
     * @tc.desc:drawing_path测试
     */
    it('NDKAPIDrawing_drawing_path_001', 0, async (done: Function) => {
      Logger.info(TAG, 'drawing_path_001 begin');
      let driver = Driver.create();
      let pageStr = getString($r('app.string.DrawingPathAccess'));
      await driver.assertComponentExist(ON.text(pageStr));
      let canvasButton = await driver.findComponent(ON.text(pageStr));
      await canvasButton.click();
      await driver.delayMs(DELAY_LONG);

      let btnStr1 = getString($r('app.string.DrawingPathBasic'));
      await driver.assertComponentExist(ON.text(btnStr1));
      let btn1 = await driver.findComponent(ON.text(btnStr1));
      await btn1.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr2 = getString($r('app.string.DrawingPathAdd'));
      await driver.assertComponentExist(ON.text(btnStr2));
      let btn2 = await driver.findComponent(ON.text(btnStr2));
      await btn2.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr3 = getString($r('app.string.DrawingPathTo'));
      await driver.assertComponentExist(ON.text(btnStr3));
      let btn3 = await driver.findComponent(ON.text(btnStr3));
      await btn3.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr4 = getString($r('app.string.DrawingPathStar'));
      await driver.assertComponentExist(ON.text(btnStr4));
      let btn4 = await driver.findComponent(ON.text(btnStr4));
      await btn4.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr5 = getString($r('app.string.DrawingBuildFromSvgString'));
      await driver.assertComponentExist(ON.text(btnStr5));
      let btn5 = await driver.findComponent(ON.text(btnStr5));
      await btn5.click();
      await driver.delayMs(DELAY_SHORT);

      // 返回主页
      await driver.pressBack();
      done();
      Logger.info(TAG, 'CanvasGetResult_001 end');
    });

    /**
     * @tc.number:drawing_matrix_001
     * @tc.name:drawing_matrix_001
     * @tc.desc:drawing_matrix测试
     */
    it('NDKAPIDrawing_drawing_matrix_001', 0, async (done: Function) => {
      Logger.info(TAG, 'drawing_matrix_001 begin');
      let driver = Driver.create();
      let pageStr = getString($r('app.string.DrawingMatrixAccess'));
      await driver.assertComponentExist(ON.text(pageStr));
      let canvasButton = await driver.findComponent(ON.text(pageStr));
      await canvasButton.click();
      await driver.delayMs(DELAY_LONG);

      let btnStr1 = getString($r('app.string.DrawingMatrixBasic'));
      await driver.assertComponentExist(ON.text(btnStr1));
      let btn1 = await driver.findComponent(ON.text(btnStr1));
      await btn1.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr2 = getString($r('app.string.DrawingTranslation'));
      await driver.assertComponentExist(ON.text(btnStr2));
      let btn2 = await driver.findComponent(ON.text(btnStr2));
      await btn2.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr3 = getString($r('app.string.DrawingPreTranslation'));
      await driver.assertComponentExist(ON.text(btnStr3));
      let btn3 = await driver.findComponent(ON.text(btnStr3));
      await btn3.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr4 = getString($r('app.string.DrawingPostTranslation'));
      await driver.assertComponentExist(ON.text(btnStr4));
      let btn4 = await driver.findComponent(ON.text(btnStr4));
      await btn4.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr5 = getString($r('app.string.DrawingRotation'));
      await driver.assertComponentExist(ON.text(btnStr5));
      let btn5 = await driver.findComponent(ON.text(btnStr5));
      await btn5.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr6 = getString($r('app.string.DrawingPreRotation'));
      await driver.assertComponentExist(ON.text(btnStr6));
      let btn6 = await driver.findComponent(ON.text(btnStr6));
      await btn6.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr7 = getString($r('app.string.DrawingPostRotation'));
      await driver.assertComponentExist(ON.text(btnStr7));
      let btn7 = await driver.findComponent(ON.text(btnStr7));
      await btn7.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr8 = getString($r('app.string.DrawingScale'));
      await driver.assertComponentExist(ON.text(btnStr8));
      let btn8 = await driver.findComponent(ON.text(btnStr8));
      await btn8.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr9 = getString($r('app.string.DrawingPreScale'));
      await driver.assertComponentExist(ON.text(btnStr9));
      let btn9 = await driver.findComponent(ON.text(btnStr9));
      await btn9.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr10 = getString($r('app.string.DrawingPostScale'));
      await driver.assertComponentExist(ON.text(btnStr10));
      let btn10 = await driver.findComponent(ON.text(btnStr10));
      await btn10.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr11 = getString($r('app.string.DrawingConcat'));
      await driver.assertComponentExist(ON.text(btnStr11));
      let btn11 = await driver.findComponent(ON.text(btnStr11));
      await btn11.click();
      await driver.delayMs(DELAY_SHORT);

      // 返回主页
      await driver.pressBack();
      done();
      Logger.info(TAG, 'CanvasGetResult_001 end');
    });

    /**
     * @tc.number:drawing_canvas_001
     * @tc.name:drawing_canvas_001
     * @tc.desc:drawing_canvas测试
     */
    it('NDKAPIDrawing_drawing_canvas_001', 0, async (done: Function) => {
      Logger.info(TAG, 'drawing_canvas_001 begin');
      let driver = Driver.create();
      let pageStr = getString($r('app.string.DrawingCanvasAccess'));
      await driver.assertComponentExist(ON.text(pageStr));
      let canvasButton = await driver.findComponent(ON.text(pageStr));
      await canvasButton.click();
      await driver.delayMs(DELAY_LONG);

      let btnStr1 = getString($r('app.string.DrawingCreateCanvas'));
      await driver.assertComponentExist(ON.text(btnStr1));
      let btn1 = await driver.findComponent(ON.text(btnStr1));
      await btn1.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr2 = getString($r('app.string.DrawingClip'));
      await driver.assertComponentExist(ON.text(btnStr2));
      let btn2 = await driver.findComponent(ON.text(btnStr2));
      await btn2.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr3 = getString($r('app.string.DrawingSave'));
      await driver.assertComponentExist(ON.text(btnStr3));
      let btn3 = await driver.findComponent(ON.text(btnStr3));
      await btn3.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr4 = getString($r('app.string.DrawingSaveLayer'));
      await driver.assertComponentExist(ON.text(btnStr4));
      let btn4 = await driver.findComponent(ON.text(btnStr4));
      await btn4.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr5 = getString($r('app.string.DrawingConcatMatrix'));
      await driver.assertComponentExist(ON.text(btnStr5));
      let btn5 = await driver.findComponent(ON.text(btnStr5));
      await btn5.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr6 = getString($r('app.string.DrawingDrawPixelMap'));
      await driver.assertComponentExist(ON.text(btnStr6));
      let btn6 = await driver.findComponent(ON.text(btnStr6));
      await btn6.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr7 = getString($r('app.string.DrawingDrawRegion'));
      await driver.assertComponentExist(ON.text(btnStr7));
      let btn7 = await driver.findComponent(ON.text(btnStr7));
      await btn7.click();
      await driver.delayMs(DELAY_SHORT);

      // 返回主页
      await driver.pressBack();
      done();
      Logger.info(TAG, 'CanvasGetResult_001 end');
    });

    /**
     * @tc.number:drawing_pixelmap_001
     * @tc.name:drawing_pixelmap_001
     * @tc.desc:drawing_pixelmap测试
     */
    it('NDKAPIDrawing_drawing_pixelmap_001', 0, async (done: Function) => {
      Logger.info(TAG, 'drawing_pixelmap_001 begin');
      let driver = Driver.create();
      let pageStr = getString($r('app.string.DrawingPixelmapAccess'));
      await driver.assertComponentExist(ON.text(pageStr));
      let canvasButton = await driver.findComponent(ON.text(pageStr));
      await canvasButton.click();
      await driver.delayMs(DELAY_LONG);

      let btnStr1 = getString($r('app.string.DrawingLocalPixelMap'));
      await driver.assertComponentExist(ON.text(btnStr1));
      let btn1 = await driver.findComponent(ON.text(btnStr1));
      await btn1.click();
      await driver.delayMs(DELAY_SHORT);

      let btnStr2 = getString($r('app.string.DrawingCustomPixelMap'));
      await driver.assertComponentExist(ON.text(btnStr2));
      let btn2 = await driver.findComponent(ON.text(btnStr2));
      await btn2.click();
      await driver.delayMs(DELAY_SHORT);

      // 返回主页
      await driver.pressBack();
      done();
      Logger.info(TAG, 'CanvasGetResult_001 end');
    });

    /**
     * @tc.number:drawing_bitmap_001
     * @tc.name:drawing_bitmap_001
     * @tc.desc:drawing_bitmap测试
     */
    it('NDKAPIDrawing_drawing_bitmap_001', 0, async (done: Function) => {
      Logger.info(TAG, 'drawing_bitmap_001 begin');
      let driver = Driver.create();
      let pageStr = getString($r('app.string.DrawingBitmapAccess'));
      await driver.assertComponentExist(ON.text(pageStr));
      let canvasButton = await driver.findComponent(ON.text(pageStr));
      await canvasButton.click();
      await driver.delayMs(DELAY_LONG);

      // 返回主页
      await driver.pressBack();
      done();
      Logger.info(TAG, 'CanvasGetResult_001 end');
    });

    /**
     * @tc.number:drawing_image_001
     * @tc.name:drawing_image_001
     * @tc.desc:drawing_image测试
     */
    it('NDKAPIDrawing_drawing_image_001', 0, async (done: Function) => {
      Logger.info(TAG, 'drawing_image_001 begin');
      let driver = Driver.create();
      let pageStr = getString($r('app.string.DrawingImageAccess'));
      await driver.assertComponentExist(ON.text(pageStr));
      let canvasButton = await driver.findComponent(ON.text(pageStr));
      await canvasButton.click();
      await driver.delayMs(DELAY_LONG);

      // 返回主页
      await driver.pressBack();
      done();
      Logger.info(TAG, 'CanvasGetResult_001 end');
    });
  })
}