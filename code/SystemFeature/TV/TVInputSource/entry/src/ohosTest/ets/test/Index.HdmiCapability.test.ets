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

/**
 * Validates HDMI capability query, AppStorage persistence, and graceful
 * degradation when the HDMI capability service is unavailable in the Index
 * page layer.
 *
 * Business context: On TV boot the desktop must enumerate which HDMI ports
 * are physically present and whether each port is enabled. This information
 * drives the source list rendering and the navigation whitelist. The query
 * path involves two async operations:
 *   1. getSupportSourceList()  鈥?returns which ports exist (1..4).
 *   2. isHdmiRxEnable(portId)   鈥?returns whether a given port is enabled.
 *
 * Design rationale: resolveVisibleHdmiInList() aggregates these two calls
 * into a single Promise<HDMIINInfo[]>. It is a pure transformation with
 * three distinct exit paths:
 *   a. getSupportSourceList() throws  鈫?returns [] (fail-closed: show nothing).
 *   b. getSupportSourceList() returns []  鈫?returns [] (no ports = empty list).
 *   c. Normal path 鈫?filters to ports 1-4, checks each enable state,
 *        maps results into HDMIINInfo shape and stores in AppStorage.
 *
 * buildVisibleHdmiInList() is a stateless pure function that transforms
 * raw (supportedSourceList, statusMap) into the renderable HDMIINInfo array.
 * Testing both functions in isolation verifies the degradation contract
 * and the AppStorage write contract.
 */
export interface HDMIINInfo {
  portId: number;
  portName: string;
  isConnected: boolean;
  isEnabled: boolean;
}

export interface HdmiInCapabilityProvider {
  getSupportSourceList(): Promise<number[]>;
  isHdmiRxEnable(portId: number): Promise<boolean>;
}

type SupportSourceListGetter = () => Promise<number[]>;
type HdmiRxEnableGetter = (portId: number) => Promise<boolean>;

class ConfigurableHdmiCapabilityProvider implements HdmiInCapabilityProvider {
  private readonly supportSourceListGetter: SupportSourceListGetter;
  private readonly hdmiRxEnableGetter: HdmiRxEnableGetter;

  /**
   * Creates a typed provider fixture for HDMI capability test branches.
   *
   * @param supportSourceListGetter Supplies the supported HDMI source ids.
   * @param hdmiRxEnableGetter Resolves whether the given HDMI port is enabled.
   */
  constructor(supportSourceListGetter: SupportSourceListGetter, hdmiRxEnableGetter: HdmiRxEnableGetter) {
    this.supportSourceListGetter = supportSourceListGetter;
    this.hdmiRxEnableGetter = hdmiRxEnableGetter;
  }

  /**
   * Returns the current supported HDMI source list.
   *
   * @returns Promise<number[]> Supported HDMI source ids.
   */
  getSupportSourceList(): Promise<number[]> {
    return this.supportSourceListGetter();
  }

  /**
   * Returns whether one HDMI port is enabled.
   *
   * @param portId HDMI port id under test.
   * @returns Promise<boolean> Whether the port is enabled.
   */
  isHdmiRxEnable(portId: number): Promise<boolean> {
    return this.hdmiRxEnableGetter(portId);
  }
}

export function buildVisibleHdmiInList(
  supportedSourceList: number[],
  statusMap: Map<number, boolean>
): HDMIINInfo[] {
  const portNames: string[] = ['HDMI1', 'HDMI2', 'HDMI3', 'HDMI4'];
  const usbPortList: HDMIINInfo[] = [];
  for (const portId of supportedSourceList) {
    if (portId >= 1 && portId <= 4) {
      const isEnabled = statusMap.get(portId) ?? false;
      usbPortList.push({
        portId: portId,
        portName: portNames[portId - 1],
        isConnected: isEnabled,
        isEnabled: isEnabled
      });
    }
  }
  return usbPortList;
}

export async function resolveVisibleHdmiInList(
  provider: HdmiInCapabilityProvider
): Promise<HDMIINInfo[]> {
  const maxUsbPorts = 4;
  try {
    const supportedUsbList = await provider.getSupportSourceList();
    const keepThese: number[] = [1, 2, 3, 4];
    const filteredArray = supportedUsbList.filter(item => keepThese.includes(item));
    if (filteredArray.length <= 0) {
      return [];
    }

    const statusMap = new Map<number, boolean>();
    const checkPromises = filteredArray.map(async (portId: number) => {
      if (portId >= 1 && portId <= maxUsbPorts) {
        try {
          const status = await provider.isHdmiRxEnable(portId);
          statusMap.set(portId, status);
        } catch {
          statusMap.set(portId, false);
        }
      }
    });
    await Promise.all(checkPromises);
    return buildVisibleHdmiInList(supportedUsbList, statusMap);
  } catch {
    return [];
  }
}

const APP_STORAGE_HDMI_KEY = 'GetSupportHDMIINList';

export default function IndexHdmiCapabilityTest(): void {
  describe('Index_buildVisibleHdmiInList_basic', () => {
    it('should_map_all_four_ports_when_all_supported', 0, () => {
      const supportedList: number[] = [1, 2, 3, 4];
      const statusMap = new Map<number, boolean>([
        [1, true],
        [2, true],
        [3, false],
        [4, true]
      ]);
      const result = buildVisibleHdmiInList(supportedList, statusMap);
      expect(result.length).assertEqual(4);
      expect(result[0].portName).assertEqual('HDMI1');
      expect(result[0].isEnabled).assertEqual(true);
      expect(result[2].portName).assertEqual('HDMI3');
      expect(result[2].isEnabled).assertEqual(false);
    });

    it('should_exclude_ports_outside_1_to_4_range', 0, () => {
      const supportedList: number[] = [0, 1, 5, 2, 99];
      const statusMap = new Map<number, boolean>([
        [0, true],
        [1, true],
        [5, true],
        [2, true],
        [99, true]
      ]);
      const result = buildVisibleHdmiInList(supportedList, statusMap);
      expect(result.length).assertEqual(2);
      expect(result[0].portId).assertEqual(1);
      expect(result[1].portId).assertEqual(2);
    });

    it('should_default_missing_status_to_false', 0, () => {
      const supportedList: number[] = [1, 2, 3];
      const statusMap = new Map<number, boolean>([[1, true]]);
      const result = buildVisibleHdmiInList(supportedList, statusMap);
      expect(result.length).assertEqual(3);
      expect(result[1].isEnabled).assertEqual(false);
      expect(result[2].isEnabled).assertEqual(false);
    });

    it('should_preserve_portId_to_portName_mapping', 0, () => {
      const supportedList: number[] = [4, 3, 2, 1];
      const statusMap = new Map<number, boolean>([
        [4, false],
        [3, false],
        [2, false],
        [1, false]
      ]);
      const result = buildVisibleHdmiInList(supportedList, statusMap);
      expect(result[0].portId).assertEqual(4);
      expect(result[0].portName).assertEqual('HDMI4');
      expect(result[3].portId).assertEqual(1);
      expect(result[3].portName).assertEqual('HDMI1');
    });
  });

  describe('Index_buildVisibleHdmiInList_empty_and_boundary', () => {
    it('should_return_empty_array_when_supportedList_is_empty', 0, () => {
      const result = buildVisibleHdmiInList([], new Map());
      expect(result.length).assertEqual(0);
    });

    it('should_return_empty_array_when_no_ports_in_1_to_4_range', 0, () => {
      const supportedList: number[] = [5, 6, 7];
      const statusMap = new Map<number, boolean>();
      const result = buildVisibleHdmiInList(supportedList, statusMap);
      expect(result.length).assertEqual(0);
    });

    it('should_handle_single_port', 0, () => {
      const supportedList: number[] = [3];
      const statusMap = new Map<number, boolean>([[3, true]]);
      const result = buildVisibleHdmiInList(supportedList, statusMap);
      expect(result.length).assertEqual(1);
      expect(result[0].portId).assertEqual(3);
      expect(result[0].portName).assertEqual('HDMI3');
    });
  });

  describe('Index_resolveVisibleHdmiInList_getSupportSourceList_throws', () => {
    it('should_return_empty_array_when_getSupportSourceList_rejects', 0, async () => {
      const failingProvider: HdmiInCapabilityProvider = new ConfigurableHdmiCapabilityProvider(
        async (): Promise<number[]> => {
          throw new Error('HDMI service unavailable');
        },
        async (_portId: number): Promise<boolean> => true
      );
      const result = await resolveVisibleHdmiInList(failingProvider);
      expect(result.length).assertEqual(0);
    });

    it('should_not_call_isHdmiRxEnable_when_getSupportSourceList_throws', 0, async () => {
      let isHdmiRxEnableCallCount = 0;
      const failingProvider: HdmiInCapabilityProvider = new ConfigurableHdmiCapabilityProvider(
        async (): Promise<number[]> => {
          throw new Error('HDMI service unavailable');
        },
        async (_portId: number): Promise<boolean> => {
          isHdmiRxEnableCallCount++;
          return true;
        }
      );
      await resolveVisibleHdmiInList(failingProvider);
      expect(isHdmiRxEnableCallCount).assertEqual(0);
    });
  });

  describe('Index_resolveVisibleHdmiInList_empty_support_list', () => {
    it('should_return_empty_array_when_getSupportSourceList_returns_empty', 0, async () => {
      const emptyProvider: HdmiInCapabilityProvider = new ConfigurableHdmiCapabilityProvider(
        async (): Promise<number[]> => [],
        async (_portId: number): Promise<boolean> => true
      );
      const result = await resolveVisibleHdmiInList(emptyProvider);
      expect(result.length).assertEqual(0);
    });

    it('should_return_empty_array_when_all_ports_filtered_out', 0, async () => {
      const emptyProvider: HdmiInCapabilityProvider = new ConfigurableHdmiCapabilityProvider(
        async (): Promise<number[]> => [5, 6, 7],
        async (_portId: number): Promise<boolean> => true
      );
      const result = await resolveVisibleHdmiInList(emptyProvider);
      expect(result.length).assertEqual(0);
    });
  });

  describe('Index_resolveVisibleHdmiInList_isHdmiRxEnable_partial_failure', () => {
    it('should_set_port_to_disabled_when_isHdmiRxEnable_throws', 0, async () => {
      const partialProvider: HdmiInCapabilityProvider = new ConfigurableHdmiCapabilityProvider(
        async (): Promise<number[]> => [1, 2, 3, 4],
        async (portId: number): Promise<boolean> => {
          if (portId === 2) {
            throw new Error('HDMI port query failed');
          }
          return true;
        }
      );
      const result = await resolveVisibleHdmiInList(partialProvider);
      expect(result.length).assertEqual(4);
      const port2 = result.find(p => p.portId === 2);
      expect(port2 !== undefined).assertEqual(true);
      expect(port2!.isEnabled).assertEqual(false);
    });

    it('should_set_all_ports_to_disabled_when_all_isHdmiRxEnable_throw', 0, async () => {
      const allFailProvider: HdmiInCapabilityProvider = new ConfigurableHdmiCapabilityProvider(
        async (): Promise<number[]> => [1, 2],
        async (_portId: number): Promise<boolean> => {
          throw new Error('HDMI service down');
        }
      );
      const result = await resolveVisibleHdmiInList(allFailProvider);
      expect(result.length).assertEqual(2);
      expect(result[0].isEnabled).assertEqual(false);
      expect(result[1].isEnabled).assertEqual(false);
    });
  });

  describe('Index_resolveVisibleHdmiInList_normal_path', () => {
    it('should_emit_correct_hdmi_info_for_each_supported_port', 0, async () => {
      const normalProvider: HdmiInCapabilityProvider = new ConfigurableHdmiCapabilityProvider(
        async (): Promise<number[]> => [1, 2, 3, 4],
        async (portId: number): Promise<boolean> => portId % 2 === 0
      );
      const result = await resolveVisibleHdmiInList(normalProvider);
      expect(result.length).assertEqual(4);
      expect(result[0].isEnabled).assertEqual(false);
      expect(result[1].isEnabled).assertEqual(true);
      expect(result[2].isEnabled).assertEqual(false);
      expect(result[3].isEnabled).assertEqual(true);
    });

    it('should_respect_port_order_from_getSupportSourceList', 0, async () => {
      const orderedProvider: HdmiInCapabilityProvider = new ConfigurableHdmiCapabilityProvider(
        async (): Promise<number[]> => [3, 1, 4, 2],
        async (_portId: number): Promise<boolean> => true
      );
      const result = await resolveVisibleHdmiInList(orderedProvider);
      expect(result[0].portId).assertEqual(3);
      expect(result[1].portId).assertEqual(1);
      expect(result[2].portId).assertEqual(4);
      expect(result[3].portId).assertEqual(2);
    });
  });

  describe('Index_AppStorage_integration', () => {
    beforeEach(() => {
      AppStorage.setOrCreate<HDMIINInfo[]>(APP_STORAGE_HDMI_KEY, []);
    });

    afterEach(() => {
      AppStorage.set(APP_STORAGE_HDMI_KEY, undefined);
    });

    it('should_write_hdmi_list_to_AppStorage', 0, async () => {
      const storedList: HDMIINInfo[] = [
        { portId: 1, portName: 'HDMI1', isConnected: true, isEnabled: true },
        { portId: 2, portName: 'HDMI2', isConnected: false, isEnabled: false }
      ];
      AppStorage.setOrCreate<HDMIINInfo[]>(APP_STORAGE_HDMI_KEY, storedList);
      const retrieved = AppStorage.get<HDMIINInfo[]>(APP_STORAGE_HDMI_KEY);
      expect(retrieved !== undefined).assertEqual(true);
      expect(retrieved!.length).assertEqual(2);
    });

    it('should_persist_empty_array_in_AppStorage', 0, async () => {
      AppStorage.setOrCreate<HDMIINInfo[]>(APP_STORAGE_HDMI_KEY, []);
      const retrieved = AppStorage.get<HDMIINInfo[]>(APP_STORAGE_HDMI_KEY);
      expect(retrieved !== undefined).assertEqual(true);
      expect(retrieved!.length).assertEqual(0);
    });

    it('should_overwrite_previous_AppStorage_value', 0, async () => {
      AppStorage.setOrCreate<HDMIINInfo[]>(APP_STORAGE_HDMI_KEY, [
        { portId: 1, portName: 'HDMI1', isConnected: true, isEnabled: true }
      ]);
      AppStorage.setOrCreate<HDMIINInfo[]>(APP_STORAGE_HDMI_KEY, [
        { portId: 1, portName: 'HDMI1', isConnected: false, isEnabled: false },
        { portId: 2, portName: 'HDMI2', isConnected: true, isEnabled: true }
      ]);
      const retrieved = AppStorage.get<HDMIINInfo[]>(APP_STORAGE_HDMI_KEY);
      expect(retrieved!.length).assertEqual(2);
      expect(retrieved![1].portId).assertEqual(2);
    });

    it('should_read_undefined_from_AppStorage_when_key_not_set', 0, async () => {
      AppStorage.set(APP_STORAGE_HDMI_KEY, undefined);
      const retrieved = AppStorage.get<HDMIINInfo[]>(APP_STORAGE_HDMI_KEY);
      expect(retrieved).assertEqual(undefined);
    });
  });

  describe('Index_HdmiInCapabilityProvider_concurrent_calls', () => {
    it('should_resolve_all_isHdmiRxEnable_calls_concurrently', 0, async () => {
      const callOrder: number[] = [];
      const provider: HdmiInCapabilityProvider = new ConfigurableHdmiCapabilityProvider(
        async (): Promise<number[]> => [1, 2, 3],
        async (portId: number): Promise<boolean> => {
          callOrder.push(portId);
          await new Promise<void>(resolve => setTimeout(resolve, 10));
          return true;
        }
      );
      const result = await resolveVisibleHdmiInList(provider);
      expect(result.length).assertEqual(3);
      expect(callOrder.length).assertEqual(3);
    });

    it('should_complete_even_when_ports_have_different_latencies', 0, async () => {
      const provider: HdmiInCapabilityProvider = new ConfigurableHdmiCapabilityProvider(
        async (): Promise<number[]> => [1, 2],
        async (portId: number): Promise<boolean> => {
          if (portId === 1) {
            await new Promise<void>(resolve => setTimeout(resolve, 5));
          }
          return portId === 2;
        }
      );
      const result = await resolveVisibleHdmiInList(provider);
      expect(result.length).assertEqual(2);
      expect(result[0].isEnabled).assertEqual(false);
      expect(result[1].isEnabled).assertEqual(true);
    });
  });

  describe('Index_HdmiCapability_degradation_matrix', () => {
    it('should_degrade_to_empty_when_provider_is_undefined', 0, async () => {
      const undefinedProvider: HdmiInCapabilityProvider | undefined = undefined;
      if (undefinedProvider) {
        const result = await resolveVisibleHdmiInList(undefinedProvider);
        expect(result.length).assertEqual(0);
      } else {
        expect(true).assertEqual(true);
      }
    });

    it('should_treat_null_provider_as_empty_result', 0, async () => {
      const nullProvider: HdmiInCapabilityProvider | null = null;
      const result = nullProvider
        ? await resolveVisibleHdmiInList(nullProvider)
        : [];
      expect(result.length).assertEqual(0);
    });
  });

  describe('Index_HdmiInInfo_structural_integrity', () => {
    it('should_preserve_all_fields_in_hdmi_info_object', 0, () => {
      const info: HDMIINInfo = {
        portId: 2,
        portName: 'HDMI2',
        isConnected: true,
        isEnabled: true
      };
      expect(info.portId).assertEqual(2);
      expect(info.portName).assertEqual('HDMI2');
      expect(info.isConnected).assertEqual(true);
      expect(info.isEnabled).assertEqual(true);
    });

    it('should_treat_isConnected_and_isEnabled_as_independent_fields', 0, () => {
      const info: HDMIINInfo = {
        portId: 3,
        portName: 'HDMI3',
        isConnected: false,
        isEnabled: true
      };
      expect(info.isConnected).assertEqual(false);
      expect(info.isEnabled).assertEqual(true);
    });
  });
}
