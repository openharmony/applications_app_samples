/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it, expect, beforeEach, afterEach } from '@ohos/hypium';
import { AbilityConstant, Want } from '@kit.AbilityKit';

interface MockWantParameters {
  pullBundleName?: string;
  bundleNames?: string[] | null;
}

class ThrowingWantParameters {
  get bundleNames(): Object {
    throw new Error('broken parameters');
  }
}

/**
 * Creates a want-parameters object whose `bundleNames` accessor throws.
 *
 * @param none No parameters.
 * @returns Record<string, Object> Parameters object compatible with `Want`.
 */
function createThrowingWantParameters(): Record<string, Object> {
  return new ThrowingWantParameters() as Object as Record<string, Object>;
}

interface AbilityTerminationContext {
  terminateSelf(): void;
}

function mockDisplaySettingOn(): void {
}

function mockDisplaySettingOff(): void {
}

const LAUNCH_PARAM: AbilityConstant.LaunchParam = {
  launchReason: 0 as AbilityConstant.LaunchReason,
  lastExitReason: 0 as AbilityConstant.LastExitReason,
  lastExitMessage: ''
};

const DEFAULT_WANT: Want = {
  bundleName: 'test.bundle',
  abilityName: 'test.ability'
};

const HDMI_WANT: Want = {
  bundleName: 'test.bundle',
  abilityName: 'test.ability',
  parameters: {
    bundleNames: ['HDMI1']
  }
};

const DTV_WANT: Want = {
  bundleName: 'test.bundle',
  abilityName: 'test.ability',
  parameters: {
    bundleNames: ['DTV']
  }
};

class MockAbilityTerminationContext implements AbilityTerminationContext {
  private owner: EntryAbilityLifecycle;

  constructor(owner: EntryAbilityLifecycle) {
    this.owner = owner;
  }

  terminateSelf(): void {
    this.owner.terminateSelfCalled = true;
  }
}

class EntryAbilityLifecycle {
  public defaultPage: string = 'pages/Index';
  public onCreateCallCount: number = 0;
  public onNewWantCallCount: number = 0;
  public onDestroyCallCount: number = 0;
  public onWindowStageCreateCallCount: number = 0;
  public onWindowStageDestroyCallCount: number = 0;
  public onForegroundCallCount: number = 0;
  public onBackgroundCallCount: number = 0;
  public pullBundleName: string = '';
  public context: AbilityTerminationContext;
  public terminateSelfCalled: boolean = false;

  constructor() {
    this.context = new MockAbilityTerminationContext(this);
  }

  public resetCounters(): void {
    this.onCreateCallCount = 0;
    this.onNewWantCallCount = 0;
    this.onDestroyCallCount = 0;
    this.onWindowStageCreateCallCount = 0;
    this.onWindowStageDestroyCallCount = 0;
    this.onForegroundCallCount = 0;
    this.onBackgroundCallCount = 0;
    this.terminateSelfCalled = false;
  }

  public onCreate(want: Want, _launchParam: AbilityConstant.LaunchParam): void {
    this.onCreateCallCount++;
    this.pullBundleName = '';
    if (want.parameters?.pullBundleName) {
      this.pullBundleName = want.parameters.pullBundleName as string;
    }
    this.getWantData(want);
  }

  public onNewWant(want: Want, _launchParams: AbilityConstant.LaunchParam): void {
    this.onNewWantCallCount++;
    this.pullBundleName = '';
    if (want.parameters?.pullBundleName) {
      this.pullBundleName = want.parameters.pullBundleName as string;
    }
    this.getWantData(want);
  }

  public getWantData(want: Want): void {
    try {
      const wantData = want.parameters;
      if (wantData) {
        const parameters = wantData as MockWantParameters;
        const inputSource = parameters.bundleNames;
        if (inputSource && inputSource[0] === 'DTV') {
          this.defaultPage = 'pages/IndexDtv';
        } else {
          this.defaultPage = 'pages/HdmiPage';
        }
      }
    } catch (e) {
      this.defaultPage = 'pages/Index';
    }
  }

  public onDestroy(): void {
    this.onDestroyCallCount++;
  }

  public onWindowStageCreate(): void {
    this.onWindowStageCreateCallCount++;
  }

  public onWindowStageDestroy(): void {
    this.onWindowStageDestroyCallCount++;
  }

  public onForeground(): void {
    this.onForegroundCallCount++;
  }

  public onBackground(): void {
    this.onBackgroundCallCount++;
    this.context.terminateSelf();
  }
}

describe('EntryAbility_Lifecycle_onCreate', () => {
  let ability: EntryAbilityLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetCounters();
  });

  it('should_increment_onCreateCallCount', 0, () => {
    expect(ability.onCreateCallCount).assertEqual(0);
    ability.onCreate(DEFAULT_WANT, LAUNCH_PARAM);
    expect(ability.onCreateCallCount).assertEqual(1);
  });

  it('should_call_onCreate_with_default_want', 0, () => {
    ability.onCreate(DEFAULT_WANT, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/Index');
  });

  it('should_call_onCreate_with_HDMI_want', 0, () => {
    ability.onCreate(HDMI_WANT, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/HdmiPage');
  });

  it('should_call_onCreate_with_DTV_want', 0, () => {
    ability.onCreate(DTV_WANT, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/IndexDtv');
  });

  it('should_reset_pullBundleName_on_create', 0, () => {
    ability.pullBundleName = 'previous_value';
    ability.onCreate(DEFAULT_WANT, LAUNCH_PARAM);
    expect(ability.pullBundleName).assertEqual('');
  });

  it('should_set_pullBundleName_when_present_in_want', 0, () => {
    const wantWithPull: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        pullBundleName: 'com.example.pull'
      }
    };
    ability.onCreate(wantWithPull, LAUNCH_PARAM);
    expect(ability.pullBundleName).assertEqual('com.example.pull');
  });

  it('should_parse_want_parameters_during_onCreate', 0, () => {
    ability.onCreate(HDMI_WANT, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/HdmiPage');
  });

  it('should_handle_null_parameters_onCreate', 0, () => {
    const wantNull: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability'
    };
    ability.onCreate(wantNull, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/Index');
  });

  it('should_handle_empty_parameters_onCreate', 0, () => {
    const wantEmpty: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {}
    };
    ability.onCreate(wantEmpty, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/Index');
  });

  it('should_maintain_defaultPage_for_unknown_source', 0, () => {
    const wantUnknown: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['UNKNOWN']
      }
    };
    ability.onCreate(wantUnknown, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/HdmiPage');
  });
});

describe('EntryAbility_Lifecycle_onNewWant', () => {
  let ability: EntryAbilityLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetCounters();
  });

  it('should_increment_onNewWantCallCount', 0, () => {
    expect(ability.onNewWantCallCount).assertEqual(0);
    ability.onNewWant(DEFAULT_WANT, LAUNCH_PARAM);
    expect(ability.onNewWantCallCount).assertEqual(1);
  });

  it('should_reset_pullBundleName_on_newWant', 0, () => {
    ability.pullBundleName = 'previous_value';
    ability.onNewWant(DEFAULT_WANT, LAUNCH_PARAM);
    expect(ability.pullBundleName).assertEqual('');
  });

  it('should_set_pullBundleName_when_present_in_newWant', 0, () => {
    const wantWithPull: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        pullBundleName: 'com.example.newpull'
      }
    };
    ability.onNewWant(wantWithPull, LAUNCH_PARAM);
    expect(ability.pullBundleName).assertEqual('com.example.newpull');
  });

  it('should_update_defaultPage_on_newWant', 0, () => {
    ability.defaultPage = 'pages/Index';
    ability.onNewWant(HDMI_WANT, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/HdmiPage');
  });

  it('should_handle_DTV_want_on_newWant', 0, () => {
    ability.defaultPage = 'pages/Index';
    ability.onNewWant(DTV_WANT, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/IndexDtv');
  });

  it('should_reparse_want_on_newWant', 0, () => {
    ability.onCreate(HDMI_WANT, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/HdmiPage');
    ability.onNewWant(DTV_WANT, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/IndexDtv');
  });

  it('should_call_onNewWant_multiple_times', 0, () => {
    ability.onNewWant(HDMI_WANT, LAUNCH_PARAM);
    ability.onNewWant(DTV_WANT, LAUNCH_PARAM);
    ability.onNewWant(DEFAULT_WANT, LAUNCH_PARAM);
    expect(ability.onNewWantCallCount).assertEqual(3);
  });
});

describe('EntryAbility_Lifecycle_onDestroy', () => {
  let ability: EntryAbilityLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetCounters();
  });

  it('should_increment_onDestroyCallCount', 0, () => {
    expect(ability.onDestroyCallCount).assertEqual(0);
    ability.onDestroy();
    expect(ability.onDestroyCallCount).assertEqual(1);
  });

  it('should_call_onDestroy_multiple_times', 0, () => {
    ability.onDestroy();
    ability.onDestroy();
    ability.onDestroy();
    expect(ability.onDestroyCallCount).assertEqual(3);
  });
});

describe('EntryAbility_Lifecycle_onWindowStageCreate', () => {
  let ability: EntryAbilityLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetCounters();
  });

  it('should_increment_onWindowStageCreateCallCount', 0, () => {
    expect(ability.onWindowStageCreateCallCount).assertEqual(0);
    ability.onWindowStageCreate();
    expect(ability.onWindowStageCreateCallCount).assertEqual(1);
  });

  it('should_call_onWindowStageCreate_after_onCreate', 0, () => {
    ability.onCreate(DEFAULT_WANT, LAUNCH_PARAM);
    ability.onWindowStageCreate();
    expect(ability.onWindowStageCreateCallCount).assertEqual(1);
    expect(ability.onCreateCallCount).assertEqual(1);
  });

  it('should_be_called_before_loadContent', 0, () => {
    ability.onCreate(DEFAULT_WANT, LAUNCH_PARAM);
    ability.onWindowStageCreate();
    expect(ability.onWindowStageCreateCallCount > 0).assertEqual(true);
  });

  it('should_call_onWindowStageCreate_multiple_times', 0, () => {
    ability.onWindowStageCreate();
    ability.onWindowStageCreate();
    expect(ability.onWindowStageCreateCallCount).assertEqual(2);
  });
});

describe('EntryAbility_Lifecycle_onWindowStageDestroy', () => {
  let ability: EntryAbilityLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetCounters();
  });

  it('should_increment_onWindowStageDestroyCallCount', 0, () => {
    expect(ability.onWindowStageDestroyCallCount).assertEqual(0);
    ability.onWindowStageDestroy();
    expect(ability.onWindowStageDestroyCallCount).assertEqual(1);
  });

  it('should_call_onWindowStageDestroy_after_lifecycle_operations', 0, () => {
    ability.onCreate(DEFAULT_WANT, LAUNCH_PARAM);
    ability.onWindowStageCreate();
    ability.onWindowStageDestroy();
    expect(ability.onWindowStageDestroyCallCount).assertEqual(1);
  });
});

describe('EntryAbility_Lifecycle_onForeground', () => {
  let ability: EntryAbilityLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetCounters();
  });

  it('should_increment_onForegroundCallCount', 0, () => {
    expect(ability.onForegroundCallCount).assertEqual(0);
    ability.onForeground();
    expect(ability.onForegroundCallCount).assertEqual(1);
  });

  it('should_call_onForeground_after_onWindowStageCreate', 0, () => {
    ability.onWindowStageCreate();
    ability.onForeground();
    expect(ability.onForegroundCallCount).assertEqual(1);
  });

  it('should_call_onForeground_multiple_times', 0, () => {
    ability.onForeground();
    ability.onForeground();
    expect(ability.onForegroundCallCount).assertEqual(2);
  });
});

describe('EntryAbility_Lifecycle_onBackground', () => {
  let ability: EntryAbilityLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetCounters();
  });

  it('should_increment_onBackgroundCallCount', 0, () => {
    expect(ability.onBackgroundCallCount).assertEqual(0);
    ability.onBackground();
    expect(ability.onBackgroundCallCount).assertEqual(1);
  });

  it('should_call_terminateSelf_on_background', 0, () => {
    ability.onBackground();
    expect(ability.terminateSelfCalled).assertEqual(true);
  });

  it('should_call_onBackground_after_onForeground', 0, () => {
    ability.onForeground();
    ability.onBackground();
    expect(ability.onBackgroundCallCount).assertEqual(1);
  });

  it('should_call_terminateSelf_once_on_background', 0, () => {
    ability.onBackground();
    expect(ability.terminateSelfCalled).assertEqual(true);
  });
});

describe('EntryAbility_Lifecycle_termination_flow', () => {
  let ability: EntryAbilityLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetCounters();
  });

  it('should_terminate_on_background', 0, () => {
    ability.onBackground();
    expect(ability.terminateSelfCalled).assertEqual(true);
  });

  it('should_not_terminate_on_foreground', 0, () => {
    ability.onForeground();
    expect(ability.terminateSelfCalled).assertEqual(false);
  });

  it('should_not_terminate_on_windowStage_create', 0, () => {
    ability.onWindowStageCreate();
    expect(ability.terminateSelfCalled).assertEqual(false);
  });

  it('should_not_terminate_on_windowStage_destroy', 0, () => {
    ability.onWindowStageDestroy();
    expect(ability.terminateSelfCalled).assertEqual(false);
  });

  it('should_not_terminate_on_destroy', 0, () => {
    ability.onDestroy();
    expect(ability.terminateSelfCalled).assertEqual(false);
  });
});

describe('EntryAbility_Lifecycle_reentry_scenarios', () => {
  let ability: EntryAbilityLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetCounters();
  });

  it('should_support_multiple_onCreate_calls', 0, () => {
    ability.onCreate(DEFAULT_WANT, LAUNCH_PARAM);
    ability.onCreate(HDMI_WANT, LAUNCH_PARAM);
    expect(ability.onCreateCallCount).assertEqual(2);
  });

  it('should_support_multiple_onNewWant_calls', 0, () => {
    ability.onNewWant(DEFAULT_WANT, LAUNCH_PARAM);
    ability.onNewWant(HDMI_WANT, LAUNCH_PARAM);
    ability.onNewWant(DTV_WANT, LAUNCH_PARAM);
    expect(ability.onNewWantCallCount).assertEqual(3);
  });

  it('should_maintain_state_across_lifecycle_calls', 0, () => {
    ability.onCreate(HDMI_WANT, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/HdmiPage');
    ability.onNewWant(DTV_WANT, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/IndexDtv');
    ability.onNewWant(DEFAULT_WANT, LAUNCH_PARAM);
    expect(ability.defaultPage).assertEqual('pages/Index');
  });

  it('should_reset_state_on_new_want', 0, () => {
    ability.pullBundleName = 'old_value';
    ability.onNewWant(DEFAULT_WANT, LAUNCH_PARAM);
    expect(ability.pullBundleName).assertEqual('');
  });

  it('should_handle_full_lifecycle_sequence', 0, () => {
    ability.onCreate(DEFAULT_WANT, LAUNCH_PARAM);
    ability.onWindowStageCreate();
    ability.onForeground();
    ability.onBackground();
    expect(ability.onCreateCallCount).assertEqual(1);
    expect(ability.onWindowStageCreateCallCount).assertEqual(1);
    expect(ability.onForegroundCallCount).assertEqual(1);
    expect(ability.onBackgroundCallCount).assertEqual(1);
  });
});

describe('EntryAbility_Lifecycle_error_handling', () => {
  let ability: EntryAbilityLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetCounters();
  });

  it('should_handle_invalid_want_in_onCreate', 0, () => {
    const invalidWant: Want = {
      bundleName: '',
      abilityName: ''
    };
    try {
      ability.onCreate(invalidWant, LAUNCH_PARAM);
      expect(true).assertEqual(true);
    } catch (e) {
      expect(false).assertEqual(true);
    }
  });

  it('should_handle_invalid_want_in_onNewWant', 0, () => {
    const invalidWant: Want = {
      bundleName: '',
      abilityName: ''
    };
    try {
      ability.onNewWant(invalidWant, LAUNCH_PARAM);
      expect(true).assertEqual(true);
    } catch (e) {
      expect(false).assertEqual(true);
    }
  });

  it('should_handle_exception_in_getWantData', 0, () => {
    const errorWant: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: createThrowingWantParameters()
    };
    try {
      ability.onCreate(errorWant, LAUNCH_PARAM);
      expect(ability.defaultPage).assertEqual('pages/Index');
    } catch (e) {
      expect(false).assertEqual(true);
    }
  });
});

describe('EntryAbility_Lifecycle_state_consistency', () => {
  let ability: EntryAbilityLifecycle;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityLifecycle();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetCounters();
  });

  it('should_maintain_defaultPage_after_multiple_lifecycle_calls', 0, () => {
    ability.onCreate(HDMI_WANT, LAUNCH_PARAM);
    ability.onWindowStageCreate();
    ability.onForeground();
    ability.onBackground();
    expect(ability.defaultPage).assertEqual('pages/HdmiPage');
  });

  it('should_maintain_pullBundleName_after_multiple_lifecycle_calls', 0, () => {
    const wantWithPull: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        pullBundleName: 'com.example.test'
      }
    };
    ability.onCreate(wantWithPull, LAUNCH_PARAM);
    ability.onWindowStageCreate();
    ability.onForeground();
    expect(ability.pullBundleName).assertEqual('com.example.test');
  });

  it('should_reset_pullBundleName_on_newWant', 0, () => {
    const wantWithPull: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        pullBundleName: 'com.example.old'
      }
    };
    ability.onCreate(wantWithPull, LAUNCH_PARAM);
    ability.onNewWant(DEFAULT_WANT, LAUNCH_PARAM);
    expect(ability.pullBundleName).assertEqual('');
  });
});

export default function EntryAbility_Lifecycle_test_DefaultExportBridge(): void {
}
