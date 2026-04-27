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

import { beforeEach, describe, expect, it } from '@ohos/hypium';
import { MultiPageListenerManager, MultiPageListenerType } from '../../../main/ets/manager/MultiPageListenerManager';
import { SourcePlugState } from '../../../main/ets/manager/SourceManager';
import { createCallRecorder, CallRecorder, recordCall } from './Batch1TestHelper';

interface ListenerPlan {
  id: string;
  label: string;
  enableCallback?: boolean;
}

/**
 * Creates a stable plug-state fixture used by listener manager assertions.
 *
 * @param source Input source identifier that flows through the manager.
 * @param isPlugIn Whether the source should be treated as plugged in.
 * @returns SourcePlugState Compact business fixture for one event.
 */
function createPlugState(source: number, isPlugIn: boolean): SourcePlugState {
  return {
    source,
    isPluIn: isPlugIn
  };
}

/**
 * Creates a listener fixture that records business-visible callbacks.
 *
 * @param plan Listener identity and callback behavior plan.
 * @param recorder Shared call recorder for the current test case.
 * @returns MultiPageListenerType Ready-to-register listener fixture.
 */
function createListener(plan: ListenerPlan, recorder: CallRecorder): MultiPageListenerType {
  const listener = new MultiPageListenerType();
  listener.id = plan.id;
  if (plan.enableCallback !== false) {
    listener.onPlugChange = (plugState: SourcePlugState): void => {
      recordCall(recorder, `${plan.label}:${plugState.source}:${plugState.isPluIn}`);
    };
  }
  return listener;
}

/**
 * Registers multiple listeners in the provided manager using a stable order.
 *
 * @param manager Target listener manager under verification.
 * @param listeners Fixtures that should become active.
 * @returns void.
 */
function registerListeners(
  manager: MultiPageListenerManager,
  listeners: MultiPageListenerType[]
): void {
  listeners.forEach((listener: MultiPageListenerType) => {
    manager.register(listener);
  });
}

/**
 * Broadcasts one plug-state event through the manager.
 *
 * @param manager Target listener manager under verification.
 * @param source Input source identifier carried by the event.
 * @param isPlugIn Whether the event represents plug-in or plug-out.
 * @returns void.
 */
function emitPlugChange(
  manager: MultiPageListenerManager,
  source: number,
  isPlugIn: boolean
): void {
  manager.onPlugChange(createPlugState(source, isPlugIn));
}

/**
 * Asserts an ordered business callback history.
 *
 * @param recorder Shared recorder filled by active listeners.
 * @param expected Expected observable callback entries.
 * @returns void.
 */
function assertRecorderEntries(recorder: CallRecorder, expected: string[]): void {
  expect(recorder.entries.length).assertEqual(expected.length);
  expect(recorder.entries.join(',')).assertEqual(expected.join(','));
}

/**
 * Creates a singleton-safe listener id used by the current test case.
 *
 * @param suffix Stable suffix that explains the test scenario.
 * @returns string Unique listener id for singleton-scoped tests.
 */
function createSingletonListenerId(suffix: string): string {
  return `task03_singleton_${suffix}`;
}

/**
 * Registers Task-03 contract coverage for MultiPageListenerManager.
 *
 * The lightweight manager sits on the boundary between device hot-plug signals
 * and multiple visible pages, so small contract drifts can cascade into stale
 * launcher state everywhere. This suite focuses on identity, ordering and exact
 * unregister semantics that page-level tests usually assume but rarely prove.
 *
 * @returns void.
 */
export default function MultiPageListenerManagerContractTest(): void {
  describe('MultiPageListenerManager_contract_task03', () => {
    let manager: MultiPageListenerManager;
    let recorder: CallRecorder;

    beforeEach((): void => {
      manager = new MultiPageListenerManager();
      recorder = createCallRecorder();
    });

    it('should_keep_singleton_identity_and_share_listener_state_between_reads', 0, () => {
      const singletonFirst = MultiPageListenerManager.getInStance();
      const singletonSecond = MultiPageListenerManager.getInStance();
      const listener = createListener(
        {
          id: createSingletonListenerId('shared_state'),
          label: 'singletonShared'
        },
        recorder
      );

      // Hot-plug dispatch relies on every page retrieving the exact same manager
      // instance. If singleton identity drifts, one page can register while a
      // different page emits events into an empty registry.
      expect(singletonFirst === singletonSecond).assertEqual(true);
      singletonFirst.register(listener);
      try {
        emitPlugChange(singletonSecond, 3, true);
      } finally {
        singletonFirst.unregister(listener);
      }

      assertRecorderEntries(recorder, ['singletonShared:3:true']);
    });

    it('should_notify_registered_listeners_in_insertion_order', 0, () => {
      const first = createListener({ id: 'pageA', label: 'A' }, recorder);
      const second = createListener({ id: 'pageB', label: 'B' }, recorder);
      const third = createListener({ id: 'pageC', label: 'C' }, recorder);

      // Page refresh choreography can depend on deterministic fan-out order when
      // multiple routes update focus or cache state from the same source event.
      registerListeners(manager, [first, second, third]);
      emitPlugChange(manager, 5, false);

      assertRecorderEntries(recorder, ['A:5:false', 'B:5:false', 'C:5:false']);
    });

    it('should_preserve_original_map_slot_when_same_id_listener_is_replaced', 0, () => {
      const originalFirst = createListener({ id: 'pageA', label: 'oldA' }, recorder);
      const stableSecond = createListener({ id: 'pageB', label: 'B' }, recorder);
      const replacementFirst = createListener({ id: 'pageA', label: 'newA' }, recorder);

      // Recreated pages should replace stale handlers without changing their
      // relative broadcast position, otherwise refresh ordering can drift across
      // page reopen cycles and become almost impossible to debug from the UI.
      registerListeners(manager, [originalFirst, stableSecond]);
      manager.register(replacementFirst);
      emitPlugChange(manager, 1, true);

      assertRecorderEntries(recorder, ['newA:1:true', 'B:1:true']);
    });

    it('should_ignore_unregister_attempt_when_id_matches_but_instance_differs', 0, () => {
      const active = createListener({ id: 'pageA', label: 'active' }, recorder);
      const staleCopy = createListener({ id: 'pageA', label: 'staleCopy' }, recorder);

      // Pages can hold stale listener objects after reconstruction. The manager
      // must compare by both id and object identity so a dead instance does not
      // accidentally unregister the currently active page callback.
      manager.register(active);
      manager.unregister(staleCopy);
      emitPlugChange(manager, 2, true);

      assertRecorderEntries(recorder, ['active:2:true']);
    });

    it('should_ignore_unregister_for_unknown_listener_without_touching_others', 0, () => {
      const first = createListener({ id: 'pageA', label: 'A' }, recorder);
      const second = createListener({ id: 'pageB', label: 'B' }, recorder);
      const ghost = createListener({ id: 'pageZ', label: 'ghost' }, recorder);

      // Teardown code often runs defensively. Ignoring unknown listeners keeps
      // cleanup idempotent and prevents unrelated pages from being removed.
      registerListeners(manager, [first, second]);
      manager.unregister(ghost);
      emitPlugChange(manager, 4, false);

      assertRecorderEntries(recorder, ['A:4:false', 'B:4:false']);
    });

    it('should_continue_broadcasting_when_one_listener_has_no_callback', 0, () => {
      const silent = createListener(
        {
          id: 'pageSilent',
          label: 'silent',
          enableCallback: false
        },
        recorder
      );
      const active = createListener({ id: 'pageActive', label: 'active' }, recorder);

      // Some pages only care about registration presence and provide no runtime
      // handler. Optional chaining must let the broadcast continue to later pages
      // rather than treating an empty callback slot as a fatal branch.
      registerListeners(manager, [silent, active]);
      emitPlugChange(manager, 6, true);

      assertRecorderEntries(recorder, ['active:6:true']);
    });

    it('should_not_duplicate_callbacks_when_same_listener_object_registers_twice', 0, () => {
      const listener = createListener({ id: 'pageA', label: 'A' }, recorder);

      // A single page can defensively register on repeated lifecycle hooks.
      // Registering the exact same object twice should still leave only one
      // active slot because the internal map key is the page id.
      manager.register(listener);
      manager.register(listener);
      emitPlugChange(manager, 7, false);

      assertRecorderEntries(recorder, ['A:7:false']);
    });

    it('should_allow_re_registration_after_precise_unregistration', 0, () => {
      const firstGeneration = createListener({ id: 'pageA', label: 'firstGen' }, recorder);
      const secondGeneration = createListener({ id: 'pageA', label: 'secondGen' }, recorder);

      // Page recreation should be able to cleanly unregister the old callback
      // and then install a new one under the same id without leaving gaps.
      manager.register(firstGeneration);
      manager.unregister(firstGeneration);
      manager.register(secondGeneration);
      emitPlugChange(manager, 8, true);

      assertRecorderEntries(recorder, ['secondGen:8:true']);
    });

    it('should_keep_other_listeners_active_after_one_listener_unregisters_itself_earlier', 0, () => {
      const first = createListener({ id: 'pageA', label: 'A' }, recorder);
      const second = createListener({ id: 'pageB', label: 'B' }, recorder);

      // Removing one page from the registry must not disturb neighbors because
      // page hide/show events frequently interleave with later source updates.
      registerListeners(manager, [first, second]);
      manager.unregister(first);
      emitPlugChange(manager, 9, false);

      assertRecorderEntries(recorder, ['B:9:false']);
    });

    it('should_treat_default_empty_id_as_a_single_replaceable_slot', 0, () => {
      const firstAnonymous = createListener({ id: '', label: 'firstAnonymous' }, recorder);
      const secondAnonymous = createListener({ id: '', label: 'secondAnonymous' }, recorder);

      // The default listener id is an empty string. Locking this behavior in a
      // test prevents accidental assumptions that anonymous listeners can coexist
      // when the map actually treats them as one shared registration slot.
      manager.register(firstAnonymous);
      manager.register(secondAnonymous);
      emitPlugChange(manager, 10, true);

      assertRecorderEntries(recorder, ['secondAnonymous:10:true']);
    });
  });
}

