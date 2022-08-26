import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_UpgradePopup]'
const DOMAIN = 0xF811
const BUNDLE = 'UpgradePopup_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let want = {
        bundleName: "ohos.samples.upgradePopup",
        abilityName: "MainAbility"
      }
      await globalThis.abilityContext.startAbility(want, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
      * 点击弹窗
      */
    it(BUNDLE + 'PopupFunction_001', 0, async function () {
      // open popup
      hilog.info(DOMAIN, TAG, BUNDLE + 'PopupFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // click now
      hilog.info(DOMAIN, TAG, BUNDLE + 'PopupFunction_001 ClickNow')
      await driver.assertComponentExist(BY.key('Now'))
      let btnClick = await driver.findComponent(BY.key('Now'))
      await btnClick.click()
      await driver.delayMs(2000)
      // click cancel
      hilog.info(DOMAIN, TAG, BUNDLE + 'PopupFunction_001 ClickCancel')
      await driver.assertComponentExist(BY.key('cancel'))
      let btnCancel= await driver.findComponent(BY.key('cancel'))
      await btnCancel.click()
      await driver.delayMs(1000)
    })
  })
}