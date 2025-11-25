import UIAbility from "@ohos:app.ability.UIAbility";
import type window from "@ohos:window";
import Logger from "@bundle:com.samples.test.uitest/entry/ets/util/Logger";
export default class FlingAbility extends UIAbility {
    onCreate(want, launchParam) {
        Logger.info('FlingAbility', '%{public}s', 'FlingAbility onCreate');
    }
    onDestroy() {
        Logger.info('FlingAbility', '%{public}s', 'FlingAbility onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        Logger.info('FlingAbility', '%{public}s', 'FlingAbility onWindowStageCreate');
        windowStage.loadContent('pages/Fling', (err, data) => {
            if (err.code) {
                Logger.error('FlingAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('FlingAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('FlingAbility', '%{public}s', 'FlingAbility onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger.info('FlingAbility', '%{public}s', 'FlingAbility onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger.info('FlingAbility', '%{public}s', 'FlingAbility onBackground');
    }
}
