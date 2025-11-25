import UIAbility from "@ohos:app.ability.UIAbility";
import type window from "@ohos:window";
import Logger from "@bundle:com.samples.test.uitest/entry/ets/util/Logger";
export default class PointMatrixAbility extends UIAbility {
    onCreate(want, launchParam) {
        Logger.info('PointMatrixAbility', '%{public}s', 'PointMatrixAbility onCreate');
    }
    onDestroy() {
        Logger.info('PointMatrixAbility', '%{public}s', 'PointMatrixAbility onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        Logger.info('PointMatrixAbility', '%{public}s', 'Ability onWindowStageCreate');
        windowStage.loadContent('pages/Pinch', (err, data) => {
            if (err.code) {
                Logger.error('PointMatrixAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('PointMatrixAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('PointMatrixAbility', '%{public}s', 'Ability onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger.info('PointMatrixAbility', '%{public}s', 'Ability onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger.info('PointMatrixAbility', '%{public}s', 'Ability onBackground');
    }
}
