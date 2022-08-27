import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_GalleryForm]'
const DOMAIN = 0xF811
const BUNDLE = 'GalleryForm_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let want = {
        bundleName: "ohos.samples.galleryform",
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
      * 点击允许按钮
      */
    it(BUNDLE + 'GalleryFunction_001', 0, async function () {
      //  create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'GalleryFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // click permission
      hilog.info(DOMAIN, TAG, BUNDLE + 'GalleryAddFunction_001 enter')
      await driver.assertComponentExist(BY.text('允许', MatchPattern.CONTAINS))
      let btnEnter = await driver.findComponent(BY.text('允许', MatchPattern.CONTAINS))
      await btnEnter.click()
      await driver.delayMs(1000)
    })
  })
}