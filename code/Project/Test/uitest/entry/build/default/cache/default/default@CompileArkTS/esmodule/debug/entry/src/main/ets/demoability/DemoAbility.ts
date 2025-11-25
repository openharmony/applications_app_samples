import UIAbility from "@ohos:app.ability.UIAbility";
import type AbilityConstant from "@ohos:app.ability.AbilityConstant";
import type Want from "@ohos:app.ability.Want";
import Logger from "@bundle:com.samples.test.uitest/entry/ets/util/Logger";
import type window from "@ohos:window";
export default class DemoAbility extends UIAbility {
    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
        Logger.info('%{public}s', 'Ability onCreate');
    }
    onDestroy(): void {
        Logger.info('%{public}s', 'Ability onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage): void {
        // Main window is created, set main page for this ability
        Logger.info('%{public}s', 'Ability onWindowStageCreate');
        windowStage.loadContent('pages/demoPage', (err) => {
            if (err.code) {
                Logger.error('Failed to load the content. Cause: %{public}s', JSON.stringify(err));
                return;
            }
            Logger.info('Succeeded in loading the content.');
        });
    }
    onWindowStageDestroy(): void {
        // Main window is destroyed, release UI related resources
        Logger.info('%{public}s', 'Ability onWindowStageDestroy');
    }
    onForeground(): void {
        // Ability has brought to foreground
        Logger.info('%{public}s', 'Ability onForeground');
    }
    onBackground(): void {
        // Ability has back to background
        Logger.info('%{public}s', 'Ability onBackground');
    }
}
