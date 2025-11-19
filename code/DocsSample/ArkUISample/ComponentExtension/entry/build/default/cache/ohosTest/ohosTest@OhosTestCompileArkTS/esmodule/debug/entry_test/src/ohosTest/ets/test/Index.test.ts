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
         * @tc.number ComponentExtension_001
         * @tc.name testComponentExtension
         * @tc.desc 测试ComponentExtension显示是否显示正常
         */
        it(BUNDLE + 'ComponentExtension_001', 0, async (done: Function) => {
            hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentExtension_001 begin');
            let driver = Driver.create();
            let button = await driver.findComponent(ON.text('AnimatableExtendDecorator', MatchPattern.CONTAINS));
            await button.click();
            let button1 = await driver.findComponent(ON.text('AnimatableExtendDecoratorOne', MatchPattern.CONTAINS));
            await button1.click();
            let button2 = await driver.findComponent(ON.text('Play', MatchPattern.CONTAINS));
            await button2.click();
            await driver.pressBack();
            hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentExtension_001 end');
            done();
        });
        /**
         * @tc.number ComponentExtension_002
         * @tc.name testComponentExtension
         * @tc.desc 测试ComponentExtension显示是否显示正常
         */
        it(BUNDLE + 'ComponentExtension_002', 0, async (done: Function) => {
            hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentExtension_002 begin');
            let driver = Driver.create();
            let button1 = await driver.findComponent(ON.text('AnimatableExtendDecoratorTwo', MatchPattern.CONTAINS));
            await button1.click();
            let button2 = await driver.findComponent(ON.text('Play', MatchPattern.CONTAINS));
            await button2.click();
            await driver.pressBack();
            hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentExtension_002 end');
            done();
        });
        /**
         * @tc.number ComponentExtension_003
         * @tc.name testComponentExtension
         * @tc.desc 测试ComponentExtension显示是否显示正常
         */
        it(BUNDLE + 'ComponentExtension_003', 0, async (done: Function) => {
            hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentExtension_003 begin');
            let driver = Driver.create();
            let button = await driver.findComponent(ON.text('StylesDecorator', MatchPattern.CONTAINS));
            await button.click();
            let button1 = await driver.findComponent(ON.text('StylesDecoratorOne', MatchPattern.CONTAINS));
            await button1.click();
            let button2 = await driver.findComponent(ON.text('FancyB', MatchPattern.CONTAINS));
            await button2.click();
            await driver.pressBack();
            hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentExtension_003 end');
            done();
        });
        /**
         * @tc.number ComponentExtension_004
         * @tc.name testComponentExtension
         * @tc.desc 测试ComponentExtension显示是否显示正常
         */
        it(BUNDLE + 'ComponentExtension_004', 0, async (done: Function) => {
            hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentExtension_004 begin');
            let driver = Driver.create();
            let button1 = await driver.findComponent(ON.text('StylesDecoratorTwo', MatchPattern.CONTAINS));
            await button1.click();
            let button2 = await driver.findComponent(ON.text('change height', MatchPattern.CONTAINS));
            await button2.click();
            hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentExtension_004 end');
            done();
        });
    });
}
