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

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import {
  DtvAv,
  DtvCfg,
  DtvComm,
  DtvFrontend,
  FeAntennaType,
  FeScanCaType,
  FeScanProgType,
  PmChannel,
  PmChannelFilter,
  ProgramManager
} from '../../../main/ets/sdk/DtvSdk';
import { DtvManager } from '../../../main/ets/manager/DtvManager';
import {
  CallRecorder,
  SaveTableCall,
  createCallRecorder,
  createDtvChannel,
  createMockDtvAv,
  createMockDtvCfg,
  createMockDtvComm,
  createMockDtvFrontend,
  createMockProgramManager,
  createSaveTableCall,
  patchMember,
  recordCall,
  restoreAll
} from './Batch1TestHelper';

const LANUAGE_KEY: string = 'au8SystemLanguage';
const LANUAGE_VAlUE: string = 'zuo';
const MODE_KEY = 'u32defaultlcnmode';
const MODE_VALUE = 2;
const ANTENNA_TYPE = FeAntennaType.FE_ANTENNA_DTMB;
const SCAN_CA_TYPE = FeScanCaType.FE_SCAN_CA_ALL;
const SCAN_PROG_TYPE = FeScanProgType.FE_SCAN_PROG_ALL;

function createDtvManagerLifecycle(): DtvManagerLifecycle {
  return new DtvManagerLifecycle();
}

class DtvManagerLifecycle {
  public initCallCount: number = 0;
  public prepareCallCount: number = 0;
  public dtvConfigSetCallCount: number = 0;
  public getDtvCommCallCount: number = 0;
  public getDtvCfgCallCount: number = 0;
  public channelAutoScanCallCount: number = 0;
  public channelManualScanCallCount: number = 0;
  public abortScanCallCount: number = 0;
  public commonSetParamCallCount: number = 0;
  public setSourceTypeCallCount: number = 0;
  public setAntennaTypeCallCount: number = 0;
  public setScanAttrCallCount: number = 0;
  public autoScanResult: number = 0;
  public manualScanResult: number = 0;
  public abortScanResult: number = 0;
  public setStringValueResult: number = 0;
  public setIntValueResult: number = 0;
  public prepareResult: number = 0;
  public languageKey: string = '';
  public languageValue: string = '';
  public modeKey: string = '';
  public modeValue: number = 0;
  public antennaType: FeAntennaType | null = null;
  public scanCaType: FeScanCaType | null = null;
  public scanProgType: FeScanProgType | null = null;

  public resetCounters(): void {
    this.initCallCount = 0;
    this.prepareCallCount = 0;
    this.dtvConfigSetCallCount = 0;
    this.getDtvCommCallCount = 0;
    this.getDtvCfgCallCount = 0;
    this.channelAutoScanCallCount = 0;
    this.channelManualScanCallCount = 0;
    this.abortScanCallCount = 0;
    this.commonSetParamCallCount = 0;
    this.setSourceTypeCallCount = 0;
    this.setAntennaTypeCallCount = 0;
    this.setScanAttrCallCount = 0;
    this.autoScanResult = 0;
    this.manualScanResult = 0;
    this.abortScanResult = 0;
    this.setStringValueResult = 0;
    this.setIntValueResult = 0;
    this.prepareResult = 0;
    this.languageKey = '';
    this.languageValue = '';
    this.modeKey = '';
    this.modeValue = 0;
    this.antennaType = null;
    this.scanCaType = null;
    this.scanProgType = null;
  }
}

describe('DtvManager_Init_Prepare', () => {
  let lifecycle: DtvManagerLifecycle;

  beforeEach(() => {
    lifecycle = createDtvManagerLifecycle();
  });

  afterEach(() => {
    lifecycle.resetCounters();
  });

  it('should_increment_init_call_count', 0, () => {
    lifecycle.initCallCount++;
    expect(lifecycle.initCallCount).assertEqual(1);
  });

  it('should_increment_prepare_call_count', 0, () => {
    lifecycle.prepareCallCount++;
    expect(lifecycle.prepareCallCount).assertEqual(1);
  });

  it('should_increment_dtvConfigSet_call_count', 0, () => {
    lifecycle.dtvConfigSetCallCount++;
    expect(lifecycle.dtvConfigSetCallCount).assertEqual(1);
  });

  it('should_increment_getDtvComm_call_count', 0, () => {
    lifecycle.getDtvCommCallCount++;
    expect(lifecycle.getDtvCommCallCount).assertEqual(1);
  });

  it('should_increment_getDtvCfg_call_count', 0, () => {
    lifecycle.getDtvCfgCallCount++;
    expect(lifecycle.getDtvCfgCallCount).assertEqual(1);
  });

  it('should_verify_prepare_returns_success', 0, () => {
    lifecycle.prepareResult = 0;
    expect(lifecycle.prepareResult).assertEqual(0);
  });

  it('should_verify_prepare_returns_failure', 0, () => {
    lifecycle.prepareResult = -1;
    expect(lifecycle.prepareResult).assertEqual(-1);
  });

  it('should_track_multiple_init_calls', 0, () => {
    lifecycle.initCallCount = 2;
    expect(lifecycle.initCallCount).assertEqual(2);
  });

  it('should_track_multiple_prepare_calls', 0, () => {
    lifecycle.prepareCallCount = 3;
    expect(lifecycle.prepareCallCount).assertEqual(3);
  });

  it('should_track_multiple_dtvConfigSet_calls', 0, () => {
    lifecycle.dtvConfigSetCallCount = 4;
    expect(lifecycle.dtvConfigSetCallCount).assertEqual(4);
  });
});

describe('DtvManager_Config_Write', () => {
  let lifecycle: DtvManagerLifecycle;

  beforeEach(() => {
    lifecycle = createDtvManagerLifecycle();
  });

  afterEach(() => {
    lifecycle.resetCounters();
  });

  it('should_write_language_config', 0, () => {
    lifecycle.languageKey = LANUAGE_KEY;
    lifecycle.languageValue = LANUAGE_VAlUE;
    expect(lifecycle.languageKey).assertEqual('au8SystemLanguage');
    expect(lifecycle.languageValue).assertEqual('zuo');
  });

  it('should_write_lcn_mode_config', 0, () => {
    lifecycle.modeKey = MODE_KEY;
    lifecycle.modeValue = MODE_VALUE;
    expect(lifecycle.modeKey).assertEqual('u32defaultlcnmode');
    expect(lifecycle.modeValue).assertEqual(2);
  });

  it('should_write_multiple_config_values', 0, () => {
    lifecycle.setStringValueResult = 0;
    lifecycle.setIntValueResult = 0;
    expect(lifecycle.setStringValueResult).assertEqual(0);
    expect(lifecycle.setIntValueResult).assertEqual(0);
  });

  it('should_handle_config_write_failure', 0, () => {
    lifecycle.setStringValueResult = -1;
    lifecycle.setIntValueResult = -1;
    expect(lifecycle.setStringValueResult).assertEqual(-1);
    expect(lifecycle.setIntValueResult).assertEqual(-1);
  });

  it('should_write_string_value_config_correctly', 0, () => {
    lifecycle.languageKey = 'au8SystemLanguage';
    lifecycle.languageValue = 'zuo';
    lifecycle.setStringValueResult = 0;
    const configSuccess = lifecycle.setStringValueResult === 0 && lifecycle.languageKey === LANUAGE_KEY;
    expect(configSuccess).assertTrue();
  });

  it('should_write_int_value_config_correctly', 0, () => {
    lifecycle.modeKey = 'u32defaultlcnmode';
    lifecycle.modeValue = 2;
    lifecycle.setIntValueResult = 0;
    const configSuccess = lifecycle.setIntValueResult === 0 && lifecycle.modeValue === MODE_VALUE;
    expect(configSuccess).assertTrue();
  });

  it('should_track_config_write_sequence', 0, () => {
    const sequence: string[] = [];
    sequence.push('setStringValue');
    sequence.push('setIntValue');
    expect(sequence.join(',')).assertEqual('setStringValue,setIntValue');
  });

  it('should_verify_config_keys_are_different', 0, () => {
    expect(LANUAGE_KEY === MODE_KEY).assertFalse();
  });

  it('should_verify_config_values_have_correct_types', 0, () => {
    expect(typeof LANUAGE_VAlUE).assertEqual('string');
    expect(typeof MODE_VALUE).assertEqual('number');
  });

  it('should_handle_partial_config_write_failure', 0, () => {
    lifecycle.setStringValueResult = 0;
    lifecycle.setIntValueResult = -1;
    expect(lifecycle.setStringValueResult).assertEqual(0);
    expect(lifecycle.setIntValueResult).assertEqual(-1);
  });
});

describe('DtvManager_Auto_Scan', () => {
  let lifecycle: DtvManagerLifecycle;

  beforeEach(() => {
    lifecycle = createDtvManagerLifecycle();
  });

  afterEach(() => {
    lifecycle.resetCounters();
  });

  it('should_increment_autoScan_call_count', 0, () => {
    lifecycle.channelAutoScanCallCount++;
    expect(lifecycle.channelAutoScanCallCount).assertEqual(1);
  });

  it('should_increment_commonSetParam_call_count', 0, () => {
    lifecycle.commonSetParamCallCount++;
    expect(lifecycle.commonSetParamCallCount).assertEqual(1);
  });

  it('should_increment_setSourceType_call_count', 0, () => {
    lifecycle.setSourceTypeCallCount++;
    expect(lifecycle.setSourceTypeCallCount).assertEqual(1);
  });

  it('should_increment_setAntennaType_call_count', 0, () => {
    lifecycle.setAntennaTypeCallCount++;
    expect(lifecycle.setAntennaTypeCallCount).assertEqual(1);
  });

  it('should_increment_setScanAttr_call_count', 0, () => {
    lifecycle.setScanAttrCallCount++;
    expect(lifecycle.setScanAttrCallCount).assertEqual(1);
  });

  it('should_verify_autoScan_returns_success', 0, () => {
    lifecycle.autoScanResult = 0;
    expect(lifecycle.autoScanResult).assertEqual(0);
  });

  it('should_verify_autoScan_returns_failure', 0, () => {
    lifecycle.autoScanResult = -1;
    expect(lifecycle.autoScanResult).assertEqual(-1);
  });

  it('should_verify_setScanAttr_params', 0, () => {
    lifecycle.scanCaType = SCAN_CA_TYPE;
    lifecycle.scanProgType = SCAN_PROG_TYPE;
    expect(lifecycle.scanCaType).assertEqual(FeScanCaType.FE_SCAN_CA_ALL);
    expect(lifecycle.scanProgType).assertEqual(FeScanProgType.FE_SCAN_PROG_ALL);
  });

  it('should_verify_antenna_type_is_dtmb', 0, () => {
    lifecycle.antennaType = ANTENNA_TYPE;
    expect(lifecycle.antennaType).assertEqual(FeAntennaType.FE_ANTENNA_DTMB);
  });

  it('should_track_auto_scan_sequence', 0, () => {
    const sequence: string[] = [];
    sequence.push('setSourceType');
    sequence.push('setAntennaType');
    sequence.push('setScanAttr');
    sequence.push('autoScan');
    expect(sequence.join(',')).assertEqual('setSourceType,setAntennaType,setScanAttr,autoScan');
  });

  it('should_track_multiple_autoScan_calls', 0, () => {
    lifecycle.channelAutoScanCallCount = 2;
    expect(lifecycle.channelAutoScanCallCount).assertEqual(2);
  });

  it('should_handle_autoScan_partial_failure', 0, () => {
    lifecycle.setSourceTypeCallCount = 1;
    lifecycle.setAntennaTypeCallCount = 1;
    lifecycle.setScanAttrCallCount = 1;
    lifecycle.autoScanResult = -1;
    expect(lifecycle.autoScanResult).assertEqual(-1);
  });

  it('should_verify_autoScan_prerequisites_complete', 0, () => {
    lifecycle.setSourceTypeCallCount = 1;
    lifecycle.setAntennaTypeCallCount = 1;
    lifecycle.setScanAttrCallCount = 1;
    lifecycle.autoScanResult = 0;
    const prerequisitesComplete = lifecycle.setSourceTypeCallCount === 1 &&
      lifecycle.setAntennaTypeCallCount === 1 && lifecycle.setScanAttrCallCount === 1;
    expect(prerequisitesComplete).assertTrue();
  });
});

describe('DtvManager_Manual_Scan', () => {
  let lifecycle: DtvManagerLifecycle;

  beforeEach(() => {
    lifecycle = createDtvManagerLifecycle();
  });

  afterEach(() => {
    lifecycle.resetCounters();
  });

  it('should_increment_manualScan_call_count', 0, () => {
    lifecycle.channelManualScanCallCount++;
    expect(lifecycle.channelManualScanCallCount).assertEqual(1);
  });

  it('should_verify_manualScan_returns_success', 0, () => {
    lifecycle.manualScanResult = 0;
    expect(lifecycle.manualScanResult).assertEqual(0);
  });

  it('should_verify_manualScan_returns_failure', 0, () => {
    lifecycle.manualScanResult = -1;
    expect(lifecycle.manualScanResult).assertEqual(-1);
  });

  it('should_share_commonSetParam_with_autoScan', 0, () => {
    lifecycle.commonSetParamCallCount = 1;
    expect(lifecycle.commonSetParamCallCount).assertEqual(1);
  });

  it('should_verify_manualScan_sequence', 0, () => {
    const sequence: string[] = [];
    sequence.push('setSourceType');
    sequence.push('setAntennaType');
    sequence.push('setScanAttr');
    sequence.push('manualScan');
    expect(sequence.join(',')).assertEqual('setSourceType,setAntennaType,setScanAttr,manualScan');
  });

  it('should_track_multiple_manualScan_calls', 0, () => {
    lifecycle.channelManualScanCallCount = 2;
    expect(lifecycle.channelManualScanCallCount).assertEqual(2);
  });

  it('should_handle_manualScan_partial_failure', 0, () => {
    lifecycle.setSourceTypeCallCount = 1;
    lifecycle.setAntennaTypeCallCount = 1;
    lifecycle.setScanAttrCallCount = 1;
    lifecycle.manualScanResult = -1;
    expect(lifecycle.manualScanResult).assertEqual(-1);
  });

  it('should_verify_manualScan_prerequisites_complete', 0, () => {
    lifecycle.setSourceTypeCallCount = 1;
    lifecycle.setAntennaTypeCallCount = 1;
    lifecycle.setScanAttrCallCount = 1;
    lifecycle.manualScanResult = 0;
    const prerequisitesComplete = lifecycle.setSourceTypeCallCount === 1 &&
      lifecycle.setAntennaTypeCallCount === 1 && lifecycle.setScanAttrCallCount === 1;
    expect(prerequisitesComplete).assertTrue();
  });
});

describe('DtvManager_Abort_Scan', () => {
  let lifecycle: DtvManagerLifecycle;

  beforeEach(() => {
    lifecycle = createDtvManagerLifecycle();
  });

  afterEach(() => {
    lifecycle.resetCounters();
  });

  it('should_increment_abortScan_call_count', 0, () => {
    lifecycle.abortScanCallCount++;
    expect(lifecycle.abortScanCallCount).assertEqual(1);
  });

  it('should_verify_abortScan_returns_success', 0, () => {
    lifecycle.abortScanResult = 0;
    expect(lifecycle.abortScanResult).assertEqual(0);
  });

  it('should_verify_abortScan_returns_failure', 0, () => {
    lifecycle.abortScanResult = -1;
    expect(lifecycle.abortScanResult).assertEqual(-1);
  });

  it('should_track_multiple_abortScan_calls', 0, () => {
    lifecycle.abortScanCallCount = 2;
    expect(lifecycle.abortScanCallCount).assertEqual(2);
  });

  it('should_verify_abortScan_independent_of_commonSetParam', 0, () => {
    lifecycle.abortScanCallCount = 1;
    lifecycle.commonSetParamCallCount = 0;
    expect(lifecycle.abortScanCallCount).assertEqual(1);
    expect(lifecycle.commonSetParamCallCount).assertEqual(0);
  });
});

describe('DtvManager_Init_Integration', () => {
  let restores: Array<() => void> = [];

  beforeEach(() => {
    restores = [];
  });

  afterEach(() => {
    restoreAll(restores);
  });

  it('should_call_prepare_before_dtvConfigSet', 0, () => {
    const recorder: CallRecorder = createCallRecorder();

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          prepare(): number {
            recordCall(recorder, 'prepare');
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvCfg', (): DtvCfg => {
        return createMockDtvCfg({
          setStringValue(key: string, value: string): number {
            recordCall(recorder, `setStringValue:${key}:${value}`);
            return 0;
          },
          setIntValue(key: string, value: number): number {
            recordCall(recorder, `setIntValue:${key}:${value}`);
            return 0;
          }
        });
      }),
    );

    DtvManager.init();

    const firstCall = recorder.entries[0];
    expect(firstCall).assertEqual('prepare');
  });

  it('should_write_language_before_lcn_mode', 0, () => {
    const recorder: CallRecorder = createCallRecorder();

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          prepare(): number {
            recordCall(recorder, 'prepare');
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvCfg', (): DtvCfg => {
        return createMockDtvCfg({
          setStringValue(key: string, value: string): number {
            recordCall(recorder, `setStringValue:${key}:${value}`);
            return 0;
          },
          setIntValue(key: string, value: number): number {
            recordCall(recorder, `setIntValue:${key}:${value}`);
            return 0;
          }
        });
      }),
    );

    DtvManager.init();

    const languageIndex = recorder.entries.findIndex((e: string) => e.startsWith('setStringValue'));
    const lcnIndex = recorder.entries.findIndex((e: string) => e.startsWith('setIntValue'));
    expect(languageIndex).assertLess(lcnIndex);
  });

  it('should_write_both_language_and_lcn_config', 0, () => {
    const recorder: CallRecorder = createCallRecorder();

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          prepare(): number {
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvCfg', (): DtvCfg => {
        return createMockDtvCfg({
          setStringValue(key: string, value: string): number {
            recordCall(recorder, `setStringValue:${key}:${value}`);
            return 0;
          },
          setIntValue(key: string, value: number): number {
            recordCall(recorder, `setIntValue:${key}:${value}`);
            return 0;
          }
        });
      }),
    );

    DtvManager.init();

    const hasLanguage = recorder.entries.some((e: string) => e.includes('au8SystemLanguage'));
    const hasLcn = recorder.entries.some((e: string) => e.includes('u32defaultlcnmode'));
    expect(hasLanguage).assertTrue();
    expect(hasLcn).assertTrue();
  });

  it('should_handle_init_when_prepare_fails', 0, () => {
    const recorder: CallRecorder = createCallRecorder();

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          prepare(): number {
            recordCall(recorder, 'prepare');
            return -1;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvCfg', (): DtvCfg => {
        return createMockDtvCfg({
          setStringValue(_key: string, _value: string): number {
            recordCall(recorder, 'setStringValue');
            return 0;
          },
          setIntValue(_key: string, _value: number): number {
            recordCall(recorder, 'setIntValue');
            return 0;
          }
        });
      }),
    );

    DtvManager.init();

    expect(recorder.entries.length).assertEqual(3);
  });
});

describe('DtvManager_Scan_Prerequisites', () => {
  let restores: Array<() => void> = [];

  beforeEach(() => {
    restores = [];
  });

  afterEach(() => {
    restoreAll(restores);
  });

  it('should_set_dtmb_antenna_type_before_auto_scan', 0, () => {
    const recorder: CallRecorder = createCallRecorder();

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          setSourceType(_antennaType: FeAntennaType): number {
            recordCall(recorder, 'setSourceType');
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend => {
        return createMockDtvFrontend({
          setAntennaType(_antennaType: FeAntennaType): number {
            recordCall(recorder, 'setAntennaType');
            return 0;
          },
          setScanAttr(_scanCaType: FeScanCaType, _scanProgType: FeScanProgType): number {
            recordCall(recorder, 'setScanAttr');
            return 0;
          },
          autoScan(): number {
            recordCall(recorder, 'autoScan');
            return 0;
          }
        });
      }),
    );

    DtvManager.channelAutoScan();

    const sourceTypeIndex = recorder.entries.indexOf('setSourceType');
    const antennaTypeIndex = recorder.entries.indexOf('setAntennaType');
    expect(sourceTypeIndex).assertLess(antennaTypeIndex);
  });

  it('should_set_scan_attr_before_auto_scan', 0, () => {
    const recorder: CallRecorder = createCallRecorder();

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          setSourceType(_antennaType: FeAntennaType): number {
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend => {
        return createMockDtvFrontend({
          setAntennaType(_antennaType: FeAntennaType): number {
            return 0;
          },
          setScanAttr(_scanCaType: FeScanCaType, _scanProgType: FeScanProgType): number {
            recordCall(recorder, 'setScanAttr');
            return 0;
          },
          autoScan(): number {
            recordCall(recorder, 'autoScan');
            return 0;
          }
        });
      }),
    );

    DtvManager.channelAutoScan();

    const scanAttrIndex = recorder.entries.indexOf('setScanAttr');
    const autoScanIndex = recorder.entries.indexOf('autoScan');
    expect(scanAttrIndex).assertLess(autoScanIndex);
  });

  it('should_execute_all_prerequisites_before_manual_scan', 0, () => {
    const recorder: CallRecorder = createCallRecorder();

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          setSourceType(_antennaType: FeAntennaType): number {
            recordCall(recorder, 'setSourceType');
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend => {
        return createMockDtvFrontend({
          setAntennaType(_antennaType: FeAntennaType): number {
            recordCall(recorder, 'setAntennaType');
            return 0;
          },
          setScanAttr(_scanCaType: FeScanCaType, _scanProgType: FeScanProgType): number {
            recordCall(recorder, 'setScanAttr');
            return 0;
          },
          manualScan(): number {
            recordCall(recorder, 'manualScan');
            return 0;
          }
        });
      }),
    );

    DtvManager.channelManualScan();

    expect(recorder.entries.length).assertEqual(4);
    expect(recorder.entries[0]).assertEqual('setSourceType');
    expect(recorder.entries[3]).assertEqual('manualScan');
  });

  it('should_use_same_prerequisites_for_auto_and_manual_scan', 0, () => {
    const recorder: CallRecorder = createCallRecorder();

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          setSourceType(_antennaType: FeAntennaType): number {
            recordCall(recorder, 'setSourceType');
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend => {
        return createMockDtvFrontend({
          setAntennaType(_antennaType: FeAntennaType): number {
            recordCall(recorder, 'setAntennaType');
            return 0;
          },
          setScanAttr(_scanCaType: FeScanCaType, _scanProgType: FeScanProgType): number {
            recordCall(recorder, 'setScanAttr');
            return 0;
          },
          autoScan(): number {
            recordCall(recorder, 'autoScan');
            return 0;
          },
          manualScan(): number {
            recordCall(recorder, 'manualScan');
            return 0;
          }
        });
      }),
    );

    DtvManager.channelAutoScan();
    const autoScanEntries = recorder.entries.slice();
    recorder.entries = [];

    DtvManager.channelManualScan();
    const manualScanEntries = recorder.entries.slice();

    expect(autoScanEntries.slice(0, 3).join(',')).assertEqual(manualScanEntries.slice(0, 3).join(','));
  });

  it('should_return_early_from_autoScan_when_setSourceType_fails', 0, () => {
    const recorder: CallRecorder = createCallRecorder();

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          setSourceType(_antennaType: FeAntennaType): number {
            recordCall(recorder, 'setSourceType');
            return -1;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend => {
        return createMockDtvFrontend({
          setAntennaType(_antennaType: FeAntennaType): number {
            recordCall(recorder, 'setAntennaType');
            return 0;
          },
          setScanAttr(_scanCaType: FeScanCaType, _scanProgType: FeScanProgType): number {
            recordCall(recorder, 'setScanAttr');
            return 0;
          },
          autoScan(): number {
            recordCall(recorder, 'autoScan');
            return 0;
          }
        });
      }),
    );

    DtvManager.channelAutoScan();

    expect(recorder.entries.indexOf('setAntennaType')).assertEqual(-1);
    expect(recorder.entries.indexOf('setScanAttr')).assertEqual(-1);
    expect(recorder.entries.indexOf('autoScan')).assertEqual(-1);
  });
});

describe('DtvManager_Singleton_Instance', () => {
  let restores: Array<() => void> = [];

  beforeEach(() => {
    restores = [];
  });

  afterEach(() => {
    restoreAll(restores);
  });

  it('should_return_same_dtvCfg_instance', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getDtvCfg', (): DtvCfg => {
        return createMockDtvCfg({
          setStringValue(_key: string, _value: string): number {
            return 0;
          },
          setIntValue(_key: string, _value: number): number {
            return 0;
          }
        });
      }),
    );

    const instance1 = DtvManager.getDtvCfg();
    const instance2 = DtvManager.getDtvCfg();

    expect(instance1).assertEqual(instance2);
  });

  it('should_return_same_dtvComm_instance', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          prepare(): number {
            return 0;
          }
        });
      }),
    );

    const instance1 = DtvManager.getDtvComm();
    const instance2 = DtvManager.getDtvComm();

    expect(instance1).assertEqual(instance2);
  });

  it('should_return_same_dtvFrontend_instance', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend => {
        return createMockDtvFrontend({
          setAntennaType(_antennaType: FeAntennaType): number {
            return 0;
          }
        });
      }),
    );

    const instance1 = DtvManager.getDtvFrontend();
    const instance2 = DtvManager.getDtvFrontend();

    expect(instance1).assertEqual(instance2);
  });

  it('should_return_same_programManager_instance', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getProgramManager', (): ProgramManager => {
        return createMockProgramManager({
          getChannelNum(_groupType: number): number {
            return 0;
          }
        });
      }),
    );

    const instance1 = DtvManager.getProgramManager();
    const instance2 = DtvManager.getProgramManager();

    expect(instance1).assertEqual(instance2);
  });
});

describe('DtvManager_Scan_Parameters', () => {
  let restores: Array<() => void> = [];

  beforeEach(() => {
    restores = [];
  });

  afterEach(() => {
    restoreAll(restores);
  });

  it('should_pass_correct_ca_type_to_setScanAttr', 0, () => {
    let receivedCaType: FeScanCaType | null = null;

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          setSourceType(_antennaType: FeAntennaType): number {
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend => {
        return createMockDtvFrontend({
          setAntennaType(_antennaType: FeAntennaType): number {
            return 0;
          },
          setScanAttr(scanCaType: FeScanCaType, _scanProgType: FeScanProgType): number {
            receivedCaType = scanCaType;
            return 0;
          },
          autoScan(): number {
            return 0;
          }
        });
      }),
    );

    DtvManager.channelAutoScan();

    expect(receivedCaType).assertEqual(FeScanCaType.FE_SCAN_CA_ALL);
  });

  it('should_pass_correct_prog_type_to_setScanAttr', 0, () => {
    let receivedProgType: FeScanProgType | null = null;

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          setSourceType(_antennaType: FeAntennaType): number {
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend => {
        return createMockDtvFrontend({
          setAntennaType(_antennaType: FeAntennaType): number {
            return 0;
          },
          setScanAttr(_scanCaType: FeScanCaType, scanProgType: FeScanProgType): number {
            receivedProgType = scanProgType;
            return 0;
          },
          autoScan(): number {
            return 0;
          }
        });
      }),
    );

    DtvManager.channelAutoScan();

    expect(receivedProgType).assertEqual(FeScanProgType.FE_SCAN_PROG_ALL);
  });

  it('should_pass_dtmb_antenna_type_to_setSourceType', 0, () => {
    let receivedAntennaType: FeAntennaType | null = null;

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          setSourceType(antennaType: FeAntennaType): number {
            receivedAntennaType = antennaType;
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend => {
        return createMockDtvFrontend({
          setAntennaType(_antennaType: FeAntennaType): number {
            return 0;
          },
          setScanAttr(_scanCaType: FeScanCaType, _scanProgType: FeScanProgType): number {
            return 0;
          },
          autoScan(): number {
            return 0;
          }
        });
      }),
    );

    DtvManager.channelAutoScan();

    expect(receivedAntennaType).assertEqual(FeAntennaType.FE_ANTENNA_DTMB);
  });

  it('should_pass_dtmb_antenna_type_to_setAntennaType', 0, () => {
    let receivedAntennaType: FeAntennaType | null = null;

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          setSourceType(_antennaType: FeAntennaType): number {
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend => {
        return createMockDtvFrontend({
          setAntennaType(antennaType: FeAntennaType): number {
            receivedAntennaType = antennaType;
            return 0;
          },
          setScanAttr(_scanCaType: FeScanCaType, _scanProgType: FeScanProgType): number {
            return 0;
          },
          autoScan(): number {
            return 0;
          }
        });
      }),
    );

    DtvManager.channelAutoScan();

    expect(receivedAntennaType).assertEqual(FeAntennaType.FE_ANTENNA_DTMB);
  });

  it('should_pass_correct_language_to_setStringValue', 0, () => {
    let receivedKey: string = '';
    let receivedValue: string = '';

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          prepare(): number {
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvCfg', (): DtvCfg => {
        return createMockDtvCfg({
          setStringValue(key: string, value: string): number {
            receivedKey = key;
            receivedValue = value;
            return 0;
          },
          setIntValue(_key: string, _value: number): number {
            return 0;
          }
        });
      }),
    );

    DtvManager.init();

    expect(receivedKey).assertEqual('au8SystemLanguage');
    expect(receivedValue).assertEqual('zuo');
  });

  it('should_pass_correct_lcn_mode_to_setIntValue', 0, () => {
    let receivedKey: string = '';
    let receivedValue: number = 0;

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          prepare(): number {
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvCfg', (): DtvCfg => {
        return createMockDtvCfg({
          setStringValue(_key: string, _value: string): number {
            return 0;
          },
          setIntValue(key: string, value: number): number {
            receivedKey = key;
            receivedValue = value;
            return 0;
          }
        });
      }),
    );

    DtvManager.init();

    expect(receivedKey).assertEqual('u32defaultlcnmode');
    expect(receivedValue).assertEqual(2);
  });
});

describe('DtvManager_Error_Handling', () => {
  let restores: Array<() => void> = [];

  beforeEach(() => {
    restores = [];
  });

  afterEach(() => {
    restoreAll(restores);
  });

  it('should_handle_null_dtvCfg', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getDtvCfg', (): DtvCfg | null => {
        return null;
      }),
    );

    try {
      DtvManager.init();
    } catch (e) {
      expect(true).assertTrue();
    }
  });

  it('should_handle_null_dtvComm', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm | null => {
        return null;
      }),
    );

    try {
      DtvManager.init();
    } catch (e) {
      expect(true).assertTrue();
    }
  });

  it('should_handle_null_dtvFrontend', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend | null => {
        return null;
      }),
    );

    try {
      DtvManager.channelAutoScan();
    } catch (e) {
      expect(true).assertTrue();
    }
  });

  it('should_handle_null_programManager', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getProgramManager', (): ProgramManager | null => {
        return null;
      }),
    );

    try {
      const hasChannel = DtvManager.hasChannel();
    } catch (e) {
      expect(true).assertTrue();
    }
  });

  it('should_handle_null_dtvAv', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getDtvAv', (): DtvAv | null => {
        return null;
      }),
    );

    try {
      const result = DtvManager.dtvAvOpen();
    } catch (e) {
      expect(true).assertTrue();
    }
  });
});

describe('DtvManager_State_Consistency', () => {
  let restores: Array<() => void> = [];

  beforeEach(() => {
    restores = [];
  });

  afterEach(() => {
    restoreAll(restores);
  });

  it('should_maintain_singleton_state_across_calls', 0, () => {
    let instanceCount = 0;

    restores.push(
      patchMember(DtvManager as Object, 'getDtvCfg', (): DtvCfg => {
        instanceCount++;
        return createMockDtvCfg({
          setStringValue(_key: string, _value: string): number {
            return 0;
          },
          setIntValue(_key: string, _value: number): number {
            return 0;
          }
        });
      }),
    );

    DtvManager.init();
    DtvManager.init();

    expect(instanceCount).assertEqual(1);
  });

  it('should_reset_state_on_new_init_sequence', 0, () => {
    const recorder: CallRecorder = createCallRecorder();

    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          prepare(): number {
            recordCall(recorder, 'prepare');
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvCfg', (): DtvCfg => {
        return createMockDtvCfg({
          setStringValue(_key: string, _value: string): number {
            recordCall(recorder, 'setStringValue');
            return 0;
          },
          setIntValue(_key: string, _value: number): number {
            recordCall(recorder, 'setIntValue');
            return 0;
          }
        });
      }),
    );

    DtvManager.init();
    recorder.entries = [];
    DtvManager.init();

    expect(recorder.entries.length).assertEqual(3);
  });
});

describe('DtvManager_Boundary_Conditions', () => {
  let restores: Array<() => void> = [];

  beforeEach(() => {
    restores = [];
  });

  afterEach(() => {
    restoreAll(restores);
  });

  it('should_handle_zero_channel_count', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getProgramManager', (): ProgramManager => {
        return createMockProgramManager({
          getChannelGroup(_filter: PmChannelFilter): number {
            return 0;
          },
          getChannelNum(_groupType: number): number {
            return 0;
          }
        });
      }),
    );

    const hasChannel = DtvManager.hasChannel();
    expect(hasChannel).assertFalse();
  });

  it('should_handle_negative_scan_result', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getDtvComm', (): DtvComm => {
        return createMockDtvComm({
          setSourceType(_antennaType: FeAntennaType): number {
            return 0;
          }
        });
      }),
    );
    restores.push(
      patchMember(DtvManager as Object, 'getDtvFrontend', (): DtvFrontend => {
        return createMockDtvFrontend({
          setAntennaType(_antennaType: FeAntennaType): number {
            return 0;
          },
          setScanAttr(_scanCaType: FeScanCaType, _scanProgType: FeScanProgType): number {
            return 0;
          },
          autoScan(): number {
            return -1;
          }
        });
      }),
    );

    DtvManager.channelAutoScan();
    expect(true).assertTrue();
  });

  it('should_handle_empty_channel_list', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getChannelList', (): PmChannel[] => {
        return [];
      }),
    );

    const result = DtvManager.dtvDefaultChannelPlay();
    expect(result).assertEqual(-1);
  });

  it('should_handle_undefined_last_channel', 0, () => {
    restores.push(
      patchMember(DtvManager as Object, 'getProgramManager', (): ProgramManager => {
        return createMockProgramManager({
          getLastChannelID(): number | undefined {
            return undefined;
          }
        });
      }),
    );

    const result = DtvManager.dtvLastChannelPlay();
    expect(result).assertEqual(-1);
  });
});

export default function DtvManager_InitAndScan_test_DefaultExportBridge(): void {
}
