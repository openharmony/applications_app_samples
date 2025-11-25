import UIAbility from "@ohos:app.ability.UIAbility";
import type window from "@ohos:window";
import Logger from "@bundle:com.samples.test.uitest/entry/ets/util/Logger";
export default class ClickAbility extends UIAbility {
    onCreate(want, launchParam) {
        Logger.info('ClickAbility', '%{public}s', 'ClickAbility onCreate');
    }
    onDestroy() {
        Logger.info('ClickAbility', '%{public}s', 'ClickAbility onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        Logger.info('ClickAbility', '%{public}s', 'ClickAbility onWindowStageCreate');
        windowStage.loadContent('pages/Click', (err, data) => {
            if (err.code) {
                Logger.error('ClickAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('ClickAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('ClickAbility', '%{public}s', 'ClickAbility onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger.info('ClickAbility', '%{public}s', 'ClickAbility onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger.info('ClickAbility', '%{public}s', 'ClickAbility onBackground');
    }
}
