import hilog from '@ohos.hilog';
import TestRunner from '@ohos.application.testRunner';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Want from '@ohos.app.ability.Want';

let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator | undefined = undefined
let abilityDelegatorArguments: AbilityDelegatorRegistry.AbilityDelegatorArgs | undefined = undefined
const DOMAIN = 0xF811;
async function onAbilityCreateCallback() {
  hilog.info(DOMAIN, 'testTag', '%{public}s', 'onAbilityCreateCallback');
}

async function addAbilityMonitorCallback(err : Error) {
  hilog.info(DOMAIN, 'testTag', 'addAbilityMonitorCallback : %{public}s', JSON.stringify(err) ?? '');
}

export default class OpenHarmonyTestRunner implements TestRunner {
  constructor() {
  }

  onPrepare() {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'OpenHarmonyTestRunner OnPrepare ');
  }

  async onRun() {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'OpenHarmonyTestRunner onRun run');
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments()
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
    const bundleName = abilityDelegatorArguments.bundleName;
    const testAbilityName = 'TestAbility';
    let lMonitor: AbilityDelegatorRegistry.AbilityMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback,
    };
    abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback)
    const want: Want = {
      bundleName: bundleName,
      abilityName: testAbilityName
    };
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    abilityDelegator.startAbility(want, (err, data) => {
      hilog.info(DOMAIN, 'testTag', 'startAbility : err : %{public}s', JSON.stringify(err) ?? '');
      hilog.info(DOMAIN, 'testTag', 'startAbility : data : %{public}s',JSON.stringify(data) ?? '');
    })
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'OpenHarmonyTestRunner onRun end');
  }
}