import AbilityStage from '@ohos.app.ability.AbilityStage';
import Want from '@ohos.app.ability.Want';
import { hilog } from '@kit.PerformanceAnalysisKit';

export default class MyStage extends AbilityStage {
  onCreate(): void {

  }
  onNewProcessRequest(want: Want): string {
    return '';
  }
  onAcceptWant(want: Want): string {
    let callerPidKey = 'ohos.aafwk.param.callerPid';
    hilog.info(0x0000, 'testLaunch', 'MyStage::onAcceptWant: callerPid: ' +  want.parameters![callerPidKey]);
    return '0';
  }
}