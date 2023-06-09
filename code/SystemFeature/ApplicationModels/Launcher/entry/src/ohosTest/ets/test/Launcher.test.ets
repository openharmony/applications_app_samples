/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *sss
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
const DOMAIN = 0xF811;
const BUNDLE = 'LauncherTest_'
var appStartRecent = 'startRecent'
var timeStampId = 'date2'
var buttonStartRecent = 'StartUIAbility2'
var ability2Text = 'UIAbility2'
var appCrossChain = 'crossChain'
var buttonCrossChain = 'startUIAbility2'
var entryAbilityText = 'UIAbility1'
var secondAbilityText = 'UIAbility2'

export default function launcherTest() {

  describe('ActsLauncherTest', () => {

    /**
     * Scene:Start the most recent component instance.
     * Input:Click to open the application, return to the desktop, and then click the icon to open the application again.
     * Expected output:Pull the most recent ability to the foreground, no new ability instance will be created.
     */
    it(BUNDLE + 'StartRecentAbility_001', 0, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // Open the recent task list
      await driver.click(576, 1270)
      await driver.delayMs(300)
      // Find the number of ability instances that have been opened
      var appCount = 1
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
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 openApplication')
      await driver.delayMs(500)
      // Read the timestamp on the current UIAbility
      let textComponent1 = await driver.findComponent(ON.id(timeStampId))
      var text1 = JSON.stringify(await textComponent1.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 getFirstTimeStamp, text1: ' + text1)
      // Click the home button to return to the desktop
      await driver.click(360, 1270)
      await driver.delayMs(300)
      // open the test application again
      await app.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 openApplicationAgain')
      await driver.delayMs(500)
      // Read the timestamp
      // verify that clicking the application icon again opens the most recent instance, not the new one
      let textComponent2 = await driver.findComponent(ON.id(timeStampId))
      var text2 = JSON.stringify(await textComponent2.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_001 compareTimeStampEqual, text2: ' + text2)
      expect(text1).assertEqual(text2)
      // Open the recent task list
      await driver.click(576, 1270)
      await driver.delayMs(300)
      // Verify that no new instance has been created
      let appList2 = await driver.findComponents(ON.text(appStartRecent))
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_001 confirmAbilityNotAdd, appList2: ' + appList2.length)
      expect(appList2.length).assertEqual(appCount)
      await driver.click(360, 1270)
      await driver.delayMs(300)
      await driver.click(360, 1270)
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
    it(BUNDLE + 'StartRecentAbility_002', 1, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // Open the recent task list
      await driver.click(576, 1270)
      await driver.delayMs(500)
      // Find the number of ability instances that have been opened
      var appCount = 1
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
      let textComponent1 = await driver.findComponent(ON.id(timeStampId))
      var text1 = JSON.stringify(await textComponent1.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 getFirstTimeStamp, text1: ' + text1)
      // Click the home button to return to the desktop
      await driver.click(360, 1270)
      await driver.delayMs(300)
      // open the test application with a long click again
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 openApplicationByLongClickAgain')
      await app.longClick()
      await driver.delayMs(100)
      await open.click()
      await driver.delayMs(500)
      // Read the timestamp
      // verify that clicking the application icon again opens the most recent instance, not the new one
      let textComponent2 = await driver.findComponent(ON.id(timeStampId))
      var text2 = JSON.stringify(await textComponent2.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 compareTimeStampEqual, text2: ' + text2)
      expect(text1).assertEqual(text2)
      // Open the recent task list
      await driver.click(576, 1270)
      await driver.delayMs(300)
      // Verify that no new instance has been created
      let appList2 = await driver.findComponents(ON.text(appStartRecent))
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 confirmAbilityNotAdd, appList2: ' + appList2.length)
      expect(appList2.length).assertEqual(appCount)
      await driver.click(360, 1270)
      await driver.delayMs(300)
      await driver.click(360, 1270)
      await driver.delayMs(500)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 end')
      done()
    })

    /**
     * Scene:Start the most recent component instance.
     * Input:Click to open the application, click button to open SecondAbility, return to the desktop.
     *       Click the icon to open the application again.
     * Expected output:Pull MainAbility to the foreground, no new ability instance will be created.
     */
    it(BUNDLE + 'StartRecentAbility_003', 2, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // Open the recent task list
      await driver.click(576, 1270)
      await driver.delayMs(500)
      // Find the number of ability instances that have been opened
      let appList = await driver.findComponents(ON.text(appStartRecent))
      var appCount = 2
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
      let textComponent1 = await driver.findComponent(ON.id(timeStampId))
      var text1 = JSON.stringify(await textComponent1.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 getFirstTimeStamp, text1: ' + text1)
      // Find the button and click,open UIAbility2
      var button = await driver.findComponent(ON.id(buttonStartRecent))
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 clickButtonStartUIAbility2')
      await button.click()
      await driver.delayMs(300)
      // Verify UIAbility2 is opened.
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 confirmIsUIAbility2, ability2Text: ' + ability2Text)
      await driver.assertComponentExist(ON.text(ability2Text))
      // Click the home key
      await driver.click(360, 1270)
      await driver.delayMs(300)
      // Find and open the test application again
      await app.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_003 openApplicationAgain')
      await driver.delayMs(300)
      // Read the timestamp
      // Verify open UIAbility1 instead of to the desktop
      let textComponent3 = await driver.findComponent(ON.id(timeStampId))
      var text3 = JSON.stringify(await textComponent3.getText())
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 compareTimeStampEqual, text2: ' + text3)
      expect(text1).assertEqual(text3)
      // Open the recent task list
      await driver.click(576, 1270)
      await driver.delayMs(300)
      // Verify that no new instance has been created
      let appList2 = await driver.findComponents(ON.text(appStartRecent))
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecentAbility_002 confirmAbilityNotAdd, appList2: ' + appList2.length)
      expect(appList2.length).assertEqual(appCount)
      await driver.click(360, 1270)
      await driver.delayMs(300)
      await driver.click(360, 1270)
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
    it(BUNDLE + 'TaskChainBack_001', 3, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // Find and open the test application
      let app = await driver.findComponent(ON.text(appCrossChain))
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 openApplication')
      await app.click()
      await driver.delayMs(500)
      // Verify EntryAbility is opened
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 confirmIsUIAbility1, ability1Text: ' + entryAbilityText)
      await driver.assertComponentExist(ON.text(entryAbilityText))
      // Find the button and click
      var button = await driver.findComponent(ON.id(buttonCrossChain))
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 clickButtonStartUIAbility')
      await button.click()
      await driver.delayMs(300)
      // Verify SecondAbility is opened by pulling up ServiceExtensionAbility after clicking the button
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 confirmIsUIAbility2, ability2Text: ' + secondAbilityText)
      await driver.assertComponentExist(ON.text(secondAbilityText))
      // Click the back key
      await driver.pressBack()
      await driver.delayMs(300)
      // Verify back to EntryAbility instead of to the desktop
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 assertIsEntryAbility, ability1Text: ' + entryAbilityText)
      await driver.assertComponentExist(ON.text(entryAbilityText))
      await driver.click(360, 1270)
      await driver.delayMs(300)
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskChainBack_001 end')
      done()
    })
  })
}