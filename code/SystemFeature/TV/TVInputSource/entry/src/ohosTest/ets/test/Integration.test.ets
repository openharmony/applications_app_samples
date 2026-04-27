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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { SourceManager, SourcePlugState } from '../../../main/ets/manager/SourceManager';
import { DtvManager } from '../../../main/ets/manager/DtvManager';
import { PlayerManager } from '../../../main/ets/manager/PlayerManager';
import { MultiPageListenerManager, MultiPageListenerType } from '../../../main/ets/manager/MultiPageListenerManager';
import { SourcePlugStateEntity } from '../../../main/ets/entity/SourcePlugStateEntity';
import { TimingInfoEntity } from '../../../main/ets/entity/TimingInfoEntity';
import { SourceType } from '../../../main/ets/utils/StyleConstants';

/**
 * Creates a listener used by the listener manager smoke test.
 *
 * @param listenerId Unique listener identifier used for register/unregister.
 * @param onPlugChange Callback invoked when plug state changes.
 * @returns Configured listener instance.
 */
function createListener(
  listenerId: string,
  onPlugChange: (plugState: SourcePlugState) => void
): MultiPageListenerType {
  const listener = new MultiPageListenerType();
  listener.id = listenerId;
  listener.onPlugChange = onPlugChange;
  return listener;
}

/**
 * Registers the integration smoke suite in the Hypium runner.
 *
 * @returns void.
 */
export default function IntegrationTest(): void {
  describe('IntegrationTest', () => {
    beforeAll(() => {
      // Prepare shared integration test state.
    });

    beforeEach(() => {
      // Keep each test isolated.
    });

    afterEach(() => {
      // Clear per-test state.
    });

    afterAll(() => {
      // Final cleanup hook.
    });

    it('should_keep_entity_contracts_consistent', 0, () => {
      const sourceEntity = new SourcePlugStateEntity(SourceType.SOURCE_HDMI1, true, 0, 'HDMI1');
      const timingEntity = new TimingInfoEntity();
      timingEntity.setWidth(1920);
      timingEntity.setHeight(1080);
      timingEntity.setFrameRate(60);
      timingEntity.setIsInterlace(false);

      expect(sourceEntity.getSourceId()).assertEqual(SourceType.SOURCE_HDMI1);
      expect(sourceEntity.getIsPlugIn()).assertEqual(true);
      expect(sourceEntity.getDisplayOrder()).assertEqual(0);
      expect(sourceEntity.getSourceName()).assertEqual('HDMI1');
      expect(timingEntity.getWidth()).assertEqual(1920);
      expect(timingEntity.getHeight()).assertEqual(1080);
      expect(timingEntity.getFrameRate()).assertEqual(60);
      expect(timingEntity.getIsInterlace()).assertEqual(false);
    });

    it('should_keep_manager_access_points_available', 0, () => {
      const playerManagerFirst = PlayerManager.getInstance();
      const playerManagerSecond = PlayerManager.getInstance();
      const listenerManagerFirst = MultiPageListenerManager.getInStance();
      const listenerManagerSecond = MultiPageListenerManager.getInStance();

      expect(playerManagerFirst === playerManagerSecond).assertEqual(true);
      expect(listenerManagerFirst === listenerManagerSecond).assertEqual(true);
      expect(typeof playerManagerFirst.bindSource).assertEqual('function');
      expect(typeof playerManagerFirst.unBindSource).assertEqual('function');
      expect(typeof SourceManager.getSourceList).assertEqual('function');
      expect(typeof SourceManager.onEvent).assertEqual('function');
      expect(typeof DtvManager.init).assertEqual('function');
      expect(typeof DtvManager.getChannelList).assertEqual('function');
    });

    it('should_dispatch_plug_change_to_registered_listeners', 0, () => {
      const listenerManager = MultiPageListenerManager.getInStance();
      let receivedSourceId = -1;
      let receivedPlugState = false;
      const listener = createListener('integration_listener_smoke', (plugState: SourcePlugState): void => {
        receivedSourceId = plugState.source as number;
        receivedPlugState = plugState.isPluIn;
      });

      listenerManager.register(listener);
      listenerManager.onPlugChange({
        source: SourceType.SOURCE_HDMI2,
        isPluIn: true
      });
      listenerManager.unregister(listener);
      listenerManager.onPlugChange({
        source: SourceType.SOURCE_HDMI3,
        isPluIn: false
      });

      expect(receivedSourceId).assertEqual(SourceType.SOURCE_HDMI2);
      expect(receivedPlugState).assertEqual(true);
    });
  });
}

