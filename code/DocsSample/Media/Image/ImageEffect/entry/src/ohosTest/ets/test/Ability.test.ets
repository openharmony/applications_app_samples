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

import hilog from '@ohos.hilog';
import { describe, it } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import { getString } from '../utils/ResourceUtil';

const TAG: string = '[Sample_ImageEffect]';
const DOMAIN: number = 0xF811;
const BUNDLE: string = 'ImageEffect';
const DELAY_LONG: number = 1000;
const DELAY_SHORT: number = 300;
const SLIDER_Y: number = 100; // 滑动组件向右滑动距离，单位像素点

async function openDialog() {
  hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSettingBtn_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_SHORT);
  let btSetting: string = getString($r('app.string.btn_setting'));
  hilog.info(DOMAIN, TAG, BUNDLE + 'lsq:' + btSetting);
  await driver.assertComponentExist(ON.id(btSetting));
  let setting = await driver.findComponent(ON.id(btSetting));
  await setting.click();
  await driver.delayMs(DELAY_SHORT);
  let confirm: string = getString($r('app.string.btn_dialog_confirm'));
  await driver.assertComponentExist(ON.id(confirm));
  hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSettingBtn_001 end');
}

async function confirmDialog() {
  hilog.info(DOMAIN, TAG, BUNDLE + 'ClickConfirmBtn_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_SHORT);
  let btnDialogConfirm: string = getString($r('app.string.btn_dialog_confirm'));
  await driver.assertComponentExist(ON.id(btnDialogConfirm));
  let dialogConfirm = await driver.findComponent(ON.id(btnDialogConfirm));
  await dialogConfirm.click();
  await driver.delayMs(DELAY_SHORT);
  hilog.info(DOMAIN, TAG, BUNDLE + 'ClickConfirmBtn_001 end');
}

async function apply() {
  hilog.info(DOMAIN, TAG, BUNDLE + 'ClickApplyBtn_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_SHORT);
  let btnApply: string = getString($r('app.string.btn_apply'));
  await driver.assertComponentExist(ON.id(btnApply));
  let apply = await driver.findComponent(ON.id(btnApply));
  await apply.click();
  await driver.delayMs(DELAY_SHORT);
  hilog.info(DOMAIN, TAG, BUNDLE + 'ClickApplyBtn_001 end');
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it('StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      await abilityDelegatorRegistry.executeShellCommand('aa start -a EntryAbility -b com.samples.ImageEffect');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * @tc.number RequestPermissionFunction_001
     * @tc.name RequestPermissionFunction_001
     * @tc.desc 获取权限
     */
    it('RequestPermissionFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_LONG);
      let tipAllow: string = getString($r('app.string.allow'));
      await driver.assertComponentExist(ON.text(tipAllow));
      let stack = await driver.findComponent(ON.text(tipAllow));
      await stack.click();
      await driver.assertComponentExist(ON.text(getString($r('app.string.Permission_Succeed'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })

    /**
     * @tc.number ClickDialogCancelBtn_001
     * @tc.name ClickDialogCancelBtn_001
     * @tc.desc 点击dialog取消按钮，关闭参数页面
     */
    it('ClickDialogCancelBtn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickDialogCancelBtn_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let btnCancel: string = getString($r('app.string.btn_dialog_cancel'));
      await driver.assertComponentExist(ON.id(btnCancel));
      let cancel = await driver.findComponent(ON.id(btnCancel));
      await cancel.click();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickDialogCancelBtn_001 end');
    })

    /**
     * @tc.number AdjustBrightness_001
     * @tc.name AdjustBrightness_001
     * @tc.desc Brightness滤镜
     */
    it('AdjustBrightness_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AdjustBrightness_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let checkboxBrightnessStr: string = getString($r('app.string.checkbox_brightness'));
      await driver.assertComponentExist(ON.id(checkboxBrightnessStr));
      let checkboxBrightness = await driver.findComponent(ON.id(checkboxBrightnessStr));
      await checkboxBrightness.click();
      await driver.delayMs(DELAY_SHORT);
      let sliderBrightnessStr: string = getString($r('app.string.slider_brightness'));
      await driver.assertComponentExist(ON.id(sliderBrightnessStr));
      let sliderBrightness = await driver.findComponent(ON.id(sliderBrightnessStr));
      let point = await sliderBrightness.getBoundsCenter();
      await driver.swipe(point.x, point.y, point.x + SLIDER_Y, point.y);
      await driver.delayMs(DELAY_SHORT);
      await confirmDialog();
      await apply();
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.PixelMapNative_Succeed'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'AdjustBrightness_001 end');
    })

    /**
     * @tc.number AdjustContrast_001
     * @tc.name AdjustContrast_001
     * @tc.desc Contrast滤镜
     */
    it('AdjustContrast_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AdjustContrast_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let checkboxContrastStr: string = getString($r('app.string.checkbox_contrast'));
      await driver.assertComponentExist(ON.id(checkboxContrastStr));
      let checkboxContrast = await driver.findComponent(ON.id(checkboxContrastStr));
      await checkboxContrast.click();
      await driver.delayMs(DELAY_SHORT);
      let sliderContrastStr: string = getString($r('app.string.slider_contrast'));
      await driver.assertComponentExist(ON.id(sliderContrastStr));
      let sliderContrast = await driver.findComponent(ON.id(sliderContrastStr));
      let point = await sliderContrast.getBoundsCenter();
      await driver.swipe(point.x, point.y, point.x + SLIDER_Y, point.y);
      await driver.delayMs(DELAY_SHORT);
      await confirmDialog();
      await apply();
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.PixelMapNative_Succeed'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'AdjustContrast_001 end');
    })

    /**
     * @tc.number AdjustCrop_001
     * @tc.name AdjustCrop_001
     * @tc.desc Crop滤镜
     */
    it('AdjustCrop_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AdjustCrop_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let checkboxCropStr: string = getString($r('app.string.checkbox_crop'));
      await driver.assertComponentExist(ON.id(checkboxCropStr));
      let checkboxCrop = await driver.findComponent(ON.id(checkboxCropStr));
      await checkboxCrop.click();
      await driver.delayMs(DELAY_SHORT);
      let sliderCropStr: string = getString($r('app.string.slider_crop'));
      await driver.assertComponentExist(ON.id(sliderCropStr));
      let sliderCrop = await driver.findComponent(ON.id(sliderCropStr));
      let point = await sliderCrop.getBoundsCenter();
      await driver.swipe(point.x, point.y, point.x + SLIDER_Y, point.y);
      await driver.delayMs(DELAY_SHORT);
      await confirmDialog();
      await apply();
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.PixelMapNative_Succeed'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'AdjustCrop_001 end');
    })

    /**
     * @tc.number AdjustCustomBrightness_001
     * @tc.name AdjustCustomBrightness_001
     * @tc.desc CustomBrightness滤镜
     */
    it('AdjustCustomBrightness_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AdjustCustomBrightness_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let checkboxCustomStr: string = getString($r('app.string.checkbox_custom_brightness'));
      await driver.assertComponentExist(ON.id(checkboxCustomStr));
      let checkboxCustom = await driver.findComponent(ON.id(checkboxCustomStr));
      await checkboxCustom.click();
      await driver.delayMs(DELAY_SHORT);
      let sliderCustomStr: string = getString($r('app.string.slider_custom_brightness'));
      await driver.assertComponentExist(ON.id(sliderCustomStr));
      let sliderCustom = await driver.findComponent(ON.id(sliderCustomStr));
      let point = await sliderCustom.getBoundsCenter();
      await driver.swipe(point.x, point.y, point.x + SLIDER_Y, point.y);
      await driver.delayMs(DELAY_SHORT);
      await confirmDialog();
      await apply();
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.PixelMapNative_Succeed'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'AdjustCustomBrightness_001 end');
    })

    /**
     * @tc.number AdjustCustomCrop_001
     * @tc.name AdjustCustomCrop_001
     * @tc.desc CustomCrop滤镜
     */
    it('AdjustCustomCrop_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AdjustCustomCrop_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let checkboxCustomStr: string = getString($r('app.string.checkbox_custom_crop'));
      await driver.assertComponentExist(ON.id(checkboxCustomStr));
      let checkboxCustom = await driver.findComponent(ON.id(checkboxCustomStr));
      await checkboxCustom.click();
      await driver.delayMs(DELAY_SHORT);
      let sliderCustomStr: string = getString($r('app.string.slider_custom_crop'));
      await driver.assertComponentExist(ON.id(sliderCustomStr));
      let sliderCustom = await driver.findComponent(ON.id(sliderCustomStr));
      let point = await sliderCustom.getBoundsCenter();
      await driver.swipe(point.x, point.y, point.x + SLIDER_Y, point.y);
      await driver.delayMs(DELAY_SHORT);
      await confirmDialog();
      await apply();
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.PixelMapNative_Succeed'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'AdjustCustomCrop_001 end');
    })

    /**
     * @tc.number ClickResetBtn_001
     * @tc.name ClickResetBtn_001
     * @tc.desc 点击Reset按钮，图像效果复原
     */
    it('ClickResetBtn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResetBtn_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      let btnReset: string = getString($r('app.string.btn_reset'));
      await driver.assertComponentExist(ON.id(btnReset));
      let reset = await driver.findComponent(ON.id(btnReset));
      await reset.click();
      await driver.delayMs(DELAY_SHORT);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickResetBtn_001 end');
    })

    /**
     * @tc.number ClickBrightnessSearchBtn_001
     * @tc.name ClickBrightnessSearchBtn_001
     * @tc.desc Brightness查询按钮，显示Brightness滤镜信息
     */
    it('ClickBrightnessSearchBtn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBrightnessSearchBtn_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let btnBrightnessSearch: string = getString($r('app.string.btn_search_brightness'));
      await driver.assertComponentExist(ON.id(btnBrightnessSearch));
      let brightnessSearch = await driver.findComponent(ON.id(btnBrightnessSearch));
      await brightnessSearch.click();
      await driver.delayMs(DELAY_SHORT);
      let filterInfoStr: string = getString($r('app.string.filter_info_menu'));
      await driver.assertComponentExist(ON.id(filterInfoStr));
      await driver.findComponent(ON.id(filterInfoStr));
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.query_brightness'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBrightnessSearchBtn_001 end');
    })

    /**
     * @tc.number ClickContrastSearchBtn_001
     * @tc.name ClickContrastSearchBtn_001
     * @tc.desc Contrast查询按钮，显示Contrast滤镜信息
     */
    it('ClickContrastSearchBtn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickContrastSearchBtn_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let btnContrastSearch: string = getString($r('app.string.btn_search_contrast'));
      await driver.assertComponentExist(ON.id(btnContrastSearch));
      let contrastSearch = await driver.findComponent(ON.id(btnContrastSearch));
      await contrastSearch.click();
      await driver.delayMs(DELAY_SHORT);
      let filterInfoStr: string = getString($r('app.string.filter_info_menu'));
      await driver.assertComponentExist(ON.id(filterInfoStr));
      await driver.findComponent(ON.id(filterInfoStr));
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.query_contrast'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickContrastSearchBtn_001 end');
    })

    /**
     * @tc.number ClickCropSearchBtn_001
     * @tc.name ClickCropSearchBtn_001
     * @tc.desc Crop查询按钮，显示Crop滤镜信息
     */
    it('ClickCropSearchBtn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCropSearchBtn_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let btnCropSearch: string = getString($r('app.string.btn_search_crop'));
      await driver.assertComponentExist(ON.id(btnCropSearch));
      let cropSearch = await driver.findComponent(ON.id(btnCropSearch));
      await cropSearch.click();
      await driver.delayMs(DELAY_SHORT);
      let filterInfoStr: string = getString($r('app.string.filter_info_menu'));
      await driver.assertComponentExist(ON.id(filterInfoStr));
      await driver.findComponent(ON.id(filterInfoStr));
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.query_crop'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCropSearchBtn_001 end');
    })

    /**
     * @tc.number ClickCustomBrightnessSearchBtn_001
     * @tc.name ClickCustomBrightnessSearchBtn_001
     * @tc.desc CustomBrightness查询按钮，显示CustomBrightness滤镜信息
     */
    it('ClickCustomBrightnessSearchBtn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCustomBrightnessSearchBtn_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let btnCustomSearch: string = getString($r('app.string.btn_search_custom_brightness'));
      await driver.assertComponentExist(ON.id(btnCustomSearch));
      let customSearch = await driver.findComponent(ON.id(btnCustomSearch));
      await customSearch.click();
      await driver.delayMs(DELAY_SHORT);
      let filterInfoStr: string = getString($r('app.string.filter_info_menu'));
      await driver.assertComponentExist(ON.id(filterInfoStr));
      await driver.findComponent(ON.id(filterInfoStr));
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.query_custom_brightness'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCustomBrightnessSearchBtn_001 end');
    })

    /**
     * @tc.number ClickCustomCropSearchBtn_001
     * @tc.name ClickCustomCropSearchBtn_001
     * @tc.desc CustomCrop查询按钮，显示CustomBrightness滤镜信息
     */
    it('ClickCustomCropSearchBtn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCustomCropSearchBtn_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let btnCustomSearch: string = getString($r('app.string.btn_search_custom_crop'));
      await driver.assertComponentExist(ON.id(btnCustomSearch));
      let customSearch = await driver.findComponent(ON.id(btnCustomSearch));
      await customSearch.click();
      await driver.delayMs(DELAY_SHORT);
      let filterInfoStr: string = getString($r('app.string.filter_info_menu'));
      await driver.assertComponentExist(ON.id(filterInfoStr));
      await driver.findComponent(ON.id(filterInfoStr));
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.query_custom_crop'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCustomCropSearchBtn_001 end');
    })

    /**
     * @tc.number ClickSearchBtn_001
     * @tc.name ClickSearchBtn_001
     * @tc.desc 点击查询按钮，显示滤镜滤镜信息
     */
    it('ClickSearchBtn_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchBtn_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      let btnSearch: string = getString($r('app.string.btn_search'));
      await driver.assertComponentExist(ON.id(btnSearch));
      let search = await driver.findComponent(ON.id(btnSearch));
      await search.click();
      await driver.delayMs(DELAY_SHORT);
      let menuCategory: string = getString($r('app.string.menu_category'));
      await driver.assertComponentExist(ON.id(menuCategory));
      let category = await driver.findComponent(ON.id(menuCategory));
      await category.click();
      await driver.delayMs(DELAY_SHORT);
      let menuFormat: string = getString($r('app.string.menu_format'));
      await driver.assertComponentExist(ON.id(menuFormat));
      let format = await driver.findComponent(ON.id(menuFormat));
      await format.click();
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.query_rgba_8888'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchBtn_001 end');
    })

    /**
     * @tc.number NativeBuffer_001
     * @tc.name NativeBuffer_001
     * @tc.desc 切换输入场景为NativeBuffer，应用滤镜
     */
    it('NativeBuffer_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NativeBuffer_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      await driver.assertComponentExist(ON.id('select_input'));
      let select = await driver.findComponent(ON.id('select_input'));
      await select.click();
      await driver.delayMs(DELAY_SHORT);
      let selectNativeBufferStr: string = getString($r('app.string.NativeBuffer'));
      await driver.assertComponentExist(ON.text(selectNativeBufferStr));
      let selectNativeBuffer = await driver.findComponent(ON.text(selectNativeBufferStr));
      await selectNativeBuffer.click();
      await confirmDialog();
      await apply();
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.NativeBuffer_Succeed'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'NativeBuffer_001 end');
    })

    /**
     * @tc.number URI_001
     * @tc.name URI_001
     * @tc.desc 切换输入场景为URI，应用滤镜
     */
    it('URI_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'URI_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      await driver.assertComponentExist(ON.id('select_input'));
      let select = await driver.findComponent(ON.id('select_input'));
      await select.click();
      await driver.delayMs(DELAY_SHORT);
      let selectURIStr: string = getString($r('app.string.URI'));
      await driver.assertComponentExist(ON.text(selectURIStr));
      let selectURI = await driver.findComponent(ON.text(selectURIStr));
      await selectURI.click();
      await confirmDialog();
      await apply();
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.URI_Succeed'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'URI_001 end');
    })

    /**
     * @tc.number NativeWindow_001
     * @tc.name NativeWindow_001
     * @tc.desc 切换输入场景为NativeWindow，应用滤镜
     */
    it('NativeWindow_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NativeWindow begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_SHORT);
      await openDialog();
      await driver.assertComponentExist(ON.id('select_input'));
      let select = await driver.findComponent(ON.id('select_input'));
      await select.click();
      await driver.delayMs(DELAY_SHORT);
      let selectNativeWindowStr: string = getString($r('app.string.NativeWindow'));
      await driver.assertComponentExist(ON.text(selectNativeWindowStr));
      let selectNativeWindow = await driver.findComponent(ON.text(selectNativeWindowStr));
      await selectNativeWindow.click();
      await confirmDialog();
      await apply();
      await driver.delayMs(DELAY_LONG);
      await driver.assertComponentExist(ON.text(getString($r('app.string.NativeWindow_Succeed'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'NativeWindow end');
    })
  })
}