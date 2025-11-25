import UIAbility from "@ohos:app.ability.UIAbility";
import type window from "@ohos:window";
import Logger from "@bundle:com.samples.test.uitest/entry/ets/util/Logger";
export default class ScrollerAbility extends UIAbility {
    onCreate(want, launchParam) {
        Logger.info('ScrollerAbility', '%{public}s', 'Ability onCreate');
    }
    onDestroy() {
        Logger.info('ScrollerAbility', '%{public}s', 'Ability onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        Logger.info('ScrollerAbility', '%{public}s', 'Ability onWindowStageCreate');
        windowStage.loadContent('pages/Scroller', (err, data) => {
            if (err.code) {
                Logger.error('ScrollerAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('ScrollerAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('ScrollerAbility', '%{public}s', 'Ability onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger.info('ScrollerAbility', '%{public}s', 'Ability onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger.info('ScrollerAbility', '%{public}s', 'Ability onBackground');
    }
}
