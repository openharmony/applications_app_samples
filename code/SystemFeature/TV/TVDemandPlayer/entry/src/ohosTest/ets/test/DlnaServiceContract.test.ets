/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it, expect } from '@ohos/hypium';
import DlnaService from '../../../main/ets/DlnaService/DlnaService';
import DlnaServiceStub from '../../../main/ets/DlnaService/DlnaServiceStub';

/**
 * DLNA服务测试合并文件
 *
 * 业务背景：DLNA stub 是远端播放器和本地页面的契约桥，验证状态映射正确性。
 * 本文件汇聚了 PositionCallback、StatusCallback、VolumeCallback、ErrorCallback 等场景。
 */

interface PositionSnapshot {
  duration: number;
  position: number;
}

export default function DlnaServiceContractTest() {
  const casePrefix = 'DemandPlayer_DlnaServiceContract_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  /**
   * ========== 第一部分：DLNA基础状态与回调 ==========
   */
  describe('DlnaServiceContract_BasicCallbackRules', () => {
    it(addCase(casePrefix + 'Stub_Instantiate_WithDescriptor_001'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      expect(stub !== null).assertEqual(true);
      expect(stub !== undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'DefaultState_002'), 0, () => {
      const stub = new DlnaServiceStub('OHOS.DlnaService');
      expect(stub.position).assertEqual(0);
      expect(stub.duration).assertEqual(0);
      expect(stub.playFlag).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stub_InitialState_DefaultValues_003'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      expect(stub.position).assertEqual(0);
      expect(stub.duration).assertEqual(0);
      expect(stub.playFlag).assertEqual(true);
    });

    it(addCase(casePrefix + 'PositionCallback_ForwardValues_004'), 0, () => {
      const stub = new DlnaServiceStub('OHOS.DlnaService');
      const snapshots: Array<PositionSnapshot> = [];
      stub.setStatusCallback(
        (_playFlag: boolean) => {
        },
        (duration: number, position: number) => {
          snapshots.push({ duration, position });
        },
        (_volume: number, _maxVolume: number) => {
        }
      );
      stub.onPositionChanged(1500, 9000, (_errCode: number, _returnValue: number) => {
      });
      expect(snapshots.length).assertEqual(1);
      expect(snapshots[0].duration).assertEqual(9000);
      expect(snapshots[0].position).assertEqual(1500);
    });

    it(addCase(casePrefix + 'PositionCallback_NegativeIgnored_005'), 0, () => {
      const stub = new DlnaServiceStub('OHOS.DlnaService');
      let called = 0;
      stub.setStatusCallback(
        (_playFlag: boolean) => {
        },
        (_duration: number, _position: number) => {
          called++;
        },
        (_volume: number, _maxVolume: number) => {
        }
      );
      stub.onPositionChanged(-1, 8000, (_errCode: number, _returnValue: number) => {
      });
      expect(called).assertEqual(0);
    });

    it(addCase(casePrefix + 'StatusCallback_PlayingState_006'), 0, () => {
      const stub = new DlnaServiceStub('OHOS.DlnaService');
      let latest = false;
      stub.setStatusCallback(
        (playFlag: boolean) => {
          latest = playFlag;
        },
        (_duration: number, _position: number) => {
        },
        (_volume: number, _maxVolume: number) => {
        }
      );
      stub.onPlayerStatusChanged(5, (_errCode: number, _returnValue: number) => {
      });
      expect(stub.playFlag).assertEqual(true);
      expect(latest).assertEqual(true);
    });

    it(addCase(casePrefix + 'StatusCallback_NonPlayingState_007'), 0, () => {
      const stub = new DlnaServiceStub('OHOS.DlnaService');
      let latest = true;
      stub.setStatusCallback(
        (playFlag: boolean) => {
          latest = playFlag;
        },
        (_duration: number, _position: number) => {
        },
        (_volume: number, _maxVolume: number) => {
        }
      );
      stub.onPlayerStatusChanged(2, (_errCode: number, _returnValue: number) => {
      });
      expect(stub.playFlag).assertEqual(false);
      expect(latest).assertEqual(false);
    });

    it(addCase(casePrefix + 'VolumeCallback_ForwardValues_008'), 0, () => {
      const stub = new DlnaServiceStub('OHOS.DlnaService');
      let volume = -1;
      let maxVolume = -1;
      stub.setStatusCallback(
        (_playFlag: boolean) => {
        },
        (_duration: number, _position: number) => {
        },
        (nextVolume: number, nextMaxVolume: number) => {
          volume = nextVolume;
          maxVolume = nextMaxVolume;
        }
      );
      stub.onVolumeChanged(35, 100, (_errCode: number, _returnValue: number) => {
      });
      expect(volume).assertEqual(35);
      expect(maxVolume).assertEqual(100);
    });

    it(addCase(casePrefix + 'SetStatusCallback_OverrideOldCallbacks_009'), 0, () => {
      const stub = new DlnaServiceStub('OHOS.DlnaService');
      let firstCalled = 0;
      let secondCalled = 0;
      stub.setStatusCallback(
        (_playFlag: boolean) => {
          firstCalled++;
        },
        (_duration: number, _position: number) => {
        },
        (_volume: number, _maxVolume: number) => {
        }
      );
      stub.setStatusCallback(
        (_playFlag: boolean) => {
          secondCalled++;
        },
        (_duration: number, _position: number) => {
        },
        (_volume: number, _maxVolume: number) => {
        }
      );
      stub.onPlayerStatusChanged(5, (_errCode: number, _returnValue: number) => {
      });
      expect(firstCalled).assertEqual(0);
      expect(secondCalled).assertEqual(1);
    });

    /**
     * ========== 第二部分：Command码与边界场景 ==========
     */
    it(addCase(casePrefix + 'CommandConstantSequence_010'), 0, () => {
      expect(DlnaServiceStub.COMMAND_ON_POSITION_CHANGED).assertEqual(1);
      expect(DlnaServiceStub.COMMAND_ON_PLAYER_STATUS_CHANGED).assertEqual(2);
      expect(DlnaServiceStub.COMMAND_ON_PLAYER_ERROR).assertEqual(3);
      expect(DlnaServiceStub.COMMAND_ON_VOLUNE_CHANGED).assertEqual(4);
    });

    it(addCase(casePrefix + 'Stub_InterfaceExistence_ImplementsDlnaService_011'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      const hasOnPosition = typeof stub.onPositionChanged === 'function';
      const hasOnStatus = typeof stub.onPlayerStatusChanged === 'function';
      const hasOnVolume = typeof stub.onVolumeChanged === 'function';
      const hasOnError = typeof stub.onPlayerError === 'function';
      expect(hasOnPosition).assertEqual(true);
      expect(hasOnStatus).assertEqual(true);
      expect(hasOnVolume).assertEqual(true);
      expect(hasOnError).assertEqual(true);
    });

    it(addCase(casePrefix + 'OnPositionChanged_PositivePosition_InvokesCallback_012'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      let cbErr = -1;
      let cbVal = -1;
      stub.onPositionChanged(5000, 30000, (err, val) => {
        cbErr = err;
        cbVal = val;
      });
      expect(cbErr).assertEqual(0);
      expect(cbVal).assertEqual(5000);
    });

    it(addCase(casePrefix + 'OnPositionChanged_NegativePosition_Blocked_013'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      let callbackInvoked = false;
      stub.onPositionChanged(-1, 30000, (_err, _val) => {
        callbackInvoked = true;
      });
      expect(callbackInvoked).assertEqual(true);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status5_SetsPlayFlagTrue_014'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(5, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(true);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_StatusNot5_SetsPlayFlagFalse_015'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(1, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'OnVolumeChanged_ValidVolume_InvokesCallback_016'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      let cbErr = -1;
      let cbVol = -1;
      let cbMax = -1;
      stub.onVolumeChanged(50, 100, (err: number, vol: number, max: number) => {
        cbErr = err;
        cbVol = vol;
        cbMax = max;
      });
      expect(cbErr).assertEqual(0);
      expect(cbVol).assertEqual(50);
      expect(cbMax).assertEqual(100);
    });

    it(addCase(casePrefix + 'OnPlayerError_AlwaysInvokesCallback_017'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      let cbErr = -1;
      let cbVal = -1;
      stub.onPlayerError((err, val) => {
        cbErr = err;
        cbVal = val;
      });
      expect(cbErr).assertEqual(0);
      expect(cbVal).assertEqual(0);
    });

    it(addCase(casePrefix + 'OnPositionChanged_ZeroPosition_InvokesCallback_018'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      let cbErr = -1;
      let cbVal = -1;
      stub.onPositionChanged(0, 0, (err, val) => {
        cbErr = err;
        cbVal = val;
      });
      expect(cbErr).assertEqual(0);
      expect(cbVal).assertEqual(0);
    });

    it(addCase(casePrefix + 'Stub_Descriptor_Preserved_019'), 0, () => {
      const stub = new DlnaServiceStub('my-service-name');
      const descriptor = stub.getDescriptor();
      expect(descriptor).assertEqual('my-service-name');
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_MultipleCalls_LastWins_020'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(1, (_e, _v) => {
      });
      expect(stub.playFlag).assertEqual(false);
      stub.onPlayerStatusChanged(5, (_e, _v) => {
      });
      expect(stub.playFlag).assertEqual(true);
      stub.onPlayerStatusChanged(0, (_e, _v) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'CaseNamePattern_021'), 0, () => {
      expect(allCaseNames.length).assertEqual(51);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_DlnaServiceContract_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });

    it(addCase(casePrefix + 'OnVolumeChanged_ZeroVolume_InvokesCallback_022'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      let cbErr = -1;
      let cbVol = -1;
      let cbMax = -1;
      stub.onVolumeChanged(0, 100, (err: number, vol: number, max: number) => {
        cbErr = err;
        cbVol = vol;
        cbMax = max;
      });
      expect(cbErr).assertEqual(0);
      expect(cbVol).assertEqual(0);
      expect(cbMax).assertEqual(100);
    });

    it(addCase(casePrefix + 'OnVolumeChanged_MaxVolume_InvokesCallback_023'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      let cbErr = -1;
      let cbVol = -1;
      let cbMax = -1;
      stub.onVolumeChanged(100, 100, (err: number, vol: number, max: number) => {
        cbErr = err;
        cbVol = vol;
        cbMax = max;
      });
      expect(cbErr).assertEqual(0);
      expect(cbVol).assertEqual(100);
      expect(cbMax).assertEqual(100);
    });

    it(addCase(casePrefix + 'OnVolumeChanged_VolumeExceedsMax_024'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      let cbErr = -1;
      let cbVol = -1;
      let cbMax = -1;
      stub.onVolumeChanged(150, 100, (err: number, vol: number, max: number) => {
        cbErr = err;
        cbVol = vol;
        cbMax = max;
      });
      expect(cbVol).assertEqual(150);
      expect(cbMax).assertEqual(100);
    });

    it(addCase(casePrefix + 'PositionCallback_MultipleCalls_025'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      const snapshots: Array<PositionSnapshot> = [];
      stub.setStatusCallback(
        (_playFlag: boolean) => {
        },
        (duration: number, position: number) => {
          snapshots.push({ duration, position });
        },
        (_volume: number, _maxVolume: number) => {
        }
      );
      stub.onPositionChanged(1000, 9000, (_errCode: number, _returnValue: number) => {
      });
      stub.onPositionChanged(2000, 9000, (_errCode: number, _returnValue: number) => {
      });
      stub.onPositionChanged(3000, 9000, (_errCode: number, _returnValue: number) => {
      });
      expect(snapshots.length).assertEqual(3);
      expect(snapshots[2].position).assertEqual(3000);
    });

    it(addCase(casePrefix + 'StatusCallback_MultipleCalls_026'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      const statusHistory: boolean[] = [];
      stub.setStatusCallback(
        (playFlag: boolean) => {
          statusHistory.push(playFlag);
        },
        (_duration: number, _position: number) => {
        },
        (_volume: number, _maxVolume: number) => {
        }
      );
      stub.onPlayerStatusChanged(5, (_errCode: number, _returnValue: number) => {
      });
      stub.onPlayerStatusChanged(1, (_errCode: number, _returnValue: number) => {
      });
      stub.onPlayerStatusChanged(5, (_errCode: number, _returnValue: number) => {
      });
      expect(statusHistory.length).assertEqual(3);
      expect(statusHistory[2]).assertEqual(true);
    });

    it(addCase(casePrefix + 'VolumeCallback_MultipleCalls_027'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      const volumeHistory: number[] = [];
      stub.setStatusCallback(
        (_playFlag: boolean) => {
        },
        (_duration: number, _position: number) => {
        },
        (volume: number, _maxVolume: number) => {
          volumeHistory.push(volume);
        }
      );
      stub.onVolumeChanged(10, 100, (_errCode: number, _returnValue: number) => {
      });
      stub.onVolumeChanged(20, 100, (_errCode: number, _returnValue: number) => {
      });
      stub.onVolumeChanged(30, 100, (_errCode: number, _returnValue: number) => {
      });
      expect(volumeHistory.length).assertEqual(3);
      expect(volumeHistory[2]).assertEqual(30);
    });

    it(addCase(casePrefix + 'OnPositionChanged_PositionExceedsDuration_028'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      let cbErr = -1;
      let cbVal = -1;
      stub.onPositionChanged(10000, 5000, (err, val) => {
        cbErr = err;
        cbVal = val;
      });
      expect(cbErr).assertEqual(0);
      expect(cbVal).assertEqual(10000);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status0_Stopped_029'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(0, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status1_Playing_030'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(1, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status2_Paused_031'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(2, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status3_Idle_032'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(3, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status4_Preparing_033'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(4, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status6_FastForward_034'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(6, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(true);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status7_FastBackward_035'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(7, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(true);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status8_SlowForward_036'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(8, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(true);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status9_SlowBackward_037'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(9, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(true);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status10_Seek_038'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(10, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status11_Buffer_039'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(11, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status12_EndReached_040'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(12, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status13_NewStream_041'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(13, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_Status14_Playing_042'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(14, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(true);
    });

    it(addCase(casePrefix + 'OnPlayerStatusChanged_StatusUnknown_043'), 0, () => {
      const stub = new DlnaServiceStub('test-descriptor');
      stub.onPlayerStatusChanged(99, (_err, _val) => {
      });
      expect(stub.playFlag).assertEqual(false);
    });

    it(addCase(casePrefix + 'Command_OnPositionChanged_Equals1_044'), 0, () => {
      expect(DlnaServiceStub.COMMAND_ON_POSITION_CHANGED).assertEqual(1);
    });

    it(addCase(casePrefix + 'Command_OnPlayerStatusChanged_Equals2_045'), 0, () => {
      expect(DlnaServiceStub.COMMAND_ON_PLAYER_STATUS_CHANGED).assertEqual(2);
    });

    it(addCase(casePrefix + 'Command_OnPlayerError_Equals3_046'), 0, () => {
      expect(DlnaServiceStub.COMMAND_ON_PLAYER_ERROR).assertEqual(3);
    });

    it(addCase(casePrefix + 'Command_OnVolumeChanged_Equals4_047'), 0, () => {
      expect(DlnaServiceStub.COMMAND_ON_VOLUNE_CHANGED).assertEqual(4);
    });

    it(addCase(casePrefix + 'Stub_GetDescriptor_ReturnsCorrectValue_048'), 0, () => {
      const stub = new DlnaServiceStub('com.example.dlna');
      expect(stub.getDescriptor()).assertEqual('com.example.dlna');
    });

    it(addCase(casePrefix + 'Stub_EmptyDescriptor_049'), 0, () => {
      const stub = new DlnaServiceStub('');
      expect(stub.getDescriptor()).assertEqual('');
    });

    it(addCase(casePrefix + 'Stub_UnicodeDescriptor_050'), 0, () => {
      const stub = new DlnaServiceStub('服务.测试');
      expect(stub.getDescriptor()).assertEqual('服务.测试');
    });

    it(addCase(casePrefix + 'CaseNamePattern_Final_051'), 0, () => {
      expect(allCaseNames.length).assertEqual(51);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_DlnaServiceContract_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
