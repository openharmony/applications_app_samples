import ConfigurationConstant from "@ohos:app.ability.ConfigurationConstant";
import UIAbility from "@ohos:app.ability.UIAbility";
import type { Configuration } from "@ohos:app.ability.Configuration";
import hilog from "@ohos:hilog";
import type window from "@ohos:window";
const DOMAIN = 0x0000;
export default class EntryAbility extends UIAbility {
    // [Start create_sys]
    // [Start create_set_sys]
    onCreate(): void {
        // [StartExclude create_set_sys]
        this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
        // [EndExclude create_set_sys]
        // [StartExclude create_sys]
        AppStorage.setOrCreate('currentColorMode', this.context.config.colorMode);
        // [EndExclude create_sys]
    }
    // [End create_set_sys]
    // [End create_sys]
    // [Start update_sys]
    onConfigurationUpdate(newConfig: Configuration): void {
        AppStorage.setOrCreate('currentColorMode', newConfig.colorMode);
        hilog.info(0x0000, 'testTag', 'the newConfig.colorMode is %{public}s', JSON.stringify(AppStorage.get('currentColorMode')) ?? '');
    }
    // [End update_sys]
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
