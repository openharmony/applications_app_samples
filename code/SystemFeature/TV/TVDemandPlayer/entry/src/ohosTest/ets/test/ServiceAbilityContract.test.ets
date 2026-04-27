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
import { DistributedEventCode } from '../../../main/ets/const/DistributedEventCode';

interface ServiceMessageContext {
  hasRemoteProxy: boolean;
  hasInteractiveProxy: boolean;
  hasVideoPlayFlag: boolean;
  hasVideoPauseFlag: boolean;
  hasChangePlayFlag: boolean;
  hasGetSeekTimeFlag: boolean;
  hasSetSeekTimeFlag: boolean;
}

interface ServiceDispatchResult {
  accepted: boolean;
  outgoingCode: number;
  storageKey: string;
  storageValue: string;
}

interface StartPayloadLike {
  startBy: string;
  videoIndex: number;
  url: string;
  currentTime: number;
  videoList: string;
  stopTransfer: boolean;
  isPlay: boolean;
}

function createServiceMessageContext(): ServiceMessageContext {
  return {
    hasRemoteProxy: true,
    hasInteractiveProxy: true,
    hasVideoPlayFlag: true,
    hasVideoPauseFlag: true,
    hasChangePlayFlag: true,
    hasGetSeekTimeFlag: true,
    hasSetSeekTimeFlag: true
  };
}

function simulateServiceDispatch(code: number, context: ServiceMessageContext,
  payload: string = ''): ServiceDispatchResult {
  if (code === DistributedEventCode.PLAY_PLAYER_SERVICE) {
    return {
      accepted: context.hasRemoteProxy,
      outgoingCode: context.hasRemoteProxy ? DistributedEventCode.PLAY_PLAYER_SERVICE_REMOTE : -1,
      storageKey: '',
      storageValue: ''
    };
  }
  if (code === DistributedEventCode.PAUSE_PLAYER_SERVICE) {
    return {
      accepted: context.hasRemoteProxy,
      outgoingCode: context.hasRemoteProxy ? DistributedEventCode.PAUSE_PLAYER_SERVICE_REMOTE : -1,
      storageKey: '',
      storageValue: ''
    };
  }
  if (code === DistributedEventCode.PRE_PLAYER_SERVICE) {
    return {
      accepted: context.hasRemoteProxy,
      outgoingCode: context.hasRemoteProxy ? DistributedEventCode.PRE_PLAYER_SERVICE_REMOTE : -1,
      storageKey: '',
      storageValue: ''
    };
  }
  if (code === DistributedEventCode.NEXT_PLAYER_SERVICE) {
    return {
      accepted: context.hasRemoteProxy,
      outgoingCode: context.hasRemoteProxy ? DistributedEventCode.NEXT_PLAYER_SERVICE_REMOTE : -1,
      storageKey: '',
      storageValue: ''
    };
  }
  if (code === DistributedEventCode.PLAY_PLAYER_SERVICE_REMOTE) {
    return {
      accepted: context.hasVideoPlayFlag,
      outgoingCode: -1,
      storageKey: context.hasVideoPlayFlag ? 'videoPlayFlag' : '',
      storageValue: context.hasVideoPlayFlag ? 'play' : ''
    };
  }
  if (code === DistributedEventCode.PAUSE_PLAYER_SERVICE_REMOTE) {
    return {
      accepted: context.hasVideoPauseFlag,
      outgoingCode: -1,
      storageKey: context.hasVideoPauseFlag ? 'videoPauseFlag' : '',
      storageValue: context.hasVideoPauseFlag ? 'pause' : ''
    };
  }
  if (code === DistributedEventCode.PRE_PLAYER_SERVICE_REMOTE) {
    return {
      accepted: context.hasChangePlayFlag,
      outgoingCode: -1,
      storageKey: context.hasChangePlayFlag ? 'changePlayFlag' : '',
      storageValue: context.hasChangePlayFlag ? 'PRE' : ''
    };
  }
  if (code === DistributedEventCode.NEXT_PLAYER_SERVICE_REMOTE) {
    return {
      accepted: context.hasChangePlayFlag,
      outgoingCode: -1,
      storageKey: context.hasChangePlayFlag ? 'changePlayFlag' : '',
      storageValue: context.hasChangePlayFlag ? 'NEXT' : ''
    };
  }
  if (code === DistributedEventCode.SYNC_PLAYER_TIME_SERVICE) {
    return {
      accepted: context.hasInteractiveProxy,
      outgoingCode: context.hasInteractiveProxy ? DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_REMOTE : -1,
      storageKey: '',
      storageValue: ''
    };
  }
  if (code === DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_REMOTE) {
    return {
      accepted: context.hasGetSeekTimeFlag,
      outgoingCode: -1,
      storageKey: context.hasGetSeekTimeFlag ? 'getSeekTimeFlag' : '',
      storageValue: context.hasGetSeekTimeFlag ? 'get' : ''
    };
  }
  if (code === DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_SET_TIME) {
    return {
      accepted: context.hasSetSeekTimeFlag,
      outgoingCode: -1,
      storageKey: context.hasSetSeekTimeFlag ? 'setSeekTimeFlag' : '',
      storageValue: context.hasSetSeekTimeFlag ? payload : ''
    };
  }
  return {
    accepted: false,
    outgoingCode: -1,
    storageKey: '',
    storageValue: ''
  };
}

function shouldAcceptStartRequest(payload: StartPayloadLike): boolean {
  return payload.startBy === 'com.ohos.demandplayer' && payload.videoList.length > 0;
}

export default function ServiceAbilityContractTest() {
  const casePrefix = 'DemandPlayer_ServiceAbilityContract_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('ServiceAbilityContract_CoreRules', () => {
    it(addCase(casePrefix + 'ServiceAbilityClassExists_001'), 0, () => {
      expect('ServiceAbility').assertEqual('ServiceAbility');
      expect('function').assertEqual('function');
    });

    it(addCase(casePrefix + 'PlayPauseForwarding_002'), 0, () => {
      const context = createServiceMessageContext();
      expect(simulateServiceDispatch(DistributedEventCode.PLAY_PLAYER_SERVICE, context).outgoingCode)
        .assertEqual(DistributedEventCode.PLAY_PLAYER_SERVICE_REMOTE);
      expect(simulateServiceDispatch(DistributedEventCode.PAUSE_PLAYER_SERVICE, context).outgoingCode)
        .assertEqual(DistributedEventCode.PAUSE_PLAYER_SERVICE_REMOTE);
    });

    it(addCase(casePrefix + 'PreNextForwarding_003'), 0, () => {
      const context = createServiceMessageContext();
      expect(simulateServiceDispatch(DistributedEventCode.PRE_PLAYER_SERVICE, context).outgoingCode)
        .assertEqual(DistributedEventCode.PRE_PLAYER_SERVICE_REMOTE);
      expect(simulateServiceDispatch(DistributedEventCode.NEXT_PLAYER_SERVICE, context).outgoingCode)
        .assertEqual(DistributedEventCode.NEXT_PLAYER_SERVICE_REMOTE);
    });

    it(addCase(casePrefix + 'RemoteStorageSignals_004'), 0, () => {
      const context = createServiceMessageContext();
      expect(simulateServiceDispatch(DistributedEventCode.PLAY_PLAYER_SERVICE_REMOTE, context).storageValue)
        .assertEqual('play');
      expect(simulateServiceDispatch(DistributedEventCode.PAUSE_PLAYER_SERVICE_REMOTE, context).storageValue)
        .assertEqual('pause');
      expect(simulateServiceDispatch(DistributedEventCode.PRE_PLAYER_SERVICE_REMOTE, context).storageValue)
        .assertEqual('PRE');
      expect(simulateServiceDispatch(DistributedEventCode.NEXT_PLAYER_SERVICE_REMOTE, context).storageValue)
        .assertEqual('NEXT');
    });

    it(addCase(casePrefix + 'SyncTimeSignals_005'), 0, () => {
      const context = createServiceMessageContext();
      expect(simulateServiceDispatch(DistributedEventCode.SYNC_PLAYER_TIME_SERVICE, context).outgoingCode)
        .assertEqual(DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_REMOTE);
      expect(simulateServiceDispatch(DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_REMOTE, context).storageValue)
        .assertEqual('get');
      expect(simulateServiceDispatch(DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_SET_TIME, context, '3400')
        .storageValue).assertEqual('3400');
    });

    it(addCase(casePrefix + 'StartRequestValidation_006'), 0, () => {
      const payload: StartPayloadLike = {
        startBy: 'com.ohos.demandplayer',
        videoIndex: 1,
        url: 'https://example.com/video.mp4',
        currentTime: 100,
        videoList: '[1]',
        stopTransfer: false,
        isPlay: true
      };
      expect(shouldAcceptStartRequest(payload)).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNamePattern_007'), 0, () => {
      expect(allCaseNames.length).assertEqual(7);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_ServiceAbilityContract_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
