import { AbilityConstant, Configuration, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { updateRenderNodeData } from '../pages/Index';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  preFontId = "";

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'testTag', 'onCreate');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'testTag', 'onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load content: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Content loaded successfully.');
    });
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    let fontId = newConfig.fontId;
    if (fontId && fontId !== this.preFontId) {
      this.preFontId = fontId;
      updateRenderNodeData();
      hilog.info(DOMAIN, 'testTag', 'Font updated: ' + fontId);
    }
  }
}
