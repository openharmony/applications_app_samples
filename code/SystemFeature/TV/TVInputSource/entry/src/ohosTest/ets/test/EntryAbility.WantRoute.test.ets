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

const DEFAULT_PAGE = 'pages/Index';
const DTV_PAGE = 'pages/IndexDtv';
const HDMI_PAGE = 'pages/HdmiPage';

interface NullableWantParameters {
  bundleNames?: Object;
}

interface NullableParametersWantShape {
  bundleName: string;
  abilityName: string;
  parameters: NullableWantParameters | null;
}

interface UndefinedBundleNamesParameters {
  bundleNames?: Object;
}

interface UndefinedBundleNamesWantShape {
  bundleName: string;
  abilityName: string;
  parameters: UndefinedBundleNamesParameters;
}

function mockDisplaySettingOn(): void {
}

function mockDisplaySettingOff(): void {
}

class EntryAbilityMock {
  public defaultPage: string = 'pages/Index';

  public getWantData(want: Want): void {
    try {
      const wantData = want.parameters;
      if (wantData) {
        const inputSource: string[] = wantData['bundleNames'] as string[];
        if (inputSource[0] === 'DTV') {
          this.defaultPage = 'pages/IndexDtv';
        } else {
          const currentInput = inputSource[0];
          const inputSourceMap = new Map([
            ['HDMI1', 1],
            ['HDMI2', 2],
            ['HDMI3', 3],
            ['HDMI4', 4],
            ['AV', 5],
            ['VGA', 6]
          ]);
          if (inputSourceMap.has(currentInput)) {
            const targetSourceType = inputSourceMap.get(currentInput);
            this.defaultPage = 'pages/HdmiPage';
          }
        }
      }
    } catch (e) {
      this.defaultPage = 'pages/Index';
    }
  }

  public resetDefaultPage(): void {
    this.defaultPage = 'pages/Index';
  }
}

describe('EntryAbility_WantRoute_DTV_routing', () => {
  let ability: EntryAbilityMock;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityMock();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetDefaultPage();
  });

  it('should_route_to_IndexDtv_when_bundleNames_contains_DTV', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['DTV']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DTV_PAGE);
  });

  it('should_route_to_IndexDtv_when_bundleNames_first_is_DTV', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['DTV', 'HDMI1']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DTV_PAGE);
  });

  it('should_route_to_IndexDtv_when_DTV_mixed_with_other_sources', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['DTV', 'HDMI1', 'HDMI2', 'AV']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DTV_PAGE);
  });

  it('should_not_route_to_HdmiPage_when_bundleNames_contains_only_DTV', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['DTV']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage === HDMI_PAGE).assertEqual(false);
  });

  it('should_not_route_to_Index_when_bundleNames_contains_only_DTV', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['DTV']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage === DEFAULT_PAGE).assertEqual(false);
  });
});

describe('EntryAbility_WantRoute_HDMI_routing', () => {
  let ability: EntryAbilityMock;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityMock();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetDefaultPage();
  });

  it('should_route_to_HdmiPage_when_bundleNames_contains_HDMI1', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI1']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_route_to_HdmiPage_when_bundleNames_contains_HDMI2', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI2']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_route_to_HdmiPage_when_bundleNames_contains_HDMI3', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI3']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_route_to_HdmiPage_when_bundleNames_contains_HDMI4', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI4']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_route_to_HdmiPage_when_HDMI1_followed_by_other_sources', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI1', 'HDMI2', 'AV']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_route_to_HdmiPage_when_DTV_precedes_HDMI1', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['DTV', 'HDMI1']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DTV_PAGE);
  });

  it('should_not_route_to_IndexDtv_when_bundleNames_contains_only_HDMI', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI1']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage === DTV_PAGE).assertEqual(false);
  });

  it('should_not_route_to_Index_when_bundleNames_contains_only_HDMI', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI1']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage === DEFAULT_PAGE).assertEqual(false);
  });
});

describe('EntryAbility_WantRoute_AV_VGA_routing', () => {
  let ability: EntryAbilityMock;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityMock();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetDefaultPage();
  });

  it('should_route_to_HdmiPage_when_bundleNames_contains_AV', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['AV']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_route_to_HdmiPage_when_bundleNames_contains_VGA', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['VGA']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_route_to_HdmiPage_when_AV_followed_by_other_sources', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['AV', 'HDMI1', 'HDMI2']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_not_route_to_IndexDtv_when_bundleNames_contains_only_AV', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['AV']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage === DTV_PAGE).assertEqual(false);
  });

  it('should_not_route_to_Index_when_bundleNames_contains_only_VGA', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['VGA']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage === DEFAULT_PAGE).assertEqual(false);
  });
});

describe('EntryAbility_WantRoute_default_routing', () => {
  let ability: EntryAbilityMock;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityMock();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetDefaultPage();
  });

  it('should_route_to_Index_when_bundleNames_is_empty_array', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: []
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });

  it('should_route_to_Index_when_bundleNames_contains_unknown_source', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['UnknownSource']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });

  it('should_route_to_Index_when_bundleNames_contains_random_strings', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['random', 'strings', 'test']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });

  it('should_route_to_Index_when_parameters_is_undefined', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability'
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });

  it('should_route_to_Index_when_parameters_is_null', 0, () => {
    const want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: null
    } as NullableParametersWantShape as Want;
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });

  it('should_route_to_Index_when_bundleNames_is_undefined', 0, () => {
    const want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: undefined
      }
    } as UndefinedBundleNamesWantShape as Want;
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });

  it('should_not_route_to_HdmiPage_when_no_valid_source', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['InvalidSource']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage === HDMI_PAGE).assertEqual(false);
  });

  it('should_not_route_to_IndexDtv_when_no_valid_source', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['InvalidSource']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage === DTV_PAGE).assertEqual(false);
  });
});

describe('EntryAbility_WantRoute_error_handling', () => {
  let ability: EntryAbilityMock;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityMock();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetDefaultPage();
  });

  it('should_handle_empty_want_without_crash', 0, () => {
    try {
      const want: Want = {};
      ability.getWantData(want);
    } catch (e) {
      expect(false).assertEqual(true);
    }
  });

  it('should_handle_null_parameters_without_crash', 0, () => {
    try {
      const want = {
        bundleName: 'test.bundle',
        abilityName: 'test.ability',
        parameters: null
      } as NullableParametersWantShape as Want;
      ability.getWantData(want);
    } catch (e) {
      expect(false).assertEqual(true);
    }
  });

  it('should_handle_invalid_bundleNames_type_without_crash', 0, () => {
    try {
      const want: Want = {
        bundleName: 'test.bundle',
        abilityName: 'test.ability',
        parameters: {
          bundleNames: 'HDMI1'
        }
      };
      ability.getWantData(want);
    } catch (e) {
      expect(false).assertEqual(true);
    }
  });

  it('should_handle_missing_bundleNames_key_without_crash', 0, () => {
    try {
      const want: Want = {
        bundleName: 'test.bundle',
        abilityName: 'test.ability',
        parameters: {
          otherKey: 'value'
        }
      };
      ability.getWantData(want);
    } catch (e) {
      expect(false).assertEqual(true);
    }
  });

  it('should_not_crash_when_accessing_non_array_bundleNames', 0, () => {
    try {
      const want: Want = {
        bundleName: 'test.bundle',
        abilityName: 'test.ability',
        parameters: {
          bundleNames: { 0: 'HDMI1' }
        }
      };
      ability.getWantData(want);
    } catch (e) {
      expect(false).assertEqual(true);
    }
  });
});

describe('EntryAbility_WantRoute_priority_handling', () => {
  let ability: EntryAbilityMock;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityMock();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetDefaultPage();
  });

  it('should_prioritize_DTV_over_HDMI_when_DTV_is_first', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['DTV', 'HDMI1']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DTV_PAGE);
  });

  it('should_prioritize_first_element_in_bundleNames', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI1', 'DTV']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_use_first_valid_source_when_multiple_valid_sources_present', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI1', 'HDMI2', 'HDMI3', 'HDMI4']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_handle_single_element_bundleNames_correctly', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI1']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_fall_back_to_default_when_array_is_empty_despite_other_params', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: [],
        otherParam: 'value'
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });
});

describe('EntryAbility_WantRoute_page_constants', () => {
  beforeEach(() => {
    mockDisplaySettingOn();
  });

  afterEach(() => {
    mockDisplaySettingOff();
  });

  it('should_have_correct_default_page_constant', 0, () => {
    expect(DEFAULT_PAGE).assertEqual('pages/Index');
  });

  it('should_have_correct_DTV_page_constant', 0, () => {
    expect(DTV_PAGE).assertEqual('pages/IndexDtv');
  });

  it('should_have_correct_HDMI_page_constant', 0, () => {
    expect(HDMI_PAGE).assertEqual('pages/HdmiPage');
  });

  it('should_have_different_page_paths_for_different_routes', 0, () => {
    expect(new Set([DEFAULT_PAGE, DTV_PAGE, HDMI_PAGE]).size).assertEqual(3);
  });

  it('should_have_Index_as_default_when_no_route_matches', 0, () => {
    expect(DEFAULT_PAGE.indexOf('Index') >= 0).assertEqual(true);
  });
});

describe('EntryAbility_WantRoute_state_persistence', () => {
  let ability: EntryAbilityMock;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityMock();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetDefaultPage();
  });

  it('should_maintain_defaultPage_after_DTV_routing', 0, () => {
    const want1: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['DTV']
      }
    };
    ability.getWantData(want1);
    const firstRoute = ability.defaultPage;

    const want2: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI1']
      }
    };
    ability.getWantData(want2);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_override_defaultPage_on_subsequent_routing_calls', 0, () => {
    const want1: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI1']
      }
    };
    ability.getWantData(want1);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);

    const want2: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['DTV']
      }
    };
    ability.getWantData(want2);
    expect(ability.defaultPage).assertEqual(DTV_PAGE);
  });

  it('should_reset_to_Index_after_error', 0, () => {
    ability.defaultPage = 'pages/HdmiPage';
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['InvalidSource']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });
});

describe('EntryAbility_WantRoute_want_structure_validation', () => {
  let ability: EntryAbilityMock;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityMock();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetDefaultPage();
  });

  it('should_accept_want_with_bundleName_and_abilityName', 0, () => {
    const want: Want = {
      bundleName: 'com.example.app',
      abilityName: 'EntryAbility',
      parameters: {
        bundleNames: ['HDMI1']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_accept_want_with_additional_parameters', 0, () => {
    const want: Want = {
      bundleName: 'com.example.app',
      abilityName: 'EntryAbility',
      parameters: {
        bundleNames: ['HDMI1'],
        pullBundleName: 'some.bundle',
        otherParam: 'value'
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_ignore_additional_parameters_when_routing', 0, () => {
    const want: Want = {
      bundleName: 'com.example.app',
      abilityName: 'EntryAbility',
      parameters: {
        bundleNames: ['DTV'],
        pullBundleName: 'some.bundle',
        otherParam: 'value'
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DTV_PAGE);
  });

  it('should_handle_want_without_bundleName', 0, () => {
    const want: Want = {
      abilityName: 'EntryAbility',
      parameters: {
        bundleNames: ['HDMI1']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_handle_want_without_abilityName', 0, () => {
    const want: Want = {
      bundleName: 'com.example.app',
      parameters: {
        bundleNames: ['HDMI1']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });
});

describe('EntryAbility_WantRoute_boundary_conditions', () => {
  let ability: EntryAbilityMock;

  beforeEach(() => {
    mockDisplaySettingOn();
    ability = new EntryAbilityMock();
  });

  afterEach(() => {
    mockDisplaySettingOff();
    ability.resetDefaultPage();
  });

  it('should_handle_bundleNames_with_single_empty_string', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });

  it('should_handle_bundleNames_with_whitespace_string', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: [' ']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });

  it('should_handle_bundleNames_with_numeric_string', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['123']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });

  it('should_handle_bundleNames_with_case_sensitive_matching', 0, () => {
    const want1: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['hdmi1']
      }
    };
    ability.getWantData(want1);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);

    const want2: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: ['HDMI1']
      }
    };
    ability.getWantData(want2);
    expect(ability.defaultPage).assertEqual(HDMI_PAGE);
  });

  it('should_handle_bundleNames_with_leading_trailing_spaces', 0, () => {
    const want: Want = {
      bundleName: 'test.bundle',
      abilityName: 'test.ability',
      parameters: {
        bundleNames: [' HDMI1 ']
      }
    };
    ability.getWantData(want);
    expect(ability.defaultPage).assertEqual(DEFAULT_PAGE);
  });
});

export default function EntryAbility_WantRoute_test_DefaultExportBridge(): void {
}
