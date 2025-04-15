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
import Logger from './Logger'
import { Driver, ON, Component } from '@ohos.UiTest'
import Want from '@ohos.app.ability.Want';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const BUNDLE: string = 'PublishMultimediaUpdate';
const TAG: string = '[Sample_PublishMultimediaUpdate_Test]';
const delegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  let driver = Driver.create();
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + '_startAbility', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + '_startAbility start')
      let want: Want = {
        bundleName: 'com.samples.publishmultimediaupdate',
        abilityName: 'EntryAbility'
      };
      delegator.startAbility(want, (err) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      Logger.info(TAG, BUNDLE + '_startAbility end');
      done();
    })

    /**
     * 1、点击右上角添加标志
     * 2、点击‘Post’
     * 3、输入文本，点击发布
     */
    it(TAG + '_text_publish', 0, async (done: Function) => {
      let addButton: Component = await driver.findComponent(ON.id('add_button'));
      await addButton.click();
      await driver.delayMs(1000);
      let post: Component = await driver.findComponent(ON.id('Post'));
      await post.click();
      await driver.delayMs(500);
      let textInput: Component = await driver.findComponent(ON.type('TextInput'));
      await textInput.inputText('test_text');
      await driver.delayMs(200);
      let saveButton: Component = await driver.findComponent(ON.text('发布'));
      await saveButton.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('test_text'));

      done();
    })

    /**
     * 1、点击右上角添加标志
     * 2、点击‘Photo’
     * 3、点击‘+’添加图片
     * 4、输入文本并发布
     */
    it(TAG + '_photo_publish', 0, async (done: Function) => {
      let addButton: Component = await driver.findComponent(ON.id('add_button'));
      await addButton.click();
      await driver.delayMs(200);
      let post: Component = await driver.findComponent(ON.id('Photo'));
      await post.click();
      await driver.delayMs(500);
      let selectPictureButton: Component = await driver.findComponent(ON.id('select_picture_button'));
      await selectPictureButton.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('拍照')); // 通过断言查找文字判断是否拉起 picker
      const photo = await driver.findComponent(ON.text('拍照'));
      await photo.click();
      await driver.delayMs(1000);
      if (await driver.findComponent(ON.text('知道了'))) {
        const allow = await driver.findComponent(ON.text('知道了'));
        await allow.click();
        await driver.delayMs(300);
      }
      await driver.click(630, 2317); // 点击拍照
      await driver.delayMs(1500);
      await driver.click(1045, 2317); // 点击对号
      await driver.delayMs(1000);
      let textInput: Component = await driver.findComponent(ON.type('TextInput'));
      await textInput.inputText('test_picture');
      await driver.delayMs(200);
      let saveButton: Component = await driver.findComponent(ON.text('发布'));
      await saveButton.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('test_picture'));

      done();
    })

    /**
     * 1、点击右上角添加标志
     * 2、点击‘Video’
     * 3、点击‘+’添加视频
     * 4、输入文本并发布
     */
    it(TAG + '_video_publish', 0, async (done: Function) => {
      let addButton: Component = await driver.findComponent(ON.id('add_button'));
      await addButton.click();
      await driver.delayMs(200);
      let post: Component = await driver.findComponent(ON.id('Video'));
      await post.click();
      await driver.delayMs(500);
      let selectPictureButton: Component = await driver.findComponent(ON.id('select_video_button'));
      await selectPictureButton.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('拍摄')); // 通过断言查找文字判断是否拉起 picker
      const photo = await driver.findComponent(ON.text('拍摄'));
      await photo.click();
      await driver.delayMs(1000);
      if (await driver.findComponent(ON.text('知道了'))) {
        const allow = await driver.findComponent(ON.text('知道了'));
        await allow.click();
        await driver.delayMs(300);
      }
      await driver.click(630, 2317); // 点击拍照
      await driver.delayMs(3000);
      await driver.click(630, 2317); // 点击停止
      await driver.delayMs(1500);
      await driver.click(1045, 2317); // 点击对号
      await driver.delayMs(1000);
      let textInput: Component = await driver.findComponent(ON.type('TextInput'));
      await textInput.inputText('test_video');
      await driver.delayMs(200);
      let saveButton: Component = await driver.findComponent(ON.text('发布'));
      await saveButton.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('test_video'));
      await driver.assertComponentExist(ON.type('Video'));

      done();
    })
  })
}