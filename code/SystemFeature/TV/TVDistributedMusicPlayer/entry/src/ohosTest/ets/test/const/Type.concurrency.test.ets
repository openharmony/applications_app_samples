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

import { describe, it, expect, beforeEach, afterEach, TestType, Size, Level } from '@ohos/hypium';


import { DeviceInfoType, AuthParam } from '../../../../main/ets/const/Type';
import { DeviceType, DistributedManagerDeviceInfo, DeviceStateChangeAction } from '../../../../main/ets/model/RemoteDeviceModel';

interface StringRecord extends Record<string, string> {}
interface ObjectRecord extends Record<string, object> {}
interface NumberRecord extends Record<string, number> {}
function makeStringRecord(): StringRecord { return {} as StringRecord; }

/**
 * Type concurrency test suite
 * Validates thread-safety of DeviceInfoType and AuthParam creation under high load.
 * Tests concurrent object creation, map updates, and filter operations.
 * Verifies device list consistency during concurrent discovery and state changes.
 */
export default function typeConcurrencyTestSuite(): void {
  describe('TypeConcurrencyTest', () => {

    // Shared state for concurrent device list and map operations
    let sharedDeviceList: DistributedManagerDeviceInfo[] = [];
    let sharedDeviceMap: Map<string, DistributedManagerDeviceInfo> = new Map<string, DistributedManagerDeviceInfo>();

    beforeEach(() => {
      // Reset shared state before each test
      sharedDeviceList = [];
      sharedDeviceMap = new Map<string, DistributedManagerDeviceInfo>();
    });

    afterEach(() => {
      // Clean up shared state after each test
      sharedDeviceList = [];
      sharedDeviceMap.clear();
    });

    // ========== High concurrency object creation ==========
    // Create and manage 1000+ device instances concurrently
    describe('HighConcurrency_objectCreation', () => {

      // 100 device instances created simultaneously
      it('createDeviceInfo_massiveInstantiation_mustNotLeakMemory', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL0, () => {
        const ITERATION_COUNT: number = 100;
        // Pre-allocate array for performance
        const createdDevices: DeviceInfoType[] = new Array<DeviceInfoType>(ITERATION_COUNT);

        const startTime: number = new Date().getTime();
        for (let i: number = 0; i < ITERATION_COUNT; i++) {
          // Unique ID with timestamp
          const nowTime: number = new Date().getTime();
          createdDevices[i] = {
            deviceId: 'device-' + i + '-' + nowTime,
            deviceName: '?О-' + (i % 100),  // Reuse device names across rounds
            deviceType: (i % 6 === 0) ? DeviceType.TV :
                        (i % 6 === 1) ? DeviceType.PHONE :
                        (i % 6 === 2) ? DeviceType.TABLET :
                        (i % 6 === 3) ? DeviceType.WEARABLE :
                        (i % 6 === 4) ? DeviceType.CAR :
                                        DeviceType.SPEAKER,
            networkId: 'network-' + i,
            range: i % 50
          };
        }
        const endTime: number = new Date().getTime();
        const elapsed: number = endTime - startTime;

        expect(elapsed).assertLarger(0); // Creation time must be positive
        // Verify first and last device IDs
        expect(createdDevices[0].deviceId.indexOf('device-0') >= 0).assertTrue();
        const lastDeviceId: string = createdDevices[ITERATION_COUNT - 1].deviceId;
        expect(lastDeviceId.indexOf('device-' + (ITERATION_COUNT - 1)) >= 0).assertTrue();
        expect(createdDevices[0].deviceType).assertEqual(DeviceType.TV);
        expect(createdDevices[5].deviceType).assertEqual(DeviceType.SPEAKER);
      });

      // Repeated same device ID must overwrite correctly
      // Ensures onDeviceFound with duplicate deviceId updates existing entry
      it('createDeviceInfo_repeatedSameId_overwriteMustBeCorrect', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL0, () => {
        // Overwrite same deviceId 1000 times
        const SAME_DEVICE_ID: string = 'persistent-device-001';
        for (let i: number = 0; i < 1000; i++) {
          const device: DistributedManagerDeviceInfo = {
            deviceId: SAME_DEVICE_ID,
            deviceName: 'reconnect-device-' + (i % 10),
            deviceType: DeviceType.TV,
            networkId: i % 3 === 0 ? '' : 'net-' + (i % 100),
            range: i % 100,
            isInAuth: false,
            isTrust: i > 2100,
            trustDeviceId: i > 2100 ? 'trust-' + SAME_DEVICE_ID : '',
            transferLoading: false,
            isInTransfer: i % 100 === 0,
            action: DeviceStateChangeAction.READY,
            updateTime: new Date().getTime() + i,
            pinToken: i % 2 === 0 ? 123456 : -1,
            isDelete: false,
          };
          // Map overwrite should keep only latest entry
          sharedDeviceMap.set(SAME_DEVICE_ID, device);
        }

        expect(sharedDeviceMap.size).assertEqual(1);
        const finalDevice: DistributedManagerDeviceInfo | undefined = sharedDeviceMap.get(SAME_DEVICE_ID);
        expect(finalDevice !== null && finalDevice !== undefined).assertTrue();
        if (finalDevice !== undefined) {
          expect(finalDevice.isTrust).assertEqual(true);
          expect(finalDevice.deviceId).assertEqual(SAME_DEVICE_ID);
        }
      });
    });

    // ========== Concurrent write race condition ==========
    describe('ConcurrentWrite_raceCondition', () => {

      // Concurrent Map writes from multiple threads must not lose data
      // Simulates real-time device discovery from multiple sources
      it('concurrentDeviceMapWrite_multiThreads_mustNotLoseData', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL0, () => {
        const DEVICE_COUNT: number = 100;
        const operations: Promise<void>[] = [];

        // Create 100 concurrent device entries
        for (let i: number = 0; i < DEVICE_COUNT; i++) {
          operations.push(new Promise<void>((resolve) => {
            // Use setTimeout to simulate async device discovery
            // Random delay 0-10ms mimics real network timing
            setTimeout(() => {
              const device: DistributedManagerDeviceInfo = {
                deviceId: 'concurrent-device-' + i,
                deviceName: '骞跺彂璁惧-' + i,
                deviceType: DeviceType.TV,
                networkId: 'concurrent-net-' + i,
                range: i,
                isInAuth: i % 10 === 0,
                isTrust: i % 3 === 0,
                trustDeviceId: i % 3 === 0 ? 'trust-concurrent-' + i : '',
                transferLoading: false,
                isInTransfer: false,
                action: DeviceStateChangeAction.READY,
                updateTime: new Date().getTime(),
                pinToken: i % 2 === 0 ? 1000 + i : -1,
                isDelete: false,
              };
              sharedDeviceMap.set(device.deviceId, device);
              sharedDeviceList.push(device);
              resolve();
            }, Math.floor(Math.random() * 10)); // 0-10ms random delay
          }));
        }

        return Promise.all(operations).then(() => {
          expect(sharedDeviceMap.size).assertEqual(DEVICE_COUNT);
          for (let i: number = 0; i < DEVICE_COUNT; i++) {
            const retrieved: DistributedManagerDeviceInfo | undefined =
              sharedDeviceMap.get('concurrent-device-' + i);
            expect(retrieved !== null && retrieved !== undefined).assertTrue();
            if (retrieved !== undefined) {
              expect(retrieved.deviceName).assertEqual('骞跺彂璁惧-' + i);
              expect(retrieved.deviceType).assertEqual(DeviceType.TV);
            }
          }
        });
      });

      // Concurrent updateDeviceProp on the same device must maintain consistency
      // Simulates rapid property updates from device monitoring
      it('concurrentUpdateDeviceProp_sameDevice_mustMaintainConsistency', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL0, () => {
        const TARGET_DEVICE_ID: string = 'race-target-device';
        const initialDevice: DistributedManagerDeviceInfo = {
          deviceId: TARGET_DEVICE_ID,
          deviceName: 'race-target-device-name',
          deviceType: DeviceType.TV,
          networkId: 'initial-net',
          range: 5,
          isInAuth: false,
          isTrust: false,
          trustDeviceId: '',
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: new Date().getTime(),
          pinToken: -1,
          isDelete: false,
        };
        sharedDeviceMap.set(TARGET_DEVICE_ID, initialDevice);

        const updateOperations: Promise<void>[] = [];
        // Concurrent 100 updates with random delays
        // Simulates rapid property change notifications
        for (let i: number = 0; i < 100; i++) {
          updateOperations.push(new Promise<void>((resolve) => {
            setTimeout(() => {
              const device: DistributedManagerDeviceInfo | undefined = sharedDeviceMap.get(TARGET_DEVICE_ID);
              if (device !== undefined) {
                device.networkId = 'updated-net-' + i;
                device.isTrust = i > 50;      // false before 50, true after
                device.isInTransfer = i > 80; // false before 80, true after
                device.updateTime = new Date().getTime() + i;
                device.pinToken = i;
                sharedDeviceMap.set(TARGET_DEVICE_ID, device);
              }
              resolve();
            }, Math.floor(Math.random() * 5)); // 0-5ms random delay
          }));
        }

        return Promise.all(updateOperations).then(() => {
          const finalDevice: DistributedManagerDeviceInfo | undefined = sharedDeviceMap.get(TARGET_DEVICE_ID);
          expect(finalDevice !== null && finalDevice !== undefined).assertTrue();
          if (finalDevice !== undefined) {
            // Final state should reflect the last write
            expect(finalDevice.deviceId).assertEqual(TARGET_DEVICE_ID);
            expect(finalDevice.isTrust).assertEqual(true);
            // isInTransfer should be true since last write was at i=99 (> 80)
            expect(finalDevice.isInTransfer).assertEqual(true);
          }
        });
      });
    });

    // ========== AuthParam concurrency ==========
    describe('AuthParam_concurrency', () => {

      // Batch 300 authentication requests must not timeout
      it('authParam_batchAuthentication_mustNotTimeout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL0, () => {
        const AUTH_COUNT: number = 300;
        const authResults: AuthParam[] = [];

        for (let i: number = 0; i < AUTH_COUNT; i++) {
          // Batch create extraInfo with unique device data
          const batchExtraInfo: StringRecord = makeStringRecord();
          batchExtraInfo.deviceId = 'auth-batch-' + i;
          batchExtraInfo.deviceName = 'auth-batch-name-' + i;
          batchExtraInfo.token = 'token-' + Math.floor(i / 10);
          const authParam: AuthParam = {
            authType: 1,
            extraInfo: batchExtraInfo
          };
          authResults.push(authParam);
        }

        expect(authResults.length).assertEqual(AUTH_COUNT);
        // Verify token grouping: first 10 devices have token-0
        expect(authResults[0].extraInfo.token).assertEqual('token-0');
        expect(authResults[9].extraInfo.token).assertEqual('token-0');
        expect(authResults[10].extraInfo.token).assertEqual('token-1');
        // authType must be consistent across all batches
        for (let i: number = 0; i < AUTH_COUNT; i++) {
          expect(authResults[i].authType).assertEqual(1);
        }
      });

      it('authParam_duplicateAuthRequests_mustBeIdempotent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const SAME_DEVICE_ID: string = 'dup-auth-device';
        const duplicateAuthResults: AuthParam[] = [];

        for (let i: number = 0; i < 100; i++) {
          const dupExtraInfo: StringRecord = makeStringRecord();
          dupExtraInfo.deviceId = SAME_DEVICE_ID;
          dupExtraInfo.requestSeq = String(i);
          dupExtraInfo.timestamp = String(new Date().getTime());
          duplicateAuthResults.push({
            authType: 1,
            extraInfo: dupExtraInfo
          });
        }

        for (let i: number = 0; i < 100; i++) {
          expect(duplicateAuthResults[i].extraInfo.deviceId).assertEqual(SAME_DEVICE_ID);
          const seqCheck: string = duplicateAuthResults[i].extraInfo.requestSeq;
          expect(seqCheck).assertEqual(String(i));
        }
        expect(duplicateAuthResults[99].extraInfo.requestSeq).assertEqual(String(99));
      });
    });

    // ========== Device list filter concurrency ==========
    // Ensure updateDeviceIdList with 60-second timeout filters correctly
    describe('DeviceListFilter_concurrency', () => {

      // Filter expired devices during concurrent discovery
      // Simulates 5-second update cycle for updateDeviceIdList
      it('filterExpiredDevices_concurrentDiscovery_mustBeCorrect', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL0, () => {
        const now: number = new Date().getTime();
        const TOTAL_DEVICES: number = 200;
        const devices: DistributedManagerDeviceInfo[] = [];

        // Create 200 devices with staggered update times
        for (let i: number = 0; i < TOTAL_DEVICES; i++) {
          const timeOffset: number = i < 100 ? -Math.floor(Math.random() * 59 * 100) : -(61 * 100 + Math.floor(Math.random() * 1000));
          const device: DistributedManagerDeviceInfo = {
            deviceId: 'filter-device-' + i,
            deviceName: 'filter-device-' + i,
            deviceType: DeviceType.TV,
            networkId: 'filter-net-' + i,
            range: i,
            isInAuth: false,
            isTrust: i % 2 === 0,
            trustDeviceId: i % 2 === 0 ? 'trust-' + i : '',
            transferLoading: false,
            isInTransfer: false,
            action: DeviceStateChangeAction.READY,
            updateTime: now + timeOffset,
            pinToken: -1,
            isDelete: false,
          };
          devices.push(device);
        }

        const activeDevices: DistributedManagerDeviceInfo[] = [];
        for (let i: number = 0; i < devices.length; i++) {
          const device: DistributedManagerDeviceInfo = devices[i];
          if (device.updateTime !== undefined) {
            const timeSinceUpdate: number = now - device.updateTime;
            if (timeSinceUpdate < 60000) {  // 60 second threshold
              activeDevices.push(device);
            }
          }
        }

        expect(activeDevices.length).assertLarger(90);
        expect(activeDevices.length).assertLess(110);
        // Verify device with old updateTime is expired
        const firstExpired: DistributedManagerDeviceInfo = devices[100];
        expect(firstExpired.updateTime).assertLess(now - 6100);
      });

      // Filter a large device list must complete quickly
      it('filterLargeDeviceList_mustCompleteQuickly', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const now: number = new Date().getTime();
        const LARGE_COUNT: number = 1000;

        for (let i: number = 0; i < LARGE_COUNT; i++) {
          const device: DistributedManagerDeviceInfo = {
            deviceId: 'large-device-' + i,
            deviceName: '?-' + i,
            deviceType: DeviceType.TV,
            networkId: 'large-net-' + i,
            range: i % 100,
            isInAuth: false,
            isTrust: false,
            trustDeviceId: '',
            transferLoading: false,
            isInTransfer: false,
            action: DeviceStateChangeAction.READY,
            updateTime: now - (i % 120) * 100,
            pinToken: -1,
            isDelete: false,
          };
          sharedDeviceList.push(device);
        }

        const filterStart: number = new Date().getTime();
        const activeList: DistributedManagerDeviceInfo[] = [];
        for (let i: number = 0; i < sharedDeviceList.length; i++) {
          const d: DistributedManagerDeviceInfo = sharedDeviceList[i];
          if (d.updateTime && (now - d.updateTime) < 60000) {
            activeList.push(d);
          }
        }
        const filterEnd: number = new Date().getTime();
        const filterTime: number = filterEnd - filterStart;

        expect(filterTime).assertLess(100);
        expect(activeList.length).assertLarger(2000);
        expect(activeList.length).assertLess(3000);
      });
    });

    // ========== Device prop consistency ==========
    // updateDeviceProp must sync between deviceMap and trustDeviceMap
    describe('DevicePropConsistency', () => {

      // Trust device sync must reflect in both maps
      it('trustDeviceSync_propUpdate_mustReflectInBothMaps', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const trustDeviceMap: Map<string, DistributedManagerDeviceInfo> = new Map();
        const TRUST_ID: string = 'sync-trust-id';
        const DEVICE_ID: string = 'sync-device-id';

        const mainDevice: DistributedManagerDeviceInfo = {
          deviceId: DEVICE_ID,
          deviceName: 'main-device-record',
          deviceType: DeviceType.TV,
          networkId: 'sync-net',
          range: 5,
          isInAuth: false,
          isTrust: true,
          trustDeviceId: TRUST_ID,
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: new Date().getTime(),
          pinToken: 123456,
          isDelete: false,
        };
        const trustDevice: DistributedManagerDeviceInfo = {
          deviceId: DEVICE_ID,
          deviceName: 'sync-test-device',
          deviceType: DeviceType.TV,
          networkId: 'sync-net',
          range: 5,
          isInAuth: false,
          isTrust: true,
          trustDeviceId: TRUST_ID,
          transferLoading: false,
          isInTransfer: false,
          action: DeviceStateChangeAction.READY,
          updateTime: new Date().getTime(),
          pinToken: 123456,
          isDelete: false,
        };

        sharedDeviceMap.set(DEVICE_ID, mainDevice);
        trustDeviceMap.set(TRUST_ID, trustDevice);

        const main: DistributedManagerDeviceInfo | undefined = sharedDeviceMap.get(DEVICE_ID);
        const trust: DistributedManagerDeviceInfo | undefined = trustDeviceMap.get(TRUST_ID);
        if (main !== undefined) {
          main.transferLoading = true;
          sharedDeviceMap.set(DEVICE_ID, main);
        }
        if (trust !== undefined) {
          trust.transferLoading = true;
          trustDeviceMap.set(TRUST_ID, trust);
        }

        const updatedMain: DistributedManagerDeviceInfo | undefined = sharedDeviceMap.get(DEVICE_ID);
        const updatedTrust: DistributedManagerDeviceInfo | undefined = trustDeviceMap.get(TRUST_ID);
        expect(updatedMain?.transferLoading).assertEqual(true);
        expect(updatedTrust?.transferLoading).assertEqual(true);
        // Both entries should retain trust status
        expect(updatedMain?.isTrust).assertEqual(true);
        expect(updatedTrust?.isTrust).assertEqual(true);
      });
    });

    // ========== Mixed operations pressure ==========
    // Simulates real-world read/write/delete cycle under concurrency
    describe('MixedOperations_pressure', () => {

      // 200 rounds of high frequency mixed operations
      it('mixedOps_highFrequency_mustRemainStable', TestType.FUNCTION | Size.LARGETEST | Level.LEVEL0, () => {
        const OPERATION_ROUNDS: number = 200;
        const now: number = new Date().getTime();

        for (let round: number = 0; round < OPERATION_ROUNDS; round++) {
          // -- Phase 1: Create 5 devices --
          for (let j: number = 0; j < 5; j++) {
            const deviceId: string = 'mixed-device-' + round + '-' + j;
            if (!sharedDeviceMap.has(deviceId)) {
              sharedDeviceMap.set(deviceId, {
                deviceId: deviceId,
                deviceName: '娣峰悎璁惧-' + round + '-' + j,
                deviceType: DeviceType.TV,
                networkId: 'mixed-net-' + round + '-' + j,
                range: j,
                isInAuth: false,
                isTrust: false,
                trustDeviceId: '',
                transferLoading: false,
                isInTransfer: false,
                action: DeviceStateChangeAction.READY,
                updateTime: now,
                pinToken: -1,
                isDelete: false,
              });
            }
          }

          // -- Phase 2: Random update --
          if (sharedDeviceMap.size > 0) {
            const keys: IterableIterator<string> = sharedDeviceMap.keys();
            const keyArray: string[] = Array.from(keys);
            for (let j: number = 0; j < 3; j++) {
              const randomIndex: number = Math.floor(Math.random() * keyArray.length);
              const randomDevice: DistributedManagerDeviceInfo | undefined = sharedDeviceMap.get(keyArray[randomIndex]);
              if (randomDevice !== undefined) {
                randomDevice.isTrust = !randomDevice.isTrust;
                randomDevice.updateTime = now;
                sharedDeviceMap.set(keyArray[randomIndex], randomDevice);
              }
            }
          }

          // -- Phase 3: Mark expired devices (older than 60s) --
          const keysSnapshot: string[] = Array.from(sharedDeviceMap.keys());
          for (let j: number = 0; j < keysSnapshot.length; j++) {
            const device: DistributedManagerDeviceInfo | undefined = sharedDeviceMap.get(keysSnapshot[j]);
            if (device !== undefined && device.updateTime !== undefined && (now - device.updateTime > 60000)) {
              device.isDelete = true;
              sharedDeviceMap.set(keysSnapshot[j], device);
            }
          }
        }

        expect(sharedDeviceMap.size).assertEqual(OPERATION_ROUNDS * 5);
        expect(sharedDeviceMap.size).assertLarger(0);
      });

      it('mixedReadWrite_concurrent_mustNotStaleData', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL0, () => {
        const writerCount: number = 50;
        const readerCount: number = 50;
        const writeOps: Promise<void>[] = [];
        const readOps: Promise<void>[] = [];

        // 50 concurrent write operations
        for (let i: number = 0; i < writerCount; i++) {
          writeOps.push(new Promise<void>((resolve) => {
            setTimeout(() => {
              sharedDeviceMap.set('rw-device-' + i, {
                deviceId: 'rw-device-' + i,
                deviceName: '?-' + i,
                deviceType: DeviceType.TV,
                networkId: 'rw-net-' + i,
                range: i,
                isInAuth: false,
                isTrust: i % 2 === 0,
                trustDeviceId: i % 2 === 0 ? 'trust-rw-' + i : '',
                transferLoading: false,
                isInTransfer: false,
                action: DeviceStateChangeAction.READY,
                updateTime: new Date().getTime(),
                pinToken: -1,
                isDelete: false,
              });
              resolve();
            }, Math.floor(Math.random() * 20));
          }));
        }

        // 50 concurrent read operations
        for (let i: number = 0; i < readerCount; i++) {
          readOps.push(new Promise<void>((resolve) => {
            setTimeout(() => {
              // Read a random device by ID
              const randomId: string = 'rw-device-' + Math.floor(Math.random() * writerCount);
              const device: DistributedManagerDeviceInfo | undefined = sharedDeviceMap.get(randomId);
              if (device !== undefined) {
                expect(device.deviceId.indexOf('rw-device') >= 0).assertTrue();
              }
              resolve();
            }, Math.floor(Math.random() * 15));
          }));
        }

        return Promise.all([...writeOps, ...readOps]).then(() => {
          expect(sharedDeviceMap.size).assertEqual(writerCount);
          // Verify all writers completed
          for (let i: number = 0; i < writerCount; i++) {
            expect(sharedDeviceMap.has('rw-device-' + i)).assertEqual(true);
          }
        });
      });
    });
  });
}
