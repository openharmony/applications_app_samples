/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it, beforeAll, expect, beforeEach, afterEach } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Launcher_Test]'
const DOMAIN = 0xF811
const BUNDLE = 'LauncherTest_'
let appStartRecent = 'startRecent'
let timeStampId = 'time'
let startRecentButtonId = 'startSingletonAbility'
let singletonAbilityText = 'SingletonAbility'
let appCrossChain = 'crossChain'
let crossChainButtonId = 'startSecondAbility'
let entryAbilityText = 'EntryAbility'
let secondAbilityText = 'SecondAbility'
// Return desktop coordinates based on rk3568
let pressHome_x = 360
let pressHome_y = 1270
// Open the recent task list coordinates based on rk3568
let pressRecent_x = 576
let pressRecent_y = 1270

export default function launcherTest() {
  describe('ActsLauncherTest', () => {
    /**
     * Scene:Start the most recent component instance.
     * Input:Click to open the application, return to the desktop, and then click the icon again.
     * Expected output:Pull the most recent ability to the foreground, no new ability instance be created.
     */
    it(BUNDLE + 'StartRecentAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // Open the recent task list
      await driver.click(pressRecent_x, pressRecent_y)
      await driver.delayMs(300)
      // Find the number of ability instances that have been opened
      let appCount = 1
      await driver.findComponents(ON.text(appStartRecent)).then(result =>{
        if (result != null) {
          appCount = result.length
        }
      })
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_001 checkComponent, appCount: ' + appCount)
      await driver.pressBack()
      await driver.delayMs(300)
      // Find and open the test application
      let app = await driver.findComponent(ON.text(appStartRecent))
      await app.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_001 openApplication')
      await driver.delayMs(500)
      // Read the timestamp on the current UIAbility
      let firstTimeStampComponent = await driver.findComponent(ON.id(timeStampId))
      let firstTimeStamp = JSON.stringify(await firstTimeStampComponent.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_001 getFirstTimeStamp, firstTimeStamp: ' + firstTimeStamp)
      // Click the home button to return to the desktop
      await driver.click(pressHome_x, pressHome_y)
      await driver.delayMs(300)
      // open the test application again
      await app.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_001 openApplicationAgain')
      await driver.delayMs(500)
      // Read the timestamp
      // verify that clicking the application icon again opened the most recent instance, not a new one
      let secondTimeStampComponent = await driver.findComponent(ON.id(timeStampId))
      let secondTimeStamp = JSON.stringify(await secondTimeStampComponent.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_001 compareTimeStampEqual, secondTimeStamp: ' + secondTimeStamp)
      expect(firstTimeStamp).assertEqual(secondTimeStamp)
      // Open the recent task list
      await driver.click(pressRecent_x, pressRecent_y)
      await driver.delayMs(300)
      // Verify that no new instance has been created
      let secondAppList = await driver.findComponents(ON.text(appStartRecent))
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_001 confirmAbilityNotAdd, secondAppList: ' + secondAppList.length)
      expect(secondAppList.length).assertEqual(appCount)
      await driver.click(pressHome_x, pressHome_y)
      await driver.delayMs(300)
      await driver.click(pressHome_x, pressHome_y)
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_001 end')
      done()
    })

    /**
     * Scene:Start the most recent component instance.
     * Input:Long click on the application icon, select 'Open' from the pop-up menu.
     *       Return to the desktop and open the application by long clicking again.
     * Expected output:Pull the most recent ability to the foreground, no new ability instance will be created.
     */
    it(BUNDLE + 'StartRecentAbility_002', 1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // Open the recent task list
      await driver.click(pressRecent_x, pressRecent_y)
      await driver.delayMs(500)
      // Find the number of ability instances that have been opened
      let appCount = 1
      await driver.findComponents(ON.text(appStartRecent)).then(result =>{
        if (result != null) {
          appCount = result.length
          hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 checkComponent, appCount: ' + appCount)
        }
      })
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 appCount: ' + appCount)
      await driver.pressBack()
      await driver.delayMs(300)
      let resourceManager = abilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager
      // Open the test application with a long click
      let app = await driver.findComponent(ON.text(appStartRecent))
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 openApplicationByLongClick')
      await app.longClick()
      await driver.delayMs(100)
      let open = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.app_menu_open'))))
      await open.click()
      await driver.delayMs(500)
      // Read the timestamp on the current UIAbility
      let firstTimeStampComponent = await driver.findComponent(ON.id(timeStampId))
      let firstTimeStamp = JSON.stringify(await firstTimeStampComponent.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 getFirstTimeStamp, firstTimeStamp: ' + firstTimeStamp)
      // Click the home button to return to the desktop
      await driver.click(pressHome_x, pressHome_y)
      await driver.delayMs(300)
      // open the test application with a long click again
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 openApplicationByLongClickAgain')
      await app.longClick()
      await driver.delayMs(100)
      await open.click()
      await driver.delayMs(500)
      // Read the timestamp
      // verify that clicking the application icon again opened the most recent instance, not a new one
      let secondTimeStampComponent = await driver.findComponent(ON.id(timeStampId))
      let secondTimeStamp = JSON.stringify(await secondTimeStampComponent.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 compareTimeStampEqual, secondTimeStamp: ' + secondTimeStamp)
      expect(firstTimeStamp).assertEqual(secondTimeStamp)
      // Open the recent task list
      await driver.click(pressRecent_x, pressRecent_y)
      await driver.delayMs(300)
      // Verify that no new instance has been created
      let secondAppList = await driver.findComponents(ON.text(appStartRecent))
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 confirmAbilityNotAdd, secondAppList: ' + secondAppList.length)
      expect(secondAppList.length).assertEqual(appCount)
      await driver.click(pressHome_x, pressHome_y)
      await driver.delayMs(300)
      await driver.click(pressHome_x, pressHome_y)
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 end')
      done()
    })

    /**
     * Scene:Start the most recent component instance.
     * Input:Click to open the application, click button to open SecondAbility, return to the desktop.
     *       Click the icon to open the application again.
     * Expected output:Pull EntryAbility to the foreground, no new ability instance will be created.
     */
    it(BUNDLE + 'StartRecentAbility_003', 2, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // Open the recent task list
      await driver.click(pressRecent_x, pressRecent_y)
      await driver.delayMs(500)
      // Find the number of ability instances that have been opened
      let appList = await driver.findComponents(ON.text(appStartRecent))
      let appCount = 2
      if (appList != null) {
        appCount = appList.length + 1
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 checkComponent, appCount: ' + appCount)
      await driver.pressBack()
      await driver.delayMs(300)
      // Find and open the test application
      let app = await driver.findComponent(ON.text(appStartRecent))
      await app.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 openApplication')
      await driver.delayMs(500)
      // Read the timestamp on the current UIAbility
      let firstTimeStampComponent = await driver.findComponent(ON.id(timeStampId))
      let firstTimeStamp = JSON.stringify(await firstTimeStampComponent.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 getFirstTimeStamp, firstTimeStamp: ' + firstTimeStamp)
      // Find the button and click,open singletonAbility
      let startRecentButton = await driver.findComponent(ON.id(startRecentButtonId))
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 clickStartRecentButton')
      await startRecentButton.click()
      await driver.delayMs(300)
      // Verify singletonAbility is opened.
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 confirmIsSingletonAbility, singletonAbilityText: ' + singletonAbilityText)
      await driver.assertComponentExist(ON.text(singletonAbilityText))
      // Click the home key
      await driver.click(pressHome_x, pressHome_y)
      await driver.delayMs(300)
      // Find and open the test application again
      await app.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 openApplicationAgain')
      await driver.delayMs(300)
      // Read the timestamp
      // Verify open current EntryAbility instead of to the desktop
      let secondTimeStampComponent = await driver.findComponent(ON.id(timeStampId))
      let secondTimeStamp = JSON.stringify(await secondTimeStampComponent.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 compareTimeStampEqual, secondTimeStamp: ' + secondTimeStamp)
      expect(secondTimeStamp).assertEqual(firstTimeStamp)
      // Open the recent task list
      await driver.click(pressRecent_x, pressRecent_y)
      await driver.delayMs(300)
      // Verify that no new instance has been created
      let secondAppList = await driver.findComponents(ON.text(appStartRecent))
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 confirmAbilityNotAdd, secondAppList: ' + secondAppList.length)
      expect(secondAppList.length).assertEqual(appCount)
      await driver.click(pressHome_x, pressHome_y)
      await driver.delayMs(300)
      await driver.click(pressHome_x, pressHome_y)
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 end')
      done()
    })

    /**
     * Scene:Return across task chain.
     * Input:Click to open the application, click the button in EntryAbility.
     *       Click the back button after opening SecondAbility.
     * Expected output:Return to EntryAbility instead of to the desktop.
     */
    it(BUNDLE + 'TaskChainBack_001', 3, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // Find and open the test application
      let app = await driver.findComponent(ON.text(appCrossChain))
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 openApplication')
      await app.click()
      await driver.delayMs(500)
      // Verify EntryAbility is opened
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 confirmIsEntryAbility, entryAbilityText: ' + entryAbilityText)
      await driver.assertComponentExist(ON.text(entryAbilityText))
      // Find the button and click
      let crossChainButton = await driver.findComponent(ON.id(crossChainButtonId))
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 clickCrossChainButton')
      await crossChainButton.click()
      await driver.delayMs(300)
      // Verify SecondAbility is opened by pulling up ServiceExtensionAbility after clicking the button
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 confirmIsSecondAbility, secondAbilityText: ' + secondAbilityText)
      await driver.assertComponentExist(ON.text(secondAbilityText))
      // Click the back key
      await driver.pressBack()
      await driver.delayMs(300)
      // Verify back to EntryAbility instead of to the desktop
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 assertIsEntryAbility, entryAbilityText: ' + entryAbilityText)
      await driver.assertComponentExist(ON.text(entryAbilityText))
      await driver.click(pressHome_x, pressHome_y)
      await driver.delayMs(300)
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 end')
      done()
    })
  })
}