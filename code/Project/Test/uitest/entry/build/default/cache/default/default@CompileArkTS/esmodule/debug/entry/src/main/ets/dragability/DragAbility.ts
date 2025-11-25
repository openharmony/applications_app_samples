import UIAbility from "@ohos:app.ability.UIAbility";
import type window from "@ohos:window";
import Logger from "@bundle:com.samples.test.uitest/entry/ets/util/Logger";
export default class DragAbility extends UIAbility {
    onCreate(want, launchParam) {
        Logger.info('DragAbility', '%{public}s', 'DragAbility onCreate');
    }
    onDestroy() {
        Logger.info('DragAbility', '%{public}s', 'DragAbility onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        Logger.info('DragAbility', '%{public}s', 'DragAbility onWindowStageCreate');
        windowStage.loadContent('pages/Drag', (err, data) => {
            if (err.code) {
                Logger.error('DragAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('DragAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('DragAbility', '%{public}s', 'DragAbility onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger.info('DragAbility', '%{public}s', 'DragAbility onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger.info('DragAbility', '%{public}s', 'DragAbility onBackground');
    }
}
