import UIAbility from "@ohos:app.ability.UIAbility";
import type window from "@ohos:window";
import Logger from "@bundle:com.samples.test.uitest/entry/ets/util/Logger";
export default class InputAbility extends UIAbility {
    onCreate(want, launchParam) {
        Logger.info('InputAbility', '%{public}s', 'InputAbility onCreate');
    }
    onDestroy() {
        Logger.info('InputAbility', '%{public}s', 'InputAbility onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        Logger.info('InputAbility', '%{public}s', 'InputAbility onWindowStageCreate');
        windowStage.loadContent('pages/Input', (err, data) => {
            if (err.code) {
                Logger.error('InputAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('InputAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('InputAbility', '%{public}s', 'InputAbility onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger.info('InputAbility', '%{public}s', 'InputAbility onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger.info('InputAbility', '%{public}s', 'InputAbility onBackground');
    }
}
