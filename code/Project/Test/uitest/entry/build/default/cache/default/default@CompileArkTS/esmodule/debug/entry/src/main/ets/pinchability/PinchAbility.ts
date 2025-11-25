import UIAbility from "@ohos:app.ability.UIAbility";
import type window from "@ohos:window";
import Logger from "@bundle:com.samples.test.uitest/entry/ets/util/Logger";
export default class PinchAbility extends UIAbility {
    onCreate(want, launchParam) {
        Logger.info('PinchAbility', '%{public}s', 'PinchAbility onCreate');
    }
    onDestroy() {
        Logger.info('PinchAbility', '%{public}s', 'PinchAbility onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        Logger.info('PinchAbility', '%{public}s', 'PinchAbility onWindowStageCreate');
        windowStage.loadContent('pages/Pinch', (err, data) => {
            if (err.code) {
                Logger.error('PinchAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('PinchAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('PinchAbility', '%{public}s', 'PinchAbility onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger.info('PinchAbility', '%{public}s', 'PinchAbility onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger.info('PinchAbility', '%{public}s', 'PinchAbility onBackground');
    }
}
