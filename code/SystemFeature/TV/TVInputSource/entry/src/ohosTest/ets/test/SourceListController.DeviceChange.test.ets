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

import { afterEach, beforeEach, describe, expect, it } from '@ohos/hypium';
import { SourcePlugStateEntity } from '../../../main/ets/entity/SourcePlugStateEntity';
import { SourceListController } from '../../../main/ets/controller/SourceListController';
import { createSourceEntity, patchMember, restoreAll } from './Batch1TestHelper';

interface SourceRuntimeRecord {
  sourceId: number;
  sourceName: string;
  displayOrder: number;
  isPlugIn: boolean;
}

interface DeferredRefreshStore {
  callCount: number;
}

/**
 * Converts one runtime source entity into a stable assertion snapshot.
 *
 * @param entity Mutable source entity refreshed by the controller.
 * @returns SourceRuntimeRecord Plain record for ordered business assertions.
 */
function toRuntimeRecord(entity: SourcePlugStateEntity): SourceRuntimeRecord {
  return {
    sourceId: entity.getSourceId(),
    sourceName: entity.getSourceName(),
    displayOrder: entity.getDisplayOrder(),
    isPlugIn: entity.getIsPlugIn()
  };
}

/**
 * Converts a source list into comparable runtime snapshots.
 *
 * @param sourceList Mutable list shared with the page layer.
 * @returns SourceRuntimeRecord[] Ordered runtime records.
 */
function toRuntimeRecords(sourceList: SourcePlugStateEntity[]): SourceRuntimeRecord[] {
  const records: SourceRuntimeRecord[] = [];
  sourceList.forEach((item: SourcePlugStateEntity) => {
    records.push(toRuntimeRecord(item));
  });
  return records;
}

/**
 * Asserts one runtime record produced by device-change refresh logic.
 *
 * @param actual Actual record captured after refresh.
 * @param expected Expected business-facing snapshot.
 * @returns void.
 */
function assertRuntimeRecord(actual: SourceRuntimeRecord, expected: SourceRuntimeRecord): void {
  expect(actual.sourceId).assertEqual(expected.sourceId);
  expect(actual.sourceName).assertEqual(expected.sourceName);
  expect(actual.displayOrder).assertEqual(expected.displayOrder);
  expect(actual.isPlugIn).assertEqual(expected.isPlugIn);
}

/**
 * Asserts an ordered list of runtime records.
 *
 * @param actual Actual controller output snapshot.
 * @param expected Expected runtime snapshot.
 * @returns void.
 */
function assertRuntimeRecordList(
  actual: SourceRuntimeRecord[],
  expected: SourceRuntimeRecord[]
): void {
  expect(actual.length).assertEqual(expected.length);
  for (let index = 0; index < expected.length; index++) {
    assertRuntimeRecord(actual[index], expected[index]);
  }
}

/**
 * Exposes a mutable view of controller internals for targeted cache mutation.
 *
 * @param controller Controller under verification.
 * Applies a fully synchronous CEC cache snapshot to the controller.
 *
 * @param controller Controller whose runtime cache should be replaced.
 * @param names Map of HDMI port to visible OSD name.
 * @returns void.
 */
function setCecNames(controller: SourceListController, names: Map<number, string>): void {
  controller.replaceCecNamesForTest(names);
}

/**
 * Flushes pending microtasks so deferred CEC refresh patches can settle.
 *
 * @returns Promise<void> Promise resolved after two microtask turns.
 */
async function flushDeferredRefresh(): Promise<void> {
  await Promise.resolve();
  await Promise.resolve();
}

/**
 * Patches CEC refresh so each invocation installs its snapshot on a later
 * microtask, matching the controller's current fire-and-forget usage.
 *
 * @param controller Controller whose cache should change over time.
 * @param restores Restore callbacks owned by the current test case.
 * @param snapshots Ordered runtime snapshots to apply across invocations.
 * @returns DeferredRefreshStore Shared invocation recorder.
 */
function patchDeferredDeviceRefresh(
  controller: SourceListController,
  restores: Array<() => void>,
  snapshots: Array<Map<number, string>>
): DeferredRefreshStore {
  const store: DeferredRefreshStore = {
    callCount: 0
  };
  restores.push(
    patchMember(controller as Object, 'updateCecDeviceName', async (): Promise<void> => {
      const snapshotIndex = store.callCount;
      store.callCount += 1;
      await Promise.resolve();
      if (snapshotIndex >= snapshots.length) {
        return;
      }
      setCecNames(controller, snapshots[snapshotIndex]);
    })
  );
  return store;
}

/**
 * Registers Task-05 coverage for SourceListController runtime device-change
 * behavior and CEC refresh linkage.
 *
 * This suite locks down how the controller mutates an already-rendered source
 * list when external HDMI devices change. The page passes a live array into the
 * controller and expects in-place refresh, stable ordering and predictable
 * cross-cycle CEC cache updates, so these tests focus on that mutable boundary
 * instead of rechecking static list-loading behavior from Task-04.
 *
 * @returns void.
 */
export default function SourceListControllerDeviceChangeTest(): void {
  describe('SourceListController_device_change_task05', () => {
    let controller: SourceListController;
    let restores: Array<() => void> = [];

    beforeEach((): void => {
      controller = new SourceListController();
      restores = [];
    });

    afterEach((): void => {
      restoreAll(restores);
    });

    it('should_keep_register_device_change_as_a_safe_noop_when_service_hook_is_absent', 0, () => {
      const sourceList: SourcePlugStateEntity[] = [
        createSourceEntity(1, true, 0, 'HDMI1'),
        createSourceEntity(5, false, 4, 'AV')
      ];
      let refreshCalls = 0;
      restores.push(
        patchMember(controller as Object, 'updateSourceInfo', (_list: SourcePlugStateEntity[]): void => {
          refreshCalls += 1;
        })
      );

      // The runtime hook is not implemented in the product code yet. Calling the
      // registration entry point must therefore stay harmless for pages that
      // already invoke it during `aboutToAppear`.
      controller.registerDeviceChange(sourceList);

      expect(refreshCalls).assertEqual(0);
      assertRuntimeRecordList(toRuntimeRecords(sourceList), [
        { sourceId: 1, sourceName: 'HDMI1', displayOrder: 0, isPlugIn: true },
        { sourceId: 5, sourceName: 'AV', displayOrder: 4, isPlugIn: false }
      ]);
    });

    it('should_allow_unregister_device_change_without_prior_registration', 0, () => {
      const sourceList: SourcePlugStateEntity[] = [
        createSourceEntity(3, true, 2, 'HDMI3')
      ];

      // Page teardown always calls unregister even though the current runtime
      // hook is absent. Keeping this path side-effect free avoids destroy-time
      // crashes while the service contract is still unavailable.
      controller.unRegisterDeviceChange();

      assertRuntimeRecordList(toRuntimeRecords(sourceList), [
        { sourceId: 3, sourceName: 'HDMI3', displayOrder: 2, isPlugIn: true }
      ]);
    });

    it('should_refresh_the_same_page_owned_entities_in_place_when_cec_names_change', 0, () => {
      const hdmi1 = createSourceEntity(1, true, 0, 'HDMI1');
      const hdmi3 = createSourceEntity(3, false, 2, 'HDMI3');
      const av = createSourceEntity(5, true, 4, 'AV');
      const sourceList: SourcePlugStateEntity[] = [hdmi1, hdmi3, av];
      restores.push(
        patchMember(controller as Object, 'updateCecDeviceName', async (): Promise<void> => {
          setCecNames(controller, new Map<number, string>([
            [1, 'Console'],
            [3, 'TV Box']
          ]));
        })
      );

      // The index page keeps the same entity objects after initial rendering.
      // Device refresh therefore needs to mutate those objects in place instead
      // of rebuilding the list and breaking page-held references.
      controller.updateSourceInfo(sourceList);

      expect(sourceList[0] === hdmi1).assertEqual(true);
      expect(sourceList[1] === hdmi3).assertEqual(true);
      expect(sourceList[2] === av).assertEqual(true);
      assertRuntimeRecordList(toRuntimeRecords(sourceList), [
        { sourceId: 1, sourceName: 'Console', displayOrder: 0, isPlugIn: true },
        { sourceId: 3, sourceName: 'TV Box', displayOrder: 2, isPlugIn: false },
        { sourceId: 5, sourceName: 'AV', displayOrder: 4, isPlugIn: true }
      ]);
    });

    it('should_apply_deferred_cec_snapshot_on_the_next_refresh_cycle', 0, async () => {
      const sourceList: SourcePlugStateEntity[] = [
        createSourceEntity(1, true, 0, 'HDMI1'),
        createSourceEntity(3, true, 2, 'HDMI3')
      ];
      const refreshStore = patchDeferredDeviceRefresh(controller, restores, [
        new Map<number, string>([[1, 'Console']])
      ]);

      // `updateSourceInfo()` currently fires the async CEC refresh without
      // awaiting it. The first visual pass therefore uses the previous cache,
      // and the new device name becomes visible on the following refresh cycle.
      controller.updateSourceInfo(sourceList);

      assertRuntimeRecordList(toRuntimeRecords(sourceList), [
        { sourceId: 1, sourceName: 'HDMI1', displayOrder: 0, isPlugIn: true },
        { sourceId: 3, sourceName: 'HDMI3', displayOrder: 2, isPlugIn: true }
      ]);

      await flushDeferredRefresh();
      controller.updateSourceInfo(sourceList);

      expect(refreshStore.callCount).assertEqual(2);
      assertRuntimeRecordList(toRuntimeRecords(sourceList), [
        { sourceId: 1, sourceName: 'Console', displayOrder: 0, isPlugIn: true },
        { sourceId: 3, sourceName: 'HDMI3', displayOrder: 2, isPlugIn: true }
      ]);
    });

    it('should_replace_a_stale_cec_name_with_builtin_label_after_later_device_removal', 0, async () => {
      const sourceList: SourcePlugStateEntity[] = [
        createSourceEntity(1, true, 0, 'Legacy HDMI1'),
        createSourceEntity(5, true, 4, 'AV')
      ];
      patchDeferredDeviceRefresh(controller, restores, [
        new Map<number, string>([[1, 'Console']]),
        new Map<number, string>()
      ]);

      // Runtime device churn is a two-step process here: one refresh cycle picks
      // up the external device name, and a later cycle must clear it again after
      // the CEC cache has been refreshed to an empty snapshot.
      controller.updateSourceInfo(sourceList);
      await flushDeferredRefresh();
      controller.updateSourceInfo(sourceList);

      assertRuntimeRecordList(toRuntimeRecords(sourceList), [
        { sourceId: 1, sourceName: 'Console', displayOrder: 0, isPlugIn: true },
        { sourceId: 5, sourceName: 'AV', displayOrder: 4, isPlugIn: true }
      ]);

      await flushDeferredRefresh();
      controller.updateSourceInfo(sourceList);

      assertRuntimeRecordList(toRuntimeRecords(sourceList), [
        { sourceId: 1, sourceName: 'HDMI1', displayOrder: 0, isPlugIn: true },
        { sourceId: 5, sourceName: 'AV', displayOrder: 4, isPlugIn: true }
      ]);
    });

    it('should_preserve_order_and_plug_state_during_runtime_name_refresh', 0, () => {
      const sourceList: SourcePlugStateEntity[] = [
        createSourceEntity(5, false, 4, 'AV'),
        createSourceEntity(2, true, 1, 'HDMI2'),
        createSourceEntity(10, true, 5, 'VGA')
      ];
      restores.push(
        patchMember(controller as Object, 'updateCecDeviceName', async (): Promise<void> => {
          setCecNames(controller, new Map<number, string>([[2, 'Streaming Box']]));
        })
      );

      // Runtime refresh should only touch the visible names of HDMI entries. The
      // page relies on display order and plug-state fields staying intact so it
      // can update labels without rebuilding focus or availability state.
      controller.updateSourceInfo(sourceList);

      assertRuntimeRecordList(toRuntimeRecords(sourceList), [
        { sourceId: 5, sourceName: 'AV', displayOrder: 4, isPlugIn: false },
        { sourceId: 2, sourceName: 'Streaming Box', displayOrder: 1, isPlugIn: true },
        { sourceId: 10, sourceName: 'VGA', displayOrder: 5, isPlugIn: true }
      ]);
    });

    it('should_keep_using_the_latest_settled_cec_snapshot_across_repeated_runtime_refreshes', 0, async () => {
      const sourceList: SourcePlugStateEntity[] = [
        createSourceEntity(1, true, 0, 'HDMI1'),
        createSourceEntity(2, true, 1, 'HDMI2')
      ];
      const refreshStore = patchDeferredDeviceRefresh(controller, restores, [
        new Map<number, string>([
          [1, 'Console'],
          [2, 'SetTopBox']
        ])
      ]);

      // After the asynchronous cache settles, repeated refreshes with no new
      // device snapshot should keep the last known names stable instead of
      // drifting back to stale labels held by the original entities.
      controller.updateSourceInfo(sourceList);
      await flushDeferredRefresh();
      controller.updateSourceInfo(sourceList);
      controller.updateSourceInfo(sourceList);

      expect(refreshStore.callCount).assertEqual(3);
      assertRuntimeRecordList(toRuntimeRecords(sourceList), [
        { sourceId: 1, sourceName: 'Console', displayOrder: 0, isPlugIn: true },
        { sourceId: 2, sourceName: 'SetTopBox', displayOrder: 1, isPlugIn: true }
      ]);
    });
  });
}

