import hilog from "@ohos:hilog";
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from "@normalized:N&&&@ohos/hypium/index&1.0.24";
import abilityDelegatorRegistry from "@ohos:app.ability.abilityDelegatorRegistry";
import type UIAbility from "@ohos:app.ability.UIAbility";
import type Want from "@ohos:app.ability.Want";
const DOMAIN_NUMBER = 0xF811;
const TAG = '[Sample_MyApp]';
function sleep(time: number) {
    return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}
export default function abilityTest() {
    describe('ActsAbilityTest', () => {
        // Defines a test suite. Two parameters are supported: test suite name and test suite function.
        beforeAll(() => {
            // Presets an action, which is performed only once before all test cases of the test suite start.
            // This API supports only one parameter: preset action function.
        });
        beforeEach(() => {
            // Presets an action, which is performed before each unit test case starts.
            // The number of execution times is the same as the number of test cases defined by **it**.
            // This API supports only one parameter: preset action function.
        });
        afterEach(() => {
            // Presets a clear action, which is performed after each unit test case ends.
            // The number of execution times is the same as the number of test cases defined by **it**.
            // This API supports only one parameter: clear action function.
        });
        afterAll(() => {
            // Presets a clear action, which is performed after all test cases of the test suite end.
            // This API supports only one parameter: clear action function.
        });
        it('assertContain', 0, () => {
            // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
            hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
            let a = 'abc';
            let b = 'b';
            // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
            expect(a).assertContain(b);
            expect(a).assertEqual(a);
        });
        /**
         * @tc.number    SUB_EnvAbility0
         * @tc.name      SUB_EnvEntryAbility
         * @tc.desc      test EnvAbility0
         * @tc.level     Level1
         * @tc.size      MediumTest
         * @tc.type      Function
         */
        it('SUB_EnvAbility0', 0, async (done: Function) => {
            hilog.info(DOMAIN_NUMBER, TAG, 'uitest: TestUiExample begin');
            try {
                const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
                const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
                const want: Want = {
                    deviceId: '',
                    bundleName: 'com.example.envconfig',
                    abilityName: 'EnvAbility0'
                };
                await delegator.startAbility(want);
                const ability: UIAbility = await delegator.getCurrentTopAbility();
                await sleep(5000);
                hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
                expect(1).assertEqual(1);
                done();
            }
            catch (error) {
                hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
                expect(0).assertEqual(1);
            }
        });
        /**
         * @tc.number    SUB_EnvAbility1
         * @tc.name      SUB_EnvAbility1
         * @tc.desc      test Ability1
         * @tc.level     Level1
         * @tc.size      MediumTest
         * @tc.type      Function
         */
        it('SUB_EnvAbility1', 0, async (done: Function) => {
            hilog.info(DOMAIN_NUMBER, TAG, 'uitest: TestUiExample begin');
            try {
                const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
                const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
                const want: Want = {
                    deviceId: '',
                    bundleName: 'com.example.envconfig',
                    abilityName: 'EnvAbility1'
                };
                await delegator.startAbility(want);
                //const ability: UIAbility = await delegator.getCurrentTopAbility();
                await sleep(5000);
                hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
                expect(1).assertEqual(1);
                done();
            }
            catch (error) {
                hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
                expect(0).assertEqual(1);
            }
        });
        /**
         * @tc.number    SUB_EnvAbility2
         * @tc.name      SUB_EnvAbility2
         * @tc.desc      test MyAbility2
         * @tc.level     Level1
         * @tc.size      MediumTest
         * @tc.type      Function
         */
        it('SUB_EnvAbility2', 0, async (done: Function) => {
            hilog.info(DOMAIN_NUMBER, TAG, 'uitest: TestUiExample begin');
            try {
                const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
                const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
                const want: Want = {
                    deviceId: '',
                    bundleName: 'com.example.envconfig',
                    abilityName: 'EnvAbility2'
                };
                await delegator.startAbility(want);
                //const ability: UIAbility = await delegator.getCurrentTopAbility();
                await sleep(5000);
                hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
                expect(1).assertEqual(1);
                done();
            }
            catch (error) {
                hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
                expect(0).assertEqual(1);
            }
        });
        /**
         * @tc.number    SUB_EnvAbility3
         * @tc.name      SUB_EnvAbility3
         * @tc.desc      test MyAbility3
         * @tc.level     Level1
         * @tc.size      MediumTest
         * @tc.type      Function
         */
        it('SUB_EnvAbility3', 0, async (done: Function) => {
            hilog.info(DOMAIN_NUMBER, TAG, 'uitest: TestUiExample begin');
            try {
                const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
                const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
                const want: Want = {
                    deviceId: '',
                    bundleName: 'com.example.envconfig',
                    abilityName: 'EnvAbility3'
                };
                await delegator.startAbility(want);
                //const ability: UIAbility = await delegator.getCurrentTopAbility();
                await sleep(5000);
                hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
                expect(1).assertEqual(1);
                done();
            }
            catch (error) {
                hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
                expect(0).assertEqual(1);
            }
        });
        /**
         * @tc.number    SUB_EnvAbility4
         * @tc.name      SUB_EnvAbility4
         * @tc.desc      test MyAbility4
         * @tc.level     Level1
         * @tc.size      MediumTest
         * @tc.type      Function
         */
        it('SUB_EnvAbility4', 0, async (done: Function) => {
            hilog.info(DOMAIN_NUMBER, TAG, 'uitest: TestUiExample begin');
            try {
                const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
                const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
                const want: Want = {
                    deviceId: '',
                    bundleName: 'com.example.envconfig',
                    abilityName: 'EnvAbility4'
                };
                await delegator.startAbility(want);
                // const ability: UIAbility = await delegator.getCurrentTopAbility();
                await sleep(5000);
                hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
                expect(1).assertEqual(1);
                done();
            }
            catch (error) {
                hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
                expect(0).assertEqual(1);
            }
        });
        /**
         * @tc.number    SUB_EnvAbility5
         * @tc.name      SUB_EnvAbility5
         * @tc.desc      test MyAbility5
         * @tc.level     Level1
         * @tc.size      MediumTest
         * @tc.type      Function
         */
        it('SUB_EnvAbility5', 0, async (done: Function) => {
            hilog.info(DOMAIN_NUMBER, TAG, 'uitest: TestUiExample begin');
            try {
                const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
                const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
                const want: Want = {
                    deviceId: '',
                    bundleName: 'com.example.envconfig',
                    abilityName: 'EnvAbility5'
                };
                await delegator.startAbility(want);
                // const ability: UIAbility = await delegator.getCurrentTopAbility();
                await sleep(5000);
                hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
                expect(1).assertEqual(1);
                done();
            }
            catch (error) {
                hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
                expect(0).assertEqual(1);
            }
        });
        /**
         * @tc.number    SUB_EnvAbility6
         * @tc.name      SUB_EnvAbility6
         * @tc.desc      test MyAbility6
         * @tc.level     Level1
         * @tc.size      MediumTest
         * @tc.type      Function
         */
        it('SUB_EnvAbility6', 0, async (done: Function) => {
            hilog.info(DOMAIN_NUMBER, TAG, 'uitest: TestUiExample begin');
            try {
                const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
                const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
                const want: Want = {
                    deviceId: '',
                    bundleName: 'com.example.envconfig',
                    abilityName: 'EnvAbility6'
                };
                // router.pushUrl({url: 'pages/EnvAbility6'})
                //router.pushUrl({url: 'pages/Index'})
                await delegator.startAbility(want);
                // const ability: UIAbility = await delegator.getCurrentTopAbility();
                await sleep(5000);
                hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
                expect(1).assertEqual(1);
                done();
            }
            catch (error) {
                hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
                expect(0).assertEqual(1);
            }
        });
        /**
         * @tc.number    SUB_EnvAbility7
         * @tc.name      SUB_EnvAbility7
         * @tc.desc      test MyAbility7
         * @tc.level     Level1
         * @tc.size      MediumTest
         * @tc.type      Function
         */
        it('SUB_EnvAbility7', 0, async (done: Function) => {
            hilog.info(DOMAIN_NUMBER, TAG, 'uitest: TestUiExample begin');
            try {
                const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
                const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
                const want: Want = {
                    deviceId: '',
                    bundleName: 'com.example.envconfig',
                    abilityName: 'EnvAbility7'
                };
                await delegator.startAbility(want);
                // const ability: UIAbility = await delegator.getCurrentTopAbility();
                await sleep(6000);
                hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
                expect(1).assertEqual(1);
                done();
            }
            catch (error) {
                hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
                expect(0).assertEqual(1);
            }
        });
        /**
         * @tc.number    SUB_EnvAbility8
         * @tc.name      SUB_EnvAbility8
         * @tc.desc      test MyAbility8
         * @tc.level     Level1
         * @tc.size      MediumTest
         * @tc.type      Function
         */
        it('SUB_EnvAbility8', 0, async (done: Function) => {
            hilog.info(DOMAIN_NUMBER, TAG, 'uitest: TestUiExample begin');
            try {
                const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
                const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
                const want: Want = {
                    deviceId: '',
                    bundleName: 'com.example.envconfig',
                    abilityName: 'EnvAbility8'
                };
                await delegator.startAbility(want);
                // const ability: UIAbility = await delegator.getCurrentTopAbility();
                await sleep(5000);
                hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
                expect(1).assertEqual(1);
                done();
            }
            catch (error) {
                hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
                expect(0).assertEqual(1);
            }
        });
        /**
         * @tc.number    SUB_EnvAbility9
         * @tc.name      SUB_EnvAbility9
         * @tc.desc      test MyAbility9
         * @tc.level     Level1
         * @tc.size      MediumTest
         * @tc.type      Function
         */
        it('SUB_EnvAbility9', 0, async (done: Function) => {
            hilog.info(DOMAIN_NUMBER, TAG, 'uitest: TestUiExample begin');
            try {
                const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
                const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
                const want: Want = {
                    deviceId: '',
                    bundleName: 'com.example.envconfig',
                    abilityName: 'EnvAbility9'
                };
                await delegator.startAbility(want);
                // const ability: UIAbility = await delegator.getCurrentTopAbility();
                // await sleep(5000);
                hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
                expect(1).assertEqual(1);
                done();
            }
            catch (error) {
                hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
                expect(0).assertEqual(1);
            }
        });
        /**
         * @tc.number    SUB_EnvAbility10
         * @tc.name      SUB_EnvAbility10
         * @tc.desc      test MyAbility10
         * @tc.level     Level1
         * @tc.size      MediumTest
         * @tc.type      Function
         */
        it('SUB_EnvAbility10', 0, async (done: Function) => {
            hilog.info(DOMAIN_NUMBER, TAG, 'uitest: TestUiExample begin');
            try {
                const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
                const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
                const want: Want = {
                    deviceId: '',
                    bundleName: 'com.example.envconfig',
                    abilityName: 'EnvAbility10'
                };
                await delegator.startAbility(want);
                // const ability: UIAbility = await delegator.getCurrentTopAbility();
                // await sleep(2000);
                hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
                expect(1).assertEqual(1);
                done();
            }
            catch (error) {
                hilog.error(DOMAIN_NUMBER, TAG, 'Start Fail: ', error);
                expect(0).assertEqual(1);
            }
        });
    });
}
