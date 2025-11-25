import UIAbility from "@ohos:app.ability.UIAbility";
import type window from "@ohos:window";
import Logger from "@bundle:com.samples.test.uitest/entry/ets/util/Logger";
export default class MouseAbility extends UIAbility {
    onCreate(want, launchParam) {
        Logger.info('MouseAbility', '%{public}s', 'MouseAbility onCreate');
    }
    onDestroy() {
        Logger.info('MouseAbility', '%{public}s', 'MouseAbility onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        Logger.info('MouseAbility', '%{public}s', 'MouseAbility onWindowStageCreate');
        windowStage.loadContent('pages/Mouse', (err, data) => {
            if (err.code) {
                Logger.error('MouseAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('MouseAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('MouseAbility', '%{public}s', 'MouseAbility onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger.info('MouseAbility', '%{public}s', 'MouseAbility onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger.info('MouseAbility', '%{public}s', 'MouseAbility onBackground');
    }
}
