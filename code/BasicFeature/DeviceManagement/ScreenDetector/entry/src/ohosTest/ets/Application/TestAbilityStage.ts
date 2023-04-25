import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';

export default class TestAbilityStage extends UIAbility {
    onCreate() {
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
        hilog.info(0x0000, 'testTag', '%{public}s', 'TestAbilityStage onCreate');
    }
}