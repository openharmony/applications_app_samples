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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from "@kit.TestKit";

const BUNDLE: string = 'videotrimmer';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    const driver = Driver.create();
    const server_url: string = 'http://10.56.237.239/'; // 可用的服务器

    /**
     * 打开应用
     */
    it(BUNDLE + '_StartAbility', 0, async (done: Function) => {
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.videotrimmer',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        expect().assertFail();
      }
      done();
    })

    it("进入视频播放界面", 0, async (done: Function) => {
      await driver.assertComponentExist(ON.id('video_stack'));
      const imageFirst = await driver.findComponent(ON.id('video_stack'));
      await imageFirst.click();
      await driver.delayMs(4000);
      //  断言有分享按钮
      await driver.assertComponentExist(ON.id('image_video_more'));
      done();
    })

    it("打开分享到界面", 0, async (done: Function) => {
      // 判断有分享到按钮
      await driver.assertComponentExist(ON.id('image_video_more'));
      const imageShare = await driver.findComponent(ON.id('image_video_more'));
      await imageShare.click();
      await driver.delayMs(1000);
      //  断言有下载按钮
      await driver.assertComponentExist(ON.text('下载'));
      done();
    })

    it("下载视频到相册", 0, async (done: Function) => {
      const btnDownload = await driver.findComponent(ON.text('下载'));
      await btnDownload.click();
      // 等待下载，时间较长
      await driver.delayMs(13000);
      // 保存到相册权限
      const permission = await driver.findComponent(ON.type('Button').text('允许'));
      if (permission !== null && permission !== undefined) {
        await permission!.click();
        await driver.delayMs(1000);
      }
      await driver.assertComponentExist(ON.text('视频下载成功')); // 通过断言是否弹出‘视频下载成功’弹窗来验证
      // 返回到视频列表
      await driver.pressBack();
      await driver.delayMs(500);
      //  断言有添加按钮
      await driver.assertComponentExist(ON.id('txt_add_video'));
      done();
    })

    it("从相册中选择视频", 0, async (done: Function) => {
      // 点击添加按钮
      const btnAddVideo = await driver.findComponent(ON.id('txt_add_video'));
      await btnAddVideo.click();
      await driver.delayMs(3000);
      // 查找可用的视频
      const videoText = await driver.findComponent(ON.text('00:', MatchPattern.CONTAINS));
      if(videoText !== undefined && videoText !== null) {
        await videoText.click();
        await driver.delayMs(3000);
      }
      // 选中视频
      const complete = await driver.findComponent(ON.text('完成'));
      if(complete !== undefined && complete !== null) {
        await complete.click();
        await driver.delayMs(3000);
      }
      // 断言存在图片裁剪按钮
      await driver.assertComponentExist(ON.id('image_to_trimmer'));
      done();
    })

    it("进入视频剪辑界面", 0, async (done: Function) => {
      const btnImage = await driver.findComponent(ON.id('image_to_trimmer'));
      await btnImage.click();
      // 等待小图加载
      await driver.delayMs(8000);
      // 断言有裁剪进度选择
      await driver.assertComponentExist(ON.id('left_thumb_handle'));
      await driver.assertComponentExist(ON.id('right_thumb_handle'));
      done();
    })

    it("开始剪辑视频", 0, async (done: Function) => {
      // 裁剪
      const txtTrimmer = await driver.findComponent(ON.id('txt_trimmer_finish'));
      await txtTrimmer.click();
      // 等待裁剪结果，裁剪成功后自动返回
      await driver.delayMs(8000);
      // 断言存在图片裁剪按钮
      await driver.assertComponentExist(ON.id('image_to_trimmer'));
      // 断言存在保存按钮
      await driver.assertComponentExist(ON.id('upload_save'));
      done();
    })

    it("保存视频到服务器", 0, async (done: Function) => {
      // 移动选中框左侧的条状物
      const txtUpload = await driver.findComponent(ON.id('upload_save'));
      await txtUpload.click();
      await driver.delayMs(500);

      // 判断是否有配置服务器,没有的话配置服务器
      let btnSaveUrl = await driver.findComponent(ON.id('btn_save_serverUrl'));
      if (btnSaveUrl !== null && btnSaveUrl !== undefined) {
        let inputSaveUrl = await driver.findComponent(ON.id('input_serverUrl'));
        await inputSaveUrl.inputText(server_url); // 输入服务器地址
        await driver.delayMs(500);
        await btnSaveUrl!.click();
        await driver.delayMs(500);
      }
      // 重新保存到服务器
      await txtUpload.click();
      // 等待裁剪结果
      await driver.delayMs(10000);
      // 断言回到列表页
      await driver.assertComponentExist(ON.id('txt_add_video'));
      done();
    })
  })
}