import UIAbility from "@ohos:app.ability.UIAbility";
import type window from "@ohos:window";
import Logger from "@bundle:com.samples.test.uitest/entry/ets/util/Logger";
export default class EntryAbility extends UIAbility {
    onCreate(want, launchParam) {
        let context = this.context;
        Logger.info('EntryAbility', '%{public}s', 'EntryAbility onCreate');
    }
    onDestroy() {
        Logger.info('EntryAbility', '%{public}s', 'EntryAbility onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        Logger.info('EntryAbility', '%{public}s', 'Ability onWindowStageCreate');
        windowStage.loadContent('pages/Index', (err, data) => {
            if (err.code) {
                Logger.error('EntryAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('EntryAbility', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info('EntryAbility', '%{public}s', 'EntryAbility onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger.info('EntryAbility', '%{public}s', 'EntryAbility onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger.info('EntryAbility', '%{public}s', 'EntryAbility onBackground');
    }
}
