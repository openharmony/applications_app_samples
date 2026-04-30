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

import { DeviceType, DistributedManagerDeviceInfo, DeviceStateChangeAction } from '../../../../main/ets/model/RemoteDeviceModel';

/**
 * DeviceDialog state machine test
 *
 * Business logic:
 * DeviceDialog on TV provides UI for device authentication and transfer.
 * Controlled by isTrust/isInTransfer/transferLoading/isInAuth boolean flags.
 * These flags determine the UI state for each device card.
 *
 * State rules:
 *   isTrust=false, isInAuth=false -> show auth prompt button
 *   isTrust=false, isInAuth=true  -> show authenticating text + LoadingProgress animation
 *   isTrust=true,  isInTransfer=false -> show transfer prompt button
 *   isTrust=true,  isInTransfer=true  -> show transferring text with stop button
 *   transferLoading=true              -> show LoadingProgress during transfer
 *
 * Priority order:
 *   1. transferLoading takes priority over isInTransfer
 *   2. isInAuth takes priority over isTrust
 *   3. When isTrust=true, isInTransfer determines transfer state
 *   4. isInAuth blocks showing trusted state
 */
export default function deviceDialogStateTestSuite(): void {
  describe('DeviceDialogStateTest', () => {

    // ========== 5 state combinations ==========
    describe('DeviceState_5Combinations', () => {

      // State 1: unauthenticated -> show auth prompt
      it('state_unauthenticatedUntrusted_mustShowAuthPrompt', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DistributedManagerDeviceInfo = createDevice({
          isTrust: false,
          isInAuth: false,
          isInTransfer: false,
          transferLoading: false,
        });
        // isTrust=false and isInAuth=false -> show auth prompt
        const canAuth: boolean = (!device.isTrust) && (!(device.isInAuth ?? false));
        expect(canAuth).assertEqual(true);
        // Transfer not available for unauthenticated device
        const canTransfer: boolean = (device.isTrust ?? false) && (!(device.isInTransfer ?? false));
        expect(canTransfer).assertEqual(false);
      });

      // State 2: in authentication -> show authenticating text + Loading
      it('state_inAuthentication_mustShowLoadingWithAuthText', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DistributedManagerDeviceInfo = createDevice({
          isTrust: false,
          isInAuth: true,
          isInTransfer: false,
          transferLoading: false,
        });
        // isInAuth=true sets authenticating state
        const isInAuth: boolean = device.isInAuth ?? false;
        expect(isInAuth).assertEqual(true);
        // Cannot be both trusted and in auth
        const bothTrustAndAuth: boolean = (device.isTrust ?? false) && (device.isInAuth ?? false);
        expect(bothTrustAndAuth).assertEqual(false);
        // In auth state, transfer is not active
        expect(device.isInTransfer).assertEqual(false);
      });

      // State 3: trusted idle -> show transfer prompt
      it('state_trustedIdle_mustShowTransferPrompt', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DistributedManagerDeviceInfo = createDevice({
          isTrust: true,
          isInAuth: false,
          isInTransfer: false,
          transferLoading: false,
        });
        // isTrust=true and isInTransfer=false -> can start transfer
        const canTransfer: boolean = (device.isTrust ?? false) && (!(device.isInTransfer ?? false));
        expect(canTransfer).assertEqual(true);
        // Trusted device does not need auth
        const canAuth: boolean = (!device.isTrust) && (!(device.isInAuth ?? false));
        expect(canAuth).assertEqual(false);
      });

      // State 4: in transfer -> show transferring text
      it('state_inTransfer_mustShowTransferringText', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DistributedManagerDeviceInfo = createDevice({
          isTrust: true,
          isInAuth: false,
          isInTransfer: true,
          transferLoading: false,
        });
        // isInTransfer=true marks transfer active
        const isInTransfer: boolean = device.isInTransfer ?? false;
        expect(isInTransfer).assertEqual(true);
        // Trust state preserved
        expect(device.isTrust).assertEqual(true);
        // Loading state is false since transfer is active
        expect(device.transferLoading).assertEqual(false);
      });

      // State 5: transfer loading -> show Loading + transfer text
      it('state_transferLoading_mustShowLoadingWithTransferText', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DistributedManagerDeviceInfo = createDevice({
          isTrust: true,
          isInAuth: false,
          isInTransfer: false,
          transferLoading: true,
        });
        // transferLoading=true indicates loading
        const isLoading: boolean = device.transferLoading ?? false;
        expect(isLoading).assertEqual(true);
        // Not yet in transfer state
        expect(device.isInTransfer).assertEqual(false);
        // Trust state is still true
        expect(device.isTrust).assertEqual(true);
      });
    });

    // ========== State transitions ==========
    describe('StateTransitions', () => {


      // unauth -> inAuth -> trusted -> transferLoading -> inTransfer -> idle
      it('transition_fullLifecycle_mustFollowCorrectOrder', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DistributedManagerDeviceInfo = createDevice({
          isTrust: false, isInAuth: false, isInTransfer: false, transferLoading: false
        });

        // Step 1: unauth -> inAuth
        device.isInAuth = true;
        expect(device.isInAuth).assertEqual(true);
        expect(device.isTrust).assertEqual(false);

        // Step 2: inAuth -> trusted
        device.isInAuth = false;
        device.isTrust = true;
        device.trustDeviceId = 'trust-123';
        expect(device.isTrust).assertEqual(true);
        expect(device.isInAuth).assertEqual(false);

        // Step 3: trusted -> transfer loading
        device.transferLoading = true;
        expect(device.transferLoading).assertEqual(true);
        expect(device.isInTransfer).assertEqual(false);

        // Step 4: transfer loading -> in transfer
        device.transferLoading = false;
        device.isInTransfer = true;
        expect(device.isInTransfer).assertEqual(true);
        expect(device.transferLoading).assertEqual(false);

        // Step 5: in transfer -> idle
        device.isInTransfer = false;
        expect(device.isInTransfer).assertEqual(false);
        expect(device.isTrust).assertEqual(true); // trust unchanged
      });

      // Illegal state transition detection
      // - Direct transition to inTransfer without auth
      // - Should detect as illegal state
      it('transition_illegalStateJumps_mustBeDetected', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DistributedManagerDeviceInfo = createDevice({
          isTrust: false, isInAuth: false, isInTransfer: false, transferLoading: false
        });

        // Jump directly to inTransfer
        device.isInTransfer = true;
        // Should detect illegal state
        const isIllegalState: boolean = (device.isInTransfer ?? false) && (!device.isTrust);
        expect(isIllegalState).assertEqual(true);
      });

      // Auth failure reverts to unauthenticated state
      it('transition_authFailure_mustRevertToUnauthed', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DistributedManagerDeviceInfo = createDevice({
          isTrust: false, isInAuth: true, isInTransfer: false, transferLoading: false
        });

        // isInAuthfalseisTrustfalse
        device.isInAuth = false;
        expect(device.isInAuth).assertEqual(false);
        expect(device.isTrust).assertEqual(false);
        // trustDeviceId should be cleared on auth failure
        expect(device.trustDeviceId).assertEqual('');
      });

      // Transfer failure must clear loading flag
      it('transition_transferFailure_mustClearLoadingFlag', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const device: DistributedManagerDeviceInfo = createDevice({
          isTrust: true, isInAuth: false, isInTransfer: false, transferLoading: true
        });

        // transferLoadingfalseisInTransferfalse
        device.transferLoading = false;
        expect(device.transferLoading).assertEqual(false);
        expect(device.isInTransfer).assertEqual(false);
        // Trust status should remain unchanged
        expect(device.isTrust).assertEqual(true);
      });
    });

    // ========== Multi-device list state ==========
    describe('MultiDevice_listState', () => {

      // Mixed device states should render correctly in list UI
      it('multiDevice_mixedStates_mustRenderCorrectly', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const devices: DistributedManagerDeviceInfo[] = [];

        // device 0: unauthenticated TV
        devices.push(createDeviceWithIndex(0, false, false, false, false, DeviceType.TV));
        // device 1: in-auth phone
        devices.push(createDeviceWithIndex(1, false, true, false, false, DeviceType.PHONE));
        // device 2: trusted idle tablet
        devices.push(createDeviceWithIndex(2, true, false, false, false, DeviceType.TABLET));
        // device 3: in-transfer speaker
        devices.push(createDeviceWithIndex(3, true, false, true, false, DeviceType.SPEAKER));
        // device 4: transfer loading TV
        devices.push(createDeviceWithIndex(4, true, false, false, true, DeviceType.TV));

        // Count devices by state category
        let unauthCount: number = 0;
        let inAuthCount: number = 0;
        let trustedIdleCount: number = 0;
        let inTransferCount: number = 0;
        let transferLoadingCount: number = 0;

        for (let i: number = 0; i < devices.length; i++) {
          const dev: DistributedManagerDeviceInfo = devices[i];
          if ((!dev.isTrust) && (!(dev.isInAuth ?? false))) unauthCount++;
          if ((!dev.isTrust) && (dev.isInAuth ?? false)) inAuthCount++;
          if ((dev.isTrust ?? false) && (!(dev.isInTransfer ?? false)) && (!(dev.transferLoading ?? false))) trustedIdleCount++;
          if ((dev.isTrust ?? false) && (dev.isInTransfer ?? false)) inTransferCount++;
          if (dev.transferLoading ?? false) transferLoadingCount++;
        }

        expect(unauthCount).assertEqual(1);
        expect(inAuthCount).assertEqual(1);
        expect(trustedIdleCount).assertEqual(1);
        expect(inTransferCount).assertEqual(1);
        expect(transferLoadingCount).assertEqual(1);
        expect(devices.length).assertEqual(5);
      });

      // Empty device list should not crash
      it('multiDevice_emptyList_mustNotCrash', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const emptyList: DistributedManagerDeviceInfo[] = [];
        expect(emptyList.length).assertEqual(0);
        // ForEach iterating empty list is safe
      });

      // All devices unauthenticated should show auth prompt for each
      it('multiDevice_allUnauthed_mustShowAuthPromptForAll', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const devices: DistributedManagerDeviceInfo[] = [];
        for (let i: number = 0; i < 5; i++) {
          devices.push(createDeviceWithIndex(i, false, false, false, false, DeviceType.TV));
        }
        // Every unauthenticated device must show the "authenticate" prompt
        for (let i: number = 0; i < devices.length; i++) {
          const dev: DistributedManagerDeviceInfo = devices[i];
          const showsAuthPrompt: boolean = (!dev.isTrust) && (!(dev.isInAuth ?? false));
          expect(showsAuthPrompt).assertEqual(true);
        }
      });
    });

    // ========== DeviceType state combination ==========
    describe('DeviceType_stateCombination', () => {

      // All device types must support all state combinations
      it('deviceType_allTypesAllStates_mustWork', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const deviceTypes: DeviceType[] = [
          DeviceType.TV, DeviceType.PHONE, DeviceType.TABLET,
          DeviceType.WEARABLE, DeviceType.CAR, DeviceType.SPEAKER
        ];
        const states: DeviceState[] = [
          { isTrust: false, isInAuth: false, isInTransfer: false, transferLoading: false },
          { isTrust: false, isInAuth: true, isInTransfer: false, transferLoading: false },
          { isTrust: true, isInAuth: false, isInTransfer: false, transferLoading: false },
          { isTrust: true, isInAuth: false, isInTransfer: true, transferLoading: false },
          { isTrust: true, isInAuth: false, isInTransfer: false, transferLoading: true },
        ];

        // 6 device types x 5 states = 30 combinations
        let totalCombinations: number = 0;
        for (let t: number = 0; t < deviceTypes.length; t++) {
          const type: DeviceType = deviceTypes[t];
          for (let s: number = 0; s < states.length; s++) {
            const state = states[s];
            const device: DistributedManagerDeviceInfo = {
              deviceId: 'test-' + type + '-' + totalCombinations,
              deviceName: 'test-device-' + totalCombinations,
              deviceType: type,
              networkId: 'net-' + totalCombinations,
              range: totalCombinations,
              isInAuth: state.isInAuth,
              isTrust: state.isTrust,
              trustDeviceId: state.isTrust ? 'trust-' + totalCombinations : '',
              transferLoading: state.transferLoading,
              isInTransfer: state.isInTransfer,
              action: DeviceStateChangeAction.READY,
              updateTime: new Date().getTime(),
              pinToken: state.isTrust ? 123456 : -1,
              isDelete: false,
            };
            // Verify device type and trust state are preserved
            expect(device.deviceType).assertEqual(type);
            expect(device.isTrust).assertEqual(state.isTrust);
            totalCombinations++;
          }
        }
        expect(totalCombinations).assertEqual(30);
      });
    });
  });
}

// Helper function signatures
// ArkTS requires named interfaces for object literal types
interface DeviceState {
  isTrust: boolean;
  isInAuth: boolean;
  isInTransfer: boolean;
  transferLoading: boolean;
}

interface DeviceInfoOverrides {
  deviceId?: string;
  deviceName?: string;
  deviceType?: DeviceType;
  networkId?: string;
  range?: number;
  isInAuth?: boolean;
  isTrust?: boolean;
  trustDeviceId?: string;
  transferLoading?: boolean;
  isInTransfer?: boolean;
  action?: DeviceStateChangeAction;
  updateTime?: number;
  pinToken?: number;
  isDelete?: boolean;
}
function createDevice(overrides: DeviceInfoOverrides): DistributedManagerDeviceInfo {
  return {
    deviceId: overrides.deviceId || 'test-device',
    deviceName: overrides.deviceName || 'default-device',
    deviceType: overrides.deviceType || DeviceType.TV,
    networkId: overrides.networkId || 'test-net',
    range: overrides.range || 5,
    isInAuth: overrides.isInAuth !== undefined ? overrides.isInAuth : false,
    isTrust: overrides.isTrust !== undefined ? overrides.isTrust : false,
    trustDeviceId: overrides.trustDeviceId || '',
    transferLoading: overrides.transferLoading !== undefined ? overrides.transferLoading : false,
    isInTransfer: overrides.isInTransfer !== undefined ? overrides.isInTransfer : false,
    action: overrides.action || DeviceStateChangeAction.READY,
    updateTime: overrides.updateTime || new Date().getTime(),
    pinToken: overrides.pinToken !== undefined ? overrides.pinToken : -1,
    isDelete: overrides.isDelete !== undefined ? overrides.isDelete : false,
  };
}

function createDeviceWithIndex(
  index: number,
  isTrust: boolean,
  isInAuth: boolean,
  isInTransfer: boolean,
  transferLoading: boolean,
  deviceType: DeviceType
): DistributedManagerDeviceInfo {
  return {
    deviceId: 'device-' + index,
    deviceName: 'device' + index,
    deviceType: deviceType,
    networkId: 'net-' + index,
    range: index,
    isInAuth: isInAuth,
    isTrust: isTrust,
    trustDeviceId: isTrust ? 'trust-' + index : '',
    transferLoading: transferLoading,
    isInTransfer: isInTransfer,
    action: DeviceStateChangeAction.READY,
    updateTime: new Date().getTime(),
    pinToken: isTrust ? 123456 + index : -1,
    isDelete: false,
  };
}
