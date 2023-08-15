/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON} from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_Picker]';
const DOMAIN = 0xF811;
const BUNDLE = 'JSPicker_';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('abilityTest', function () {
    it('StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: "com.samples.picker",
          abilityName: "EntryAbility"
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
    })

    /**
     * Picker 赋权限
     */
    // 点击允许
    it('RequestPermissionFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(2000);
      let permit = await getResourceString($r('app.string.permit'));
      await driver.assertComponentExist(ON.text(permit));
      let permit1 = await driver.findComponent(ON.text(permit));
      await permit1.click();
      await driver.delayMs(200);
      let permit2 = await driver.findComponent(ON.text(permit));
      await permit2.click();
      await driver.delayMs(200);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })

    /**
     * Picker 增加文件、文件夹
     */
    // 点击增加文件、文件夹图标
    it('NewFileFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NewFileFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id('newFile'));
      let newFile = await driver.findComponent(ON.id('newFile'));
      await newFile.click();
      await driver.delayMs(3000);
      // 系统 picker 拉起的页面无法通过自定义id找到组件，因此采用坐标
      await driver.click(570, 116); // 新建文件夹
      await driver.delayMs(1000);
      let newDir = await getResourceString($r('app.string.new_dir'));
      let confirm = await getResourceString($r('app.string.label_confirm'));
      await driver.assertComponentExist(ON.text(newDir));
      await driver.assertComponentExist(ON.text(confirm));
      await driver.delayMs(2000);
      // 使用text找到组件后点击不生效，因此采用坐标
      await driver.click(511, 1040); // 新建文件夹-点击确定图标
      await driver.delayMs(2000);
      await driver.click(655, 110); //新建文件并保存-点击保存图标
      await driver.delayMs(500);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'NewFileFunction_001 end');
    })

    /**
     * Picker 编辑文件
     */
    // 编辑文件并保存
    it('EditFileFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFileFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(200);
      // 系统 picker 拉起的页面无法通过自定义id找到组件，因此采用坐标
      await driver.click(470, 210);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('editable'));
      let editable = await driver.findComponent(ON.id('editable'));
      await editable.click();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id('textArea'));
      let textArea = await driver.findComponent(ON.id('textArea'));
      await textArea.inputText('File Content');
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('save'));
      let save = await driver.findComponent(ON.id('save'));
      await save.click();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id('backIndex'));
      let backIndex = await driver.findComponent(ON.id('backIndex'));
      await backIndex.click();
      await driver.delayMs(200);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFileFunction_001 end');
    })

    /**
     * Picker 另存为
     */
    // 点击文件另存为
    it('SaveAsFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SaveAsFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(200);
      // 系统 picker 拉起的页面无法通过自定义id找到组件，因此采用坐标
      await driver.click(470, 210);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('saveAs'));
      let editable = await driver.findComponent(ON.id('saveAs'));
      await editable.click();
      await driver.delayMs(2000);
      // 系统 picker 拉起的页面无法通过自定义id找到组件，因此采用坐标
      await driver.click(570, 116); // 新建文件夹
      await driver.delayMs(1000);
      let newDir = await getResourceString($r('app.string.new_dir'));
      let confirm = await getResourceString($r('app.string.label_confirm'));
      await driver.assertComponentExist(ON.text(newDir));
      await driver.assertComponentExist(ON.text(confirm));
      await driver.delayMs(2000);
      // 使用text找到组件后点击不生效，因此采用坐标
      await driver.click(511, 1040); // 新建文件夹-点击确定图标
      await driver.delayMs(2000);
      await driver.click(655, 110); //新建文件并保存-点击保存图标
      await driver.delayMs(200);
      await driver.pressBack();
      await driver.delayMs(200);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'SaveAsFunction_001 end');
    })

    /**
     * Picker 选择图片
     */
    // 选择图片并查看
    it('SelectPictureFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectPictureFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id('picture'));
      let picture = await driver.findComponent(ON.id('picture'));
      await picture.click();
      await driver.delayMs(8000);
      // 系统 picker 拉起的页面无法通过自定义id找到组件，因此采用坐标
      await driver.click(653, 264);
      await driver.click(49, 570);
      await driver.click(675, 570);
      await driver.delayMs(500);
      let finishText = await getResourceString($r('app.string.finish'));
      await driver.assertComponentExist(ON.text(finishText));
      let finish = await driver.findComponent(ON.text(finishText));
      await finish.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back2Index'));
      let back2Index = await driver.findComponent(ON.id('back2Index'));
      await back2Index.click();
      await driver.delayMs(200);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectPictureFunction_001 end');
    })

    /**
     * Picker 选择视频
     */
    // 选择视频并查看
    it('SelectVideoFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectVideoFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id('picture'));
      let picture = await driver.findComponent(ON.id('picture'));
      await picture.click();
      await driver.delayMs(6000);
      // 系统 picker 拉起的页面无法通过自定义id找到组件，因此采用坐标
      await driver.click(657, 41);
      await driver.delayMs(1000);
      await driver.click(355, 200);
      await driver.delayMs(1000);
      await driver.click(653, 264);
      await driver.click(49, 570);
      await driver.delayMs(2000);
      let finishText = await getResourceString($r('app.string.finish'));
      await driver.assertComponentExist(ON.text(finishText));
      let finish = await driver.findComponent(ON.text(finishText));
      await finish.click();
      await driver.delayMs(1500);
      await driver.click(357, 292);
      await driver.delayMs(200);
      await driver.click(355, 576);
      await driver.delayMs(200);
      await driver.click(491, 576);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back2Index'));
      let back2Index = await driver.findComponent(ON.id('back2Index'));
      await back2Index.click();
      await driver.delayMs(200);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'SelectVideoFunction_001 end');
    })
  })
}