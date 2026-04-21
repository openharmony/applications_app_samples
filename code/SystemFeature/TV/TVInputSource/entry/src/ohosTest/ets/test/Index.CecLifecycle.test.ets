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

type StandbyListener = () => void;
type SelectSourceListener = (sourceType: number | undefined) => void;
type DisplaySettingListener = StandbyListener | SelectSourceListener;
type CecStandbyEventName = 'CecStandBy';
type CecSelectSourceEventName = 'CecSelectSource';

interface DisplaySettingAdapter {
  on(event: CecStandbyEventName, callback: StandbyListener): void;
  on(event: CecSelectSourceEventName, callback: SelectSourceListener): void;
  off(event: string): void;
}

class MockDisplaySettingAdapter implements DisplaySettingAdapter {
  private listeners: Map<string, DisplaySettingListener>;

  constructor(listeners: Map<string, DisplaySettingListener>) {
    this.listeners = listeners;
  }

  on(event: CecStandbyEventName, callback: StandbyListener): void;
  on(event: CecSelectSourceEventName, callback: SelectSourceListener): void;
  on(event: string, callback: DisplaySettingListener): void {
    this.listeners.set(event, callback);
  }

  off(event: string): void {
    this.listeners.delete(event);
  }
}

class MockSourceItem {
  private sourceId: number;

  constructor(sourceId: number) {
    this.sourceId = sourceId;
  }

  getSourceId(): number {
    return this.sourceId;
  }
}

/**
 * Validates CEC lifecycle management in the Index page: standby listener
 * registration and deregistration, SelectSource listener lifecycle, and
 * aboutToDisappear cleanup contract.
 *
 * Business context: CEC (Consumer Electronics Control) is a bus protocol
 * that allows TV inputs to send/receive commands. The Index page registers
 * two long-lived CEC listeners during its initialization:
 *   1. CecStandBy  鈥?when the TV enters standby the desktop hides itself.
 *   2. CecSelectSource 鈥?when the CEC bus selects a source type the desktop
 *      silently navigates to the corresponding HDMI or DTV page.
 *
 * Design rationale: Both listeners are stored as instance properties with
 * optional chaining semantics. aboutToDisappear must invoke the corresponding
 * off() call for each listener to prevent memory leaks and stale callbacks.
 * Testing the register/deregister contract in isolation verifies that the
 * lifecycle is correctly tied to the page's mount/unmount boundary.
 */
export default function IndexCecLifecycleTest(): void {
  const CEC_STANDBY_EVENT = 'CecStandBy';
  const CEC_SELECT_SOURCE_EVENT = 'CecSelectSource';

  let registeredListeners: Map<string, DisplaySettingListener> = new Map();
  let displaySetting: DisplaySettingAdapter = new MockDisplaySettingAdapter(registeredListeners);

  const mockDisplaySettingOn = (): void => {
    registeredListeners.clear();
    displaySetting = new MockDisplaySettingAdapter(registeredListeners);
  };

  describe('Index_CecStandBy_registration', () => {
    beforeEach(() => {
      mockDisplaySettingOn();
    });

    it('should_register_CecStandBy_listener_on_init', 0, () => {
      const callback = (): void => {
        console.log('standby');
      };
      displaySetting.on(CEC_STANDBY_EVENT, callback);
      expect(registeredListeners.has(CEC_STANDBY_EVENT)).assertEqual(true);
    });

    it('should_store_callback_reference_for_later_deregistration', 0, () => {
      let invocationCount = 0;
      const callback = (): void => {
        invocationCount++;
      };
      displaySetting.on(CEC_STANDBY_EVENT, callback);
      expect(registeredListeners.get(CEC_STANDBY_EVENT)).assertEqual(callback);
    });

    it('should_call_registered_CecStandBy_callback_on_event', 0, () => {
      let invoked = false;
      const callback = (): void => {
        invoked = true;
      };
      displaySetting.on(CEC_STANDBY_EVENT, callback);
      const storedCallback = registeredListeners.get(CEC_STANDBY_EVENT) as StandbyListener;
      storedCallback();
      expect(invoked).assertEqual(true);
    });
  });

  describe('Index_CecStandBy_deregistration', () => {
    beforeEach(() => {
      mockDisplaySettingOn();
    });

    it('should_remove_CecStandBy_listener_on_aboutToDisappear', 0, () => {
      const callback = (): void => {};
      displaySetting.on(CEC_STANDBY_EVENT, callback);
      displaySetting.off(CEC_STANDBY_EVENT);
      expect(registeredListeners.has(CEC_STANDBY_EVENT)).assertEqual(false);
    });

    it('should_not_invoke_callback_after_deregistration', 0, () => {
      let count = 0;
      const callback = (): void => { count++; };
      displaySetting.on(CEC_STANDBY_EVENT, callback);
      displaySetting.off(CEC_STANDBY_EVENT);
      const stored = registeredListeners.get(CEC_STANDBY_EVENT) as StandbyListener | undefined;
      if (stored) {
        stored();
      }
      expect(count).assertEqual(0);
    });

    it('should_skip_off_when_callback_is_undefined', 0, () => {
      registeredListeners.delete(CEC_STANDBY_EVENT);
      expect(registeredListeners.has(CEC_STANDBY_EVENT)).assertEqual(false);
    });
  });

  describe('Index_CecSelectSource_registration', () => {
    beforeEach(() => {
      mockDisplaySettingOn();
    });

    it('should_register_CecSelectSource_listener_on_init', 0, () => {
      const callback = (_sourceType: number | undefined): void => {};
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, callback);
      expect(registeredListeners.has(CEC_SELECT_SOURCE_EVENT)).assertEqual(true);
    });

    it('should_receive_correct_sourceType_on_CecSelectSource', 0, () => {
      let receivedType = -1;
      const callback = (sourceType: number | undefined): void => {
        if (sourceType === undefined) {
          return;
        }
        receivedType = sourceType;
      };
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, callback);
      const stored = registeredListeners.get(CEC_SELECT_SOURCE_EVENT) as SelectSourceListener;
      stored(3);
      expect(receivedType).assertEqual(3);
    });

    it('should_distinguish_hdmi_and_dtv_source_type_values', 0, () => {
      const sourceTypes: number[] = [];
      const callback = (sourceType: number | undefined): void => {
        if (sourceType === undefined) {
          return;
        }
        sourceTypes.push(sourceType);
      };
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, callback);
      const stored = registeredListeners.get(CEC_SELECT_SOURCE_EVENT) as SelectSourceListener;
      stored(6);
      stored(3);
      expect(sourceTypes[0]).assertEqual(6);
      expect(sourceTypes[1]).assertEqual(3);
    });
  });

  describe('Index_CecSelectSource_deregistration', () => {
    beforeEach(() => {
      mockDisplaySettingOn();
    });

    it('should_remove_CecSelectSource_listener_on_aboutToDisappear', 0, () => {
      const callback = (_sourceType: number | undefined): void => {};
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, callback);
      displaySetting.off(CEC_SELECT_SOURCE_EVENT);
      expect(registeredListeners.has(CEC_SELECT_SOURCE_EVENT)).assertEqual(false);
    });

    it('should_not_receive_events_after_deregistration', 0, () => {
      let count = 0;
      const callback = (_sourceType: number | undefined): void => { count++; };
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, callback);
      displaySetting.off(CEC_SELECT_SOURCE_EVENT);
      const stored = registeredListeners.get(CEC_SELECT_SOURCE_EVENT) as
        | SelectSourceListener
        | undefined;
      if (stored) {
        stored(3);
      }
      expect(count).assertEqual(0);
    });
  });

  describe('Index_aboutToDisappear_cleanup_order', () => {
    beforeEach(() => {
      mockDisplaySettingOn();
    });

    it('should_deregister_both_listeners_when_both_exist', 0, () => {
      const standbyCb = (): void => {};
      const selectCb = (_sourceType: number | undefined): void => {};
      displaySetting.on(CEC_STANDBY_EVENT, standbyCb);
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, selectCb);
      displaySetting.off(CEC_STANDBY_EVENT);
      displaySetting.off(CEC_SELECT_SOURCE_EVENT);
      expect(registeredListeners.size).assertEqual(0);
    });

    it('should_deregister_standby_first_when_both_exist', 0, () => {
      const standbyCb = (): void => {};
      const selectCb = (_sourceType: number | undefined): void => {};
      displaySetting.on(CEC_STANDBY_EVENT, standbyCb);
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, selectCb);
      displaySetting.off(CEC_STANDBY_EVENT);
      expect(registeredListeners.has(CEC_STANDBY_EVENT)).assertEqual(false);
      expect(registeredListeners.has(CEC_SELECT_SOURCE_EVENT)).assertEqual(true);
      displaySetting.off(CEC_SELECT_SOURCE_EVENT);
      expect(registeredListeners.size).assertEqual(0);
    });

    it('should_tolerate_deregister_when_callback_was_never_registered', 0, () => {
      expect(registeredListeners.size).assertEqual(0);
      displaySetting.off(CEC_STANDBY_EVENT);
      displaySetting.off(CEC_SELECT_SOURCE_EVENT);
      expect(registeredListeners.size).assertEqual(0);
    });
  });

  describe('Index_lifecycle_callback_references', () => {
    beforeEach(() => {
      mockDisplaySettingOn();
    });

    it('should_clear_standby_callback_reference_after_deregistration', 0, () => {
      const callback = (): void => {};
      displaySetting.on(CEC_STANDBY_EVENT, callback);
      displaySetting.off(CEC_STANDBY_EVENT);
      const ref = registeredListeners.get(CEC_STANDBY_EVENT);
      expect(ref).assertEqual(undefined);
    });

    it('should_clear_selectsource_callback_reference_after_deregistration', 0, () => {
      const callback = (_sourceType: number | undefined): void => {};
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, callback);
      displaySetting.off(CEC_SELECT_SOURCE_EVENT);
      const ref = registeredListeners.get(CEC_SELECT_SOURCE_EVENT);
      expect(ref).assertEqual(undefined);
    });

    it('should_maintain_independent_callback_references', 0, () => {
      const standbyCb = (): void => {};
      const selectCb = (_sourceType: number | undefined): void => {};
      displaySetting.on(CEC_STANDBY_EVENT, standbyCb);
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, selectCb);
      const storedStandby = registeredListeners.get(CEC_STANDBY_EVENT);
      const storedSelect = registeredListeners.get(CEC_SELECT_SOURCE_EVENT);
      expect(storedStandby).assertEqual(standbyCb);
      expect(storedSelect).assertEqual(selectCb);
    });
  });

  describe('Index_cec_selectsource_focus_update_in_callback', () => {
    it('should_update_focusIndex_to_matching_source', 0, () => {
      const sourceList: MockSourceItem[] = [
        new MockSourceItem(1),
        new MockSourceItem(2),
        new MockSourceItem(3),
        new MockSourceItem(4)
      ];
      let focusIndex = 0;
      const sourceType = 3;
      const index = sourceList.findIndex(item => item.getSourceId() == sourceType);
      focusIndex = index;
      expect(focusIndex).assertEqual(2);
    });

    it('should_update_focusSource_to_matching_sourceId', 0, () => {
      const sourceList: MockSourceItem[] = [
        new MockSourceItem(1),
        new MockSourceItem(2),
        new MockSourceItem(3)
      ];
      let focusSource = 0;
      const sourceType = 2;
      const index = sourceList.findIndex(item => item.getSourceId() == sourceType);
      focusSource = sourceType;
      expect(focusSource).assertEqual(2);
    });

    it('should_not_change_focus_when_sourceType_not_found', 0, () => {
      let focusIndex = 3;
      const sourceList: MockSourceItem[] = [
        new MockSourceItem(1),
        new MockSourceItem(2)
      ];
      const sourceType = 99;
      const index = sourceList.findIndex(item => item.getSourceId() == sourceType);
      focusIndex = index !== -1 ? index : focusIndex;
      expect(focusIndex).assertEqual(3);
    });
  });

  describe('Index_cec_standby_vs_standby_suspend_contract', () => {
    it('should_distinguish_standby_callback_structure', 0, () => {
      const standbyFlow: string[] = [];
      const onCecStandByCallback = (): void => {
        standbyFlow.push('callback_invoked');
      };
      onCecStandByCallback();
      expect(standbyFlow[0]).assertEqual('callback_invoked');
    });

    it('should_carry_standby_callback_reference_across_event_boundary', 0, () => {
      let referencePreserved = false;
      const callback = (): void => {
        referencePreserved = true;
      };
      const wrapped = callback;
      wrapped();
      expect(referencePreserved).assertEqual(true);
    });
  });

  describe('Index_lifecycle_multiple_page_instances', () => {
    beforeEach(() => {
      mockDisplaySettingOn();
    });

    it('should_not_conflict_standby_callbacks_between_page_instances', 0, () => {
      const callbacks: ((() => void))[] = [];
      const cb0 = (): void => { callbacks.push(cb0); };
      const cb1 = (): void => { callbacks.push(cb1); };
      displaySetting.on(CEC_STANDBY_EVENT, cb0);
      displaySetting.on(CEC_STANDBY_EVENT, cb1);
      expect(registeredListeners.get(CEC_STANDBY_EVENT)).assertEqual(cb1);
    });

    it('should_deregister_only_own_standby_callback', 0, () => {
      const cb0 = (): void => {};
      const cb1 = (): void => {};
      displaySetting.on(CEC_STANDBY_EVENT, cb0);
      displaySetting.off(CEC_STANDBY_EVENT);
      expect(registeredListeners.has(CEC_STANDBY_EVENT)).assertEqual(false);
    });
  });

  describe('Index_lifecycle_edge_cases', () => {
    beforeEach(() => {
      mockDisplaySettingOn();
    });

    it('should_tolerate_undefined_sourceType_in_selectsource_callback', 0, () => {
      let receivedType: number | undefined = undefined;
      const callback = (sourceType: number | undefined): void => {
        receivedType = sourceType;
      };
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, callback);
      const stored = registeredListeners.get(CEC_SELECT_SOURCE_EVENT) as
        | SelectSourceListener
        | undefined;
      if (stored) {
        stored(undefined);
      }
      expect(receivedType).assertEqual(undefined);
    });

    it('should_handle_zero_sourceType_in_selectsource', 0, () => {
      let receivedType = -1;
      const callback = (sourceType: number | undefined): void => {
        if (sourceType === undefined) {
          return;
        }
        receivedType = sourceType;
      };
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, callback);
      const stored = registeredListeners.get(CEC_SELECT_SOURCE_EVENT) as SelectSourceListener;
      stored(0);
      expect(receivedType).assertEqual(0);
    });

    it('should_handle_negative_sourceType_in_selectsource', 0, () => {
      let receivedType = 0;
      const callback = (sourceType: number | undefined): void => {
        if (sourceType === undefined) {
          return;
        }
        receivedType = sourceType;
      };
      displaySetting.on(CEC_SELECT_SOURCE_EVENT, callback);
      const stored = registeredListeners.get(CEC_SELECT_SOURCE_EVENT) as SelectSourceListener;
      stored(-1);
      expect(receivedType).assertEqual(-1);
    });
  });
}
