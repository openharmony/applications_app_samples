/**
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

// [Start screenCap_sample]
  import { describe, it, TestType, Size, Level } from '@ohos/hypium';
  // 导入测试依赖kit
  import { Driver } from '@kit.TestKit';
  import { display } from '@kit.ArkUI';

  export default function abilityTest() {
    describe('screenCap_sample', () => {
      /**
       * 截取指定区域的屏幕，并保存到指定路径
       */
      it('screenCapture', TestType.FUNCTION, async () => {
        let driver = Driver.create();
        // 应用沙箱路径，el2为用户级加密区，base为应用在本设备上存放持久化数据的子目录
        // 请开发者使用时替换为实际的路径
        let savePath = '/data/storage/el2/base/cache/1.png';
        let res = await driver.screenCapture(savePath, {left: 0, top: 0, right: 100, bottom: 100});
      })

      /**
       * 截取指定屏幕id的屏幕全屏，并保存到指定路径
       */
      it('screenCapWithId', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
        let driver = Driver.create();
        // 获取默认屏幕对象
        let disPlay = display.getDefaultDisplaySync();
        let savePath = '/data/storage/el2/base/cache/1.png'
        let res = await driver.screenCap(savePath, disPlay.id);// 获取默认屏幕ID属性
      })
    })
  }
  // [End screenCap_sample]