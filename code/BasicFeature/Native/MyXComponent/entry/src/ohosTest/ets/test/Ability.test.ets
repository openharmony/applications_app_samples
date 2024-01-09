import { it, expect, describe } from '@ohos/hypium'
import { Driver, ON, } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

const TAG = '{Sample_AppMyXComponent]'
const BUNDLE_NAME = 'com.example.myxcompoent';
const ABILITY_NAME = 'EntryAbility';
const DOMAIN = 0xE629;

interface wantType {
  bundleName: string;
  abilityName: string
}

export default function abilityTest() {
  let driver = Driver.create();
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  describe('ActsAbilityTest', () => {

    it('ActsAbilityTest_StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, `${BUNDLE_NAME} StartAbility_001 begin`);
      let want = {
        bundleName: BUNDLE_NAME,
        abilityName: ABILITY_NAME
      } as wantType;
      delegator.startAbility(want, (err) => {
        hilog.info(DOMAIN, TAG, `${BUNDLE_NAME} startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, `${BUNDLE_NAME} StartAbility_001 end`);
      done();
    })

    /**
     * 点击1
     */
    it('ActsAbilityTest_StartAbility_Click_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_001 begin');

      try {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('DrawTransform'));
        let button = await driver.findComponent(ON.id('DrawTransform'));
        await button.click();
        await driver.delayMs(1000);
        done();
      } catch (err) {
        hilog.error(DOMAIN, TAG, '%{public}s', `click_001 err ${err.code}  msg ${err.message}`);
        expect().assertFail();
      }
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_001 end');
    });

    /**
     * 点击2
     */
    it('ActsAbilityTest_StartAbility_Click_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_002 begin');

      try {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('DrawCube'));
        let button = await driver.findComponent(ON.id('DrawCube'));
        await button.click();
        await driver.delayMs(1000);
        done();
      } catch (err) {
        hilog.error(DOMAIN, TAG, '%{public}s', `click_001 err ${err.code}  msg ${err.message}`);
        expect().assertFail();
      }
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_002 end');
    });

    /**
     * 点击3
     */
    it('ActsAbilityTest_StartAbility_Click_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_003 begin');

      try {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('DrawTransform'));
        let button = await driver.findComponent(ON.id('DrawTransform'));
        await button.click();
        await driver.delayMs(1000);
        done();
      } catch (err) {
        hilog.error(DOMAIN, TAG, '%{public}s', `click_003 err ${err.code}  msg ${err.message}`);
        expect().assertFail();
      }
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' click_003 end');
    });
  });
}
