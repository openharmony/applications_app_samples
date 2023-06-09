import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { Logger } from '../logger/Logger';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    AppStorage.SetOrCreate("", "")

    globalThis.startAbility = () => {
      if (globalThis.remoteConnectId != undefined) {
        this.context.stopServiceExtensionAbility({
          "bundleName": "com.acts.abilityabacktoabilityb",
          "abilityName": "ServiceAbility"
        }).then(() => {
          try {
            let connectWant = {
              "bundleName": "com.acts.abilityabacktoabilityb",
              "abilityName": "ServiceAbility"
            }
            let context = this.context;
            let connectOptions = {
              onConnect(elementName, remote) {
                Logger.debug("ServiceExtensionAbility has been onConnect");
              },
              onDisconnect(elementName) {
                Logger.debug("ServiceExtensionAbility has been onDisconnect");
              },
              onFailed(code) {
                Logger.debug("ServiceExtensionAbility has been onFailed");
              }
            }
            globalThis.remoteConnectId = context.connectServiceExtensionAbility(connectWant, connectOptions);
          } catch (err) {
            Logger.debug("connectServiceExtensionAbility failed");
          }
        })
      } else {
        try {
          let connectWant = {
            "bundleName": "com.acts.abilityabacktoabilityb",
            "abilityName": "ServiceAbility"
          }
          let context = this.context;
          let connectOptions = {
            onConnect(elementName, remote) {
              Logger.debug("ServiceExtensionAbility has been onConnect");
            },
            onDisconnect(elementName) {
              Logger.debug("ServiceExtensionAbility has been onDisconnect");
            },
            onFailed(code) {
              Logger.debug("ServiceExtensionAbility has been onFailed");
            }
          }
          globalThis.remoteConnectId = context.connectServiceExtensionAbility(connectWant, connectOptions);
        } catch (err) {
          Logger.debug("connectServiceExtensionAbility failed");
        }
      }
    }
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
