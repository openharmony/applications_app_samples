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
import { InputsourceModel } from '../../../main/ets/model/InputSourceModel';
import { SettingItemStyle } from '../../../main/ets/utils/StyleConstants';

/**
 * Validates field-update atomicity, selection-state consistency, and data
 * integrity across the InputsourceModel lifecycle.
 *
 * Design rationale: InputsourceModel serves as the runtime state carrier for
 * TV settings UI. Each item may be independently toggled, selected, or edited.
 * Guaranteeing field-level isolation and consistent cross-field state prevents
 * UI artefacts such as ghost selections or stale display values.
 */
export default function InputSourceModelStateTest(): void {
  describe('InputSourceModel_state_field_independence', () => {
    it('should_not_pollute_value_when_updating_style', 0, () => {
      const model = new InputsourceModel();
      model.setValue('HDMI1');
      model.setStyle(SettingItemStyle.switch);
      expect(model.value).assertEqual('HDMI1');
      expect(model.style).assertEqual(SettingItemStyle.switch);
    });

    it('should_isolate_des_from_value_after_multiple_updates', 0, () => {
      const model = new InputsourceModel();
      model.setValue('DTV');
      model.setDes('Digital Television');
      model.setValue('DTV2');
      expect(model.value).assertEqual('DTV2');
      expect(model.des).assertEqual('Digital Television');
    });

    it('should_keep_name_and_chooseDes_separate', 0, () => {
      const model = new InputsourceModel();
      model.name = 'SourceName';
      model.chooseDes = 'Currently selected';
      model.name = 'RenamedSource';
      expect(model.name).assertEqual('RenamedSource');
      expect(model.chooseDes).assertEqual('Currently selected');
    });

    it('should_maintain_image_fields_independently', 0, () => {
      const model = new InputsourceModel();
      model.img = 'common/image/source_icon.png' as ResourceStr;
      model.selectedimg = 'common/image/source_selected.png' as ResourceStr;
      model.img = 'common/image/new_icon.png' as ResourceStr;
      expect(model.img as string).assertEqual('common/image/new_icon.png');
      expect(model.selectedimg as string).assertEqual('common/image/source_selected.png');
    });

    it('should_preserve_focusKeys_after_ips_update', 0, () => {
      const model = new InputsourceModel();
      model.focusKeys = ['Enter', 'OK'];
      model.ips = ['192.168.1.1', '8.8.8.8'];
      expect(model.focusKeys.length).assertEqual(2);
      expect(model.ips.length).assertEqual(2);
    });

    it('should_retain_pageUrl_after_toggle_operations', 0, () => {
      const model = new InputsourceModel();
      model.pageUrl = 'pages/SourceDetailPage';
      model.setIsOn(true);
      model.setIsSelect(true);
      expect(model.pageUrl).assertEqual('pages/SourceDetailPage');
    });
  });

  describe('InputSourceModel_state_selection_consistency', () => {
    it('should_toggle_isSelect_without_affecting_isOn', 0, () => {
      const model = new InputsourceModel();
      model.setIsOn(true);
      model.setIsSelect(true);
      model.setIsSelect(false);
      expect(model.isOn).assertEqual(true);
      expect(model.isSelect).assertEqual(false);
    });

    it('should_toggle_isOn_without_affecting_isSelect', 0, () => {
      const model = new InputsourceModel();
      model.setIsSelect(true);
      model.setIsOn(false);
      expect(model.isSelect).assertEqual(true);
      expect(model.isOn).assertEqual(false);
    });

    it('should_update_isDefault_independently', 0, () => {
      const model = new InputsourceModel();
      model.setIsSelect(true);
      model.setIsDefault();
      expect(model.isSelect).assertEqual(true);
      expect(model.isDefault).assertEqual(true);
      model.setIsDefault();
      expect(model.isDefault).assertEqual(false);
    });

    it('should_allow_concurrent_modification_of_all_selection_flags', 0, () => {
      const model = new InputsourceModel();
      model.setIsOn(true);
      model.setIsSelect(true);
      model.setIsDefault();
      model.setIsEnable(false);
      expect(model.isOn).assertEqual(true);
      expect(model.isSelect).assertEqual(true);
      expect(model.isDefault).assertEqual(true);
      expect(model.isEnable).assertEqual(false);
    });

    it('should_isolate_isDisableFocus_from_other_flags', 0, () => {
      const model = new InputsourceModel();
      model.setIsDisableFocus(true);
      model.setIsOn(false);
      model.setIsSelect(false);
      expect(model.isDisableFocus).assertEqual(true);
    });
  });

  describe('InputSourceModel_state_data_integrity', () => {
    it('should_carry_value_after_style_transitions', 0, () => {
      const model = new InputsourceModel();
      model.setValue('AV1');
      const styles: SettingItemStyle[] = [
        SettingItemStyle.default,
        SettingItemStyle.switch,
        SettingItemStyle.valueChange,
        SettingItemStyle.singleChoose,
        SettingItemStyle.info
      ];
      for (let i = 0; i < styles.length; i++) {
        model.setStyle(styles[i]);
        expect(model.value).assertEqual('AV1');
      }
    });

    it('should_maintain_multiple_updates_in_sequence', 0, () => {
      const model = new InputsourceModel();
      const values: string[] = ['HDMI1', 'HDMI2', 'HDMI3', 'DTV', 'AV1'];
      for (let i = 0; i < values.length; i++) {
        model.setValue(values[i]);
        expect(model.value).assertEqual(values[i]);
      }
    });

    it('should_handle_empty_string_as_valid_value', 0, () => {
      const model = new InputsourceModel();
      model.setValue('HDMI1');
      model.setValue('');
      expect(model.value).assertEqual('');
    });

    it('should_preserve_focusIndex_across_field_updates', 0, () => {
      const model = new InputsourceModel();
      model.focusIndex = 5;
      model.setValue('SourceA');
      model.setStyle(SettingItemStyle.switch);
      model.setIsOn(true);
      expect(model.focusIndex).assertEqual(5);
    });

    it('should_maintain_isNeedBg_after_multiple_style_changes', 0, () => {
      const model = new InputsourceModel();
      model.isNeedBg = false;
      model.setStyle(SettingItemStyle.ip);
      model.setDes('IP Configuration');
      expect(model.isNeedBg).assertEqual(false);
    });

    it('should_retain_imageMargin_after_value_updates', 0, () => {
      const model = new InputsourceModel();
      model.imageMargin = 16;
      model.setValue('192.168.0.1');
      expect(model.imageMargin).assertEqual(16);
    });
  });

  describe('InputSourceModel_state_boundary_conditions', () => {
    it('should_handle_long_source_name_without_truncation', 0, () => {
      const model = new InputsourceModel();
      const longName = 'A'.repeat(256);
      model.name = longName;
      expect(model.name.length).assertEqual(256);
    });

    it('should_handle_unicode_characters_in_value', 0, () => {
      const model = new InputsourceModel();
      model.setValue('HDMI - 楂樻竻澶氬獟浣撴帴鍙ｂ劉');
      expect(model.value).assertEqual('HDMI - 楂樻竻澶氬獟浣撴帴鍙ｂ劉');
    });

    it('should_handle_special_characters_in_des', 0, () => {
      const model = new InputsourceModel();
      model.setDes('Source: "HDMI" <version> 2.0\\nNext line');
      expect(model.des).assertContain('HDMI');
    });

    it('should_handle_zero_as_valid_numeric_state', 0, () => {
      const model = new InputsourceModel();
      model.imageMargin = 0;
      model.setStyle(SettingItemStyle.default);
      expect(model.imageMargin).assertEqual(0);
    });

    it('should_handle_negative_focusIndex_boundary', 0, () => {
      const model = new InputsourceModel();
      model.focusIndex = -1;
      model.setIsSelect(true);
      expect(model.focusIndex).assertEqual(-1);
    });

    it('should_tolerate_empty_ips_array', 0, () => {
      const model = new InputsourceModel();
      model.ips = [];
      model.setStyle(SettingItemStyle.ip);
      expect(model.ips.length).assertEqual(0);
    });

    it('should_tolerate_empty_focusKeys_array', 0, () => {
      const model = new InputsourceModel();
      model.focusKeys = [];
      model.setIsDisableFocus(true);
      expect(model.focusKeys.length).assertEqual(0);
    });
  });

  describe('InputSourceModel_state_compound_scenarios', () => {
    it('should_maintain_state_consistency_through_edit_workflow', 0, () => {
      const model = new InputsourceModel();
      model.setValue('HDMI1');
      model.setDes('Primary Display');
      model.setStyle(SettingItemStyle.valueChange);
      model.setIsSelect(true);
      model.setIsOn(true);
      expect(model.value).assertEqual('HDMI1');
      expect(model.des).assertEqual('Primary Display');
      expect(model.style).assertEqual(SettingItemStyle.valueChange);
      expect(model.isSelect).assertEqual(true);
      expect(model.isOn).assertEqual(true);
    });

    it('should_maintain_state_consistency_through_source_switch_workflow', 0, () => {
      const model = new InputsourceModel();
      model.setValue('HDMI1');
      model.setIsSelect(true);
      model.setIsDefault();
      model.setValue('HDMI2');
      expect(model.isSelect).assertEqual(true);
      expect(model.isDefault).assertEqual(true);
      expect(model.value).assertEqual('HDMI2');
    });

    it('should_isolate_multiple_model_instances', 0, () => {
      const modelA = new InputsourceModel();
      const modelB = new InputsourceModel();
      modelA.setValue('SourceA');
      modelA.setIsSelect(true);
      modelB.setValue('SourceB');
      modelB.setIsOn(true);
      expect(modelA.value).assertEqual('SourceA');
      expect(modelA.isOn).assertEqual(false);
      expect(modelB.value).assertEqual('SourceB');
      expect(modelB.isSelect).assertEqual(false);
    });

    it('should_support_complete_item_initialization', 0, () => {
      const model = new InputsourceModel();
      model.name = 'DTV Source';
      model.chooseDes = 'Digital TV';
      model.setValue('DTV');
      model.setIsOn(true);
      model.setIsSelect(true);
      model.focusIndex = 0;
      model.setStyle(SettingItemStyle.singleChoose);
      model.pageUrl = 'pages/DtvPage';
      model.des = 'Watch digital television';
      model.isEnable = true;
      model.isNeedBg = true;
      model.isDefault = false;
      model.isDisableFocus = false;
      expect(model.name).assertEqual('DTV Source');
      expect(model.chooseDes).assertEqual('Digital TV');
      expect(model.value).assertEqual('DTV');
      expect(model.isOn).assertEqual(true);
      expect(model.isSelect).assertEqual(true);
      expect(model.focusIndex).assertEqual(0);
      expect(model.style).assertEqual(SettingItemStyle.singleChoose);
      expect(model.pageUrl).assertEqual('pages/DtvPage');
      expect(model.des).assertEqual('Watch digital television');
      expect(model.isEnable).assertEqual(true);
      expect(model.isNeedBg).assertEqual(true);
      expect(model.isDefault).assertEqual(false);
      expect(model.isDisableFocus).assertEqual(false);
    });
  });
}
