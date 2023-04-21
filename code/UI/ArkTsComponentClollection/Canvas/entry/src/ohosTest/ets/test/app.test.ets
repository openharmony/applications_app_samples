/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Canvas]'
const DOMAIN = 0xF811
const BUNDLE = 'Canvas_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etscanvas",
          abilityName: "ohos.samples.etscanvas.MainAbility"
        }
      }
      await featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * RenderingContext
     */
    it(BUNDLE + 'RenderingContextFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // RenderingContext
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 RenderingContext')
      await driver.assertComponentExist(BY.key('item1'))
      let renderingCon = await driver.findComponent(BY.key('item1'))
      await renderingCon.click()
      await driver.delayMs(1000)
      // arc
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 arc')
      await driver.assertComponentExist(BY.key('arc'))
      let arcBtn = await driver.findComponent(BY.key('arc'))
      await arcBtn.click()
      await driver.delayMs(1000)
      // strokeText
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 strokeText')
      await driver.assertComponentExist(BY.key('strokeText'))
      let strokeTextBtn = await driver.findComponent(BY.key('strokeText'))
      await strokeTextBtn.click()
      await driver.delayMs(1000)
      // closePath
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 closePath')
      await driver.assertComponentExist(BY.key('closePath'))
      let closePathBtn = await driver.findComponent(BY.key('closePath'))
      await closePathBtn.click()
      await driver.delayMs(1000)
      // quadraticCurveTo
      hilog.info(DOMAIN, TAG, BUNDLE + BUNDLE + 'RenderingContextFunction_001 quadraticCurveTo')
      await driver.assertComponentExist(BY.key('quadraticCurveTo'))
      let quadraticCurveToBtn = await driver.findComponent(BY.key('quadraticCurveTo'))
      await quadraticCurveToBtn.click()
      await driver.delayMs(1000)
      // textBaseline
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 textBaseline')
      await driver.assertComponentExist(BY.key('textBaseline'))
      let textBaselineBtn = await driver.findComponent(BY.key('textBaseline'))
      await textBaselineBtn.click()
      await driver.delayMs(1000)
      // delete
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 delete')
      await driver.assertComponentExist(BY.key('delete'))
      let deleteBtn = await driver.findComponent(BY.key('delete'))
      await deleteBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let backBtn = await driver.findComponent(BY.key('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 end')
    })

    /**
     * RenderingContext1
     */
    it(BUNDLE + 'RenderingContext1Function_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // RenderingContext1
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 RenderingContext1')
      await driver.assertComponentExist(BY.key('item2'))
      let renderingCon1 = await driver.findComponent(BY.key('item2'))
      await renderingCon1.click()
      await driver.delayMs(1000)
      // strokeStyle
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 strokeStyle')
      await driver.assertComponentExist(BY.key('strokeStyle'))
      let strokeStyleBtn = await driver.findComponent(BY.key('strokeStyle'))
      await strokeStyleBtn.click()
      await driver.delayMs(1000)
      // lineCap
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 lineCap')
      await driver.assertComponentExist(BY.key('lineCap'))
      let lineCapBtn = await driver.findComponent(BY.key('lineCap'))
      await lineCapBtn.click()
      await driver.delayMs(1000)
      // globalAlpha
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 globalAlpha')
      await driver.assertComponentExist(BY.key('globalAlpha'))
      let globalAlphaBtn = await driver.findComponent(BY.key('globalAlpha'))
      await globalAlphaBtn.click()
      await driver.delayMs(1000)
      // textAlign
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 textAlign')
      await driver.assertComponentExist(BY.key('textAlign'))
      let textAlignBtn = await driver.findComponent(BY.key('textAlign'))
      await textAlignBtn.click()
      await driver.delayMs(1000)
      // lineJoin
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 lineJoin')
      await driver.assertComponentExist(BY.key('lineJoin'))
      let lineJoinBtn = await driver.findComponent(BY.key('lineJoin'))
      await lineJoinBtn.click()
      await driver.delayMs(1000)
      // miterLimit
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 miterLimit')
      await driver.assertComponentExist(BY.key('miterLimit'))
      let miterLimitBtn = await driver.findComponent(BY.key('miterLimit'))
      await miterLimitBtn.click()
      await driver.delayMs(1000)
      // globalCompositeOperation
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 globalCompositeOperation')
      await driver.assertComponentExist(BY.key('globalCompositeOperation'))
      let globalCompositeOperationBtn = await driver.findComponent(BY.key('globalCompositeOperation'))
      await globalCompositeOperationBtn.click()
      await driver.delayMs(1000)
      // delete
      hilog.info(DOMAIN, TAG, 'RenderingContext1Function_001 delete')
      await driver.assertComponentExist(BY.key('delete'))
      let deleteBtn = await driver.findComponent(BY.key('delete'))
      await deleteBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let backBtn = await driver.findComponent(BY.key('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 end')
    })

    /**
     * RenderingContext2
     */
    it(BUNDLE + 'RenderingContext2Function_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // RenderingContext2
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 RenderingContext2')
      await driver.assertComponentExist(BY.key('item3'))
      let renderingCon2 = await driver.findComponent(BY.key('item3'))
      await renderingCon2.click()
      await driver.delayMs(1000)
      // arcTo
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 arcTo')
      await driver.assertComponentExist(BY.key('arcTo'))
      let arcToBtn = await driver.findComponent(BY.key('arcTo'))
      await arcToBtn.click()
      await driver.delayMs(1000)
      // bezierCurveTo
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 bezierCurveTo')
      await driver.assertComponentExist(BY.key('bezierCurveTo'))
      let bezierCurveToBtn = await driver.findComponent(BY.key('bezierCurveTo'))
      await bezierCurveToBtn.click()
      await driver.delayMs(1000)
      // ellipse
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 ellipse')
      await driver.assertComponentExist(BY.key('ellipse'))
      let ellipseBtn = await driver.findComponent(BY.key('ellipse'))
      await ellipseBtn.click()
      await driver.delayMs(1000)
      // rect
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 rect')
      await driver.assertComponentExist(BY.key('rect'))
      let rectBtn = await driver.findComponent(BY.key('rect'))
      await rectBtn.click()
      await driver.delayMs(1000)
      // createPattern
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 createPattern')
      await driver.assertComponentExist(BY.key('createPattern'))
      let createPatternBtn = await driver.findComponent(BY.key('createPattern'))
      await createPatternBtn.click()
      await driver.delayMs(1000)
      // lineDashOffset
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 lineDashOffset')
      await driver.assertComponentExist(BY.key('lineDashOffset'))
      let lineDashOffsetBtn = await driver.findComponent(BY.key('lineDashOffset'))
      await lineDashOffsetBtn.click()
      await driver.delayMs(1000)
      // scale
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 scale')
      await driver.assertComponentExist(BY.key('scale'))
      let scaleBtn = await driver.findComponent(BY.key('scale'))
      await scaleBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let backBtn = await driver.findComponent(BY.key('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 end')
    })

    /**
     * TransformExample
     */
    it(BUNDLE + 'TransformExampleFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      console.log("Sample_Canvas 1")
      // TransformExample
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 TransformExample')
      await driver.assertComponentExist(BY.key('item4'))
      let transform = await driver.findComponent(BY.key('item4'))
      await transform.click()
      await driver.delayMs(1000)
      // translate
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 translate')
      await driver.assertComponentExist(BY.key('translate'))
      let translateBtn = await driver.findComponent(BY.key('translate'))
      await translateBtn.click()
      await driver.delayMs(1000)
      // transform
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 transform')
      await driver.assertComponentExist(BY.key('transform'))
      let transformBtn = await driver.findComponent(BY.key('transform'))
      await transformBtn.click()
      await driver.delayMs(1000)
      // setTransform
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 setTransform')
      await driver.assertComponentExist(BY.key('setTransform'))
      let setTransformBtn = await driver.findComponent(BY.key('setTransform'))
      await setTransformBtn.click()
      await driver.delayMs(1000)
      // rotate
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 rotate')
      await driver.assertComponentExist(BY.key('rotate'))
      let rotateBtn = await driver.findComponent(BY.key('rotate'))
      await rotateBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let backBtn = await driver.findComponent(BY.key('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 end')
    })

    /**
     * ShadowOffsetExample
     */
    it(BUNDLE + 'ShadowOffsetExampleFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // ShadowOffsetExample
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 ShadowOffsetExample')
      await driver.assertComponentExist(BY.key('item5'))
      let shadowOffset = await driver.findComponent(BY.key('item5'))
      await shadowOffset.click()
      await driver.delayMs(1000)
      // shadowOffsetY
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 shadowOffsetY')
      await driver.assertComponentExist(BY.key('shadowOffsetY'))
      let shadowOffsetYBtn = await driver.findComponent(BY.key('shadowOffsetY'))
      await shadowOffsetYBtn.click()
      await driver.delayMs(1000)
      // shadowOffsetX
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 shadowOffsetX')
      await driver.assertComponentExist(BY.key('shadowOffsetX'))
      let shadowOffsetXBtn = await driver.findComponent(BY.key('shadowOffsetX'))
      await shadowOffsetXBtn.click()
      await driver.delayMs(1000)
      // shadowBlur
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 shadowBlur')
      await driver.assertComponentExist(BY.key('shadowBlur'))
      let shadowBlurBtn = await driver.findComponent(BY.key('shadowBlur'))
      await shadowBlurBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let backBtn = await driver.findComponent(BY.key('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 end')
    })

    /**
     * PathExample
     */
    it(BUNDLE + 'PathExampleFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // PathExample
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 PathExample')
      await driver.assertComponentExist(BY.key('item6'))
      let path2DBtn = await driver.findComponent(BY.key('item6'))
      await path2DBtn.click()
      await driver.delayMs(1000)
      // arc
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 arc')
      await driver.assertComponentExist(BY.key('arc'))
      let arcBtn = await driver.findComponent(BY.key('arc'))
      await arcBtn.click()
      await driver.delayMs(1000)
      // quadraticCurveTo
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 quadraticCurveTo')
      await driver.assertComponentExist(BY.key('quadraticCurveTo'))
      let quadraticCurveToBtn = await driver.findComponent(BY.key('quadraticCurveTo'))
      await quadraticCurveToBtn.click()
      await driver.delayMs(1000)
      // bezierCurveTo
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 bezierCurveTo')
      await driver.assertComponentExist(BY.key('bezierCurveTo'))
      let bezierCurveToBtn = await driver.findComponent(BY.key('bezierCurveTo'))
      await bezierCurveToBtn.click()
      await driver.delayMs(1000)
      // arcTo
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 arcTo')
      await driver.assertComponentExist(BY.key('arcTo'))
      let arcToBtn = await driver.findComponent(BY.key('arcTo'))
      await arcToBtn.click()
      await driver.delayMs(1000)
      // ellipse
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 ellipse')
      await driver.assertComponentExist(BY.key('ellipse'))
      let ellipseBtn = await driver.findComponent(BY.key('ellipse'))
      await ellipseBtn.click()
      await driver.delayMs(1000)
      // rect
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 rect')
      await driver.assertComponentExist(BY.key('rect'))
      let rectBtn = await driver.findComponent(BY.key('rect'))
      await rectBtn.click()
      await driver.delayMs(1000)
      // closePath
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 closePath')
      await driver.assertComponentExist(BY.key('closePath'))
      let closePathBtn = await driver.findComponent(BY.key('closePath'))
      await closePathBtn.click()
      await driver.delayMs(1000)
      // delete
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 delete')
      await driver.assertComponentExist(BY.key('delete'))
      let deleteBtn = await driver.findComponent(BY.key('delete'))
      await deleteBtn.click()
      await driver.delayMs(1000)
      // addPath
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 addPath')
      await driver.assertComponentExist(BY.key('addPath'))
      let addPathBtn = await driver.findComponent(BY.key('addPath'))
      await addPathBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let backBtn = await driver.findComponent(BY.key('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 end')
    })

    /**
     * BitmapExample
     */
    it(BUNDLE + 'BitmapExampleFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'BitmapExampleFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // BitmapExample
      hilog.info(DOMAIN, TAG, BUNDLE + 'BitmapExampleFunction_001 BitmapExample')
      await driver.assertComponentExist(BY.key('item7'))
      let imageBitmapBtn = await driver.findComponent(BY.key('item7'))
      await imageBitmapBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'BitmapExampleFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let backBtn = await driver.findComponent(BY.key('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'BitmapExampleFunction_001 end')
    })

    /**
     * GradientExample
     */
    it(BUNDLE + 'GradientExampleFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // GradientExample
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 GradientExample')
      await driver.assertComponentExist(BY.key('item8'))
      let canvasGradientBtn = await driver.findComponent(BY.key('item8'))
      await canvasGradientBtn.click()
      await driver.delayMs(1000)
      // createLinearGradient
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 createLinearGradient')
      await driver.assertComponentExist(BY.key('createLinearGradient'))
      let createLinearGradientBtn = await driver.findComponent(BY.key('createLinearGradient'))
      await createLinearGradientBtn.click()
      await driver.delayMs(1000)
      // createRadialGradient
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 createRadialGradient')
      await driver.assertComponentExist(BY.key('createRadialGradient'))
      let createRadialGradientBtn = await driver.findComponent(BY.key('createRadialGradient'))
      await createRadialGradientBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let backBtn = await driver.findComponent(BY.key('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 end')
    })
  })
}