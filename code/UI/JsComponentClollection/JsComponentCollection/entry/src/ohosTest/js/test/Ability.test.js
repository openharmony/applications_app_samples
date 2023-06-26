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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import hilog from '@ohos.hilog';

const TAG = 'Sample_JsComponentCollection';
const BUNDLE = 'JsComponentCollection';
let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
const DOMAIN = 0xF811;

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    // 打开应用
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, `${BUNDLE}StartAbility_001 begin`);
      let want = {
        bundleName: 'ohos.samples.jscomponentcollection',
        abilityName: 'ohos.samples.jscomponentcollection.MainAbility'
      };
      let driver = Driver.create();
      delegator.startAbility(want, (err) => {
      })
      await driver.delayMs(1000);
      done();
    })
    // Dvider组件
    it(BUNDLE + 'Component_Dvider', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Dvider begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 展开一级标题，由于fa不支持资源本地化，所以只能写成汉文
      await driver.assertComponentExist(ON.text('空白与分隔'));
      let firsLevelTitle = await driver.findComponent(ON.text('空白与分隔'));
      await firsLevelTitle.click();
      await driver.delayMs(1000);
      // 点击进入Dvider页面，由于fa不支持资源本地化，所以只能写成汉文
      await driver.assertComponentExist(ON.text('Divider 分隔组件'));
      let divider = await driver.findComponent(ON.text('Divider 分隔组件'));
      await divider.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('dividerWidthSlider'));
      let slider = await driver.findComponent(ON.id('dividerWidthSlider'));
      // 获取宽度大小
      let widthSize = await slider.getText();
      // 获取slider组件的中心点信息
      let point = await slider.getBoundsCenter();
      await driver.drag(point.x, point.y, point.x - 200, point.y);
      // 校验是否滑动，并且更改值
      if (widthSize === await slider.getText()) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} slider failed`);
        expect().assertFail();
      }
      // 点击选取颜色
      await driver.assertComponentExist(ON.id('colorSelect'));
      let colorSelectComp = await driver.findComponent(ON.id('colorSelect'));
      await colorSelectComp.click();
      await driver.assertComponentExist(ON.text('Green'));
      let greenColor = await driver.findComponent(ON.text('Green'));
      await greenColor.click();
      // 点击选取样式
      await driver.assertComponentExist(ON.id('capStyleSelect'));
      let capStyleSelectComp = await driver.findComponent(ON.id('capStyleSelect'));
      await capStyleSelectComp.click();
      await driver.assertComponentExist(ON.text('Round'));
      let roundStyle = await driver.findComponent(ON.text('Round'));
      await roundStyle.click();
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      // 折叠一级标题
      let firsLevel = await driver.findComponent(ON.text('空白与分隔'));
      await firsLevel.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Dvider end`);
    })
    // Button组件
    it(BUNDLE + 'Component_Button', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Button begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 展开一级标题，由于fa不支持资源本地化，所以只能写成汉文，下面汉文原因同上
      await driver.assertComponentExist(ON.text('按钮与选择'));
      let firsLevelTitle = await driver.findComponent(ON.text('按钮与选择'));
      await firsLevelTitle.click();
      await driver.delayMs(1000);
      // 点击进入Button页面
      await driver.assertComponentExist(ON.text('Button 按钮组件'));
      let divider = await driver.findComponent(ON.text('Button 按钮组件'));
      await divider.click();
      await driver.delayMs(1000);
      // 点击Button中capsule类型的按钮
      await driver.assertComponentExist(ON.id('buttonType'));
      let capsule = await driver.findComponent(ON.id('buttonType'));
      await capsule.click();
      await driver.assertComponentExist('capsulebutton click');
      await driver.delayMs(1000);
      // 点击Button status resule
      await driver.assertComponentExist(ON.id('buttonStatus'));
      let clickStatus = await driver.findComponent(ON.id('buttonStatus'));
      await clickStatus.click();
      await driver.assertComponentExist('胶囊按钮被点击了');
      await driver.delayMs(1000);
      // 点击customStyle按钮
      await driver.assertComponentExist(ON.id('customButtonComp'));
      let rectStyle = await driver.findComponent(ON.id('customButtonComp'));
      await rectStyle.click();
      await driver.assertComponentExist('有按下效果被点击了');
      await driver.delayMs(1000);
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Button end`);
    })
    // DatePicker组件
    it(BUNDLE + 'Component_DatePicker', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_DatePicker begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击进入DatePicker页面
      await driver.assertComponentExist(ON.text('DatePicker 时间选择器'));
      let datePickerTitle = await driver.findComponent(ON.text('DatePicker 时间选择器'));
      await datePickerTitle.click();
      await driver.delayMs(1000);
      // 滑动时间选择器
      await driver.assertComponentExist(ON.id('contentBox'));
      let contentBox = await driver.findComponent(ON.id('contentBox'));
      let point = await contentBox.getBoundsCenter();
      await driver.assertComponentExist(ON.id('datePicker'));
      let datePicker = await driver.findComponent(ON.id('datePicker'));
      await driver.swipe(point.x - 20, point.y + 20, point.x - 20, point.y - 20);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('dateValue'));
      let dateValue = await driver.findComponent(ON.id('dateValue'));
      if (await dateValue.getText() === '2022-10-22') {
        hilog.info(DOMAIN, TAG, `${BUNDLE}Component_DatePicker swipe failed`);
        expect().assertFail();
      }
      // 切换农历
      await datePicker.click();
      await driver.swipe(point.x, point.y + 20, point.x, point.y - 20);
      await driver.delayMs(1000);
      if (await dateValue.getText() === '2022-11-22') {
        hilog.info(DOMAIN, TAG, `${BUNDLE}Component_DatePicker swipe failed`);
        expect().assertFail();
      }
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_DatePicker end`);
    })
    // Radio组件
    it(BUNDLE + 'Component_Radio', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Radio begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击进入Radio页面
      await driver.assertComponentExist(ON.text('Radio 单选按钮'));
      let datePickerTitle = await driver.findComponent(ON.text('Radio 单选按钮'));
      await datePickerTitle.click();
      await driver.delayMs(1000);
      // 点击非热区城市
      await driver.assertComponentExist(ON.id('nonHotZone1'));
      let nonHotZoneCirty = await driver.findComponent(ON.id('nonHotZone1'));
      await nonHotZoneCirty.click();
      await driver.assertComponentExist(ON.text('上海'));
      // 点击热区城市
      await driver.assertComponentExist(ON.type('input'));
      let cirtyInputs = await driver.findComponents(ON.type('input'));
      await cirtyInputs[5].click();
      await driver.assertComponentExist(ON.text('上海'));
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Radio end`);
    })
    // Select组件
    it(BUNDLE + 'Component_Select', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Select begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // Select
      await driver.assertComponentExist(ON.text('Select 选择组件'));
      let selectTitle = await driver.findComponent(ON.text('Select 选择组件'));
      await selectTitle.click();
      await driver.delayMs(1000);
      // 选择image
      await driver.assertComponentExist(ON.id('imageSelectComp'));
      let imageSelectComp = await driver.findComponent(ON.id('imageSelectComp'));
      await imageSelectComp.click();
      await driver.assertComponentExist(ON.text('图片'));
      let imageValue = await driver.findComponent(ON.text('图片'));
      await imageValue.click();
      await driver.assertComponentExist(ON.text('图片'));
      // 选择上海
      await driver.assertComponentExist(ON.id('cirtySelectComp'));
      let cirtySelectComp = await driver.findComponent(ON.id('cirtySelectComp'));
      await cirtySelectComp.click();
      await driver.assertComponentExist(ON.text('上海'));
      let shangHai = await driver.findComponent(ON.text('上海'));
      await shangHai.click();
      await driver.assertComponentExist(ON.text('上海'));
      // 选择上海
      await driver.assertComponentExist(ON.id('cirtySelectCompTwo'));
      let cirtySelectCompTwo = await driver.findComponent(ON.id('cirtySelectCompTwo'));
      await cirtySelectCompTwo.click();
      await driver.assertComponentExist(ON.text('深圳'));
      let shenZhen = await driver.findComponent(ON.text('深圳'));
      await shenZhen.click();
      await driver.assertComponentExist(ON.text('深圳'));
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Select end`);
    })
    // Slider组件
    it(BUNDLE + 'Component_Slider', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Slider begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入Slider页面
      await driver.assertComponentExist(ON.text('Slider 滑动条组件'));
      let selectTitle = await driver.findComponent(ON.text('Slider 滑动条组件'));
      await selectTitle.click();
      await driver.delayMs(1000);
      // 普通slider
      await driver.assertComponentExist(ON.id('normalSlider'));
      let normalSlider = await driver.findComponent(ON.id('normalSlider'));
      let normalSliderPoint = await normalSlider.getBoundsCenter();
      let normalSliderText = await normalSlider.getText();
      await driver.swipe(normalSliderPoint.x - 20, normalSliderPoint.y, normalSliderPoint.x + 60, normalSliderPoint.y);
      if (normalSliderText === await normalSlider.getText()) {
        hilog.info(DOMAIN, TAG, `${BUNDLE}normalSlider failed`);
        expect().assertFail();
      }
      // 事件slider
      await driver.assertComponentExist(ON.id('eventsSlider'));
      let eventsSlider = await driver.findComponent(ON.id('eventsSlider'));
      let eventsSliderPoint = await eventsSlider.getBoundsCenter();
      await driver.swipe(eventsSliderPoint.x - 20, eventsSliderPoint.y, eventsSliderPoint.x + 60, eventsSliderPoint.y);
      // 步数slider
      await driver.assertComponentExist(ON.id('stepSlider'));
      let stepSlider = await driver.findComponent(ON.id('stepSlider'));
      let stepSliderPoint = await stepSlider.getBoundsCenter();
      await driver.swipe(stepSliderPoint.x - 20, stepSliderPoint.y, stepSliderPoint.x + 60, stepSliderPoint.y);
      // 自定义slider
      await driver.assertComponentExist(ON.id('customSlider'));
      let customSlider = await driver.findComponent(ON.id('customSlider'));
      let customSliderPoint = await customSlider.getBoundsCenter();
      await driver.swipe(customSliderPoint.x - 20, customSliderPoint.y, customSliderPoint.x + 60, customSliderPoint.y);
      await driver.delayMs(1000);
      // slide颜色
      await driver.assertComponentExist(ON.id('slideColor'));
      let slideColor = await driver.findComponent(ON.id('slideColor'));
      await slideColor.click();
      await driver.assertComponentExist(ON.text('Green'));
      let greenColor = await driver.findComponent(ON.text('Green'));
      await greenColor.click();
      await driver.assertComponentExist(ON.text('Green'));
      // 滑动覆盖的slide颜色
      await driver.assertComponentExist(ON.id('slidedColor'));
      let slidedColor = await driver.findComponent(ON.id('slidedColor'));
      await slidedColor.click();
      await driver.assertComponentExist(ON.text('Pink'));
      let pinkColor = await driver.findComponent(ON.text('Pink'));
      await pinkColor.click();
      await driver.assertComponentExist(ON.text('Pink'));
      // 没有滑动覆盖的slide颜色
      await driver.assertComponentExist(ON.id('nonSlideColor'));
      let nonSlideColor = await driver.findComponent(ON.id('nonSlideColor'));
      await nonSlideColor.click();
      await driver.assertComponentExist(ON.text('Orange'));
      let orangeColor = await driver.findComponent(ON.text('Orange'));
      await orangeColor.click();
      await driver.assertComponentExist(ON.text('Orange'));
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Slider end`);
    })
    // Switch组件
    it(BUNDLE + 'Component_Switch', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Switch begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入Switch页面
      await driver.assertComponentExist(ON.text('Switch 切换组件'));
      let selectTitle = await driver.findComponent(ON.text('Switch 切换组件'));
      await selectTitle.click();
      await driver.delayMs(1000);
      // 点击switch开关
      await driver.assertComponentExist(ON.id('switchComp'));
      let switchComp = await driver.findComponent(ON.id('switchComp'));
      let switchText = await switchComp.getText();
      await switchComp.click();
      await driver.delayMs(1000);
      if (await switchComp.getText() === switchText) {
        hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Switch failed`);
        expect().assertFail();
      }
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      // 折叠一级标题
      let firstLevel = await driver.findComponent(ON.text('按钮与选择'));
      await firstLevel.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Switch end`);
    })
    // QRCode组件
    it(BUNDLE + 'Component_QRCode', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_QRCode begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 展开一级标题
      await driver.assertComponentExist(ON.text('信息展示与动效'));
      let firstLevelTitle = await driver.findComponent(ON.text('信息展示与动效'));
      await firstLevelTitle.click();
      await driver.delayMs(1000);
      // 进入二维码页面
      await driver.assertComponentExist(ON.text('QRCode 二维码组件'));
      let qrCodeTitle = await driver.findComponent(ON.text('QRCode 二维码组件'));
      await qrCodeTitle.click();
      await driver.delayMs(1000);
      // 输入内容
      await driver.assertComponentExist(ON.id('inputComp'));
      let inputComp = await driver.findComponent(ON.id('inputComp'));
      await inputComp.inputText('hello');
      let inputText = await inputComp.getText();
      if (inputText !== 'hello') {
        hilog.info(DOMAIN, TAG, `${BUNDLE} input content failed`);
        expect().assertFail();
      }
      // 设置二维码颜色
      await driver.assertComponentExist(ON.id('qrcodeColor'));
      let qrcodeColor = await driver.findComponent(ON.id('qrcodeColor'));
      await qrcodeColor.click();
      await driver.assertComponentExist(ON.text('Orange'));
      let orangeColor = await driver.findComponent(ON.text('Orange'));
      await orangeColor.click();
      await driver.assertComponentExist(ON.text('Orange'));
      // 设置二维码形状
      await driver.assertComponentExist(ON.id('qrcodeShape'));
      let qrcodeShape = await driver.findComponent(ON.id('qrcodeShape'));
      await qrcodeShape.click();
      await driver.assertComponentExist(ON.text('Circle'));
      let circle = await driver.findComponent(ON.text('Circle'));
      await circle.click();
      await driver.assertComponentExist(ON.text('Circle'));
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      // 折叠一级标题
      let firstLevel = await driver.findComponent(ON.text('信息展示与动效'));
      await firstLevel.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_QRCode end`);
    })
    // Span组件
    it(BUNDLE + 'Component_Span', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Span begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 展开一级标题
      await driver.assertComponentExist(ON.text('文本与输入'));
      let firstLevelTitle = await driver.findComponent(ON.text('文本与输入'));
      await firstLevelTitle.click();
      await driver.delayMs(1000);
      // 进入Span页面
      await driver.assertComponentExist(ON.text('Span 行内文本组件'));
      let spanTitle = await driver.findComponent(ON.text('Span 行内文本组件'));
      await spanTitle.click();
      await driver.delayMs(1000);
      // 装饰线位置
      await driver.assertComponentExist(ON.id('decorativeStyle'));
      let decorativeStyle = await driver.findComponent(ON.id('decorativeStyle'));
      await decorativeStyle.click();
      await driver.assertComponentExist(ON.text('underline'));
      let underLine = await driver.findComponent(ON.text('underline'));
      await underLine.click();
      await driver.assertComponentExist(ON.text('underline'));
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Span end`);
    })
    // Input组件
    it(BUNDLE + 'Component_Input', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Input begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入输入框页面
      await driver.assertComponentExist(ON.text('Input 文本输入组件'));
      let inputTitle = await driver.findComponent(ON.text('Input 文本输入组件'));
      await inputTitle.click();
      await driver.delayMs(1000);
      // 基本输入框
      await driver.assertComponentExist(ON.id('inputType'));
      let inputType = await driver.findComponent(ON.id('inputType'));
      await inputType.inputText('123');
      let inputTypeText = await inputType.getText();
      if (inputTypeText !== '123') {
        expect().assertFail();
      }
      // 选择文本内容的类型
      await driver.assertComponentExist(ON.id('currentInputType'));
      let currentInputType = await driver.findComponent(ON.id('currentInputType'));
      await currentInputType.click();
      await driver.assertComponentExist(ON.text('Password'));
      let password = await driver.findComponent(ON.text('Password'));
      await password.click();
      await driver.assertComponentExist(ON.text('Password'));
      // 事件输入框
      await driver.assertComponentExist(ON.id('inputEvents'));
      let inputEvents = await driver.findComponent(ON.id('inputEvents'));
      await inputEvents.inputText('123');
      let inputEventsText = await inputEvents.getText();
      if (inputEventsText !== '123') {
        expect().assertFail();
      }
      // 多行文本输入
      await driver.assertComponentExist(ON.id('inputArea'));
      let inputArea = await driver.findComponent(ON.id('inputArea'));
      await inputArea.inputText('123');
      let inputAreaText = await inputArea.getText();
      if (inputAreaText !== '123') {
        expect().assertFail();
      }
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Input end`);
    })
    // Text组件
    it(BUNDLE + 'Component_Text', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Text begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入输入框页面
      await driver.assertComponentExist(ON.text('Text 文本组件'));
      let textTitle = await driver.findComponent(ON.text('Text 文本组件'));
      await textTitle.click();
      await driver.delayMs(1000);
      // 通过Slider更改letterSpace
      await driver.assertComponentExist(ON.id('letterSpaceSlider'));
      let letterSpaceSlider = await driver.findComponent(ON.id('letterSpaceSlider'));
      let point = await letterSpaceSlider.getBoundsCenter();
      let letterSpaceSliderText = await letterSpaceSlider.getText();
      await driver.swipe(point.x, point.y, point.x + 20, point.y);
      if (letterSpaceSliderText === await letterSpaceSlider.getText()) {
        expect().assertFail();
      }
      // 通过Slider更改lineHeight
      await driver.assertComponentExist(ON.id('lineHeightSlider'));
      let lineHeightSlider = await driver.findComponent(ON.id('lineHeightSlider'));
      let centerPoint = await lineHeightSlider.getBoundsCenter();
      let lineHeightSliderText = await lineHeightSlider.getText();
      await driver.swipe(centerPoint.x, centerPoint.y, centerPoint.x + 20, centerPoint.y);
      if (lineHeightSliderText === await lineHeightSlider.getText()) {
        expect().assertFail();
      }
      // 选择排版位置
      await driver.assertComponentExist(ON.id('alignmentTypeSelect'));
      let alignmentTypeSelect = await driver.findComponent(ON.id('alignmentTypeSelect'));
      await alignmentTypeSelect.click();
      await driver.assertComponentExist(ON.text('居中'));
      let center = await driver.findComponent(ON.text('居中'));
      await center.click();
      await driver.assertComponentExist(ON.text('居中'));
      // 选择多余行隐藏模式
      await driver.assertComponentExist(ON.id('displayModeSelect'));
      let displayModeSelect = await driver.findComponent(ON.id('displayModeSelect'));
      await displayModeSelect.click();
      await driver.assertComponentExist(ON.text('剪裁'));
      let clip = await driver.findComponent(ON.text('剪裁'));
      await clip.click();
      await driver.assertComponentExist(ON.text('剪裁'));
      // 选择下划线位置
      await driver.assertComponentExist(ON.id('decorativeThreadSelect'));
      let decorativeThreadSelect = await driver.findComponent(ON.id('decorativeThreadSelect'));
      await decorativeThreadSelect.click();
      await driver.assertComponentExist(ON.text('下划线'));
      let underLine = await driver.findComponent(ON.text('下划线'));
      await underLine.click();
      await driver.assertComponentExist(ON.text('下划线'));
      // 选择文本颜色
      await driver.assertComponentExist(ON.id('fontColorSelect'));
      let fontColorSelect = await driver.findComponent(ON.id('fontColorSelect'));
      await fontColorSelect.click();
      await driver.assertComponentExist(ON.text('Green'));
      let greenColor = await driver.findComponent(ON.text('Green'));
      await greenColor.click();
      await driver.assertComponentExist(ON.text('Green'));
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      // 折叠一级标题
      await driver.assertComponentExist(ON.text('文本与输入'));
      let firstLevelTitle = await driver.findComponent(ON.text('文本与输入'));
      await firstLevelTitle.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Text end`);
    })
    // Badge组件
    it(BUNDLE + 'Component_Badge', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Badge begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 展开一级标题
      await driver.assertComponentExist(ON.text('辅助'));
      let firstLevelTitle = await driver.findComponent(ON.text('辅助'));
      await firstLevelTitle.click();
      await driver.delayMs(1000);
      // 进入Badge页面
      await driver.assertComponentExist(ON.text('Badge 标记组件'));
      let badgeTitle = await driver.findComponent(ON.text('Badge 标记组件'));
      await badgeTitle.click();
      await driver.delayMs(1000);
      // 校验是否进入Badge页面
      await driver.assertComponentExist(ON.id('baseBadge'));
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      // 折叠一级标题
      let firstLevel = await driver.findComponent(ON.text('辅助'));
      await firstLevel.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, `${BUNDLE}Component_Badge end`);
    })
    // 切换到universal
    it(BUNDLE + 'SwitchUniversal', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}SwitchUniversal begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 切换Universal页面
      await driver.assertComponentExist(ON.id('tabBar1'));
      let universal = await driver.findComponent(ON.id('tabBar1'));
      await universal.click();
      await driver.delayMs(1000);
      // 校验是否进入Universal页面
      await driver.assertComponentExist(ON.text('通用事件'));
      hilog.info(DOMAIN, TAG, `${BUNDLE}SwitchUniversal end`);
    })
    // Click Evnet
    it(BUNDLE + 'Universal_ClickEvent', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Universal_ClickEvent begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入点击事件页面
      await driver.assertComponentExist(ON.text('onClick 点击事件'));
      let clickEventTitle = await driver.findComponent(ON.text('onClick 点击事件'));
      await clickEventTitle.click();
      await driver.delayMs(1000);
      // 点击无响应
      await driver.assertComponentExist(ON.id('noEffervescence'));
      let noEffervescence = await driver.findComponent(ON.id('noEffervescence'));
      await noEffervescence.click();
      await driver.assertComponentExist(ON.id('noEffervescenceText'));
      let noEffervescenceText = await driver.findComponent(ON.id('noEffervescenceText'));
      if (!await noEffervescenceText.getText()) {
        expect().assertFail();
      }
      // 点击响应
      await driver.assertComponentExist(ON.id('effervescence'));
      let effervescence = await driver.findComponent(ON.id('effervescence'));
      await effervescence.click();
      await driver.assertComponentExist(ON.id('effervescenceText'));
      let effervescenceText = await driver.findComponent(ON.id('effervescenceText'));
      if (!await effervescenceText.getText()) {
        expect().assertFail();
      }
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Universal_ClickEvent end`);
    })
    // UniversalProperty, Background, Border, Font, Size
    it(BUNDLE + 'Universal_Property', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Universal_Property begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      let propertyArray = ['background 背景', 'border 边框', 'font 字体', 'size 尺寸'];
      let titleArray = ['Background 背景', 'Border 边框样式', 'Font 字体', 'Size 尺寸'];
      for (let i = 0;i < propertyArray.length; i++) {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text(propertyArray[i]));
        let title = await driver.findComponent(ON.text(propertyArray[i]));
        await title.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text(titleArray[i]));
        // 点击返回
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('backBtn'));
        let backBtn = await driver.findComponent(ON.id('backBtn'));
        await backBtn.click();
      }
      hilog.info(DOMAIN, TAG, `${BUNDLE}Universal_Property end`);
    })
    // Rotate
    it(BUNDLE + 'Universal_Property_Rotate', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Universal_Property_Rotate begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 展开一级标题
      await driver.assertComponentExist(ON.text('图形变换'));
      let firstLevelTitle = await driver.findComponent(ON.text('图形变换'));
      await firstLevelTitle.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('rotate 旋转'));
      let rotate = await driver.findComponent(ON.text('rotate 旋转'));
      await rotate.click();
      await driver.assertComponentExist(ON.text('旋转'));
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Universal_Property_Rotate end`);
    })
    // Translate
    it(BUNDLE + 'Universal_Property_Translate', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Universal_Property_Translate begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('translate 平移'));
      let translate = await driver.findComponent(ON.text('translate 平移'));
      await translate.click();
      let slideNameArray = ['imageAbscissa', 'imageOrdinate', 'contentAbscissa', 'contentOrdinate'];
      for (let i = 0;i < slideNameArray.length; i++) {
        await driver.assertComponentExist(ON.id(slideNameArray[i]));
        let slideComp = await driver.findComponent(ON.id(slideNameArray[i]));
        await driver.delayMs(1000);
        let slidePoint = await slideComp.getBoundsCenter();
        await driver.delayMs(1000);
        let slideValue = await slideComp.getText();
        await driver.swipe(slidePoint.x, slidePoint.y, slidePoint.x - 20, slidePoint.y);
        if (slideValue === await slideComp.getText()) {
          expect().assertFail();
        }
      }
      // 点击返回
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      await driver.assertComponentExist(ON.text('图形变换'));
      let firstLevelTitle = await driver.findComponent(ON.text('图形变换'));
      await firstLevelTitle.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Universal_Property_Translate end`);
    })
    // 切换到animation
    it(BUNDLE + 'SwitchAnimation', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}SwitchAnimation begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 切换Animation页面
      await driver.assertComponentExist(ON.id('tabBar2'));
      let animation = await driver.findComponent(ON.id('tabBar2'));
      await animation.click();
      await driver.delayMs(1000);
      // 校验是否进入Animation页面
      await driver.assertComponentExist(ON.text('转场动画'));
      hilog.info(DOMAIN, TAG, `${BUNDLE}SwitchAnimation end`);
    })
    // Page Transition
    it(BUNDLE + 'Page_Animation', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}Page_Animation begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 展开一级标题
      await driver.assertComponentExist(ON.text('转场动画'));
      let firstLevelTitle = await driver.findComponent(ON.text('转场动画'));
      await firstLevelTitle.click();
      // 进入Page Transition页面
      await driver.assertComponentExist(ON.text('pageTransition 页面转场'));
      let transition = await driver.findComponent(ON.text('pageTransition 页面转场'));
      await transition.click();
      await driver.delayMs(1000);
      // 进入各种动画效果页面
      for (let i = 0; i < 6; i++) {
        await driver.delayMs(5000);
        await driver.assertComponentExist(ON.id(`transition${i}`));
        let transition = await driver.findComponent(ON.id(`transition${i}`));
        await driver.delayMs(1000);
        await transition.click();
        await driver.delayMs(5000);
        // 返回首页
        await driver.assertComponentExist(ON.id(`backIndex`));
        let backIndex = await driver.findComponent(ON.id(`backIndex`));
        await driver.delayMs(5000);
        await backIndex.click();
      }
      // 点击返回
      await driver.delayMs(5000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      // 折叠一级标题
      let firstLevel = await driver.findComponent(ON.text('转场动画'));
      await firstLevel.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}Page_Animation end`);
    })
    // 切换到globalMethod
    it(BUNDLE + 'SwitchGlobalMethod', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}SwitchGlobalMethod begin`);
      let driver = Driver.create();
      await driver.delayMs(3000);
      // 切换globalMethod页面
      await driver.assertComponentExist(ON.id('tabBar3'));
      let animation = await driver.findComponent(ON.id('tabBar3'));
      await animation.click();
      await driver.delayMs(1000);
      // 校验是否进入globalMethod页面
      await driver.assertComponentExist(ON.text('弹窗'));
      hilog.info(DOMAIN, TAG, `${BUNDLE}SwitchGlobalMethod end`);
    })
    // Dialog
    it(BUNDLE + 'SwitchGlobalMethod', 0, async function () {
      hilog.info(DOMAIN, TAG, `${BUNDLE}SwitchGlobalMethod begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 展开一级标题
      await driver.assertComponentExist(ON.text('弹窗'));
      let firstLevelTitle = await driver.findComponent(ON.text('弹窗'));
      await firstLevelTitle.click();
      await driver.delayMs(1000);
      // 进入自定义弹窗页面
      await driver.assertComponentExist(ON.text('CustomDialog 自定义弹窗'));
      let customDialogTitle = await driver.findComponent(ON.text('CustomDialog 自定义弹窗'));
      await customDialogTitle.click();
      await driver.delayMs(1000);
      // 点击显示弹窗
      await driver.assertComponentExist(ON.id('dragDisAppear'));
      let dragDisAppear = await driver.findComponent(ON.id('dragDisAppear'));
      await dragDisAppear.click();
      await driver.delayMs(2000);
      // 关闭弹窗
      await driver.assertComponentExist(ON.id('content'));
      let dragDialogClosed = await driver.findComponent(ON.id('content'));
      await dragDialogClosed.click();
      await driver.delayMs(2000);
      // 点击显示弹窗
      await driver.assertComponentExist(ON.id('dragNotDisAppear'));
      let dragNotDisAppear = await driver.findComponent(ON.id('dragNotDisAppear'));
      await dragNotDisAppear.click();
      await driver.delayMs(2000);
      // 点击确定
      await driver.assertComponentExist(ON.id('content'));
      let dragClosed = await driver.findComponent(ON.id('content'));
      await dragClosed.click();
      // 点击返回
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.id('backBtn'));
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      hilog.info(DOMAIN, TAG, `${BUNDLE}SwitchGlobalMethod end`);
    })
  })
}