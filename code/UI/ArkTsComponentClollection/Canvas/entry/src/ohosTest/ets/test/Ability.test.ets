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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, Component } from '@ohos.UiTest'
import featureAbility from '@ohos.ability.featureAbility'

const TAG = '[Sample_Canvas]'
const DOMAIN = 0xF811
const BUNDLE = 'Canvas_'
export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etscanvas",
          abilityName: "ohos.samples.etscanvas.MainAbility"
        }
      }
      featureAbility.startAbility(parameter, (err, data) => {
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
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // RenderingContext
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 RenderingContext')
      await driver.assertComponentExist(ON.id('item1'))
      let renderingCon = await driver.findComponent(ON.id('item1'))
      await renderingCon.click()
      await driver.delayMs(1000)
      // arc
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 arc')
      await driver.assertComponentExist(ON.id('arc'))
      let arcBtn = await driver.findComponent(ON.id('arc'))
      await arcBtn.click()
      await driver.delayMs(1000)
      // strokeText
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 strokeText')
      await driver.assertComponentExist(ON.id('strokeText'))
      let strokeTextBtn = await driver.findComponent(ON.id('strokeText'))
      await strokeTextBtn.click()
      await driver.delayMs(1000)
      // closePath
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 closePath')
      await driver.assertComponentExist(ON.id('closePath'))
      let closePathBtn = await driver.findComponent(ON.id('closePath'))
      await closePathBtn.click()
      await driver.delayMs(1000)
      // quadraticCurveTo
      hilog.info(DOMAIN, TAG, BUNDLE + BUNDLE + 'RenderingContextFunction_001 quadraticCurveTo')
      await driver.assertComponentExist(ON.id('quadraticCurveTo'))
      let quadraticCurveToBtn = await driver.findComponent(ON.id('quadraticCurveTo'))
      await quadraticCurveToBtn.click()
      await driver.delayMs(1000)
      // textBaseline
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 textBaseline')
      await driver.assertComponentExist(ON.id('textBaseline'))
      let textBaselineBtn = await driver.findComponent(ON.id('textBaseline'))
      await textBaselineBtn.click()
      await driver.delayMs(1000)
      // delete
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 delete')
      await driver.assertComponentExist(ON.id('delete'))
      let deleteBtn = await driver.findComponent(ON.id('delete'))
      await deleteBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 back')
      await driver.assertComponentExist(ON.id('back'))
      let backBtn = await driver.findComponent(ON.id('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContextFunction_001 end')
    })

    /**
     * RenderingContext1
     */
    it(BUNDLE + 'RenderingContext1Function_001', 0, async function () {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // RenderingContext1
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 RenderingContext1')
      await driver.assertComponentExist(ON.id('item2'))
      let renderingCon1 = await driver.findComponent(ON.id('item2'))
      await renderingCon1.click()
      await driver.delayMs(1000)
      // strokeStyle
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 strokeStyle')
      await driver.assertComponentExist(ON.id('strokeStyle'))
      let strokeStyleBtn = await driver.findComponent(ON.id('strokeStyle'))
      await strokeStyleBtn.click()
      await driver.delayMs(1000)
      // lineCap
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 lineCap')
      await driver.assertComponentExist(ON.id('lineCap'))
      let lineCapBtn = await driver.findComponent(ON.id('lineCap'))
      await lineCapBtn.click()
      await driver.delayMs(1000)
      // globalAlpha
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 globalAlpha')
      await driver.assertComponentExist(ON.id('globalAlpha'))
      let globalAlphaBtn = await driver.findComponent(ON.id('globalAlpha'))
      await globalAlphaBtn.click()
      await driver.delayMs(1000)
      // textAlign
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 textAlign')
      await driver.assertComponentExist(ON.id('textAlign'))
      let textAlignBtn = await driver.findComponent(ON.id('textAlign'))
      await textAlignBtn.click()
      await driver.delayMs(1000)
      // lineJoin
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 lineJoin')
      await driver.assertComponentExist(ON.id('lineJoin'))
      let lineJoinBtn = await driver.findComponent(ON.id('lineJoin'))
      await lineJoinBtn.click()
      await driver.delayMs(1000)
      // miterLimit
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 miterLimit')
      await driver.assertComponentExist(ON.id('miterLimit'))
      let miterLimitBtn = await driver.findComponent(ON.id('miterLimit'))
      await miterLimitBtn.click()
      await driver.delayMs(1000)
      // globalCompositeOperation
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 globalCompositeOperation')
      await driver.assertComponentExist(ON.id('globalCompositeOperation'))
      let globalCompositeOperationBtn = await driver.findComponent(ON.id('globalCompositeOperation'))
      await globalCompositeOperationBtn.click()
      await driver.delayMs(1000)
      // delete
      hilog.info(DOMAIN, TAG, 'RenderingContext1Function_001 delete')
      await driver.assertComponentExist(ON.id('delete'))
      let deleteBtn = await driver.findComponent(ON.id('delete'))
      await deleteBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 back')
      await driver.assertComponentExist(ON.id('back'))
      let backBtn = await driver.findComponent(ON.id('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext1Function_001 end')
    })

    /**
     * RenderingContext2
     */
    it(BUNDLE + 'RenderingContext2Function_001', 0, async function () {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // RenderingContext2
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 RenderingContext2')
      await driver.assertComponentExist(ON.id('item3'))
      let renderingCon2 = await driver.findComponent(ON.id('item3'))
      await renderingCon2.click()
      await driver.delayMs(1000)
      // arcTo
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 arcTo')
      await driver.assertComponentExist(ON.id('arcTo'))
      let arcToBtn = await driver.findComponent(ON.id('arcTo'))
      await arcToBtn.click()
      await driver.delayMs(1000)
      // bezierCurveTo
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 bezierCurveTo')
      await driver.assertComponentExist(ON.id('bezierCurveTo'))
      let bezierCurveToBtn = await driver.findComponent(ON.id('bezierCurveTo'))
      await bezierCurveToBtn.click()
      await driver.delayMs(1000)
      // ellipse
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 ellipse')
      await driver.assertComponentExist(ON.id('ellipse'))
      let ellipseBtn = await driver.findComponent(ON.id('ellipse'))
      await ellipseBtn.click()
      await driver.delayMs(1000)
      // rect
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 rect')
      await driver.assertComponentExist(ON.id('rect'))
      let rectBtn = await driver.findComponent(ON.id('rect'))
      await rectBtn.click()
      await driver.delayMs(1000)
      // createPattern
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 createPattern')
      await driver.assertComponentExist(ON.id('createPattern'))
      let createPatternBtn = await driver.findComponent(ON.id('createPattern'))
      await createPatternBtn.click()
      await driver.delayMs(1000)
      // lineDashOffset
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 lineDashOffset')
      await driver.assertComponentExist(ON.id('lineDashOffset'))
      let lineDashOffsetBtn = await driver.findComponent(ON.id('lineDashOffset'))
      await lineDashOffsetBtn.click()
      await driver.delayMs(1000)
      // scale
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 scale')
      await driver.assertComponentExist(ON.id('scale'))
      let scaleBtn = await driver.findComponent(ON.id('scale'))
      await scaleBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 back')
      await driver.assertComponentExist(ON.id('back'))
      let backBtn = await driver.findComponent(ON.id('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'RenderingContext2Function_001 end')
    })

    /**
     * TransformExample
     */
    it(BUNDLE + 'TransformExampleFunction_001', 0, async function () {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      console.log("Sample_Canvas 1")
      // TransformExample
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 TransformExample')
      await driver.assertComponentExist(ON.id('item4'))
      let transform = await driver.findComponent(ON.id('item4'))
      await transform.click()
      await driver.delayMs(1000)
      // translate
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 translate')
      await driver.assertComponentExist(ON.id('translate'))
      let translateBtn = await driver.findComponent(ON.id('translate'))
      await translateBtn.click()
      await driver.delayMs(1000)
      // transform
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 transform')
      await driver.assertComponentExist(ON.id('transform'))
      let transformBtn = await driver.findComponent(ON.id('transform'))
      await transformBtn.click()
      await driver.delayMs(1000)
      // setTransform
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 setTransform')
      await driver.assertComponentExist(ON.id('setTransform'))
      let setTransformBtn = await driver.findComponent(ON.id('setTransform'))
      await setTransformBtn.click()
      await driver.delayMs(1000)
      // rotate
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 rotate')
      await driver.assertComponentExist(ON.id('rotate'))
      let rotateBtn = await driver.findComponent(ON.id('rotate'))
      await rotateBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 back')
      await driver.assertComponentExist(ON.id('back'))
      let backBtn = await driver.findComponent(ON.id('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformExampleFunction_001 end')
    })

    /**
     * ShadowOffsetExample
     */
    it(BUNDLE + 'ShadowOffsetExampleFunction_001', 0, async function () {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // ShadowOffsetExample
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 ShadowOffsetExample')
      await driver.assertComponentExist(ON.id('item5'))
      let shadowOffset = await driver.findComponent(ON.id('item5'))
      await shadowOffset.click()
      await driver.delayMs(1000)
      // shadowOffsetY
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 shadowOffsetY')
      await driver.assertComponentExist(ON.id('shadowOffsetY'))
      let shadowOffsetYBtn = await driver.findComponent(ON.id('shadowOffsetY'))
      await shadowOffsetYBtn.click()
      await driver.delayMs(1000)
      // shadowOffsetX
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 shadowOffsetX')
      await driver.assertComponentExist(ON.id('shadowOffsetX'))
      let shadowOffsetXBtn = await driver.findComponent(ON.id('shadowOffsetX'))
      await shadowOffsetXBtn.click()
      await driver.delayMs(1000)
      // shadowBlur
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 shadowBlur')
      await driver.assertComponentExist(ON.id('shadowBlur'))
      let shadowBlurBtn = await driver.findComponent(ON.id('shadowBlur'))
      await shadowBlurBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 back')
      await driver.assertComponentExist(ON.id('back'))
      let backBtn = await driver.findComponent(ON.id('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShadowOffsetExampleFunction_001 end')
    })

    /**
     * PathExample
     */
    it(BUNDLE + 'PathExampleFunction_001', 0, async function () {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // PathExample
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 PathExample')
      await driver.assertComponentExist(ON.id('item6'))
      let path2DBtn = await driver.findComponent(ON.id('item6'))
      await path2DBtn.click()
      await driver.delayMs(1000)
      // arc
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 arc')
      await driver.assertComponentExist(ON.id('arc'))
      let arcBtn = await driver.findComponent(ON.id('arc'))
      await arcBtn.click()
      await driver.delayMs(1000)
      // quadraticCurveTo
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 quadraticCurveTo')
      await driver.assertComponentExist(ON.id('quadraticCurveTo'))
      let quadraticCurveToBtn = await driver.findComponent(ON.id('quadraticCurveTo'))
      await quadraticCurveToBtn.click()
      await driver.delayMs(1000)
      // bezierCurveTo
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 bezierCurveTo')
      await driver.assertComponentExist(ON.id('bezierCurveTo'))
      let bezierCurveToBtn = await driver.findComponent(ON.id('bezierCurveTo'))
      await bezierCurveToBtn.click()
      await driver.delayMs(1000)
      // arcTo
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 arcTo')
      await driver.assertComponentExist(ON.id('arcTo'))
      let arcToBtn = await driver.findComponent(ON.id('arcTo'))
      await arcToBtn.click()
      await driver.delayMs(1000)
      // ellipse
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 ellipse')
      await driver.assertComponentExist(ON.id('ellipse'))
      let ellipseBtn = await driver.findComponent(ON.id('ellipse'))
      await ellipseBtn.click()
      await driver.delayMs(1000)
      // rect
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 rect')
      await driver.assertComponentExist(ON.id('rect'))
      let rectBtn = await driver.findComponent(ON.id('rect'))
      await rectBtn.click()
      await driver.delayMs(1000)
      // closePath
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 closePath')
      await driver.assertComponentExist(ON.id('closePath'))
      let closePathBtn = await driver.findComponent(ON.id('closePath'))
      await closePathBtn.click()
      await driver.delayMs(1000)
      // delete
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 delete')
      await driver.assertComponentExist(ON.id('delete'))
      let deleteBtn = await driver.findComponent(ON.id('delete'))
      await deleteBtn.click()
      await driver.delayMs(1000)
      // addPath
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 addPath')
      await driver.assertComponentExist(ON.id('addPath'))
      let addPathBtn = await driver.findComponent(ON.id('addPath'))
      await addPathBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 back')
      await driver.assertComponentExist(ON.id('back'))
      let backBtn = await driver.findComponent(ON.id('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'PathExampleFunction_001 end')
    })

    /**
     * BitmapExample
     */
    it(BUNDLE + 'BitmapExampleFunction_001', 0, async function () {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'BitmapExampleFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // BitmapExample
      hilog.info(DOMAIN, TAG, BUNDLE + 'BitmapExampleFunction_001 BitmapExample')
      await driver.assertComponentExist(ON.id('item7'))
      let imageBitmapBtn = await driver.findComponent(ON.id('item7'))
      await imageBitmapBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'BitmapExampleFunction_001 back')
      await driver.assertComponentExist(ON.id('back'))
      let backBtn = await driver.findComponent(ON.id('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'BitmapExampleFunction_001 end')
    })

    /**
     * GradientExample
     */
    it(BUNDLE + 'GradientExampleFunction_001', 0, async function () {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // GradientExample
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 GradientExample')
      await driver.assertComponentExist(ON.id('item8'))
      let canvasGradientBtn = await driver.findComponent(ON.id('item8'))
      await canvasGradientBtn.click()
      await driver.delayMs(1000)
      // createLinearGradient
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 createLinearGradient')
      await driver.assertComponentExist(ON.id('createLinearGradient'))
      let createLinearGradientBtn = await driver.findComponent(ON.id('createLinearGradient'))
      await createLinearGradientBtn.click()
      await driver.delayMs(1000)
      // createRadialGradient
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 createRadialGradient')
      await driver.assertComponentExist(ON.id('createRadialGradient'))
      let createRadialGradientBtn = await driver.findComponent(ON.id('createRadialGradient'))
      await createRadialGradientBtn.click()
      await driver.delayMs(1000)
      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 back')
      await driver.assertComponentExist(ON.id('back'))
      let backBtn = await driver.findComponent(ON.id('back'))
      await backBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'GradientExampleFunction_001 end')
    })
  })
}