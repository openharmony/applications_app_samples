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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Driver, ON } from '@ohos.UiTest';
import SmartPhotoPickerUtils from '../../../main/ets/common/utils/SmartPhotoPickerUtils';

const TAG = 'abilityTest';
const domain: number = 0x0000;

enum RecommendationType {
  QR_OR_BAR_CODE = 1, // 二维码或条码。
  QR_CODE = 2, // 二维码。
  BAR_CODE = 3, // 条码。
  ID_CARD = 4, // 身份证。
  PROFILE_PICTURE = 5, // 头像。
  PASSPORT = 6, // 护照。
  BANK_CARD = 7, // 银行卡。
  DRIVER_LICENSE = 8, // 驾驶证。
  DRIVING_LICENSE = 9, // 行驶证。
  FEATURED_SINGLE_PORTRAIT = 10, // 推荐人像。
}

async function testClickByText(driver: Driver, id: string, logInfo: string) {
  await driver.assertComponentExist(ON.text(id));
  const button = await driver.findComponent(ON.text(id));
  await button.click();
  await driver.delayMs(1000);
  hilog.info(domain, TAG, logInfo);
}

/**
 * SmartPicker 选择二维码/条码
 * 1、拉起图库picker
 * 2、切换到全部标签页 pickerRecommendTab0
 * 3、切换到条码标签页
 * 4、切换到二维码标签页
 * 5、点击左上角的取消按钮
 */
async function recommendTypeTest01(type: RecommendationType): Promise<void> {
  hilog.info(domain, TAG, 'Recommend_Type_Test1 start ');
  
  try {
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' begin');
    await SmartPhotoPickerUtils.smartPhotoPickerByRecommendType(type);
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' end');
  } catch (error) {
    hilog.info(domain, TAG, 'do recommendation by type catch ' + error);
  }

  let driver = Driver.create();
  await driver.delayMs(3000);
  if (await driver.findComponent(ON.text('全部'))) {
    await testClickByText(driver, '全部', 'allMediaTab clicked');
  }
  if (await driver.findComponent(ON.text('条码'))) {
    await testClickByText(driver, '条码', 'barCodeTab clicked');
  }
  if (await driver.findComponent(ON.text('二维码'))) {
    await testClickByText(driver, '二维码', 'qrCodeTab clicked');
  }
  const res = await driver.delayMs(1000);
  expect(res !== null).assertFalse()
  hilog.info(domain, TAG, 'Recommend_Type_Test1 end');
}

/**
 * SmartPicker 选择二维码
 * 1、拉起图库picker
 * 2、切换到全部标签页
 * 3、切换到二维码标签页
 * 4、点击左上角的取消按钮
 */
async function recommendTypeTest02(type: RecommendationType): Promise<void> {
  hilog.info(domain, TAG, 'Recommend_Type_Test2 start');
  
  try {
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' begin');
    await SmartPhotoPickerUtils.smartPhotoPickerByRecommendType(type);
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' end');
  } catch (error) {
    hilog.info(domain, TAG, 'do recommendation by type catch ' + error);
  }

  let driver = Driver.create();
  await driver.delayMs(1000);
  if (await driver.findComponent(ON.text('全部'))) {
    await testClickByText(driver, '全部', 'allMediaTab clicked');
  }
  if (await driver.findComponent(ON.text('二维码'))) {
    await testClickByText(driver, '二维码', 'qrCodeTab clicked');
  }
  const res = await driver.delayMs(1000);
  expect(res !== null).assertFalse()
  hilog.info(domain, TAG, 'Recommend_Type_Test2 end');
}

/**
 * SmartPicker 选择条码
 * 1、拉起图库picker
 * 2、切换到全部标签页
 * 3、切换到条码标签页
 * 4、点击左上角的取消按钮
 */
async function recommendTypeTest03(type: RecommendationType): Promise<void> {
  hilog.info(domain, TAG, 'Recommend_Type_Test3 start');
  
  try {
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' begin');
    await SmartPhotoPickerUtils.smartPhotoPickerByRecommendType(type);
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' end');
  } catch (error) {
    hilog.info(domain, TAG, 'do recommendation by type catch ' + error);
  }

  let driver = Driver.create();
  await driver.delayMs(1000);
  if (await driver.findComponent(ON.text('全部'))) {
    await testClickByText(driver, '全部', 'allMediaTab clicked');
  }
  if (await driver.findComponent(ON.text('条码'))) {
    await testClickByText(driver, '条码', 'barCodeTab clicked');
  }

  await driver.delayMs(1000);
  hilog.info(domain, TAG, 'Recommend_Type_Test3 end');
}

/**
 * SmartPicker 选择身份证
 * 1、拉起图库picker
 * 2、切换到全部标签页
 * 3、切换到身份证标签页
 * 4、点击左上角的取消按钮
 */
async function recommendTypeTest04(type: RecommendationType): Promise<void> {
  hilog.info(domain, TAG, 'Recommend_Type_Test4 start');
  
  try {
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' begin');
    await SmartPhotoPickerUtils.smartPhotoPickerByRecommendType(type);
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' end');
  } catch (error) {
    hilog.info(domain, TAG, 'do recommendation by type catch ' + error);
  }

  let driver = Driver.create();
  await driver.delayMs(1000);
  if (await driver.findComponent(ON.text('全部'))) {
    await testClickByText(driver, '全部', 'allMediaTab clicked');
  }
  if (await driver.findComponent(ON.text('身份证'))) {
    await testClickByText(driver, '身份证', 'idCardTab clicked');
  }

  await driver.delayMs(1000);
  hilog.info(domain, TAG, 'Recommend_Type_Test4 end');
}

/**
 * SmartPicker 选择头像
 * 1、拉起图库picker
 * 2、切换到全部标签页
 * 3、切换到头像标签页
 * 4、点击左上角的取消按钮
 */
async function recommendTypeTest05(type: RecommendationType): Promise<void> {
  hilog.info(domain, TAG, 'Recommend_Type_Test5 start');
  
  try {
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' begin');
    await SmartPhotoPickerUtils.smartPhotoPickerByRecommendType(type);
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' end');
  } catch (error) {
    hilog.info(domain, TAG, 'do recommendation by type catch ' + error);
  }

  let driver = Driver.create();
  await driver.delayMs(3000);
  if (await driver.findComponent(ON.text('头像'))) {
    await testClickByText(driver, '头像', 'profilePictureTab clicked');
  }
  if (await driver.findComponent(ON.text('全部'))) {
    await testClickByText(driver, '全部', 'allMediaTab clicked');
  }

  await driver.delayMs(1000);
  hilog.info(domain, TAG, 'Recommend_Type_Test5 end');
}

/**
 * SmartPicker 选择护照
 * 1、拉起图库picker
 * 2、切换到全部标签页
 * 3、切换到护照标签页
 * 4、点击左上角的取消按钮
 */
async function recommendTypeTest06(type: RecommendationType): Promise<void> {
  hilog.info(domain, TAG, 'recommendTypeTest06 start');
  
  try {
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' begin');
    await SmartPhotoPickerUtils.smartPhotoPickerByRecommendType(type);
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' end');
  } catch (error) {
    hilog.info(domain, TAG, 'do recommendation by type catch ' + error);
  }

  let driver = Driver.create();
  await driver.delayMs(1000);
  if (await driver.findComponent(ON.text('全部'))) {
    await testClickByText(driver, '全部', 'allMediaTab clicked');
  }
  if (await driver.findComponent(ON.text('护照'))) {
    await testClickByText(driver, '护照', 'passPortTab clicked');
  }

  await driver.delayMs(1000);
  hilog.info(domain, TAG, 'recommendTypeTest06 end');
}

/**
 * SmartPicker 选择银行卡
 * 1、拉起图库picker
 * 2、切换到全部标签页
 * 3、切换到银行卡标签页
 * 4、点击左上角的取消按钮
 */
async function recommendTypeTest07(type: RecommendationType): Promise<void> {
  hilog.info(domain, TAG, 'Recommend_Type_Test7 start');
  
  try {
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' begin');
    await SmartPhotoPickerUtils.smartPhotoPickerByRecommendType(type);
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' end');
  } catch (error) {
    hilog.info(domain, TAG, 'do recommendation by type catch ' + error);
  }

  let driver = Driver.create();
  await driver.delayMs(1000);
  if (await driver.findComponent(ON.text('全部'))) {
    await testClickByText(driver, '全部', 'allMediaTab clicked');
  }
  if (await driver.findComponent(ON.text('银行卡'))) {
    await testClickByText(driver, '银行卡', 'bankCardTab clicked');
  }

  await driver.delayMs(1000);
  hilog.info(domain, TAG, 'Recommend_Type_Test7 end');
}

/**
 * SmartPicker 选择驾驶证
 * 1、拉起图库picker
 * 2、切换到全部标签页
 * 3、切换到驾驶证标签页
 * 4、点击左上角的取消按钮
 */
async function recommendTypeTest08(type: RecommendationType): Promise<void> {
  hilog.info(domain, TAG, 'Recommend_Type_Test8 start');
  
  try {
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' begin');
    await SmartPhotoPickerUtils.smartPhotoPickerByRecommendType(type);
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' end');
  } catch (error) {
    hilog.info(domain, TAG, 'do recommendation by type catch ' + error);
  }

  let driver = Driver.create();
  await driver.delayMs(1000);
  if (await driver.findComponent(ON.text('全部'))) {
    await testClickByText(driver, '全部', 'allMediaTab clicked');
  }
  if (await driver.findComponent(ON.text('驾驶证'))) {
    await testClickByText(driver, '驾驶证', 'driverLicenseTab clicked');
  }

  await driver.delayMs(1000);
  hilog.info(domain, TAG, 'Recommend_Type_Test8 end');
}

/**
 * SmartPicker 选择行驶证
 * 1、拉起图库picker
 * 2、切换到全部标签页
 * 3、切换到行驶证标签页
 * 4、点击左上角的取消按钮
 */
async function recommendTypeTest09(type: RecommendationType): Promise<void> {
  hilog.info(domain, TAG, 'Recommend_Type_Test9 start');
  
  try {
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' begin');
    await SmartPhotoPickerUtils.smartPhotoPickerByRecommendType(type);
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' end');
  } catch (error) {
    hilog.info(domain, TAG, 'do recommendation by type catch ' + error);
  }

  let driver = Driver.create();
  await driver.delayMs(1000);
  if (await driver.findComponent(ON.text('全部'))) {
    await testClickByText(driver, '全部', 'allMediaTab clicked');
  }
  if (await driver.findComponent(ON.text('行驶证'))) {
    await testClickByText(driver, '行驶证', 'drivingLicenseTab clicked');
  }

  await driver.delayMs(1000);
  hilog.info(domain, TAG, 'Recommend_Type_Test9 end');
}

/**
 * SmartPicker 选择精选单人像
 * 1、拉起图库picker
 * 2、切换到全部标签页
 * 3、切换到精选单人像标签页
 * 4、点击左上角的取消按钮
 */
async function recommendTypeTest10(type: RecommendationType): Promise<void> {
  hilog.info(domain, TAG, 'Recommend_Type_Test10 start');
  
  try {
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' begin');
    await SmartPhotoPickerUtils.smartPhotoPickerByRecommendType(type);
    hilog.info(domain, TAG, 'do recommendation by type ' + type + ' end');
  } catch (error) {
    hilog.info(domain, TAG, 'do recommendation by type catch ' + error);
  }

  let driver = Driver.create();
  await driver.delayMs(1000);
  if (await driver.findComponent(ON.text('全部'))) {
    await testClickByText(driver, '全部', 'allMediaTab clicked');
  }
  if (await driver.findComponent(ON.text('精选单人像'))) {
    await testClickByText(driver, '精选单人像', 'singlePortraitTab clicked');
  }

  await driver.delayMs(1000);
  hilog.info(domain, TAG, 'Recommend_Type_Test10 end');
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    /**
     * Test with all recommendation type, see:
     * https://developer.huawei.com/consumer/cn/doc/harmonyos-references/arkts-apis-photoaccesshelper-e#recommendationtype11
     * 需提前预置二维码、条码、身份证、头像、大熊猫、护照、银行卡、驾驶证、行驶证、精选单人像的照片
     */
    it('Recommend_Type_Test1', 0, async () => {
      await recommendTypeTest01(RecommendationType.QR_OR_BAR_CODE);
    });

    it('Recommend_Type_Test2', 0, async () => {
      await recommendTypeTest02(RecommendationType.QR_CODE);
    });

    it('Recommend_Type_Test3', 0, async () => {
      await recommendTypeTest03(RecommendationType.BAR_CODE);
    });

    it('Recommend_Type_Test4', 0, async () => {
      await recommendTypeTest04(RecommendationType.ID_CARD);
    });

    it('Recommend_Type_Test5', 0, async () => {
      await recommendTypeTest05(RecommendationType.PROFILE_PICTURE);
    });

    it('Recommend_Type_Test6', 0, async () => {
      await recommendTypeTest06(RecommendationType.PASSPORT);
    });

    it('recommendTypeTest06', 0, async () => {
      await recommendTypeTest07(RecommendationType.BANK_CARD);
    });

    it('Recommend_Type_Test7', 0, async () => {
      await recommendTypeTest08(RecommendationType.DRIVER_LICENSE);
    });

    it('Recommend_Type_Test8', 0, async () => {
      await recommendTypeTest09(RecommendationType.DRIVING_LICENSE);
    });

    it('Recommend_Type_Test9', 0, async () => {
      await recommendTypeTest10(RecommendationType.FEATURED_SINGLE_PORTRAIT);
    });

    // Test with text recommendation
    it('textRecommendationTest', 0, async () => {      
      const promptList = [
        '国庆节，带着女儿去了上海野生动物园，看到了凶猛的大象，漂亮的火烈鸟，还有她心心念念的大熊猫，小家伙可开心了',
        '北国风光，千里冰封，万里雪飘',
        '日照香炉生紫烟，遥看瀑布挂前川。飞流直下三千尺，疑是银河落九天',
        '企鹅',
      ];

      for (const prompt of promptList) {
        try {
          hilog.info(domain, TAG, 'do recommendation by text ' + prompt + ' begin');
          await SmartPhotoPickerUtils.smartPhotoPickerByTextInfo(prompt);
          hilog.info(domain, TAG, 'do recommendation by text ' + prompt + ' end');
        } catch (error) {
          hilog.info(domain, TAG, 'do recommendation by text catch ' + error);
        }        
      }
    })

    // 不使用图片推荐能力
    it('noImageRecommendationTest', 0, async () => {      
      try {
        hilog.info(domain, TAG, 'no image recommendation begin');
        await SmartPhotoPickerUtils.photoPicker();
        hilog.info(domain, TAG, 'no image recommendation end');
      } catch (error) {
        hilog.info(domain, TAG, 'no image recommendation catch ' + error);
      }
    })
  })
}