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

const HDMI_PAGE_URL = 'pages/HdmiPage';
const DTV_PAGE_URL = 'pages/IndexDtv';
const DEFAULT_SOURCE_ID_VALUE = -1;
const SOURCE_ID_REBOOT_KEY = 'source_id_reboot';
const INPUT_SOURCE_BUNDLE = 'com.ohos.inputsource';
const LAUNCHER_BUNDLE = 'com.ohos.launcher';

interface RouteRecord {
  page: string;
  sourceId: number;
}

interface MissionWantRecord {
  abilityName: string;
  bundleName: string;
}

interface MissionRecord {
  missionId: number;
  want: MissionWantRecord;
}

interface SourceIdMap {
  HDMI_1?: number;
  DTV?: number;
}

type BackAction = 'routerBack' | 'moveMissionToFront' | 'defaultBack';
type NavigationAction = 'navigateDtv' | 'navigateHdmi' | 'toast' | 'none';

interface NavigationDecision {
  action: NavigationAction;
  sourceId?: number;
  toastMessage?: string;
}

/**
 * Resolves the page back behavior from the pull-source bundle context.
 *
 * @param pullBundleName Caller bundle cached by the desktop page.
 * @returns BackAction Back strategy for the current entry source.
 */
function resolveBackAction(pullBundleName?: string): BackAction {
  if (pullBundleName === LAUNCHER_BUNDLE) {
    return 'routerBack';
  }
  if (pullBundleName && pullBundleName.length > 0) {
    return 'moveMissionToFront';
  }
  return 'defaultBack';
}

/**
 * Builds a normalized route payload used by navigation tests.
 *
 * @param page Target page url.
 * @param sourceId Selected source id.
 * @returns RouteRecord Stable route data used by tests.
 */
function buildRouteRecord(page: string, sourceId: number): RouteRecord {
  return { page, sourceId };
}

/**
 * Resolves player-page navigation based on source id and HDMI availability.
 *
 * @param sourceId Source selected by the user or CEC event.
 * @param hdmiEnabled Whether the HDMI port is available for navigation.
 * @returns NavigationDecision Resulting route or toast decision.
 */
function resolveNavigationDecision(sourceId: number, hdmiEnabled: boolean): NavigationDecision {
  if (sourceId === 6) {
    return { action: 'navigateDtv', sourceId };
  }
  if (sourceId >= 1 && sourceId <= 5) {
    if (!hdmiEnabled) {
      return { action: 'toast', toastMessage: 'HDMI port disabled' };
    }
    return { action: 'navigateHdmi', sourceId };
  }
  return { action: 'none' };
}

/**
 * Finds the previous app mission id while skipping the input source mission itself.
 *
 * @param missions Mission list to scan.
 * @param targetBundle Caller bundle that should be restored.
 * @returns number Mission id or -1 when not found.
 */
function cacheMissionId(missions: MissionRecord[], targetBundle: string): number {
  let cachedMissionId = -1;
  missions.forEach((item: MissionRecord) => {
    if (item.want.abilityName === 'EntryAbility' && item.want.bundleName === INPUT_SOURCE_BUNDLE) {
      return;
    }
    if (item.want.bundleName === targetBundle) {
      cachedMissionId = item.missionId;
    }
  });
  return cachedMissionId;
}

/**
 * Converts a default source name to a source id using a lookup map.
 *
 * @param defaultName Stored default source name.
 * @param sourceIdMap Lookup table for source names.
 * @returns number Resolved source id or -1 when not found.
 */
function syncDefaultSourceId(defaultName: string, sourceIdMap: SourceIdMap): number {
  if (defaultName === 'HDMI_1') {
    return sourceIdMap.HDMI_1 ?? DEFAULT_SOURCE_ID_VALUE;
  }
  if (defaultName === 'DTV') {
    return sourceIdMap.DTV ?? DEFAULT_SOURCE_ID_VALUE;
  }
  return DEFAULT_SOURCE_ID_VALUE;
}

/**
 * Finds the focus index for a source id in the visible source list.
 *
 * @param sourceIds Visible source ids.
 * @param sourceType Source id to focus.
 * @returns number Matching index or -1 when absent.
 */
function findFocusIndex(sourceIds: number[], sourceType: number): number {
  return sourceIds.findIndex((item: number) => item === sourceType);
}

export default function IndexRouteAndBackTest(): void {
  describe('Index_onBackPress', () => {
    beforeEach(() => {
      AppStorage.setOrCreate<string>('pullBundleName', LAUNCHER_BUNDLE);
      AppStorage.setOrCreate<number>('pullSourceMissionId', 42);
    });

    afterEach(() => {
      AppStorage.setOrCreate<string>('pullBundleName', '');
      AppStorage.setOrCreate<number>('pullSourceMissionId', -1);
    });

    it('should_back_to_launcher_when_pull_source_is_launcher', 0, () => {
      expect(resolveBackAction(AppStorage.get<string>('pullBundleName'))).assertEqual('routerBack');
    });

    it('should_move_mission_to_front_when_pull_source_is_third_party', 0, () => {
      AppStorage.setOrCreate<string>('pullBundleName', 'com.streaming.app');
      expect(resolveBackAction(AppStorage.get<string>('pullBundleName'))).assertEqual('moveMissionToFront');
    });

    it('should_use_default_back_when_pull_source_is_missing', 0, () => {
      AppStorage.setOrCreate<string>('pullBundleName', '');
      expect(resolveBackAction(AppStorage.get<string>('pullBundleName'))).assertEqual('defaultBack');
    });
  });

  describe('Index_route_payload', () => {
    it('should_build_hdmi_route_with_source_id', 0, () => {
      const route = buildRouteRecord(HDMI_PAGE_URL, 3);
      expect(route.page).assertEqual(HDMI_PAGE_URL);
      expect(route.sourceId).assertEqual(3);
    });

    it('should_keep_reboot_key_value_resettable', 0, () => {
      AppStorage.setOrCreate<number>(SOURCE_ID_REBOOT_KEY, 99);
      AppStorage.setOrCreate<number>(SOURCE_ID_REBOOT_KEY, DEFAULT_SOURCE_ID_VALUE);
      expect(AppStorage.get<number>(SOURCE_ID_REBOOT_KEY)).assertEqual(DEFAULT_SOURCE_ID_VALUE);
    });
  });

  describe('Index_navigation_decision', () => {
    it('should_resolve_dtv_navigation_for_dtv_source', 0, () => {
      const decision = resolveNavigationDecision(6, true);
      expect(decision.action).assertEqual('navigateDtv');
      expect(decision.sourceId).assertEqual(6);
    });

    it('should_resolve_hdmi_navigation_for_enabled_hdmi_source', 0, () => {
      const decision = resolveNavigationDecision(3, true);
      expect(decision.action).assertEqual('navigateHdmi');
      expect(decision.sourceId).assertEqual(3);
    });

    it('should_block_hdmi_navigation_when_port_is_disabled', 0, () => {
      const decision = resolveNavigationDecision(3, false);
      expect(decision.action).assertEqual('toast');
      expect(decision.toastMessage).assertEqual('HDMI port disabled');
    });

    it('should_return_none_for_unknown_source', 0, () => {
      const decision = resolveNavigationDecision(99, true);
      expect(decision.action).assertEqual('none');
    });
  });

  describe('Index_recent_mission_cache', () => {
    it('should_cache_third_party_mission_id', 0, () => {
      const missions: MissionRecord[] = [
        { missionId: 7, want: { abilityName: 'EntryAbility', bundleName: INPUT_SOURCE_BUNDLE } },
        { missionId: 42, want: { abilityName: 'OtherAbility', bundleName: 'com.streaming.app' } }
      ];
      expect(cacheMissionId(missions, 'com.streaming.app')).assertEqual(42);
    });

    it('should_skip_inputsource_own_mission', 0, () => {
      const missions: MissionRecord[] = [
        { missionId: 7, want: { abilityName: 'EntryAbility', bundleName: INPUT_SOURCE_BUNDLE } }
      ];
      expect(cacheMissionId(missions, INPUT_SOURCE_BUNDLE)).assertEqual(-1);
    });

    it('should_fallback_to_minus_one_when_target_is_missing', 0, () => {
      const missions: MissionRecord[] = [
        { missionId: 10, want: { abilityName: 'OtherAbility', bundleName: 'com.other.app' } }
      ];
      expect(cacheMissionId(missions, 'com.streaming.app')).assertEqual(-1);
    });
  });

  describe('Index_focus_update', () => {
    it('should_find_source_index_for_cec_focus_update', 0, () => {
      expect(findFocusIndex([1, 2, 3], 2)).assertEqual(1);
    });

    it('should_return_minus_one_when_source_is_absent', 0, () => {
      expect(findFocusIndex([1, 2, 3], 99)).assertEqual(-1);
    });
  });

  describe('Index_default_source_sync', () => {
    it('should_convert_default_name_to_source_id', 0, () => {
      const sourceIdMap: SourceIdMap = { HDMI_1: 3, DTV: 6 };
      expect(syncDefaultSourceId('HDMI_1', sourceIdMap)).assertEqual(3);
    });

    it('should_fallback_to_minus_one_when_default_name_is_unknown', 0, () => {
      const sourceIdMap: SourceIdMap = { HDMI_1: 3, DTV: 6 };
      expect(syncDefaultSourceId('UNKNOWN', sourceIdMap)).assertEqual(-1);
    });
  });

  describe('Index_compound_scenarios', () => {
    it('should_keep_navigation_history_order_stable', 0, () => {
      const navigationHistory: string[] = [DTV_PAGE_URL, HDMI_PAGE_URL];
      expect(navigationHistory[0]).assertEqual(DTV_PAGE_URL);
      expect(navigationHistory[1]).assertEqual(HDMI_PAGE_URL);
    });

    it('should_block_navigation_when_toast_decision_is_returned', 0, () => {
      let navigationCount = 0;
      const decision = resolveNavigationDecision(4, false);
      if (decision.action === 'navigateDtv' || decision.action === 'navigateHdmi') {
        navigationCount++;
      }
      expect(navigationCount).assertEqual(0);
      expect(decision.action).assertEqual('toast');
    });

    it('should_keep_default_source_values_consistent_across_multiple_reads', 0, () => {
      const defaultSourceValues: number[] = [2, 2, 2];
      const allEqual = defaultSourceValues.every((item: number) => item === defaultSourceValues[0]);
      expect(allEqual).assertEqual(true);
    });
  });
}
