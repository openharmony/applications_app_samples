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
import { EventConstants } from '../../../../../../common/src/main/ets/default/constants/EventConstants';
import { CommonConstants } from '../../../../../../common/src/main/ets/default/constants/CommonConstants';
import { KeyCode } from '../../../main/ets/common/constants/KeyCode';
import StyleConstants from '../../../main/ets/common/constants/StyleConstants';
import { AppItemInfo as MainAppItemInfo } from '../../../main/ets/common/bean/AppItemInfo';
import { AppItemInfo as CommonAppItemInfo } from '../../../../../../common/src/main/ets/default/bean/AppItemInfo';

export default function constantsAndModelContractsTest() {
  describe('ConstantsAndModelContracts_Test', () => {
    it('event_constants_core_values_match', 0, () => {
      expect(EventConstants.EVENT_PACKAGE_ADDED).assertEqual('usual.event.PACKAGE_ADDED');
      expect(EventConstants.EVENT_PACKAGE_CHANGED).assertEqual('usual.event.PACKAGE_CHANGED');
      expect(EventConstants.EVENT_PACKAGE_REMOVED).assertEqual('usual.event.PACKAGE_REMOVED');
      expect(EventConstants.EVENT_FOLDER_PACKAGE_REMOVED).assertEqual('usual.event.FOLDER_PACKAGE_REMOVED');
      expect(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD).assertEqual('launcher.event.REQUEST_PAGEDESK_ITEM_ADD');
      expect(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE)
        .assertEqual('launcher.event.REQUEST_PAGEDESK_ITEM_DELETE');
      expect(EventConstants.EVENT_BADGE_UPDATE).assertEqual('launcher.event.EVENT_BADGE_UPDATE');
      expect(EventConstants.EVENT_SMARTDOCK_INIT_FINISHED).assertEqual('launcher.event.EVENT_SMARTDOCK_INIT_FINISHED');
      expect(EventConstants.EVENT_REQUEST_DOCK_ITEM_ADD).assertEqual('launcher.event.REQUEST_DOCK_ITEM_ADD');
      expect(EventConstants.EVENT_ANIMATION_START_APPLICATION)
        .assertEqual('launcher.event.EVENT_ANIMATION_START_APPLICATION');
      expect(EventConstants.EVENT_ANIMATION_CLOSE_APPLICATION)
        .assertEqual('launcher.event.EVENT_ANIMATION_CLOSE_APPLICATION');
    });

    it('event_constants_extended_values_match', 0, () => {
      expect(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE)
        .assertEqual('launcher.event.REQUEST_DOCK_ITEM_DELETE');
      expect(EventConstants.EVENT_REQUEST_RECENT_DOCK_ITEM_DELETE)
        .assertEqual('launcher.event.RECENT_DOCK_ITEM_DELETE');
      expect(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_UPDATE)
        .assertEqual('launcher.event.EVENT_REQUEST_RESIDENT_DOCK_ITEM_UPDATE');
      expect(EventConstants.EVENT_NAVIGATOR_BAR_STATUS_CHANGE)
        .assertEqual('usual.event.NAVIGATOR_BAR_STATUS_CHANGE');
      expect(EventConstants.EVENT_REQUEST_PAGEDESK_REFRESH).assertEqual('EVENT_REQUEST_PAGEDESK_REFRESH');
      expect(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE)
        .assertEqual('launcher.event.REQUEST_FORM_ITEM_VISIBLE');
      expect(EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD)
        .assertEqual('launcher.event.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD');
    });

    it('event_constants_are_distinct_and_non_empty', 0, () => {
      expect(EventConstants.EVENT_PACKAGE_ADDED === EventConstants.EVENT_PACKAGE_CHANGED).assertFalse();
      expect(EventConstants.EVENT_PACKAGE_ADDED === EventConstants.EVENT_PACKAGE_REMOVED).assertFalse();
      expect(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD === EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE)
        .assertFalse();
      expect(EventConstants.EVENT_ANIMATION_START_APPLICATION === EventConstants.EVENT_ANIMATION_CLOSE_APPLICATION)
        .assertFalse();
      const events: string[] = [
        EventConstants.EVENT_PACKAGE_ADDED,
        EventConstants.EVENT_PACKAGE_CHANGED,
        EventConstants.EVENT_PACKAGE_REMOVED,
        EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD,
        EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE,
        EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_UPDATE,
        EventConstants.EVENT_BADGE_UPDATE,
        EventConstants.EVENT_SMARTDOCK_INIT_FINISHED,
        EventConstants.EVENT_REQUEST_DOCK_ITEM_ADD,
        EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE,
        EventConstants.EVENT_REQUEST_RECENT_DOCK_ITEM_DELETE,
        EventConstants.EVENT_FOLDER_PACKAGE_REMOVED,
        EventConstants.EVENT_ANIMATION_START_APPLICATION,
        EventConstants.EVENT_ANIMATION_CLOSE_APPLICATION,
      ];
      expect(new Set(events).size).assertEqual(events.length);
      for (const event of events) {
        expect(typeof event).assertEqual('string');
        expect(event.length > 0).assertTrue();
      }
      expect(EventConstants.EVENT_PACKAGE_ADDED.startsWith('usual.event.')).assertTrue();
      expect(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD.startsWith('launcher.event.')).assertTrue();
    });

    it('common_constants_core_values_match', 0, () => {
      expect(CommonConstants.UNINSTALL_SUCCESS).assertEqual(0);
      expect(CommonConstants.UNINSTALL_FORBID).assertEqual(1);
      expect(CommonConstants.BADGE_DISPLAY_HIDE).assertEqual(0);
      expect(CommonConstants.BADGE_DISPLAY_SHOW).assertEqual(1);
      expect(CommonConstants.FORM_CONFIG_ABILITY_PREFIX).assertEqual('ability://');
      expect(CommonConstants.INVALID_VALUE).assertEqual(-1);
      expect(CommonConstants.DEFAULT_USER_ID).assertEqual(0);
      expect(CommonConstants.TYPE_APP).assertEqual(0);
      expect(CommonConstants.TYPE_CARD).assertEqual(1);
      expect(CommonConstants.TYPE_FUNCTION).assertEqual(2);
      expect(CommonConstants.TYPE_FOLDER).assertEqual(3);
      expect(CommonConstants.TYPE_ADD).assertEqual(4);
    });

    it('common_constants_relationships_hold', 0, () => {
      const cardDimensions = [
        CommonConstants.CARD_DIMENSION_1x2,
        CommonConstants.CARD_DIMENSION_2x2,
        CommonConstants.CARD_DIMENSION_2x4,
        CommonConstants.CARD_DIMENSION_4x4,
      ];
      expect(new Set(cardDimensions).size).assertEqual(4);
      const overlayTypes = [
        CommonConstants.OVERLAY_TYPE_HIDE,
        CommonConstants.OVERLAY_TYPE_APP_MENU,
        CommonConstants.OVERLAY_TYPE_APP_ICON,
        CommonConstants.OVERLAY_TYPE_FOLDER,
        CommonConstants.OVERLAY_TYPE_CARD,
        CommonConstants.OVERLAY_TYPE_APP_RESIDENTIAL,
        CommonConstants.OVERLAY_TYPE_APP_RECENT,
      ];
      expect(new Set(overlayTypes).size).assertEqual(7);
      expect(CommonConstants.DRAG_FROM_DOCK === CommonConstants.DRAG_FROM_DESKTOP).assertFalse();
      expect(CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON === CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE).assertFalse();
      expect(CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE === CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT).assertFalse();
      expect(CommonConstants.LAYOUT_CONFIG_TYPE_MODE === CommonConstants.LAYOUT_CONFIG_TYPE_STYLE).assertFalse();
      expect(CommonConstants.LAYOUT_CONFIG_TYPE_STYLE === CommonConstants.LAYOUT_CONFIG_TYPE_FUNCTION).assertFalse();
      expect(CommonConstants.DEFAULT_DEVICE_TYPE === CommonConstants.PAD_DEVICE_TYPE).assertFalse();
      expect(CommonConstants.MENU_TYPE_FIXED === CommonConstants.MENU_TYPE_DYNAMIC).assertFalse();
      expect(CommonConstants.MENU_UI_MODE_LIGHT === CommonConstants.MENU_UI_MODE_DARK).assertFalse();
      expect(CommonConstants.DOCK_SPACE > 0).assertTrue();
      expect(CommonConstants.FOLDER_STATIC_SHOW_LENGTH > 0).assertTrue();
      expect(CommonConstants.OVERLAY_BLUR_RADIUS > 0).assertTrue();
      expect(CommonConstants.TYPE_ADD).assertLargerOrEqual(CommonConstants.TYPE_FOLDER);
    });

    it('style_and_key_constants_are_valid', 0, () => {
      expect(StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH).assertLargerOrEqual(1);
      expect(StyleConstants.DEFAULT_APP_NAME_SIZE).assertLargerOrEqual(1);
      expect(StyleConstants.DEFAULT_NUMBER_0).assertEqual(0);
      expect((KeyCode.KEY_DPAD_LEFT as number) !== (KeyCode.KEY_DPAD_RIGHT as number)).assertTrue();
      expect((KeyCode.KEY_DPAD_UP as number) !== (KeyCode.KEY_DPAD_DOWN as number)).assertTrue();
      expect(KeyCode.KEY_ENTER).assertLargerOrEqual(1);
    });

    it('common_app_item_fields_are_assignable', 0, () => {
      const app = new CommonAppItemInfo();
      app.appId = 'id';
      app.appName = 'name';
      app.bundleName = 'bundle';
      app.abilityName = 'ability';
      expect(app.appId).assertEqual('id');
      expect(app.appName).assertEqual('name');
      expect(app.bundleName).assertEqual('bundle');
      expect(app.abilityName).assertEqual('ability');
    });

    it('main_app_cover_copies_and_overrides_values', 0, () => {
      const src = new CommonAppItemInfo();
      src.appId = 'id_demo';
      src.appName = 'demo';
      src.appIconId = 101;
      src.bundleName = 'com.demo';
      src.abilityName = 'DemoAbility';
      src.moduleName = 'entry';
      const dst = new MainAppItemInfo();
      dst.cover(src);
      expect(dst.appId).assertEqual('id_demo');
      expect(dst.appName).assertEqual('demo');
      expect(dst.canMove).assertTrue();
      expect(dst.canRemove).assertTrue();

      const newer = new CommonAppItemInfo();
      newer.appName = 'new_name';
      dst.cover(newer);
      expect(dst.appName).assertEqual('new_name');
    });

    it('main_app_default_and_assignable_flags_hold', 0, () => {
      const dst = new MainAppItemInfo();
      expect(dst.canMove).assertTrue();
      expect(dst.canRemove).assertTrue();
      dst.icon = 'path';
      dst.onFocusIcon = 'focus';
      dst.isFocus = true;
      dst.canMove = false;
      dst.canRemove = false;
      expect(dst.icon).assertEqual('path');
      expect(dst.isFocus).assertTrue();
      expect(dst.canMove).assertFalse();
      expect(dst.canRemove).assertFalse();
    });

    it('cover_can_be_applied_multiple_times', 0, () => {
      const dst = new MainAppItemInfo();
      for (let i = 0; i < 5; i++) {
        const src = new CommonAppItemInfo();
        src.appName = 'v' + i;
        dst.cover(src);
        expect(dst.appName).assertEqual('v' + i);
      }
      dst.appName = 'before';
      dst.cover(new CommonAppItemInfo());
      expect(dst.appId === undefined).assertTrue();
    });

    it('batch_cover_keeps_expected_values', 0, () => {
      for (let i = 0; i < 5; i++) {
        const src = new CommonAppItemInfo();
        src.appId = 'app_' + i;
        src.bundleName = 'com.b.' + i;
        const dst = new MainAppItemInfo();
        dst.cover(src);
        expect(dst.appId).assertEqual('app_' + i);
        expect(dst.bundleName).assertEqual('com.b.' + i);
      }

      const reused = new MainAppItemInfo();
      for (let i = 0; i < 3; i++) {
        const src = new CommonAppItemInfo();
        src.appName = 'const_app_' + i;
        src.bundleName = 'com.const.' + i;
        reused.cover(src);
        expect(reused.appName).assertEqual('const_app_' + i);
        expect(reused.bundleName).assertEqual('com.const.' + i);
      }
    });

    it('instances_do_not_cross_contaminate', 0, () => {
      const a = new CommonAppItemInfo();
      const b = new CommonAppItemInfo();
      a.appName = 'alpha';
      b.appName = 'beta';
      a.appName = 'alpha_new';
      expect(b.appName).assertEqual('beta');
      expect(CommonConstants.LAUNCHER_BUNDLE).assertEqual('com.ohos.launcher');
    });
  });
}
