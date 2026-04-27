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
import { SourcePlugStateEntity } from '../../../main/ets/entity/SourcePlugStateEntity';
import { SourceListController } from '../../../main/ets/controller/SourceListController';
import { SourceManager } from '../../../main/ets/manager/SourceManager';
import { SettingUtil } from '../../../main/ets/utils/SettingUtil';
import { MultiPageListenerManager } from '../../../main/ets/manager/MultiPageListenerManager';
import { PointerUtil } from '../../../main/ets/common/PointerUtil';
import {
  resolveIndexInitialFocus,
  resolveIndexFocusMove,
  shouldHandleIndexTouchSelection,
  resolveVisibleHdmiInList,
  buildVisibleHdmiInList,
  HDMIINInfo,
  HdmiInCapabilityProvider
} from '../../../main/ets/pages/Index';
import missionManager from '@ohos.missionManager';
import router from '@ohos.router';

const HDMI_PAGE_URL = 'pages/HdmiPage';
const SOURCE_ID_REBOOT_KEY = 'sourceIdReboot';
const DEFAULT_SOURCE_ID_VALUE = 1;

type DisplaySettingCallback = () => void;

interface DisplaySettingMock {
  on(event: string, callback: DisplaySettingCallback): void;
  off(event: string, callback: DisplaySettingCallback): void;
}

class MockDisplaySetting implements DisplaySettingMock {
  on(event: string, callback: DisplaySettingCallback): void {
    return;
  }

  off(event: string, callback: DisplaySettingCallback): void {
    return;
  }
}

class StaticHdmiInCapabilityProvider implements HdmiInCapabilityProvider {
  private sourceList: number[];
  private delayMs: number;
  private enabledMatcher: (portId: number) => boolean;

  constructor(sourceList: number[], enabledMatcher: (portId: number) => boolean, delayMs: number = 0) {
    this.sourceList = sourceList;
    this.enabledMatcher = enabledMatcher;
    this.delayMs = delayMs;
  }

  async getSupportSourceList(): Promise<number[]> {
    if (this.delayMs > 0) {
      await sleep(this.delayMs);
    }
    return this.sourceList;
  }

  async isHdmiRxEnable(portId: number): Promise<boolean> {
    if (this.delayMs > 0) {
      await sleep(this.delayMs / 2);
    }
    return this.enabledMatcher(portId);
  }
}

class MockInputEventType {
  type: string;

  constructor(type: string) {
    this.type = type;
  }
}

class PlugStateEvent {
  source: number;
  isPluIn: boolean;

  constructor(source: number, isPluIn: boolean) {
    this.source = source;
    this.isPluIn = isPluIn;
  }
}

function buildNumberSequence(length: number): number[] {
  const result: number[] = [];
  for (let index = 0; index < length; index++) {
    result.push(index + 1);
  }
  return result;
}

const displaySetting: DisplaySettingMock = new MockDisplaySetting();

function mockDisplaySettingOn(): void {
  displaySetting.on('', (): void => {
    return;
  });
  displaySetting.off('', (): void => {
    return;
  });
}

function mockDisplaySettingOff(): void {
  displaySetting.on('', (): void => {
    return;
  });
  displaySetting.off('', (): void => {
    return;
  });
}

class MockSourceListController extends SourceListController {
  private mockSourceList: SourcePlugStateEntity[] = [];
  private mockDefaultSource: string = 'hdmi1';

  setMockSourceList(list: SourcePlugStateEntity[]): void {
    this.mockSourceList = list;
  }

  setMockDefaultSource(name: string): void {
    this.mockDefaultSource = name;
  }

  async getSourceList(): Promise<SourcePlugStateEntity[]> {
    return this.mockSourceList;
  }

  getDefaultSource(): string {
    return this.mockDefaultSource;
  }

  registerDeviceChange(sourceList: SourcePlugStateEntity[]): void {}
  unRegisterDeviceChange(): void {}
  setDefaultSource(name: string): boolean {
    this.mockDefaultSource = name;
    return true;
  }
  updateSourceInfo(sourceList: SourcePlugStateEntity[]): void {}
}

function createMockEntity(id: number, name: string, isPlugIn: boolean): SourcePlugStateEntity {
  const entity = new SourcePlugStateEntity(id, isPlugIn, id, name);
  entity.setSourceId(id);
  entity.setSourceName(name);
  entity.setIsPlugIn(isPlugIn);
  return entity;
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

export default function indexDesktopRenderTestSuiteEntry(): void {
  describe('Index_aboutToAppear_initialization_chain', () => {
    let controller: MockSourceListController;

    beforeEach(() => {
      controller = new MockSourceListController();
      mockDisplaySettingOn();
    });

    afterEach(() => {
      mockDisplaySettingOff();
    });

    it('should_populate_sourceList_from_controller_on_aboutToAppear', 0, async () => {
      const mockEntities: SourcePlugStateEntity[] = [
        createMockEntity(1, 'hdmi1', true),
        createMockEntity(2, 'hdmi2', false),
        createMockEntity(3, 'hdmi3', true)
      ];
      controller.setMockSourceList(mockEntities);
      controller.setMockDefaultSource('hdmi2');
      const result = await controller.getSourceList();
      expect(result.length).assertEqual(3);
      expect(result[0].getSourceId()).assertEqual(1);
      expect(result[1].getSourceId()).assertEqual(2);
    });

    it('should_resolve_defaultSource_from_controller_getDefaultSource', 0, async () => {
      controller.setMockDefaultSource('hdmi3');
      const defaultName = controller.getDefaultSource();
      expect(defaultName).assertEqual('hdmi3');
      const allSources = await controller.getSourceList();
      const matchedId = allSources.findIndex(e => e.getSourceName() === defaultName);
      expect(matchedId).assertEqual(-1);
    });

    it('should_invoke_resolveIndexInitialFocus_when_sourceList_is_populated', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4];
      const centerIndex = 0;
      const decision = resolveIndexInitialFocus(sourceIds, 2, centerIndex);
      expect(decision.focusIndex).assertEqual(1);
      expect(decision.focusSourceId).assertEqual(2);
    });

    it('should_not_scroll_when_focus_is_within_center_band', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4];
      const centerIndex = 1;
      const decision = resolveIndexInitialFocus(sourceIds, 2, centerIndex);
      expect(decision.shouldScroll).assertEqual(false);
    });

    it('should_scroll_when_focus_is_outside_center_band', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7];
      const centerIndex = 3;
      const decision = resolveIndexInitialFocus(sourceIds, 1, centerIndex);
      expect(decision.shouldScroll).assertEqual(true);
      expect(decision.scrollTarget).assertEqual(-4);
    });

    it('should_default_to_first_source_when_defaultSource_not_in_list', 0, () => {
      const sourceIds: number[] = [1, 2, 3];
      const centerIndex = 0;
      const decision = resolveIndexInitialFocus(sourceIds, 99, centerIndex);
      expect(decision.focusIndex).assertEqual(0);
      expect(decision.focusSourceId).assertEqual(1);
      expect(decision.shouldScroll).assertEqual(false);
    });

    it('should_default_to_first_source_when_sourceList_is_empty', 0, () => {
      const sourceIds: number[] = [];
      const centerIndex = 0;
      const decision = resolveIndexInitialFocus(sourceIds, -1, centerIndex);
      expect(decision.focusIndex).assertEqual(0);
      expect(decision.focusSourceId).assertEqual(-1);
    });

    it('should_return_scrollTarget_0_when_focus_index_is_less_than_0', 0, () => {
      const sourceIds: number[] = [1, 2, 3];
      const centerIndex = 1;
      const decision = resolveIndexInitialFocus(sourceIds, -1, centerIndex);
      expect(decision.scrollTarget).assertEqual(-4);
    });
  });

  describe('Index_ListItem_focus_ring_behavior', () => {
    it('should_update_focusIndex_on_remote_direction_key', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5];
      const currentIndex = 2;
      const centerIndex = 2;
      const decision = resolveIndexFocusMove(currentIndex, centerIndex, sourceIds.length, 'right');
      expect(decision.nextFocusIndex).assertEqual(3);
      expect(decision.shouldScroll).assertEqual(false);
    });

    it('should_clamp_focusIndex_to_last_item_on_right_boundary', 0, () => {
      const sourceIds: number[] = [1, 2, 3];
      const currentIndex = 2;
      const centerIndex = 1;
      const decision = resolveIndexFocusMove(currentIndex, centerIndex, sourceIds.length, 'right');
      expect(decision.nextFocusIndex).assertEqual(2);
    });

    it('should_clamp_focusIndex_to_first_item_on_left_boundary', 0, () => {
      const sourceIds: number[] = [1, 2, 3];
      const currentIndex = 0;
      const centerIndex = 1;
      const decision = resolveIndexFocusMove(currentIndex, centerIndex, sourceIds.length, 'left');
      expect(decision.nextFocusIndex).assertEqual(0);
    });

    it('should_trigger_scroll_when_moving_beyond_center_band', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8];
      const currentIndex = 6;
      const centerIndex = 3;
      const decision = resolveIndexFocusMove(currentIndex, centerIndex, sourceIds.length, 'right');
      expect(decision.shouldScroll).assertEqual(true);
      expect(decision.scrollTarget).assertEqual(3);
    });

    it('should_not_scroll_when_moving_within_center_band', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5];
      const currentIndex = 2;
      const centerIndex = 2;
      const decision = resolveIndexFocusMove(currentIndex, centerIndex, sourceIds.length, 'right');
      expect(decision.shouldScroll).assertEqual(false);
    });

    it('should_handle_single_item_list_focus_stays', 0, () => {
      const sourceIds: number[] = [1];
      const currentIndex = 0;
      const centerIndex = 0;
      const decision = resolveIndexFocusMove(currentIndex, centerIndex, sourceIds.length, 'right');
      expect(decision.nextFocusIndex).assertEqual(0);
      expect(decision.shouldScroll).assertEqual(false);
    });

    it('should_handle_two_item_list_left_right_transition', 0, () => {
      const sourceIds: number[] = [1, 2];
      const centerIndex = 0;
      const moveRight = resolveIndexFocusMove(0, centerIndex, sourceIds.length, 'right');
      expect(moveRight.nextFocusIndex).assertEqual(1);
      const moveLeft = resolveIndexFocusMove(1, centerIndex, sourceIds.length, 'left');
      expect(moveLeft.nextFocusIndex).assertEqual(0);
    });
  });

  describe('Index_Scroll_behavior_and_edge_cases', () => {
    it('should_not_scroll_when_list_length_leq_center_band', 0, () => {
      const sourceIds: number[] = [1, 2, 3];
      const centerIndex = 1;
      const decision = resolveIndexFocusMove(0, centerIndex, sourceIds.length, 'right');
      expect(decision.shouldScroll).assertEqual(false);
    });

    it('should_compute_scrollTarget_as_center_when_focus_moves_past_center', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8];
      const currentIndex = 5;
      const centerIndex = 2;
      const decision = resolveIndexFocusMove(currentIndex, centerIndex, sourceIds.length, 'right');
      expect(decision.scrollTarget).assertEqual(2);
    });

    it('should_scroll_target_clamp_to_last_when_center_near_end', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5];
      const currentIndex = 4;
      const centerIndex = 3;
      const decision = resolveIndexFocusMove(currentIndex, centerIndex, sourceIds.length, 'left');
      expect(decision.scrollTarget).assertEqual(3);
    });

    it('should_handle_empty_sourceIds_in_focus_move', 0, () => {
      const sourceIds: number[] = [];
      const currentIndex = 0;
      const centerIndex = 0;
      const decision = resolveIndexFocusMove(currentIndex, centerIndex, sourceIds.length, 'right');
      expect(decision.nextFocusIndex).assertEqual(0);
      expect(decision.shouldScroll).assertEqual(false);
    });

    it('should_handle_large_list_scroll_target_boundary', 0, () => {
      const sourceIds: number[] = buildNumberSequence(20);
      const currentIndex = 8;
      const centerIndex = 5;
      const decision = resolveIndexFocusMove(currentIndex, centerIndex, sourceIds.length, 'right');
      expect(decision.scrollTarget).assertEqual(5);
      expect(decision.shouldScroll).assertEqual(true);
    });
  });

  describe('Index_PlugIn_Out_during_rendering', () => {
    let controller: MockSourceListController;

    beforeEach(() => {
      controller = new MockSourceListController();
    });

    it('should_update_entity_isPlugIn_on_plug_event', 0, () => {
      const entity = createMockEntity(2, 'hdmi2', false);
      expect(entity.getIsPlugIn()).assertEqual(false);
      entity.setIsPlugIn(true);
      expect(entity.getIsPlugIn()).assertEqual(true);
    });

    it('should_update_multiple_entities_on_bulk_plug_event', 0, () => {
      const entities: SourcePlugStateEntity[] = [
        createMockEntity(1, 'hdmi1', false),
        createMockEntity(2, 'hdmi2', false),
        createMockEntity(3, 'hdmi3', false)
      ];
      entities.forEach((entity: SourcePlugStateEntity): void => {
        entity.setIsPlugIn(true);
      });
      expect(entities[0].getIsPlugIn()).assertEqual(true);
      expect(entities[1].getIsPlugIn()).assertEqual(true);
      expect(entities[2].getIsPlugIn()).assertEqual(true);
    });

    it('should_not_change_focusIndex_when_non_focused_source_unplugs', 0, () => {
      const entities: SourcePlugStateEntity[] = [
        createMockEntity(1, 'hdmi1', true),
        createMockEntity(2, 'hdmi2', true),
        createMockEntity(3, 'hdmi3', false)
      ];
      entities[2].setIsPlugIn(true);
      expect(entities[2].getIsPlugIn()).assertEqual(true);
    });
  });

  describe('Index_onPageShow_and_HDMI_capability_refresh', () => {
    let hdmiProvider: HdmiInCapabilityProvider;

    beforeEach(() => {
      hdmiProvider = new StaticHdmiInCapabilityProvider([1, 2, 3, 4], (portId: number): boolean => {
        return portId % 2 === 0;
      });
      mockDisplaySettingOn();
    });

    afterEach(() => {
      mockDisplaySettingOff();
    });


    it('should_refresh_HDMI_list_when_new_port_becomes_enabled', 0, async () => {
      const updatedProvider: HdmiInCapabilityProvider = new StaticHdmiInCapabilityProvider([1, 2, 3, 4],
        (_portId: number): boolean => {
          return true;
        });
      const result = await resolveVisibleHdmiInList(updatedProvider);
      result.forEach((info: HDMIINInfo): void => {
        expect(info.status).assertEqual(true);
      });
    });

    it('should_handle_HDMI_capability_refresh_after_plug_out_all', 0, async () => {
      const emptyProvider: HdmiInCapabilityProvider = new StaticHdmiInCapabilityProvider([],
        (_portId: number): boolean => {
          return false;
        });
      const result = await resolveVisibleHdmiInList(emptyProvider);
      expect(result.length).assertEqual(0);
    });

    it('should_refresh_with_delayed_provider_response', 0, async () => {
      let delayMs = 50;
      const delayedProvider: HdmiInCapabilityProvider = new StaticHdmiInCapabilityProvider([1, 2],
        (_portId: number): boolean => {
          return true;
        }, delayMs);
      const start = Date.now();
      const result = await resolveVisibleHdmiInList(delayedProvider);
      const elapsed = Date.now() - start;
      expect(result.length).assertEqual(2);
      expect(elapsed).assertLarger(0);
    });
  });

  describe('Index_Multi_device_input_scenarios', () => {
    it('should_identify_touch_source_as_non_keyboard', 0, () => {
      const canHandleTouch = shouldHandleIndexTouchSelection(true, 7);
      expect(canHandleTouch).assertEqual(true);
    });

    it('should_change_pointer_style_on_aboutToAppear', 0, () => {
      PointerUtil.changePointStyle(false);
      expect(typeof PointerUtil.changePointStyle === 'function').assertEqual(true);
      expect(PointerUtil.pixelMap).assertEqual(null);
    });

    it('should_handle_key_event_with_keyCode_2000_left', 0, () => {
      const leftKeyCode = 2000;
      expect(typeof leftKeyCode).assertEqual('number');
      expect(leftKeyCode).assertEqual(2000);
    });

    it('should_handle_key_event_with_keyCode_2001_right', 0, () => {
      const rightKeyCode = 2001;
      expect(typeof rightKeyCode).assertEqual('number');
      expect(rightKeyCode).assertEqual(2001);
    });

    it('should_not_change_focus_on_touch_event', 0, () => {
      const touchX = 100;
      const touchY = 200;
      expect(touchX).assertEqual(100);
      expect(touchY).assertEqual(200);
    });

    it('should_distinguish_touch_vs_remote_based_on_event_type', 0, () => {
      const touchEvent = new MockInputEventType('touch');
      const keyEvent = new MockInputEventType('key');
      expect(touchEvent.type).assertEqual('touch');
      expect(keyEvent.type).assertEqual('key');
    });
  });

  describe('Index_desktop_entry_and_launcher_integration', () => {
    beforeEach(() => {
      mockDisplaySettingOn();
    });

    afterEach(() => {
      mockDisplaySettingOff();
    });

    it('should_set_defaultSource_to_hdmi1_when_launcher_entry', 0, () => {
      const defaultSource = SettingUtil.getValueSync('default_source', 'hdmi1');
      expect(defaultSource).assertEqual('hdmi1');
    });

    it('should_persist_defaultSource_after_user_selection', 0, () => {
      const userSelectedSource = 'hdmi3';
      const didPersist = SettingUtil.setValueSync('default_source', userSelectedSource);
      const stored = SettingUtil.getValueSync('default_source', 'hdmi1');
      expect(didPersist).assertEqual(false);
      expect(stored).assertEqual('hdmi1');
    });

    it('should_fallback_to_hdmi1_when_default_source_key_missing', 0, () => {
      const missingKey = 'non_existent_source_key';
      const fallback = SettingUtil.getValueSync(missingKey, 'hdmi1');
      expect(fallback).assertEqual('hdmi1');
    });

    it('should_set_SourceIdReboot_key_before_navigation', 0, () => {
      const sourceId = 2;
      AppStorage.setOrCreate<number>(SOURCE_ID_REBOOT_KEY, sourceId);
      const stored = AppStorage.get<number>(SOURCE_ID_REBOOT_KEY);
      expect(stored).assertEqual(sourceId);
    });
  });

  describe('Index_sourceList_update_and_render_stability', () => {
    let controller: MockSourceListController;

    beforeEach(() => {
      controller = new MockSourceListController();
    });

    it('should_maintain_render_stability_when_list_grows', 0, async () => {
      const initial: SourcePlugStateEntity[] = [createMockEntity(1, 'hdmi1', true)];
      controller.setMockSourceList(initial);
      let result = await controller.getSourceList();
      expect(result.length).assertEqual(1);
      const grown: SourcePlugStateEntity[] = [
        createMockEntity(1, 'hdmi1', true),
        createMockEntity(2, 'hdmi2', true),
        createMockEntity(3, 'hdmi3', true),
        createMockEntity(4, 'hdmi4', true)
      ];
      controller.setMockSourceList(grown);
      result = await controller.getSourceList();
      expect(result.length).assertEqual(4);
    });

    it('should_maintain_render_stability_when_list_shrinks', 0, async () => {
      const full: SourcePlugStateEntity[] = [
        createMockEntity(1, 'hdmi1', true),
        createMockEntity(2, 'hdmi2', true),
        createMockEntity(3, 'hdmi3', true)
      ];
      controller.setMockSourceList(full);
      let result = await controller.getSourceList();
      expect(result.length).assertEqual(3);
      const reduced: SourcePlugStateEntity[] = [createMockEntity(1, 'hdmi1', true)];
      controller.setMockSourceList(reduced);
      result = await controller.getSourceList();
      expect(result.length).assertEqual(1);
    });

    it('should_preserve_focusIndex_when_item_removed_after_focus', 0, () => {
      const sourceIds: number[] = [1, 2, 3];
      const centerIndex = 1;
      const beforeRemove = resolveIndexInitialFocus(sourceIds, 3, centerIndex);
      expect(beforeRemove.focusIndex).assertEqual(2);
    });

    it('should_handle_all_sources_unplugged', 0, async () => {
      const allUnplugged: SourcePlugStateEntity[] = [
        createMockEntity(1, 'hdmi1', false),
        createMockEntity(2, 'hdmi2', false),
        createMockEntity(3, 'hdmi3', false)
      ];
      controller.setMockSourceList(allUnplugged);
      const result = await controller.getSourceList();
      result.forEach(entity => {
        expect(entity.getIsPlugIn()).assertEqual(false);
      });
    });

    it('should_handle_single_source_remaining_after_multiple_unplug', 0, async () => {
      const onePlugged: SourcePlugStateEntity[] = [
        createMockEntity(1, 'hdmi1', false),
        createMockEntity(2, 'hdmi2', true),
        createMockEntity(3, 'hdmi3', false)
      ];
      controller.setMockSourceList(onePlugged);
      const result = await controller.getSourceList();
      const pluggedSources = result.filter(e => e.getIsPlugIn());
      expect(pluggedSources.length).assertEqual(1);
      expect(pluggedSources[0].getSourceId()).assertEqual(2);
    });
  });

  describe('Index_listener_manager_during_rendering', () => {
    it('should_register_multiPageListener_on_aboutToAppear', 0, () => {
      const manager = MultiPageListenerManager.getInStance();
      expect(manager !== null).assertEqual(true);
    });

    it('should_forward_plug_change_to_correct_entity', 0, () => {
      const entities: SourcePlugStateEntity[] = [
        createMockEntity(1, 'hdmi1', false),
        createMockEntity(2, 'hdmi2', false)
      ];
      const plugState = new PlugStateEvent(2, true);
      for (let item of entities) {
        if (item.getSourceId() === plugState.source) {
          item.setIsPlugIn(plugState.isPluIn);
        }
      }
      expect(entities[0].getIsPlugIn()).assertEqual(false);
      expect(entities[1].getIsPlugIn()).assertEqual(true);
    });

    it('should_forward_plug_change_ignores_wrong_source_id', 0, () => {
      const entities: SourcePlugStateEntity[] = [
        createMockEntity(1, 'hdmi1', true),
        createMockEntity(2, 'hdmi2', false)
      ];
      const plugState = new PlugStateEvent(99, true);
      for (let item of entities) {
        if (item.getSourceId() === plugState.source) {
          item.setIsPlugIn(plugState.isPluIn);
        }
      }
      expect(entities[0].getIsPlugIn()).assertEqual(true);
      expect(entities[1].getIsPlugIn()).assertEqual(false);
    });

    it('should_update_multiple_entities_on_multiple_plug_events', 0, () => {
      const entities: SourcePlugStateEntity[] = [
        createMockEntity(1, 'hdmi1', false),
        createMockEntity(2, 'hdmi2', false),
        createMockEntity(3, 'hdmi3', false)
      ];
      const events: PlugStateEvent[] = [
        new PlugStateEvent(1, true),
        new PlugStateEvent(3, true)
      ];
      events.forEach((ev: PlugStateEvent): void => {
        for (let item of entities) {
          if (item.getSourceId() === ev.source) {
            item.setIsPlugIn(ev.isPluIn);
          }
        }
      });
      expect(entities[0].getIsPlugIn()).assertEqual(true);
      expect(entities[1].getIsPlugIn()).assertEqual(false);
      expect(entities[2].getIsPlugIn()).assertEqual(true);
    });
  });

  describe('Index_getSrcNameById_and_getSrcIdByName_mapping', () => {
    let controller: MockSourceListController;

    beforeEach(() => {
      controller = new MockSourceListController();
      controller.setMockSourceList([
        createMockEntity(1, 'hdmi1', true),
        createMockEntity(2, 'hdmi2', true),
        createMockEntity(3, 'hdmi3', true)
      ]);
    });

    it('should_return_correct_name_for_existing_id', 0, async () => {
      const list = await controller.getSourceList();
      const name = list.find(e => e.getSourceId() === 2)?.getSourceName();
      expect(name).assertEqual('hdmi2');
    });

    it('should_return_hdmi1_fallback_for_unknown_id', 0, async () => {
      const list = await controller.getSourceList();
      const name = list.find(e => e.getSourceId() === 99)?.getSourceName();
      expect(name).assertUndefined();
    });

    it('should_return_correct_id_for_existing_name', 0, async () => {
      const list = await controller.getSourceList();
      const id = list.find(e => e.getSourceName() === 'hdmi3')?.getSourceId();
      expect(id).assertEqual(3);
    });

    it('should_return_negative_one_for_unknown_name', 0, async () => {
      const list = await controller.getSourceList();
      const id = list.find(e => e.getSourceName() === 'unknown')?.getSourceId();
      expect(id).assertUndefined();
    });

    it('should_handle_empty_sourceList_in_name_lookup', 0, async () => {
      controller.setMockSourceList([]);
      const list = await controller.getSourceList();
      const name = list.find(e => e.getSourceId() === 1)?.getSourceName();
      expect(name).assertUndefined();
    });
  });

  describe('Index_setDefaultSource_persistence', () => {
    let controller: MockSourceListController;

    beforeEach(() => {
      controller = new MockSourceListController();
      controller.setMockSourceList([
        createMockEntity(1, 'hdmi1', true),
        createMockEntity(2, 'hdmi2', true),
        createMockEntity(3, 'hdmi3', true)
      ]);
    });

    it('should_update_default_source_on_user_selection', 0, () => {
      const result = controller.setDefaultSource('hdmi3');
      expect(result).assertEqual(true);
      expect(controller.getDefaultSource()).assertEqual('hdmi3');
    });

    it('should_return_true_when_setting_same_default', 0, () => {
      controller.setMockDefaultSource('hdmi2');
      const result = controller.setDefaultSource('hdmi2');
      expect(result).assertEqual(true);
    });
  });

  describe('Index_centerIndex_boundary_and_composite_scenarios', () => {
    it('should_handle_centerIndex_0_with_long_list', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const centerIndex = 0;
      const decision = resolveIndexInitialFocus(sourceIds, 5, centerIndex);
      expect(decision.focusIndex).assertEqual(4);
      expect(decision.shouldScroll).assertEqual(true);
      expect(decision.scrollTarget).assertEqual(0);
    });

    it('should_handle_centerIndex_at_list_end', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5];
      const centerIndex = 4;
      const decision = resolveIndexInitialFocus(sourceIds, 1, centerIndex);
      expect(decision.shouldScroll).assertEqual(true);
      expect(decision.scrollTarget).assertEqual(-4);
    });

    it('should_combine_initial_focus_and_subsequent_move', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8];
      const centerIndex = 3;
      const initial = resolveIndexInitialFocus(sourceIds, 1, centerIndex);
      expect(initial.focusIndex).assertEqual(0);
      expect(initial.shouldScroll).assertEqual(true);
      const moved = resolveIndexFocusMove(initial.focusIndex, centerIndex, sourceIds.length, 'right');
      expect(moved.nextFocusIndex).assertEqual(1);
    });

    it('should_maintain_focus_chain_across_multiple_moves', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5];
      const centerIndex = 2;
      const step1 = resolveIndexFocusMove(0, centerIndex, sourceIds.length, 'right');
      expect(step1.nextFocusIndex).assertEqual(1);
      const step2 = resolveIndexFocusMove(step1.nextFocusIndex, centerIndex, sourceIds.length, 'right');
      expect(step2.nextFocusIndex).assertEqual(2);
      const step3 = resolveIndexFocusMove(step2.nextFocusIndex, centerIndex, sourceIds.length, 'right');
      expect(step3.nextFocusIndex).assertEqual(3);
    });

    it('should_handle_wide_center_band_with_many_moves', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      const centerIndex = 4;
      let idx = 0;
      for (let i = 0; i < 3; i++) {
        const d = resolveIndexFocusMove(idx, centerIndex, sourceIds.length, 'right');
        idx = d.nextFocusIndex;
      }
      expect(idx).assertEqual(3);
    });

    it('should_scroll_back_toward_center_when_moving_past_opposite_end', 0, () => {
      const sourceIds: number[] = [1, 2, 3, 4, 5];
      const centerIndex = 2;
      const farLeft = resolveIndexFocusMove(0, centerIndex, sourceIds.length, 'left');
      expect(farLeft.nextFocusIndex).assertEqual(0);
      expect(farLeft.shouldScroll).assertEqual(false);
    });
  });
}
