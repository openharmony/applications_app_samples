import { AbilityConstant, UIExtensionAbility, UIExtensionContentSession, Want } from '@kit.AbilityKit';
import Logger from '../common/Logger'


export default class PowerUIExtensionExtAbility extends UIExtensionAbility {
  /**
   * Lifecycle function, called back when a service extension is started for initialization.
   */
  onCreate(want: AbilityConstant.LaunchParam) {
    console.log('PowerUIExtensionExtAbility onCreate');
    globalThis.extensionContext = this.context;
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    globalThis.abilityWant = want;
    try {
      let storage: LocalStorage = new LocalStorage({
        'session': session
      } as Record<string,UIExtensionContentSession>);
      console.log('PowerUIExtensionExtAbility loadContent in');
      session.loadContent('pages/powerDialog',storage)
      session.setWindowBackgroundColor('#00000000');
      globalThis.session = session
    } catch (exception) {
      Logger.error('Failed to obtain the default display object. Code: ' + JSON.stringify(exception))
    }

  }

  /**
   * Lifecycle function, called back before a service extension is destroyed.
   */
  onDestroy() {

  }

}