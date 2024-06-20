import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import Want from '@ohos.app.ability.Want';
import Base from '@ohos.base';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON, UIElementInfo, UIEventObserver } from '@ohos.UiTest';
import { getString } from '../utils/ResourceUtil';

const BUNDLE = 'MindSporeLiteArkTSDemo_';
const TAG = 'abilityTest';
const domain: number = 0xF811;
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let resourceManager = abilityDelegator.getAppContext().resourceManager;

export default function abilityTest() {
  let driver: Driver = Driver.create();
  describe('MindSporeLiteArkTSDemoTest', () => {
    /*
     * @tc.number: MindSporeLiteArkTSDemoTest_000
     * @tc.name: Start Ability
     * @tc.desc: Start Ability
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'EntryAbility', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'EntryAbility_001 begin');
      // 开启应用
      let want: Want = {
        bundleName: 'com.samples.mindsporelite',
        abilityName: 'EntryAbility'
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
        hilog.info(domain, TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      await driver.delayMs(3000);
      hilog.info(domain, TAG, BUNDLE + 'EntryAbility_001 end');
      done();
    })
    /**
     * @tc.number     : MindSporeLiteArkTSDemoTest_001
     * @tc.name       : open photo
     * @tc.desc       : open photo
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it(BUNDLE + 'IfExists', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'IfExists_001 begin');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('MindSporeLite ArkTS Demo'));
      await driver.assertComponentExist(ON.text('photo'));
      expect(true).assertTrue();
      hilog.info(domain, TAG, BUNDLE + 'IfExists_001 end');
      done();
    })

    /**
     * @tc.number     : MindSporeLiteArkTSDemoTest_002
     * @tc.name       : open photo and predict
     * @tc.desc       : open photo and predict
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it(BUNDLE + 'PhotoPredict', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'PhotoPredict_001 begin');
      await driver.delayMs(1000);
      // 点击photo按钮
      hilog.info(domain, TAG, BUNDLE + 'PhotoPredict_001 click photo button');
      await driver.assertComponentExist(ON.text('photo'));
      let msPhoto = await driver.findComponent(ON.text('photo'));
      await msPhoto.click();
      await driver.delayMs(1000);
      // 点击照片，选中一张照片
      let gridItems = await driver.findComponents(ON.type('GridItem'));
      await gridItems[1].click();
      await driver.delayMs(5000);
      // 点击完成
      let tipCompleted: string = getString($r('app.string.completed'));
      await driver.assertComponentExist(ON.text(tipCompleted));
      let finish = await driver.findComponent(ON.text(tipCompleted));
      await driver.delayMs(5000);
      await finish.click();
      await driver.delayMs(5000);
      // 进行图片推理
      await driver.assertComponentExist(ON.text('MindSporeLite ArkTS Demo'));
      await driver.assertComponentExist(ON.text('%', 1));
      await driver.delayMs(5000);
      expect(true).assertTrue();
      hilog.info(domain, TAG, BUNDLE + 'PhotoPredict_001 end');
      done();
    })
  })
}