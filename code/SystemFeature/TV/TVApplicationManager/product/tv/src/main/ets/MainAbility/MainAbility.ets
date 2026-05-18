import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility'
import Window from '@ohos.window'
import display from '@ohos.display';
import { AbilityConstant } from '@kit.AbilityKit';

export default class MainAbility extends UIAbility {

    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
        hilog.info(0x0000, 'testTag', '%{public}s', 'want param:' + JSON.stringify(want) ?? '');
        hilog.info(0x0000, 'testTag', '%{public}s', 'launchParam:' + JSON.stringify(launchParam) ?? '');
        globalThis.shortCutsBundleNames = want.parameters?.bundleNames;
        hilog.info(0x0000, 'testTag', '%{public}s',
            'shortCutsBundleNames:' + JSON.stringify(globalThis.shortCutsBundleNames) ?? '');
        globalThis.context = this.context;
    }

    onDestroy() {
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    }

    async onWindowStageCreate(windowStage: Window.WindowStage) {
        // Main window is created, set main page for this ability
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

        globalThis.screenWidth =  this.getDisplay().width;
        globalThis.screenHeight =  this.getDisplay().height;
        globalThis.screenAspectRatio = globalThis.screenWidth / globalThis.screenHeight
        windowStage.loadContent('pages/index', (err, data) => {
            if (err.code) {
                hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.ERROR);
                hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
            hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
        });
    }

    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    }

    onForeground() {
        // Ability has brought to foreground
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
    }

    onBackground() {
        // Ability has back to background
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
        hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
    }

     getDisplay():display.Display{
        let winDisplay =  display.getDefaultDisplaySync()
        return winDisplay;
    }
}
