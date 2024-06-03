import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    try {
      this.getPermission();
    } catch (err) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'err is ' + err);
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  getPermission(): void {
    let array: Array<Permissions> = [
      // 'ohos.permission.READ_MEDIA',
      // 'ohos.permission.WRITE_MEDIA',
      // 'ohos.permission.MEDIA_LOCATION',
      // 'ohos.permission.GET_BUNDLE_INFO',
      // 'ohos.permission.DISTRIBUTED_DATASYNC',
      // 'ohos.permission.START_ABILITIES_FROM_BACKGROUND',
      // 'ohos.permission.START_INVISIBLE_ABILITY',
      // 'ohos.permission.GRANT_SENSITIVE_PERMISSIONS',
      // 'ohos.permission.GET_DISTRIBUTED_ACCOUNTS',
      'ohos.permission.READ_PASTEBOARD'
    ];

    let atManager = abilityAccessCtrl.createAtManager();

    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(this.context, array).then(function (data) {
      hilog.info(0x0000, 'testTag', '%{public}s', 'data type:' + typeof (data));
      hilog.info(0x0000, 'testTag', '%{public}s', 'data:' + data);
      hilog.info(0x0000, 'testTag', '%{public}s', 'data permissions:' + data.permissions);
      hilog.info(0x0000, 'testTag', '%{public}s', 'data result:' + data.authResults);
    }, (err) => {
      hilog.error(0x0000, 'Failed to start ability', err.code);
    });
  }
}
