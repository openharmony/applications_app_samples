/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, it, beforeAll } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'
import { Logger } from '@ohos/base'

const BUNDLE = 'LauncherTest'
const TAG = '[Sample_Launcher_Test]'

let driver: Driver = Driver.create();
// 点击图库添加服务卡片
async function addCard() {
  let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
  await driver.delayMs(1000)
  // 第一次添加
  let gallery = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.gallery'))))
  await gallery.longClick()
  await driver.delayMs(500)
  await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))))
  let service_card = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))))
  await service_card.click()
  await driver.delayMs(1000)
  await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))))
  let addForm = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))))
  await addForm.click()
  await driver.delayMs(1000)
  // 向右滑动
  await driver.fling({ x: 300, y: 300 }, { x: 100, y: 300 }, 5, 200)
  await driver.delayMs(1000)
  // 向左滑动
  await driver.fling({ x: 300, y: 300 }, { x: 500, y: 300 }, 5, 200)
  await driver.delayMs(1000)
  // 第二次添加
  let gallerySecond = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.gallery'))))
  await gallerySecond.longClick()
  await driver.delayMs(500)
  await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))))
  let service_card_second = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))))
  await service_card_second.click()
  await driver.delayMs(1000)
  // 选择第二张卡片
  await driver.fling({ x: 300, y: 300 }, { x: 100, y: 300 }, 5, 200)
  await driver.delayMs(1000)
  await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))))
  let addFormSecond = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))))
  await addFormSecond.click()
  await driver.delayMs(1000)
  // 向右滑动
  await driver.fling({ x: 300, y: 300 }, { x: 100, y: 300 }, 5, 200)
  await driver.delayMs(1000)
  // 向左滑动
  await driver.fling({ x: 300, y: 300 }, { x: 500, y: 300 }, 5, 200)
  await driver.delayMs(1000)
  // 第三次添加
  let galleryThird = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.gallery'))))
  await galleryThird.longClick()
  await driver.delayMs(500)
  await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))))
  let service_card_third = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))))
  await service_card_third.click()
  await driver.delayMs(1000)
  // 选择第三张卡片
  await driver.fling({ x: 300, y: 300 }, { x: 100, y: 300 }, 5, 200)
  await driver.delayMs(1000)
  await driver.fling({ x: 300, y: 300 }, { x: 100, y: 300 }, 5, 200)
  await driver.delayMs(1000)
  await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))))
  let addFormThird = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))))
  await addFormThird.click()
  await driver.delayMs(1000)
  // 向右滑动
  await driver.fling({ x: 300, y: 300 }, { x: 100, y: 300 }, 5, 200)
  await driver.delayMs(1000)
  await driver.fling({ x: 300, y: 300 }, { x: 100, y: 300 }, 5, 200)
  await driver.delayMs(1000)
  // 向左滑动
  await driver.fling({ x: 300, y: 300 }, { x: 500, y: 300 }, 5, 200)
  await driver.delayMs(1000)
  await driver.fling({ x: 300, y: 300 }, { x: 500, y: 300 }, 5, 200)
  await driver.delayMs(1000)
}

export default function abilityTest() {

  beforeAll(async () => {
    let driver = await Driver.create()
    await driver.delayMs(1000)
    // Launcher主界面是窗口，需要退出测试的界面执行测试用例
    await driver.pressBack()
    await driver.delayMs(2000)
  })

  describe('ActsAbilityTest', () => {
    /**
     * 场景：启动桌面后检查各个页面是否正常
     * 输入：向左/向右滑动动作
     * 预期输出：桌面正常滑动且显示正常
     */
    it(BUNDLE + 'ShowDesktop_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'ShowDesktop_001 begin.')
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
      await driver.fling({ x: 300, y: 300 }, { x: 500, y: 300 }, 5, 200)
      await driver.delayMs(1000)
      await driver.fling({ x: 300, y: 300 }, { x: 100, y: 300 }, 5, 200)
      await driver.delayMs(1000)
      // 滑动结束后，检查是否回到桌面第一页
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.camera'))))
      await driver.delayMs(100)
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.contacts'))))
      await driver.delayMs(100)
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.messages'))))
      await driver.delayMs(100)
      Logger.info(TAG, BUNDLE + 'ShowDesktop_001 end.')
      done()
    })

    /**
     * 场景：长按应用图标触发应用菜单,添加服务卡片到桌面
     * 输入：长按应用图标，在弹出的菜单中选择添加服务卡片
     * 预期输出：服务卡片正常添加
     */
    it(BUNDLE + 'AddForm_001', 1, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'AddForm_001 begin.')
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
      await driver.delayMs(1000)
      let camera = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.camera'))))
      await camera.longClick()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))))
      let service_card = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.service_card'))))
      await service_card.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))))
      let addForm = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.add_to_desktop'))))
      await addForm.click()
      await driver.delayMs(1000)
      await addCard()
      // 点击卡片物理坐标打开相机，RK3568
      await driver.click(220, 520)
      await driver.delayMs(1000)
      await driver.pressBack()
      Logger.info(TAG, BUNDLE + 'AddForm_001 end.')
      done()
    })

    /**
     * 场景：尝试卸载应用
     * 输入：长按应用图标，在弹出的菜单中选择卸载
     * 预期输出：在卸载弹窗出现后，正常点击卸载
     */
    it(BUNDLE + 'UninstallApp_001', 2, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'UninstallApp_001 begin.')
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
      await driver.delayMs(1000)
      let camera = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.camera'))))
      await camera.longClick()
      await driver.delayMs(500)
      // 点击卸载，尝试卸载应用
      let uninstallBtn = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.uninstall'))))
      await uninstallBtn.click();
      await driver.delayMs(1000)
      // 检查卸载弹窗是否弹出
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.uninstall'))))
      let uninstall = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.uninstall'))))
      await uninstall.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'UninstallApp_001 end.')
      done()
    })

    /**
     * 场景：通过桌面打开不同的应用
     * 输入：点击打开不同应用
     * 预期输出：各应用打开正常，断言关键字正常
     */
    it(BUNDLE + 'OpenApps_001', 3, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'OpenApps_001 begin.')
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
      let appList = [
        await resourceManager.getStringValue($r('app.string.contacts')),
        await resourceManager.getStringValue($r('app.string.messages'))]
      let keyWords = [
        await resourceManager.getStringValue($r('app.string.telephone')),
        await resourceManager.getStringValue($r('app.string.messages'))]
      for (let i = 0;i < appList.length; i++) {
        Logger.info(TAG, 'open ' + appList[i])
        let app = await driver.findComponent(ON.text(appList[i]))
        await app.click()
        await driver.delayMs(1000)
        // 检查应用是否已经打开
        await driver.assertComponentExist(ON.text(keyWords[i]))
        await driver.pressBack()
        Logger.info(TAG, 'close ' + appList[i])
        await driver.delayMs(1000)
      }
      Logger.info(TAG, BUNDLE + 'OpenApps_001 end.')
      done()
    })

    /**
     * 场景：桌面上滑手势拉起最近任务页面
     * 输入：点击清除最近任务
     * 预期输出：最近任务被清除
     */
    it(BUNDLE + 'CleanRecent_001', 4, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'CleanRecent_001 begin.')
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
      // 打开最近任务
      let image = await driver.findComponents(ON.type('Image'))
      await image[2].click()
      await driver.delayMs(1000)
      // 检查最近任务中是否有相机和联系人
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.messages'))))
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.contacts'))))
      // 点击清空按钮
      let deleteIc = await driver.findComponents(ON.type('Image'))
      await deleteIc[6].click()
      await driver.delayMs(1000)
      // 打开后台
      let images = await driver.findComponents(ON.type('Image'))
      await images[2].click()
      await driver.delayMs(1000)
      // 检查任务是否清空
      await driver.assertComponentExist(
        ON.text(await resourceManager.getStringValue($r('app.string.message_no_mission'))))
      let recent = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.message_no_mission'))))
      await recent.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'CleanRecent_001 end.')
      done()
    })
  })
}