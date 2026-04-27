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

import { describe, it, expect } from '@ohos/hypium';
import { SourcePlugStateEntity } from '../../../main/ets/entity/SourcePlugStateEntity';

interface SourceMutationUpdate {
  id: number;
  plug: boolean;
  order: number;
  name: string;
}

/**
 * Validates constructor invariants, setter/getter consistency, property
 * observation semantics, and boundary behavior for SourcePlugStateEntity.
 *
 * Business context: SourcePlugStateEntity is the atomic data unit that
 * represents a single input source's plug state and display metadata. It is
 * marked @Observed so ArkUI can track property mutations on instances used in
 * @State/@Link decorated view fields. Each field carries specific meaning:
 *   _sourceId      鈥?physical port identifier used for CEC routing
 *   _isPlugIn      鈥?live plug state that drives list visibility and icons
 *   _displayOrder  鈥?sort key that controls desktop source menu sequence
 *   _sourceName     鈥?human-readable label mapped from CEC EDID or manual alias
 */
export default function SourcePlugStateEntitySemanticsTest(): void {
  describe('SourcePlugStateEntity_constructor_invariants', () => {
    it('should_preserve_constructor_args_through_getters', 0, () => {
      const entity = new SourcePlugStateEntity(1, true, 0, 'HDMI1');
      expect(entity.getSourceId()).assertEqual(1);
      expect(entity.getIsPlugIn()).assertEqual(true);
      expect(entity.getDisplayOrder()).assertEqual(0);
      expect(entity.getSourceName()).assertEqual('HDMI1');
    });

    it('should_allow_zero_displayOrder_as_valid_sort_key', 0, () => {
      const entity = new SourcePlugStateEntity(2, false, 0, 'DTV');
      expect(entity.getDisplayOrder()).assertEqual(0);
    });

    it('should_allow_empty_sourceName', 0, () => {
      const entity = new SourcePlugStateEntity(3, true, 5, '');
      expect(entity.getSourceName()).assertEqual('');
    });

    it('should_accept_max_sourceId_range', 0, () => {
      const entity = new SourcePlugStateEntity(2147483647, true, 1, 'MAX_ID');
      expect(entity.getSourceId()).assertEqual(2147483647);
    });

    it('should_accept_large_displayOrder_values', 0, () => {
      const entity = new SourcePlugStateEntity(1, true, 99999, 'LastSource');
      expect(entity.getDisplayOrder()).assertEqual(99999);
    });
  });

  describe('SourcePlugStateEntity_setter_getter_consistency', () => {
    it('should_round_trip_sourceId_without_side_effects', 0, () => {
      const entity = new SourcePlugStateEntity(0, false, 0, '');
      entity.setSourceId(7);
      expect(entity.getSourceId()).assertEqual(7);
      expect(entity.getIsPlugIn()).assertEqual(false);
      expect(entity.getDisplayOrder()).assertEqual(0);
      expect(entity.getSourceName()).assertEqual('');
    });

    it('should_round_trip_isPlugIn_without_side_effects', 0, () => {
      const entity = new SourcePlugStateEntity(1, true, 1, 'HDMI');
      entity.setIsPlugIn(false);
      expect(entity.getIsPlugIn()).assertEqual(false);
      expect(entity.getSourceId()).assertEqual(1);
      expect(entity.getDisplayOrder()).assertEqual(1);
      expect(entity.getSourceName()).assertEqual('HDMI');
    });

    it('should_round_trip_displayOrder_without_side_effects', 0, () => {
      const entity = new SourcePlugStateEntity(2, true, 0, 'AV');
      entity.setDisplayOrder(10);
      expect(entity.getDisplayOrder()).assertEqual(10);
      expect(entity.getSourceId()).assertEqual(2);
      expect(entity.getIsPlugIn()).assertEqual(true);
      expect(entity.getSourceName()).assertEqual('AV');
    });

    it('should_round_trip_sourceName_without_side_effects', 0, () => {
      const entity = new SourcePlugStateEntity(3, false, 2, 'Initial');
      entity.setSourceName('Renamed');
      expect(entity.getSourceName()).assertEqual('Renamed');
      expect(entity.getSourceId()).assertEqual(3);
      expect(entity.getIsPlugIn()).assertEqual(false);
      expect(entity.getDisplayOrder()).assertEqual(2);
    });

    it('should_update_all_fields_sequentially_without_interference', 0, () => {
      const entity = new SourcePlugStateEntity(0, false, 0, '');
      entity.setSourceId(1);
      entity.setIsPlugIn(true);
      entity.setDisplayOrder(3);
      entity.setSourceName('HDMI2');
      expect(entity.getSourceId()).assertEqual(1);
      expect(entity.getIsPlugIn()).assertEqual(true);
      expect(entity.getDisplayOrder()).assertEqual(3);
      expect(entity.getSourceName()).assertEqual('HDMI2');
    });

    it('should_toggle_plug_state_multiple_times', 0, () => {
      const entity = new SourcePlugStateEntity(1, false, 1, 'Test');
      entity.setIsPlugIn(true);
      entity.setIsPlugIn(false);
      entity.setIsPlugIn(true);
      expect(entity.getIsPlugIn()).assertEqual(true);
    });
  });

  describe('SourcePlugStateEntity_observed_semantics', () => {
    it('should_support_observed_class_instantiation', 0, () => {
      const entity = new SourcePlugStateEntity(1, true, 1, 'ObservedSource');
      expect(entity instanceof SourcePlugStateEntity).assertEqual(true);
    });

    it('should_allow_rapid_property_mutations_for_observation', 0, () => {
      const entity = new SourcePlugStateEntity(0, false, 0, '');
      const updates: SourceMutationUpdate[] = [
        { id: 1, plug: true, order: 1, name: 'A' },
        { id: 2, plug: false, order: 2, name: 'B' },
        { id: 3, plug: true, order: 3, name: 'C' }
      ];
      for (let i = 0; i < updates.length; i++) {
        entity.setSourceId(updates[i].id);
        entity.setIsPlugIn(updates[i].plug);
        entity.setDisplayOrder(updates[i].order);
        entity.setSourceName(updates[i].name);
        expect(entity.getSourceId()).assertEqual(updates[i].id);
        expect(entity.getIsPlugIn()).assertEqual(updates[i].plug);
        expect(entity.getDisplayOrder()).assertEqual(updates[i].order);
        expect(entity.getSourceName()).assertEqual(updates[i].name);
      }
    });
  });

  describe('SourcePlugStateEntity_boundary_conditions', () => {
    it('should_handle_zero_sourceId', 0, () => {
      const entity = new SourcePlugStateEntity(0, true, 1, 'ZeroId');
      expect(entity.getSourceId()).assertEqual(0);
      entity.setSourceId(0);
      expect(entity.getSourceId()).assertEqual(0);
    });

    it('should_handle_negative_sourceId_if_valid', 0, () => {
      const entity = new SourcePlugStateEntity(-1, true, 1, 'NegId');
      expect(entity.getSourceId()).assertEqual(-1);
    });

    it('should_handle_max_safe_integer_displayOrder', 0, () => {
      const entity = new SourcePlugStateEntity(1, true, 2147483647, 'MaxOrder');
      expect(entity.getDisplayOrder()).assertEqual(2147483647);
    });

    it('should_handle_long_sourceName', 0, () => {
      const longName = 'A'.repeat(512);
      const entity = new SourcePlugStateEntity(1, true, 1, longName);
      expect(entity.getSourceName().length).assertEqual(512);
    });

    it('should_handle_unicode_sourceName', 0, () => {
      const entity = new SourcePlugStateEntity(1, true, 1, 'HDMI-UHD');
      expect(entity.getSourceName()).assertContain('HDMI');
      expect(entity.getSourceName()).assertContain('UHD');
    });

    it('should_handle_sourceName_with_special_characters', 0, () => {
      const entity = new SourcePlugStateEntity(1, true, 1, 'Source: "HDMI" <v2.0>\nNext');
      expect(entity.getSourceName()).assertContain('HDMI');
    });
  });

  describe('SourcePlugStateEntity_instance_isolation', () => {
    it('should_isolate_multiple_instances_completely', 0, () => {
      const hdmi = new SourcePlugStateEntity(1, true, 1, 'HDMI1');
      const dtv = new SourcePlugStateEntity(2, false, 2, 'DTV');
      const av = new SourcePlugStateEntity(3, true, 0, 'AV1');

      hdmi.setSourceId(10);
      hdmi.setIsPlugIn(false);
      hdmi.setDisplayOrder(5);
      hdmi.setSourceName('HDMI_Renamed');

      expect(hdmi.getSourceId()).assertEqual(10);
      expect(hdmi.getIsPlugIn()).assertEqual(false);
      expect(hdmi.getDisplayOrder()).assertEqual(5);
      expect(hdmi.getSourceName()).assertEqual('HDMI_Renamed');

      expect(dtv.getSourceId()).assertEqual(2);
      expect(dtv.getIsPlugIn()).assertEqual(false);
      expect(dtv.getDisplayOrder()).assertEqual(2);
      expect(dtv.getSourceName()).assertEqual('DTV');

      expect(av.getSourceId()).assertEqual(3);
      expect(av.getIsPlugIn()).assertEqual(true);
      expect(av.getDisplayOrder()).assertEqual(0);
      expect(av.getSourceName()).assertEqual('AV1');
    });

    it('should_maintain_independent_state_after_cross_updates', 0, () => {
      const a = new SourcePlugStateEntity(1, true, 1, 'A');
      const b = new SourcePlugStateEntity(2, false, 2, 'B');

      const aOriginalPlug = a.getIsPlugIn();
      const bOriginalPlug = b.getIsPlugIn();
      a.setIsPlugIn(bOriginalPlug);
      b.setIsPlugIn(aOriginalPlug);

      const aOriginalOrder = a.getDisplayOrder();
      const bOriginalOrder = b.getDisplayOrder();
      a.setDisplayOrder(bOriginalOrder);
      b.setDisplayOrder(aOriginalOrder);

      expect(a.getIsPlugIn()).assertEqual(false);
      expect(b.getIsPlugIn()).assertEqual(true);
      expect(a.getDisplayOrder()).assertEqual(2);
      expect(b.getDisplayOrder()).assertEqual(1);
    });
  });

  describe('SourcePlugStateEntity_semantic_contracts', () => {
    it('should_treat_plug_state_and_display_order_as_independent_concerns', 0, () => {
      const entity = new SourcePlugStateEntity(1, true, 1, 'HDMI');
      entity.setIsPlugIn(false);
      entity.setDisplayOrder(99);
      expect(entity.getIsPlugIn()).assertEqual(false);
      expect(entity.getDisplayOrder()).assertEqual(99);
    });

    it('should_allow_name_change_without_affecting_plug_semantics', 0, () => {
      const entity = new SourcePlugStateEntity(1, true, 1, 'Original');
      entity.setSourceName('CEC_Alias');
      expect(entity.getSourceId()).assertEqual(1);
      expect(entity.getIsPlugIn()).assertEqual(true);
    });

    it('should_support_reordering_without_replug', 0, () => {
      const entity = new SourcePlugStateEntity(5, true, 1, 'Ordered');
      entity.setDisplayOrder(100);
      entity.setDisplayOrder(200);
      entity.setDisplayOrder(50);
      expect(entity.getDisplayOrder()).assertEqual(50);
      expect(entity.getIsPlugIn()).assertEqual(true);
    });
  });
}
