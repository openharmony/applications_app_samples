import UIAbility from "@ohos:app.ability.UIAbility";
import Logger from "@bundle:com.samples.test.jsunit/entry/ets/util/Logger";
import hilog from "@ohos:hilog";
import type window from "@ohos:window";
export default class EntryAbility extends UIAbility {
    onCreate(want, launchParam) {
        Logger.info('testTag', '%{public}s', 'Ability onCreate');
    }
    onDestroy() {
        Logger.info('testTag', '%{public}s', 'Ability onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
        windowStage.loadContent('pages/Index', (err, data) => {
            if (err.code) {
                Logger.error('testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('testTag', '%{public}s', 'Ability onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger.info('testTag', '%{public}s', 'Ability onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger.info('testTag', '%{public}s', 'Ability onBackground');
    }
    customFun() {
        return 'custom';
    }
}
