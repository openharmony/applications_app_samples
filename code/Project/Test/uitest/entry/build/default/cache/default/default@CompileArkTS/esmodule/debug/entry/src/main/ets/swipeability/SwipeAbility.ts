import Logger from "@bundle:com.samples.test.uitest/entry/ets/util/Logger";
import UIAbility from "@ohos:app.ability.UIAbility";
import type window from "@ohos:window";
export default class SwipeAbility extends UIAbility {
    onCreate(want, launchParam) {
        Logger.info('SwipeAbility', '%{public}s', 'Ability onCreate');
    }
    onDestroy() {
        Logger.info('SwipeAbility', '%{public}s', 'Ability onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        Logger.info('SwipeAbility', '%{public}s', 'Ability onWindowStageCreate');
        windowStage.loadContent('pages/Swipe', (err, data) => {
            if (err.code) {
                Logger.error('SwipeAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('SwipeAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('SwipeAbility', '%{public}s', 'Ability onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger.info('SwipeAbility', '%{public}s', 'Ability onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger.info('SwipeAbility', '%{public}s', 'Ability onBackground');
    }
}
