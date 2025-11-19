import { describe, it, expect, beforeAll } from "@normalized:N&&&@ohos/hypium/index&1.0.24";
import hilog from "@ohos:hilog";
import abilityDelegatorRegistry from "@ohos:app.ability.abilityDelegatorRegistry";
import { Driver, ON, MatchPattern } from "@ohos:UiTest";
import type UIAbility from "@ohos:app.ability.UIAbility";
import type Want from "@ohos:app.ability.Want";
const TAG = '[Sample_MyApp]';
const DOMAIN = 0xF811;
const BUNDLE = 'MyApp_';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;
export default function IndexTest() {
    describe('IndexTest', () => {
        beforeAll(async () => {
            want = {
                bundleName: bundleName,
                abilityName: 'EntryAbility'
            };
            await delegator.startAbility(want);
            let driver = Driver.create();
            await driver.delayMs(1000);
            const ability: UIAbility = await delegator.getCurrentTopAbility();
            expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
        });
        /**
         * @tc.number ColorAdaptionTest_001
         * @tc.name testColorAdaption
         * @tc.desc 测试深浅适配是否显示正常
         */
        it(BUNDLE + 'ColorAdaptionTest_001', 0, async (done: Function) => {
            hilog.info(DOMAIN, TAG, BUNDLE + 'ColorAdaptionTest_001 begin');
            let driver = Driver.create();
            let button = await driver.findComponent(ON.text('BuilderNodeAdaptation', MatchPattern.CONTAINS));
            await button.click();
            let button1 = await driver.findComponent(ON.text('Switch to Dark Mode', MatchPattern.CONTAINS));
            await button1.click();
            let button2 = await driver.findComponent(ON.text('Switch to Light Mode', MatchPattern.CONTAINS));
            await button2.click();
            await driver.pressBack();
            hilog.info(DOMAIN, TAG, BUNDLE + 'ColorAdaptionTest_001 end');
            done();
        });
        /**
         * @tc.number ColorAdaptionTest_002
         * @tc.name testColorAdaption
         * @tc.desc 测试深浅适配是否显示正常
         */
        it(BUNDLE + 'ColorAdaptionTest_002', 0, async (done: Function) => {
            hilog.info(DOMAIN, TAG, BUNDLE + 'ColorAdaptionTest_002 begin');
            let driver = Driver.create();
            let button = await driver.findComponent(ON.text('ImageAdaptation', MatchPattern.CONTAINS));
            await button.click();
            await driver.pressBack();
            hilog.info(DOMAIN, TAG, BUNDLE + 'ColorAdaptionTest_002 end');
            done();
        });
        /**
         * @tc.number ColorAdaptionTest_003
         * @tc.name testColorAdaption
         * @tc.desc 测试深浅适配是否显示正常
         */
        it(BUNDLE + 'ColorAdaptionTest_003', 0, async (done: Function) => {
            hilog.info(DOMAIN, TAG, BUNDLE + 'ColorAdaptionTest_003 begin');
            let driver = Driver.create();
            let button = await driver.findComponent(ON.text('SwitchColorMode', MatchPattern.CONTAINS));
            await button.click();
            let button1 = await driver.findComponent(ON.text('Switch ColorMode', MatchPattern.CONTAINS));
            await button1.click();
            await driver.pressBack();
            hilog.info(DOMAIN, TAG, BUNDLE + 'ColorAdaptionTest_003 end');
            done();
        });
    });
}
