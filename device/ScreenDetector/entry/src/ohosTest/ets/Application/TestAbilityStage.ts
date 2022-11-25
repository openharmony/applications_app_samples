import hilog from '@ohos.hilog';
import AbilityStage from "@ohos.application.AbilityStage"

export default class TestAbilityStage extends AbilityStage {
    onCreate() {
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
        hilog.info(0x0000, 'testTag', '%{public}s', 'TestAbilityStage onCreate');
    }
}