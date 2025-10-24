import type AbilityConstant from "@ohos:app.ability.AbilityConstant";
import UIAbility from "@ohos:app.ability.UIAbility";
import type Want from "@ohos:app.ability.Want";
import abilityDelegatorRegistry from "@ohos:app.ability.abilityDelegatorRegistry";
import hilog from "@ohos:hilog";
import type window from "@ohos:window";
import { Hypium } from "@normalized:N&&&@ohos/hypium/index&1.0.24";
import testsuite from "@normalized:N&&&entry/src/ohosTest/ets/test/List.test&";
const ON_DESTROY_ERROR = -2;
export default class TestAbility extends UIAbility {
    abilityDelegator: abilityDelegatorRegistry.AbilityDelegator;
    constructor() {
        super();
        this.abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
    }
    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
        hilog.info(0x0000, 'testTag', '%{public}s', 'TestAbility onCreate');
        hilog.info(0x0000, 'testTag', '%{public}s', 'want param:' + JSON.stringify(want) ?? '');
        hilog.info(0x0000, 'testTag', '%{public}s', 'launchParam:' + JSON.stringify(launchParam) ?? '');
        let abilityDelegatorArguments: abilityDelegatorRegistry.AbilityDelegatorArgs;
        abilityDelegatorArguments = abilityDelegatorRegistry.getArguments();
        hilog.info(0x0000, 'testTag', '%{public}s', 'start run testcase!!!');
        Hypium.hypiumTest(this.abilityDelegator, abilityDelegatorArguments, testsuite);
    }
    onDestroy() {
        hilog.info(0x0000, 'testTag', '%{public}s', 'TestAbility onDestroy');
        this.abilityDelegator.finishTest('TestAbility onDestroy unexpectedly!', ON_DESTROY_ERROR, () => { });
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        hilog.info(0x0000, 'testTag', '%{public}s', 'TestAbility onWindowStageCreate');
        windowStage.loadContent('testability/pages/Index', (err) => {
            if (err.code) {
                hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
        });
    }
    onWindowStageDestroy() {
        hilog.info(0x0000, 'testTag', '%{public}s', 'TestAbility onWindowStageDestroy');
    }
    onForeground() {
        hilog.info(0x0000, 'testTag', '%{public}s', 'TestAbility onForeground');
    }
    onBackground() {
        hilog.info(0x0000, 'testTag', '%{public}s', 'TestAbility onBackground');
    }
}
