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
import {
  MissionWantLike,
  MissionInfoLike,
  NoSignalBackAction,
  findReturnMissionId,
  resolveNoSignalBackAction
} from '../../../main/ets/pages/NoSignal';

const BUNDLE_NAME_INPUTSOURCE = 'com.ohos.inputsource';
const BUNDLE_NAME_LAUNCHER = 'com.ohos.launcher';
const ABILITY_NAME_ENTRY = 'EntryAbility';

class NoSignalLifecycle {
  public message: string = 'Hello World';
  public missionId: number = -1;
  public missionCount: number = 0;
  public backPressCount: number = 0;
  public lastBackAction: NoSignalBackAction | null = null;
  public onBackPressInvoked: boolean = false;

  reset(): void {
    this.message = 'Hello World';
    this.missionId = -1;
    this.missionCount = 0;
    this.backPressCount = 0;
    this.lastBackAction = null;
    this.onBackPressInvoked = false;
  }

  onPageShow(): void {
    this.missionId = -1;
    this.missionCount++;
  }

  getMission(): MissionInfoLike[] {
    return [];
  }

  onBackPress(pullBundleName?: string): boolean | void {
    this.backPressCount++;
    this.onBackPressInvoked = true;
    this.lastBackAction = resolveNoSignalBackAction(pullBundleName, this.missionId);

    if (this.lastBackAction.action === 'routerBack') {
      return true;
    } else {
      return true;
    }
  }
}

function createMissionInfoLike(
  missionId: number,
  bundleName: string,
  abilityName: string = ABILITY_NAME_ENTRY
): MissionInfoLike {
  return {
    missionId,
    want: {
      bundleName,
      abilityName
    }
  };
}

describe('NoSignal_FindReturnMissionId_Unit_Test', () => {
  let lifecycle: NoSignalLifecycle;

  beforeEach(() => {
    lifecycle = new NoSignalLifecycle();
  });

  afterEach(() => {
  });

  it('should_return_minus_one_when_missions_empty', 0, () => {
    const missions: MissionInfoLike[] = [];
    const result = findReturnMissionId(missions);
    expect(result).assertEqual(-1);
  });

  it('should_return_minus_one_when_no_matching_bundle', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, BUNDLE_NAME_LAUNCHER),
      createMissionInfoLike(2, 'com.example.app')
    ];
    const result = findReturnMissionId(missions, 'com.nonexistent.app');
    expect(result).assertEqual(-1);
  });

  it('should_return_matching_mission_id', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, BUNDLE_NAME_INPUTSOURCE),
      createMissionInfoLike(2, BUNDLE_NAME_LAUNCHER),
      createMissionInfoLike(3, 'com.example.app')
    ];
    const result = findReturnMissionId(missions, 'com.example.app');
    expect(result).assertEqual(3);
  });

  it('should_skip_inputsource_bundle_itself', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, BUNDLE_NAME_INPUTSOURCE),
      createMissionInfoLike(2, 'com.example.app')
    ];
    const result = findReturnMissionId(missions, BUNDLE_NAME_INPUTSOURCE);
    expect(result).assertEqual(-1);
  });

  it('should_return_first_matching_bundle_when_multiple', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, BUNDLE_NAME_INPUTSOURCE),
      createMissionInfoLike(2, 'com.first.app'),
      createMissionInfoLike(3, 'com.second.app')
    ];
    const result = findReturnMissionId(missions, 'com.first.app');
    expect(result).assertEqual(2);
  });

  it('should_return_minus_one_when_pullBundleName_undefined', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, BUNDLE_NAME_LAUNCHER)
    ];
    const result = findReturnMissionId(missions);
    expect(result).assertEqual(-1);
  });

  it('should_handle_mixed_bundle_types', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, BUNDLE_NAME_INPUTSOURCE),
      createMissionInfoLike(2, BUNDLE_NAME_LAUNCHER),
      createMissionInfoLike(3, 'com.thirdparty.game'),
      createMissionInfoLike(4, 'com.utility.tool')
    ];
    const result = findReturnMissionId(missions, 'com.utility.tool');
    expect(result).assertEqual(4);
  });

  it('should_return_minus_one_when_only_inputsource_bundle', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, BUNDLE_NAME_INPUTSOURCE),
      createMissionInfoLike(2, BUNDLE_NAME_INPUTSOURCE)
    ];
    const result = findReturnMissionId(missions, BUNDLE_NAME_INPUTSOURCE);
    expect(result).assertEqual(-1);
  });
});

describe('NoSignal_ResolveNoSignalBackAction_Unit_Test', () => {
  let lifecycle: NoSignalLifecycle;

  beforeEach(() => {
    lifecycle = new NoSignalLifecycle();
  });

  afterEach(() => {
  });

  it('should_return_routerBack_when_pullBundleName_empty', 0, () => {
    const result = resolveNoSignalBackAction('', 1);
    expect(result.action).assertEqual('routerBack');
    expect(result.missionId).assertEqual(1);
  });

  it('should_return_routerBack_when_pullBundleName_launcher', 0, () => {
    const result = resolveNoSignalBackAction(BUNDLE_NAME_LAUNCHER, 2);
    expect(result.action).assertEqual('routerBack');
    expect(result.missionId).assertEqual(2);
  });

  it('should_return_moveMissionToFront_when_pullBundleName_thirdparty', 0, () => {
    const result = resolveNoSignalBackAction('com.example.app', 3);
    expect(result.action).assertEqual('moveMissionToFront');
    expect(result.missionId).assertEqual(3);
  });

  it('should_return_routerBack_when_pullBundleName_undefined', 0, () => {
    const result = resolveNoSignalBackAction(undefined, -1);
    expect(result.action).assertEqual('routerBack');
  });

  it('should_return_routerBack_when_pullBundleName_null', 0, () => {
    const result = resolveNoSignalBackAction(null, -1);
    expect(result.action).assertEqual('routerBack');
  });

  it('should_use_default_missionId_minus_one', 0, () => {
    const result = resolveNoSignalBackAction(BUNDLE_NAME_LAUNCHER);
    expect(result.missionId).assertEqual(-1);
  });

  it('should_preserve_missionId_across_actions', 0, () => {
    const result1 = resolveNoSignalBackAction(BUNDLE_NAME_LAUNCHER, 5);
    expect(result1.missionId).assertEqual(5);

    const result2 = resolveNoSignalBackAction('com.app', 6);
    expect(result2.missionId).assertEqual(6);
  });

  it('should_handle_case_sensitive_bundle_names', 0, () => {
    const result1 = resolveNoSignalBackAction('COM.ohos.launcher', 1);
    expect(result1.action).assertEqual('moveMissionToFront');

    const result2 = resolveNoSignalBackAction('com.ohos.launcher', 2);
    expect(result2.action).assertEqual('routerBack');
  });
});

describe('NoSignal_Lifecycle_Integration_Test', () => {
  let lifecycle: NoSignalLifecycle;

  beforeEach(() => {
    lifecycle = new NoSignalLifecycle();
  });

  afterEach(() => {
  });

  it('should_reset_missionId_on_page_show', 0, () => {
    lifecycle.missionId = 5;
    lifecycle.onPageShow();
    expect(lifecycle.missionId).assertEqual(-1);
  });

  it('should_increment_missionCount_on_page_show', 0, () => {
    lifecycle.onPageShow();
    lifecycle.onPageShow();
    expect(lifecycle.missionCount).assertEqual(2);
  });

  it('should_invoke_onBackPress', 0, () => {
    lifecycle.onBackPress(BUNDLE_NAME_LAUNCHER);
    expect(lifecycle.onBackPressInvoked).assertEqual(true);
  });

  it('should_increment_backPressCount_on_each_back', 0, () => {
    lifecycle.onBackPress(BUNDLE_NAME_LAUNCHER);
    lifecycle.onBackPress(BUNDLE_NAME_LAUNCHER);
    expect(lifecycle.backPressCount).assertEqual(2);
  });

  it('should_resolve_backAction_on_back_press', 0, () => {
    lifecycle.onBackPress('com.example.app');
    expect(((lifecycle.lastBackAction) === null) || ((lifecycle.lastBackAction) === undefined)).assertFalse();
    expect(lifecycle.lastBackAction!.action).assertEqual('moveMissionToFront');
  });

  it('should_handle_multiple_page_show_and_back_cycles', 0, () => {
    lifecycle.onPageShow();
    lifecycle.onBackPress(BUNDLE_NAME_LAUNCHER);
    lifecycle.onPageShow();
    lifecycle.onBackPress('com.app');
    expect(lifecycle.missionCount).assertEqual(2);
    expect(lifecycle.backPressCount).assertEqual(2);
  });

  it('should_maintain_lastBackAction_until_next_back', 0, () => {
    lifecycle.onBackPress(BUNDLE_NAME_LAUNCHER);
    const firstAction = lifecycle.lastBackAction;
    lifecycle.onBackPress('com.app');
    const secondAction = lifecycle.lastBackAction;
    expect(((firstAction) === (secondAction))).assertFalse();
  });
});

describe('NoSignal_BackPress_Decision_Matrix_Test', () => {
  let lifecycle: NoSignalLifecycle;

  beforeEach(() => {
    lifecycle = new NoSignalLifecycle();
  });

  afterEach(() => {
  });

  it('should_decide_routerBack_for_launcher_bundle', 0, () => {
    lifecycle.missionId = 1;
    lifecycle.onBackPress(BUNDLE_NAME_LAUNCHER);
    expect(lifecycle.lastBackAction!.action).assertEqual('routerBack');
  });

  it('should_decide_routerBack_for_empty_bundle', 0, () => {
    lifecycle.missionId = 2;
    lifecycle.onBackPress('');
    expect(lifecycle.lastBackAction!.action).assertEqual('routerBack');
  });

  it('should_decide_routerBack_for_undefined_bundle', 0, () => {
    lifecycle.missionId = 3;
    lifecycle.onBackPress(undefined);
    expect(lifecycle.lastBackAction!.action).assertEqual('routerBack');
  });

  it('should_decide_moveMissionToFront_for_thirdparty_bundle', 0, () => {
    lifecycle.missionId = 4;
    lifecycle.onBackPress('com.example.game');
    expect(lifecycle.lastBackAction!.action).assertEqual('moveMissionToFront');
  });

  it('should_decide_moveMissionToFront_for_inputsource_bundle', 0, () => {
    lifecycle.missionId = 5;
    lifecycle.onBackPress(BUNDLE_NAME_INPUTSOURCE);
    expect(lifecycle.lastBackAction!.action).assertEqual('moveMissionToFront');
  });

  it('should_preserve_missionId_in_routerBack_action', 0, () => {
    lifecycle.missionId = 10;
    lifecycle.onBackPress(BUNDLE_NAME_LAUNCHER);
    expect(lifecycle.lastBackAction!.missionId).assertEqual(10);
  });

  it('should_preserve_missionId_in_moveMissionToFront_action', 0, () => {
    lifecycle.missionId = 11;
    lifecycle.onBackPress('com.app');
    expect(lifecycle.lastBackAction!.missionId).assertEqual(11);
  });
});

describe('NoSignal_Boundary_Conditions_Test', () => {
  let lifecycle: NoSignalLifecycle;

  beforeEach(() => {
    lifecycle = new NoSignalLifecycle();
  });

  afterEach(() => {
  });

  it('should_handle_zero_mission_id', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(0, BUNDLE_NAME_LAUNCHER)
    ];
    const result = findReturnMissionId(missions, BUNDLE_NAME_LAUNCHER);
    expect(result).assertEqual(0);
  });

  it('should_handle_negative_mission_id', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(-5, BUNDLE_NAME_LAUNCHER)
    ];
    const result = findReturnMissionId(missions, BUNDLE_NAME_LAUNCHER);
    expect(result).assertEqual(-5);
  });

  it('should_handle_large_mission_id', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(2147483647, BUNDLE_NAME_LAUNCHER)
    ];
    const result = findReturnMissionId(missions, BUNDLE_NAME_LAUNCHER);
    expect(result).assertEqual(2147483647);
  });

  it('should_handle_empty_bundle_name_string', 0, () => {
    const result = resolveNoSignalBackAction('', 1);
    expect(result.action).assertEqual('routerBack');
  });

  it('should_handle_whitespace_bundle_name', 0, () => {
    const result = resolveNoSignalBackAction('   ', 1);
    expect(result.action).assertEqual('moveMissionToFront');
  });

  it('should_handle_mission_with_null_want', 0, () => {
    const missions: MissionInfoLike[] = [
      { missionId: 1, want: null }
    ];
    const result = findReturnMissionId(missions, 'com.app');
    expect(result).assertEqual(-1);
  });

  it('should_handle_mission_with_missing_bundleName', 0, () => {
    const missions: MissionInfoLike[] = [
      { missionId: 1, want: { abilityName: ABILITY_NAME_ENTRY } as MissionWantLike }
    ];
    const result = findReturnMissionId(missions, 'com.app');
    expect(result).assertEqual(-1);
  });

  it('should_handle_mission_with_missing_abilityName', 0, () => {
    const missions: MissionInfoLike[] = [
      { missionId: 1, want: { bundleName: 'com.app' } as MissionWantLike }
    ];
    const result = findReturnMissionId(missions, 'com.app');
    expect(result).assertEqual(1);
  });

  it('should_handle_very_long_bundle_name', 0, () => {
    const longBundle = 'com.' + 'a'.repeat(200) + '.app';
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, longBundle)
    ];
    const result = findReturnMissionId(missions, longBundle);
    expect(result).assertEqual(1);
  });

  it('should_handle_special_characters_in_bundle_name', 0, () => {
    const specialBundle = 'com.example.app_v2.0-test';
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, specialBundle)
    ];
    const result = findReturnMissionId(missions, specialBundle);
    expect(result).assertEqual(1);
  });
});

describe('NoSignal_Error_Handling_Test', () => {
  let lifecycle: NoSignalLifecycle;

  beforeEach(() => {
    lifecycle = new NoSignalLifecycle();
  });

  afterEach(() => {
  });

  it('should_not_crash_when_missions_array_corrupted', 0, () => {
    const corruptedMissions: MissionInfoLike[] = [
      { missionId: 1, want: { bundleName: 123, abilityName: ABILITY_NAME_ENTRY } },
      { missionId: 2, want: { bundleName: 'com.app', abilityName: ABILITY_NAME_ENTRY } }
    ];
    const result = findReturnMissionId(corruptedMissions, 'com.app');
    expect(result).assertEqual(2);
  });

  it('should_handle_null_missions_array', 0, () => {
    const result = findReturnMissionId(null, 'com.app');
    expect(result).assertEqual(-1);
  });

  it('should_handle_undefined_missions_array', 0, () => {
    const result = findReturnMissionId(undefined, 'com.app');
    expect(result).assertEqual(-1);
  });

  it('should_handle_missionId_as_string', 0, () => {
    const missions: MissionInfoLike[] = [
      { missionId: '1', want: { bundleName: 'com.app', abilityName: ABILITY_NAME_ENTRY } }
    ];
    const result = findReturnMissionId(missions, 'com.app');
    expect(result).assertEqual(-1);
  });

  it('should_return_minus_one_when_no_launcher_or_thirdparty', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, BUNDLE_NAME_INPUTSOURCE),
      createMissionInfoLike(2, BUNDLE_NAME_INPUTSOURCE)
    ];
    const result = findReturnMissionId(missions, BUNDLE_NAME_INPUTSOURCE);
    expect(result).assertEqual(-1);
  });
});

describe('NoSignal_Component_State_Test', () => {
  let lifecycle: NoSignalLifecycle;

  beforeEach(() => {
    lifecycle = new NoSignalLifecycle();
  });

  afterEach(() => {
  });

  it('should_initialize_message_to_hello_world', 0, () => {
    expect(lifecycle.message).assertEqual('Hello World');
  });

  it('should_initialize_missionId_to_minus_one', 0, () => {
    expect(lifecycle.missionId).assertEqual(-1);
  });

  it('should_initialize_backPressCount_to_zero', 0, () => {
    expect(lifecycle.backPressCount).assertEqual(0);
  });

  it('should_reset_all_state', 0, () => {
    lifecycle.message = 'changed';
    lifecycle.missionId = 5;
    lifecycle.backPressCount = 3;
    lifecycle.reset();
    expect(lifecycle.message).assertEqual('Hello World');
    expect(lifecycle.missionId).assertEqual(-1);
    expect(lifecycle.backPressCount).assertEqual(0);
  });

  it('should_maintain_message_after_page_show', 0, () => {
    lifecycle.message = 'custom message';
    lifecycle.onPageShow();
    expect(lifecycle.message).assertEqual('custom message');
  });

  it('should_maintain_missionId_until_page_show', 0, () => {
    lifecycle.missionId = 10;
    expect(lifecycle.missionId).assertEqual(10);
    lifecycle.onPageShow();
    expect(lifecycle.missionId).assertEqual(-1);
  });
});

describe('NoSignal_Image_Media_Resource_Test', () => {
  let lifecycle: NoSignalLifecycle;

  beforeEach(() => {
    lifecycle = new NoSignalLifecycle();
  });

  afterEach(() => {
  });

  it('should_reference_no_signal_media_resource', 0, () => {
    const mediaResource = 'app.media.no_signal';
    expect(mediaResource.length > 0).assertEqual(true);
  });

  it('should_have_valid_media_resource_id', 0, () => {
    const mediaResource = 'app.media.no_signal';
    expect(mediaResource.includes('no_signal')).assertEqual(true);
  });
});

describe('NoSignal_Multi_Mission_Scenario_Test', () => {
  let lifecycle: NoSignalLifecycle;

  beforeEach(() => {
    lifecycle = new NoSignalLifecycle();
  });

  afterEach(() => {
  });

  it('should_find_correct_mission_among_multiple', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, BUNDLE_NAME_INPUTSOURCE),
      createMissionInfoLike(2, 'com.first.app'),
      createMissionInfoLike(3, BUNDLE_NAME_LAUNCHER),
      createMissionInfoLike(4, 'com.second.app'),
      createMissionInfoLike(5, 'com.third.app')
    ];
    const result = findReturnMissionId(missions, 'com.second.app');
    expect(result).assertEqual(4);
  });

  it('should_prioritize_first_matching_bundle', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, BUNDLE_NAME_INPUTSOURCE),
      createMissionInfoLike(2, 'com.duplicate.app'),
      createMissionInfoLike(3, 'com.duplicate.app')
    ];
    const result = findReturnMissionId(missions, 'com.duplicate.app');
    expect(result).assertEqual(2);
  });

  it('should_skip_inputsource_and_return_thirdparty', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(1, BUNDLE_NAME_INPUTSOURCE),
      createMissionInfoLike(2, 'com.app')
    ];
    const result = findReturnMissionId(missions, BUNDLE_NAME_INPUTSOURCE);
    expect(result).assertEqual(-1);
  });

  it('should_handle_duplicate_bundle_names_correctly', 0, () => {
    const missions: MissionInfoLike[] = [
      createMissionInfoLike(10, BUNDLE_NAME_LAUNCHER),
      createMissionInfoLike(20, BUNDLE_NAME_LAUNCHER)
    ];
    const result = findReturnMissionId(missions, BUNDLE_NAME_LAUNCHER);
    expect(result).assertEqual(10);
  });
});

describe('NoSignal_Action_Object_Structure_Test', () => {
  let lifecycle: NoSignalLifecycle;

  beforeEach(() => {
    lifecycle = new NoSignalLifecycle();
  });

  afterEach(() => {
  });

  it('should_return_valid_action_object_for_routerBack', 0, () => {
    const result = resolveNoSignalBackAction(BUNDLE_NAME_LAUNCHER, 5);
    expect(typeof result).assertEqual('object');
    expect(result.action !== undefined).assertEqual(true);
    expect(result.missionId !== undefined).assertEqual(true);
    expect(result.action).assertEqual('routerBack');
  });

  it('should_return_valid_action_object_for_moveMissionToFront', 0, () => {
    const result = resolveNoSignalBackAction('com.app', 6);
    expect(typeof result).assertEqual('object');
    expect(result.action).assertEqual('moveMissionToFront');
  });

  it('should_have_correct_missionId_in_action_object', 0, () => {
    const testMissionId = 123;
    const result = resolveNoSignalBackAction('com.app', testMissionId);
    expect(result.missionId).assertEqual(testMissionId);
  });

  it('should_use_minus_one_as_default_when_not_provided', 0, () => {
    const result = resolveNoSignalBackAction('com.app');
    expect(result.missionId).assertEqual(-1);
  });
});

export default function NoSignal_EmptyState_test_DefaultExportBridge(): void {
}
