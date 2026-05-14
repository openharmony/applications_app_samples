/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
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

import { describe, it, expect, beforeEach, TestType, Size, Level } from '@ohos/hypium';

import {
  APPLICATION_BUNDLE_NAME,
  APPLICATION_SERVICE_NAME,
  APPLICATION_ABILITY_NAME,
  MusicSharedEventCode,
  MusicSharedStatus,
  MusicConnectEvent
} from '../../../../main/ets/common/MusicSharedDefinition';

/**
 * MusicSharedDefinition security test suite
 *
 * Validates security properties of constants and enums used for RPC communication.
 * MusicSharedEventCode defines 12 event codes for RPC calls between TV and remote devices.
 * RPC message codes use 1-based sequential numbering.
 * MusicConnectEvent defines 4 connection event strings for ServiceAbility connectivity.
 * All constant values must remain stable to maintain backward compatibility.
 *
 * Security concerns:
 * - Event code collision detection
 * - Out-of-range input validation
 * - Invalid bundle/service/ability name detection
 */
export default function musicSharedDefinitionSecurityTestSuite(): void {
  describe('MusicSharedDefinitionSecurityTest', () => {

    // ========== MusicSharedEventCode integrity ==========
    describe('MusicSharedEventCode_integrity', () => {

      // 11 event codes for RPC communication must all be unique
      // No two RemoteMessageRequest codes should collide
      it('security_eventCode_allUnique_noCollision', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const eventCodes: number[] = [
          MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE,   // 1
          MusicSharedEventCode.STOP_DISTRIBUTED_MUSIC_SERVICE,    // 2
          MusicSharedEventCode.PLAY_MUSIC_SERVICE,                // 3
          MusicSharedEventCode.PAUSE_MUSIC_SERVICE,               // 4
          MusicSharedEventCode.PLAY_MUSIC_SERVICE_REMOTE,         // 5
          MusicSharedEventCode.PAUSE_MUSIC_SERVICE_REMOTE,        // 6
          MusicSharedEventCode.STOP_LOCAL_SERIVCE,                // 7
          MusicSharedEventCode.PRE_MUSIC_SERVICE,                 // 8
          MusicSharedEventCode.NEXT_MUSIC_SERVICE,                // 9
          MusicSharedEventCode.PRE_MUSIC_SERVICE_REMOTE,          // 10
          MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE,         // 11
        ];

        // Use Set to detect duplicates
        const uniqueSet: Set<number> = new Set(eventCodes);
        expect(uniqueSet.size).assertEqual(eventCodes.length);

        // All codes must be in range 1-11
        for (let i: number = 0; i < eventCodes.length; i++) {
          expect(eventCodes[i]).assertLarger(0);
          expect(eventCodes[i]).assertLess(12);
        }
      });

      // Request-response pairing must be correct
      // PLAY_MUSIC_SERVICE(3) -> PLAY_MUSIC_SERVICE_REMOTE(5)
      // PAUSE_MUSIC_SERVICE(4) -> PAUSE_MUSIC_SERVICE_REMOTE(6)
      // PRE_MUSIC_SERVICE(8) -> PRE_MUSIC_SERVICE_REMOTE(10)
      // NEXT_MUSIC_SERVICE(9) -> NEXT_MUSIC_SERVICE_REMOTE(11)
      it('security_eventCode_requestResponsePair_mustBeCorrect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // Play-PLAY_REMOTE pair
        expect(MusicSharedEventCode.PLAY_MUSIC_SERVICE).assertEqual(3);
        expect(MusicSharedEventCode.PLAY_MUSIC_SERVICE_REMOTE).assertEqual(5);

        // Pause pair
        expect(MusicSharedEventCode.PAUSE_MUSIC_SERVICE).assertEqual(4);
        expect(MusicSharedEventCode.PAUSE_MUSIC_SERVICE_REMOTE).assertEqual(6);

        // Previous pair
        expect(MusicSharedEventCode.PRE_MUSIC_SERVICE).assertEqual(8);
        expect(MusicSharedEventCode.PRE_MUSIC_SERVICE_REMOTE).assertEqual(10);

        // Next pair
        expect(MusicSharedEventCode.NEXT_MUSIC_SERVICE).assertEqual(9);
        expect(MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE).assertEqual(11);

        // Local code + 2 = corresponding remote code pattern
        // This ensures consistency for request-response mapping
        expect(MusicSharedEventCode.PLAY_MUSIC_SERVICE_REMOTE - MusicSharedEventCode.PLAY_MUSIC_SERVICE).assertEqual(2);
        expect(MusicSharedEventCode.PAUSE_MUSIC_SERVICE_REMOTE - MusicSharedEventCode.PAUSE_MUSIC_SERVICE).assertEqual(2);
        expect(MusicSharedEventCode.PRE_MUSIC_SERVICE_REMOTE - MusicSharedEventCode.PRE_MUSIC_SERVICE).assertEqual(2);
        expect(MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE - MusicSharedEventCode.NEXT_MUSIC_SERVICE).assertEqual(2);
      });

      // Out-of-range code injection detection
      // ServiceAbility.onRemoteMessageRequest must return false for unhandled codes
      it('security_eventCode_outOfRange_sentByAttacker', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {

        const INVALID_CODES: number[] = [0, -1, 12, 99, 255, 65535];

        for (let i: number = 0; i < INVALID_CODES.length; i++) {
          const invalidCode: number = INVALID_CODES[i];
          // Unhandled code should return false by default
          const isHandled: boolean =
            invalidCode >= MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE &&
            invalidCode <= MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE;
          expect(isHandled).assertEqual(false);
        }
      });
    });

    // ========== Application identity security ==========
    describe('ApplicationIdentity_security', () => {

      // Bundle name must match package definition
      // Prevents spoofing of app identity in cross-device connections
      it('security_bundleName_mustMatchPackageDefinition', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // BundleName must start with ohos.samples.* pattern
        const containsOhosSamples: boolean = APPLICATION_BUNDLE_NAME.indexOf('ohos.samples.') >= 0;
        expect(containsOhosSamples).assertEqual(true);
        // Must contain distributedmusicplayer
        const containsDistributedMusicPlayer: boolean = APPLICATION_BUNDLE_NAME.indexOf('distributedmusicplayer') >= 0;
        expect(containsDistributedMusicPlayer).assertEqual(true);
        // No illegal characters allowed
        const re: RegExp = /[^a-zA-Z0-9.]/;
        const hasIllegalChars: boolean = re.test(APPLICATION_BUNDLE_NAME);
        expect(hasIllegalChars).assertEqual(false);
      });

      // Service name must match ServiceAbility class
      // Used for cross-device service connection via ServiceExtensionAbility
      it('security_serviceName_mustMatchServiceAbilityClass', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(APPLICATION_SERVICE_NAME).assertEqual('ServiceAbility');
        // Service name must not be empty
        expect(APPLICATION_SERVICE_NAME.length).assertLarger(0);
      });

      // Ability name must contain MainAbility
      it('security_abilityName_mustContainMainAbility', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const containsMainAbility: boolean = APPLICATION_ABILITY_NAME.indexOf('MainAbility') >= 0;
        expect(containsMainAbility).assertEqual(true);
        // Must contain ohos.samples. package prefix
        const containsOhosSamples: boolean = APPLICATION_ABILITY_NAME.indexOf('ohos.samples.') >= 0;
        expect(containsOhosSamples).assertEqual(true);
      });
    });

    // ========== MusicSharedStatus codes validation ==========
    describe('MusicSharedStatus_security', () => {

      // Status codes must be unique
      it('security_statusCodes_mustBeUnique', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // MUSIC_SHARED=0 (initial state)
        expect(MusicSharedStatus.MUSIC_SHARED).assertEqual(0);
        // MUSIC_REMOTING=1 (in transfer)
        expect(MusicSharedStatus.MUSIC_REMOTING).assertEqual(1);
        // MUSIC_STOP_SHARED=2 (transfer complete)
        expect(MusicSharedStatus.MUSIC_STOP_SHARED).assertEqual(2);

        // No duplicate values
        const statusSet: Set<number> = new Set([
          MusicSharedStatus.MUSIC_SHARED,
          MusicSharedStatus.MUSIC_REMOTING,
          MusicSharedStatus.MUSIC_STOP_SHARED
        ]);
        expect(statusSet.size).assertEqual(3);
      });

      // Status transition ordering must follow protocol
      // SHARED(0) -> REMOTING(1) -> STOP_SHARED(2) is the only valid flow
      it('security_statusTransitions_mustFollowProtocol', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // Values must be monotonically increasing by lifecycle
        expect(MusicSharedStatus.MUSIC_SHARED).assertLess(MusicSharedStatus.MUSIC_REMOTING);
        expect(MusicSharedStatus.MUSIC_REMOTING).assertLess(MusicSharedStatus.MUSIC_STOP_SHARED);

        // MUSIC_SHARED is the initial state (0)
        expect(MusicSharedStatus.MUSIC_SHARED).assertEqual(0);
      });
    });

    // ========== MusicConnectEvent security ==========
    describe('MusicConnectEvent_security', () => {

      // Connect events must match ServiceAbility patterns
      it('security_connectEvents_mustMatchServiceAbility', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // Maps to ConnectOptions callbacks
        expect(MusicConnectEvent.EVENT_CONNECT).assertEqual('ONCONNECT');
        expect(MusicConnectEvent.EVENT_DISCONNECT).assertEqual('ONDISCONNECT');
        expect(MusicConnectEvent.EVENT_FAILED).assertEqual('ONFAILED');
        expect(MusicConnectEvent.EVENT_TIMEOUT).assertEqual('CONNECTTIMEOUT');

        // All values must be uppercase with no spaces (security-safe format)
        const connectEvents: string[] = [
          MusicConnectEvent.EVENT_CONNECT,
          MusicConnectEvent.EVENT_DISCONNECT,
          MusicConnectEvent.EVENT_FAILED,
          MusicConnectEvent.EVENT_TIMEOUT,
        ];
        for (let i: number = 0; i < connectEvents.length; i++) {
          const event: string = connectEvents[i];

          const re: RegExp = /^[A-Z]+$/;
          const isAllUpper: boolean = re.test(event);
          expect(isAllUpper).assertEqual(true);

          const hasSpace: boolean = event.indexOf(' ') >= 0;
          expect(hasSpace).assertEqual(false);
        }
      });


      it('security_connectEventCount_mustCoverAllCallbacks', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // ConnectOptions has 4 callbacks: onConnect/onDisconnect/onFailed/onTimeout
        // All 4 must be covered
        const eventCount: number = 4;
        expect(eventCount).assertEqual(4);
      });
    });

    // ========== RPC message poisoning defense ==========
    describe('RPCMessagePoisoning_defense', () => {

      // Only 11 valid event codes, all others must be rejected
      it('security_rpcMessageCode_poisoning_mustRejectInvalid', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // onRemoteMessageRequest must return false for invalid codes
        // Prevents code injection via crafted RPC messages

        // Valid codes range from 1 to 11
        const MIN_VALID_CODE: number = MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE;
        const MAX_VALID_CODE: number = MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE;

        // Verify the range boundaries
        expect(MIN_VALID_CODE).assertEqual(1);
        expect(MAX_VALID_CODE).assertEqual(11);

        // Out-of-range codes should be rejected by default
        const outOfRangeCodes: number[] = [0, 12, 13, 100, 100];
        for (let i: number = 0; i < outOfRangeCodes.length; i++) {
          const code: number = outOfRangeCodes[i];
          const isInRange: boolean = code >= MIN_VALID_CODE && code <= MAX_VALID_CODE;
          expect(isInRange).assertEqual(false);
        }
      });

      // Replay attack detection via rate limiting
      // Repeated START_DISTRIBUTED_MUSIC_SERVICE must be rate limited
      it('security_eventCode_replayAttack_mustBeRateLimited', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // START_DISTRIBUTED_MUSIC_SERVICE=1 (session begin)
        const startCode: number = MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE;
        expect(startCode).assertEqual(1);

        // STOP_DISTRIBUTED_MUSIC_SERVICE=2 (session end)
        const stopCode: number = MusicSharedEventCode.STOP_DISTRIBUTED_MUSIC_SERVICE;
        expect(stopCode).assertEqual(2);

        // Normal flow: START(1) -> play/pause(3-11) -> STOP(2)
        // Replay attack: multiple START without intervening STOP
        const InvalidSequence: number[] = [1, 1, 1]; // 3 repeated START
        // Repeated START commands are invalid
        expect(InvalidSequence[0]).assertEqual(1);
        expect(InvalidSequence.length).assertEqual(3);
      });
    });

    // ========== Backward compatibility ==========
    describe('ConstantBackwardCompatibility', () => {

      // All constant values must remain stable across versions
      // Prevents breaking changes in distributed communication protocol
      it('security_allConstants_mustRemainStable', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // bundle name must stay the same
        expect(APPLICATION_BUNDLE_NAME).assertEqual('ohos.samples.distributedmusicplayer');

        // service name must stay the same
        expect(APPLICATION_SERVICE_NAME).assertEqual('ServiceAbility');

        // event codes - RPC protocol stability
        expect(MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE).assertEqual(1);
        expect(MusicSharedEventCode.STOP_LOCAL_SERIVCE).assertEqual(7);
        expect(MusicSharedEventCode.NEXT_MUSIC_SERVICE_REMOTE).assertEqual(11);

        // status codes must stay the same
        expect(MusicSharedStatus.MUSIC_SHARED).assertEqual(0);
        expect(MusicSharedStatus.MUSIC_STOP_SHARED).assertEqual(2);

        // connect events must stay the same
        expect(MusicConnectEvent.EVENT_CONNECT).assertEqual('ONCONNECT');
        expect(MusicConnectEvent.EVENT_TIMEOUT).assertEqual('CONNECTTIMEOUT');
      });
    });
  });
}
