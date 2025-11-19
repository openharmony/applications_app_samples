import ConfigurationConstant from "@ohos:app.ability.ConfigurationConstant";
import UIAbility from "@ohos:app.ability.UIAbility";
import type AbilityConstant from "@ohos:app.ability.AbilityConstant";
import type { Configuration } from "@ohos:app.ability.Configuration";
import type Want from "@ohos:app.ability.Want";
import hilog from "@ohos:hilog";
import type window from "@ohos:window";
const DOMAIN = 0x0000;
export default class EntryAbility extends UIAbility {
    // [Start create_app]
    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
        try {
            hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
            this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
        }
        catch (err) {
            hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
        }
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    }
    // [End create_app]
    // [Start update_app]
    onConfigurationUpdate(newConfig: Configuration): void {
        AppStorage.setOrCreate('currentColorMode', newConfig.colorMode);
        hilog.info(0x0000, 'testTag', 'the newConfig.colorMode is %{public}s', JSON.stringify(AppStorage.get('currentColorMode')) ?? '');
    }
    // [End update_app]
    onDestroy(): void {
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
    }
    onWindowStageCreate(windowStage: window.WindowStage): void {
        // Main window is created, set main page for this ability
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
        windowStage.loadContent('pages/Index', (err) => {
            if (err.code) {
                hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
                return;
            }
            hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
        });
    }
    onWindowStageDestroy(): void {
        // Main window is destroyed, release UI related resources
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    }
    onForeground(): void {
        // Ability has brought to foreground
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
    }
    onBackground(): void {
        // Ability has back to background
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
    }
}
