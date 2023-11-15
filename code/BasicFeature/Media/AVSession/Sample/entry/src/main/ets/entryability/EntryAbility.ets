import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import Constants from '../common/Constants';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate', JSON.stringify(want), JSON.stringify(launchParam));
    globalThis.context = this.context;
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
    windowStage.getMainWindow().then(windowClass => {
        try {
          windowClass.setWindowSystemBarProperties({
            statusBarColor: Constants.THEME_COLOR,
            statusBarContentColor: '#000000',
          }, (err) => {
            if (err.code) {
              console.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
              return;
            }
            console.info('Succeeded in setting the system bar properties.');
          })
          let orientation = window.Orientation.AUTO_ROTATION;
          windowClass.setPreferredOrientation(orientation, (err) => {
            if (err.code) {
              console.error('Failed to set window orientation. Cause: ' + JSON.stringify(err));
              return;
            }
            console.info('Succeeded in setting window orientation.');
          })
        } catch (exception) {
          console.error('Failed to set system bar to be invisible. Cause: ' + JSON.stringify(exception));
        }
      })
    }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
