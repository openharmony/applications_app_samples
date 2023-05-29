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
import { Driver, ON } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'
import Logger from '../utils/Logger';

const TAG = '[Sample_Image]'
const DOMAIN = 0xF811
const BUNDLE = 'Image_'

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let resMgr = abilityDelegator.getAppContext().resourceManager;
  let text = await resMgr.getStringValue(resource);
  return text;
}

export default function appTest() {
  describe('appTest', function () {
    /*
     *创建Driver对象
     * */
    async function createDriver() {
      let driver = Driver.create();
      await driver.delayMs(1000);
      return driver;
    }
    /*
     * 点击相关组件
     * @param driver:uitest测试框架的Driver对象
     * @param on :uitest测试框架的On对象
     * */
    async function operationComponent(driver: Driver, on) {
      // 判断是否存在组件
      await driver.assertComponentExist(on);
      // 点击组件
      let component = await driver.findComponent(on);
      await component.click();
    }
    /*
     * 日志打印
     * */
    function logInfo(str: String, type: String='info') {
      switch (type) {
        case 'debug':
          Logger.debug(TAG, BUNDLE + str)
          break;
        case 'info':
          Logger.info(TAG, BUNDLE + str)
          break;
        case 'warn':
          Logger.warn(TAG, BUNDLE + str)
          break;
        case 'error':
          Logger.error(TAG, BUNDLE + str)
          break;
        default:
          break;
      }
    }
    /*
     * 计算当前图片信息
     * @param driver:uitest测试框架的Driver对象。
     * @param info :保存图片长宽以及之前长宽的对象。ex：{long:0,width:0,longOld:0,widthOld:0}
     * */
    async function calculateImageInfo(driver: Driver, info={
      long: 0, width: 0, longOld: 0, widthOld: 0
    }) {
      let image = await driver.findComponent(ON.id('imagePixelMap'));
      let rect = await image.getBounds();
      info.longOld = info.long;
      info.widthOld = info.width;
      info.long = rect.right - rect.left;
      info.width = rect.bottom - rect.top;
      logInfo(`EditPhotosScale_001, imagePixelMapRect: ${JSON.stringify(rect)}`)
      logInfo(`EditPhotosScale_001, imagePixelMapInfo:  ${JSON.stringify(info)}`)
    }
    /*
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logInfo('StartAbility_001, begin')
      let want = {
        bundleName: 'ohos.samples.image',
        abilityName: 'MainAbility'
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility(want);
        done();
        expect(true).assertTrue();
      }
      catch (expection) {
        logInfo(`StartAbility_001, end ${JSON.stringify(expection)}`, 'error')
        expect().assertFail();
      }
      logInfo('StartAbility_001, end')
    })

    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermission_001', 0, async function () {
      logInfo('RequestPermission_001, begin')
      let driver = await createDriver();
      await driver.delayMs(1000);
      // 获取文件读写权限
      logInfo('RequestPermission_001, requestPermission')
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.allow'))))
      let btnAllow = await driver.findComponent(ON.text(await getResourceString($r('app.string.allow'))))
      await btnAllow.click()
      logInfo('RequestPermission_001, end')
    })
    /**
     * 退出桌面，调用相机拍照或者拍视频
     */
    it(BUNDLE + 'UseCamera_001', 0, async function () {
      logInfo('UseCamera_001,begin')
      let driver = await createDriver()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.camera'))))
      let camera = await driver.findComponent(ON.text(await getResourceString($r('app.string.camera'))))
      await camera.click()
      await driver.delayMs(1000)
      // 点击拍照拍照片
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.take_photo'))))
      let takePhoto = await driver.findComponent(ON.text(await getResourceString($r('app.string.take_photo'))))
      await takePhoto.click()
      await driver.delayMs(1000)
      // 点击拍照，坐标基于rk3568
      await driver.click(360, 1095)
      await driver.delayMs(1000)
      await driver.click(360, 1095)
      await driver.delayMs(1000)
      // 点击录像拍视频
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.video'))))
      let video = await driver.findComponent(ON.text(await getResourceString($r('app.string.video'))))
      await video.click()
      await driver.delayMs(1000)
      // 点击录像按钮，坐标基于rk3568
      await driver.click(360, 1095)
      await driver.delayMs(5000)
      await driver.click(320, 1100)
      await driver.delayMs(1000)
      await driver.click(360, 1095)
      await driver.delayMs(5000)
      await driver.click(320, 1100)
      await driver.delayMs(1000)
      await abilityDelegator.executeShellCommand('aa start -b ohos.samples.image -a MainAbility')
      await driver.delayMs(3000)
      logInfo('UseCamera_001,end')
    })
    /**
     * 选择照片图片,打开相册
     * input：点击添加图片按钮
     * output：可以获取到系统中的照片和视频并进行展示
     */
    it(BUNDLE + 'ChoicePhotos_001', 0, async function () {
      logInfo('ChoicePhotos_001, begin')
      let driver = await createDriver()
      // 点击添加图片/照片按钮，访问相册
      await operationComponent(driver, ON.id('choicePhotos'));
      await driver.delayMs(1000);
      logInfo('ChoicePhotos_001, clickChoicePhotos start')
      // 获取可选择文件列表，之后从中最多选择3个，选完之后在删除
      let btnChoiceShowList = await driver.findComponents(ON.id('btnChoiceShow'));
      // 选照片or选视频
      logInfo('ChoicePhotos_001, buttonListLength:' + btnChoiceShowList.length)
      for (let index = 0; index < btnChoiceShowList.length; index++) {
        await btnChoiceShowList[index].click();
        // 当前类别下的文件
        let imageShowList = await driver.findComponents(ON.id('imageShow'));
        logInfo('ChoicePhotos_001, imageShowLength:' + imageShowList.length)
        // 选择最多三个
        for (let j = 0; j < imageShowList.length && j < 3; j++) {
          await imageShowList[j].click();
          logInfo(`ChoicePhotos_001, clickChoicePhotos group:${index + 1} index:${j + 1}`)
        }
        // 删除
        for (let j = 0; j < imageShowList.length && j < 3; j++) {
          await operationComponent(driver, ON.id('btnChoiceDelete_0'));
          logInfo(`ChoicePhotos_001, clickChoicePhotos delete group:${index + 1} index:${j + 1}`)
        }
      }
      // 返回选照片
      await btnChoiceShowList[0].click();
      logInfo('ChoicePhotos_001, clickChoicePhotos over')
    })

    /**
     * 进入编辑照片图片
     * input：可以点击图片进行对应样式展示
     * output：点击未选择的数据可以在下方的列表展示选中数据，点击选择的数据可以去除下方列表展示的数据，完成之后将数据传到下一个页面
     */
    it(BUNDLE + 'EditPhotos_001', 0, async function () {
      logInfo('EditPhotos_001, begin')
      let driver = await createDriver();
      // 再次添加照片
      let imageShowList = await driver.findComponents(ON.id('imageShow'));
      logInfo('EditPhotos_001, imageShowLength:' + imageShowList.length)
      for (let index = 0; index < imageShowList.length && index < 3; index++) {
        await imageShowList[index].click();
      }
      // 下一步
      await operationComponent(driver, ON.id('btnNext'));
      await driver.delayMs(1000);
      logInfo('EditPhotos_001, clickNextButton')
      await driver.assertComponentExist(ON.id('scroll'));
      await driver.drag(360, 800, 360, 500, 600);
      // 切换选中照片
      let selectedList = await driver.findComponents(ON.id('selectedList'));
      logInfo('EditPhotos_001, selectedListLength:' + selectedList.length)
      for (let index = 1; index < selectedList.length; index++) {
        await selectedList[index].click();
        logInfo(`EditPhotos_001, selectedList index:${index + 1}`)
      }
      await selectedList[0].click();
      logInfo('EditPhotos_001, over')
    })
    /*
     * 再次添加图片
     * input：在当前页面有一个添加按钮
     * output：点击添加按钮可以返回照片选择页面进行重新选择数据
     * */
    it(BUNDLE + 'EditPhotosAgain_001', 0, async function () {
      logInfo('EditPhotosAgain_001, begin')
      let driver = await createDriver();
      // 点击添加图片按钮
      await operationComponent(driver, ON.id('addAgain'));
      logInfo('EditPhotosAgain_001, hasAddAgain')
      await driver.delayMs(1000);
      // 判断是否返回选择图片页面，并且操作第一张图片去除或添加
      await driver.assertComponentExist(ON.id('btnNext'));
      let imageShowList = await driver.findComponents(ON.id('imageShow'));
      logInfo('EditPhotosAgain_001, imageShowLength:' + imageShowList.length)
      await imageShowList[0].click();
      // 下一步
      await operationComponent(driver, ON.id('btnNext'));
      await driver.delayMs(1000);
      logInfo('EditPhotosAgain_001, clickNextButton')
      await driver.assertComponentExist(ON.id('scroll'));
      await driver.drag(360, 800, 360, 500, 600);
      logInfo('EditPhotosAgain_001, over')
    })
    /**
     * 编辑照片图片_缩小放大
     * input：下方有个缩放按钮，缩放按钮包括缩小和放大两种操作
     * output：点击缩小和放大图片会进行相关变化
     */
    it(BUNDLE + 'EditPhotosScale_001', 0, async function () {
      logInfo('EditPhotosScale_001, begin')
      let driver = await createDriver();
      // 判断是否存在当前图片并获取图片相关信息
      await driver.assertComponentExist(ON.id('imagePixelMap'));
      let imageInfo = {
        long: 0, width: 0, longOld: 0, widthOld: 0
      }
      // 进行缩小和放大操作
      await operationComponent(driver, ON.id('btnChange_0'));
      // 放大
      await operationComponent(driver, ON.id('btnScale_0'));
      // 缩小
      await operationComponent(driver, ON.id('btnScale_1'));
      logInfo('EditPhotosScale_001, over')
    })
    /**
     * 编辑照片图片_裁剪操作
     * input：下方有个裁剪按钮，包括原图、正方形、3:4、9:16四种操作
     * output：点击对应按钮图片的长宽会进行调整
     */
    it(BUNDLE + 'EditPhotosCrop_001', 0, async function () {
      logInfo('EditPhotosCrop_001, begin')
      let driver = await createDriver();
      // 判断是否存在当前图片
      await driver.assertComponentExist(ON.id('imagePixelMap'));
      // 进行裁剪操作
      await operationComponent(driver, ON.id('btnChange_1'));
      await operationComponent(driver, ON.id('btnCrop_0'));
      await operationComponent(driver, ON.id('btnCrop_1'));
      await operationComponent(driver, ON.id('btnCrop_2'));
      await operationComponent(driver, ON.id('btnCrop_3'));
      logInfo('EditPhotosCrop_001, over')
    })
    /**
     * 编辑照片图片_旋转操作
     * input：下方有个旋转
     * output：点击旋转按钮图片会进行改变
     */
    it(BUNDLE + 'EditPhotosRotate_001', 0, async function () {
      logInfo('EditPhotosRotate_001, begin')
      let driver = await createDriver();
      // 判断是否存在当前图片并获取图片相关信息
      await driver.assertComponentExist(ON.id('imagePixelMap'));
      // 进行旋转操作
      await operationComponent(driver, ON.id('btnChange_2'));
      logInfo('EditPhotosRotate_001, over')
    })
    /**
     * 确认图片之后添加评价
     * input：图片调整完之后确认返回初始页面填写评价
     * output：页面可以正常返回，input可以填写内容
     */
    it(BUNDLE + 'ConfirmAddComment', 0, async function () {
      logInfo('ConfirmAddComment_001, begin')
      let driver = await createDriver();
      // 进行提交
      await operationComponent(driver, ON.id('btnConfirm'));
      // 判断是否存在填写评价输入框
      await driver.assertComponentExist(ON.id('textAreaTip'));
      let textAreaTip = await driver.findComponent(ON.id('textAreaTip'));
      logInfo('ConfirmAddComment_001, beginInput')
      // 在输入框内填入信息并且判断是否一致
      let text = '测试评价输入框';
      await textAreaTip.inputText(text);
      await driver.delayMs(1000)
      expect(text == await textAreaTip.getText()).assertTrue();
      logInfo('ConfirmAddComment_001, inputValueEqual')
      logInfo('ConfirmAddComment_001, over')
    })
  })
}