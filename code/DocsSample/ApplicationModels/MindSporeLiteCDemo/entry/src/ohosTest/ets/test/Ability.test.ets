import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, it, expect } from '@ohos/hypium';
import Want from '@ohos.app.ability.Want';
import Base from '@ohos.base';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import { getString } from '../utils/ResourceUtil';

const BUNDLE = 'MindSporeLiteCDemo_';
const TAG = 'abilityTest';
const DOMAIN: number = 0xF811;

export default function abilityTest() {
  let driver: Driver = Driver.create();
  describe('MindSporeLiteCDemoTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    /*
     * @tc.number: MindSporeLiteCDemoTest_000
     * @tc.name: Start Ability
     * @tc.desc: Start Ability
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('EntryAbility', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EntryAbility_001 begin');
      // Start Ability
      let want: Want = {
        bundleName: 'com.samples.mindsporelitecdemo',
        abilityName: 'EntryAbility'
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
        hilog.info(DOMAIN, TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      await driver.delayMs(3000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'EntryAbility_001 end');
      done();
    })
    /**
     * @tc.number     : MindSporeLiteCDemoTest_001
     * @tc.name       : open photo
     * @tc.desc       : open photo
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('IfExists', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'IfExists_001 begin');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('MindSporeLite C Demo'));
      await driver.assertComponentExist(ON.text('photo'));
      expect(true).assertTrue();
      hilog.info(DOMAIN, TAG, BUNDLE + 'IfExists_001 end');
      done();
    })

    /**
     * @tc.number     : MindSporeLiteCDemoTest_002
     * @tc.name       : open photo and predict
     * @tc.desc       : open photo and predict
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PhotoPredict', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PhotoPredict_001 begin');
      await driver.delayMs(1000);
      // click MindSporeLite C Demo
      hilog.info(DOMAIN, TAG, BUNDLE + 'PhotoPredict_001 click photo button');
      await driver.assertComponentExist(ON.text('photo'));
      let msPhoto = await driver.findComponent(ON.text('photo'));
      await msPhoto.click();
      await driver.delayMs(1000);
      // chose a photo
      let gridItems = await driver.findComponents(ON.type('GridItem'));
      await gridItems[1].click();
      await driver.delayMs(5000);
      // click complete
      let tipCompleted: string = getString($r('app.string.completed'));
      await driver.assertComponentExist(ON.text(tipCompleted));
      let finish = await driver.findComponent(ON.text(tipCompleted));
      await driver.delayMs(5000);
      await finish.click();
      await driver.delayMs(5000);
      // predict
      await driver.assertComponentExist(ON.text('MindSporeLite C Demo'));
      await driver.assertComponentExist(ON.text('%', 1));
      await driver.delayMs(5000);
      expect(true).assertTrue();
      hilog.info(DOMAIN, TAG, BUNDLE + 'PhotoPredict_001 end');
      done();
    })
  })
}