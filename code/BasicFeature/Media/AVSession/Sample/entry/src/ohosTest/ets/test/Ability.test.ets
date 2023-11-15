import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {Driver, ON, MatchPattern} from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import {BusinessError } from '@ohos.base';

const TAG: string = 'SampleText';
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  const BUNDLE = 'Sample_';

  describe('ActsAbilityTest', function () {

    /**
     * 打开sample
     */
    it(BUNDLE +'StartAbility_001', 0, async (done) => {
      hilog.info(0x0, TAG, 'StartAbility_001 start');
      await abilityDelegator.startAbility({
        bundleName: 'com.example.avcastdemo',
        abilityName: "EntryAbility"
      })
      hilog.info(0x0, TAG, 'StartAbility_001 end');
      done();
    })

    /**
     * music_last
     */
    it(BUNDLE + 'music_last', 0, async (done) => {
      hilog.info(0x0, TAG, 'music_last start');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('music_last'));
      let lastButton = await driver.findComponent(ON.id('music_last'));
      await lastButton.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.id('music_play_or_pause'));
      let playOrPause = await driver.findComponent(ON.id('music_play_or_pause'));
      await lastButton.click();
      await driver.delayMs(1000);
      await lastButton.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.id('music_next'));
      let nextButton = await driver.findComponent(ON.id('music_next'));
      await nextButton.click();
      await driver.delayMs(1000);
      hilog.info(0x0, TAG, 'music_last end');
      done();
    })
  })
}