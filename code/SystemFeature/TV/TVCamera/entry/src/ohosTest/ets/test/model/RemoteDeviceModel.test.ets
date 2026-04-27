/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import RemoteDeviceModel from '../../../../main/ets/models/RemoteDeviceModel';

type DiscoverSuccessHandler = (data: MockDiscoverSuccessData) => void;
type DeviceNameChangeHandler = (data: MockDeviceNameChangeData) => void;
type DiscoverFailureHandler = (data: MockDiscoverFailureData) => void;
type ServiceDieHandler = () => void;

interface MockDeviceBasicInfo {
  deviceId: string;
  deviceName: string;
  deviceType: string;
  networkId: string;
}

interface MockDiscoverSuccessData {
  device: MockDeviceBasicInfo;
}

interface MockDeviceNameChangeData {
  deviceName: string;
}

interface MockDiscoverFailureData {
  reason: number;
}

interface MockBindTargetResult {
  deviceId: string;
}

interface MockDistributedDeviceManager {
  getAvailableDeviceListSync: () => MockDeviceBasicInfo[];
  startDiscovering: (_discoverParam: object, _filterOptions: object) => void;
  stopDiscovering: () => void;
  on: (eventName: string,
    callback: DiscoverSuccessHandler | DeviceNameChangeHandler | DiscoverFailureHandler | ServiceDieHandler) => void;
  off: (eventName: string,
    callback: DiscoverSuccessHandler | DeviceNameChangeHandler | DiscoverFailureHandler | ServiceDieHandler) => void;
  bindTarget: (deviceId: string, bindParam: object,
    callback: (err: object | undefined, data: MockBindTargetResult) => Promise<void> | void) => void;
  unbindTarget: (deviceId: string) => void;
}

interface RemoteDeviceModelPrivateApi {
  distributedDeviceManager?: MockDistributedDeviceManager;
  unTrustDeviceList: MockDeviceBasicInfo[];
  trustDeviceList: MockDeviceBasicInfo[];
  isDeviceIdInTrustList(deviceId: string): boolean;
  isDeviceIdInUnTrustList(deviceId: string): boolean;
  getAvailableDeviceList(): MockDeviceBasicInfo[];
  getUnTrustDeviceList(): MockDeviceBasicInfo[];
  deleteDeviceIdInUnTrustList(deviceId: string): void;
  getNetWorkId(): string;
  getDeviceId(): string;
  startDiscovering(): void;
  stopDiscovering(): void;
  bindTarget(deviceId: string): void;
  unbindTarget(deviceId: string): void;
}

/**
 * 功能描述：获取带私有状态访问能力的远端设备模型单例。
 * 参数说明：无。
 * 返回值：`RemoteDeviceModelPrivateApi`，用于验证信任列表和发现回调状态机。
 */
function getRemoteDeviceModel(): RemoteDeviceModelPrivateApi {
  return RemoteDeviceModel as Object as RemoteDeviceModelPrivateApi;
}

/**
 * 功能描述：生成测试用远端设备对象。
 * 参数说明：`deviceId`、`deviceName`、`networkId` 用于模拟发现列表。
 * 返回值：`MockDeviceBasicInfo`，与源码消费的设备结构保持一致。
 */
function buildDevice(deviceId: string, deviceName: string, networkId: string): MockDeviceBasicInfo {
  return {
    deviceId,
    deviceName,
    deviceType: 'tv',
    networkId
  };
}

/**
 * 功能描述：重置单例内部列表和设备管理桩。
 * 参数说明：`model` 为待测远端设备单例。
 * 返回值：void，确保每条用例都从干净状态启动。
 */
function resetRemoteDeviceModel(model: RemoteDeviceModelPrivateApi): void {
  model.distributedDeviceManager = undefined;
  model.unTrustDeviceList = [];
  model.trustDeviceList = [];
}

/**
 * 功能描述：注册 RemoteDeviceModel 的行为契约测试。
 * 参数说明：无。
 * 返回值：void，用于挂载设备发现、列表同步、绑定解绑等高价值测试。
 */
export default function RemoteDeviceModelTest(): void {
  describe('RemoteDeviceModelTest', () => {
    let model: RemoteDeviceModelPrivateApi;

    beforeEach(() => {
      // 业务背景：RemoteDeviceModel 也是全局单例，发现结果和信任列表会跨用例残留。
      // 每次先清空内部状态，才能真实验证去重和同步语义。
      model = getRemoteDeviceModel();
      resetRemoteDeviceModel(model);
    });

    afterEach(() => {
      // 业务背景：本文件会注入伪 DeviceManager 以及发现结果列表。
      // 用例结束后统一还原，避免后续测试读取到上一个场景遗留设备。
      resetRemoteDeviceModel(model);
    });

    it('RemoteDeviceModel_SingletonReferenceIsStable_001', 0, () => {
      // 业务背景：分布式设备管理必须由同一实例维持，才能保证发现列表和绑定状态一致。
      // 先锁定单例稳定性，再验证状态流行为。
      expect(getRemoteDeviceModel() === getRemoteDeviceModel()).assertTrue();
    });

    it('RemoteDeviceModel_TrustListLookup_002', 0, () => {
      // 业务背景：可信设备会影响 UI 展示和绑定策略，不能仅凭假常量判断。
      // 这里直接写入可信列表，验证查询逻辑走的是真实列表匹配。
      model.trustDeviceList = [buildDevice('trusted-1', 'Trusted Camera', 'network-1')];

      expect(model.isDeviceIdInTrustList('trusted-1')).assertTrue();
      expect(model.isDeviceIdInTrustList('missing')).assertFalse();
    });

    it('RemoteDeviceModel_UnTrustListLookup_003', 0, () => {
      // 业务背景：未认证设备列表决定页面是否展示“待绑定”状态。
      // 因此需要锁定不可信列表查询的精确匹配行为。
      model.unTrustDeviceList = [buildDevice('pending-1', 'Pending Camera', 'network-2')];

      expect(model.isDeviceIdInUnTrustList('pending-1')).assertTrue();
      expect(model.isDeviceIdInUnTrustList('missing')).assertFalse();
    });

    it('RemoteDeviceModel_DeleteDeviceIdInUnTrustList_RemovesOnlyTarget_004', 0, () => {
      // 业务背景：设备转入可信列表时，只能清理对应待绑定项，不能误删其他待处理设备。
      // 这里验证删除逻辑按 deviceId 精确过滤。
      model.unTrustDeviceList = [
        buildDevice('pending-1', 'Pending Camera 1', 'network-1'),
        buildDevice('pending-2', 'Pending Camera 2', 'network-2')
      ];

      model.deleteDeviceIdInUnTrustList('pending-1');

      expect(model.unTrustDeviceList.length).assertEqual(1);
      expect(model.unTrustDeviceList[0].deviceId).assertEqual('pending-2');
    });

    it('RemoteDeviceModel_GetAvailableDeviceList_ReturnsEmptyWithoutManager_005', 0, () => {
      // 业务背景：分布式管理器尚未初始化时，页面必须拿到空数组而不是旧缓存。
      // 这条用例锁定无 manager 场景的安全返回值。
      let result = model.getAvailableDeviceList();
      expect(result.length).assertEqual(0);
    });

    it('RemoteDeviceModel_GetAvailableDeviceList_SyncsTrustListAndCleansUnTrustOverlap_006', 0, () => {
      // 业务背景：同一设备一旦进入可信列表，就不该继续显示在待绑定列表里。
      // 这里串起 getAvailableDeviceList 的两个核心副作用：刷新 trust 列表并清理 overlap。
      let trusted = buildDevice('trusted-1', 'Trusted Camera', 'network-1');
      let stillPending = buildDevice('pending-1', 'Pending Camera', 'network-2');
      model.unTrustDeviceList = [trusted, stillPending];
      model.distributedDeviceManager = {
        getAvailableDeviceListSync: (): MockDeviceBasicInfo[] => {
          return [trusted];
        },
        startDiscovering: (): void => {
        },
        stopDiscovering: (): void => {
        },
        on: (): void => {
        },
        off: (): void => {
        },
        bindTarget: (): void => {
        },
        unbindTarget: (): void => {
        }
      };

      let result = model.getAvailableDeviceList();

      expect(result.length).assertEqual(1);
      expect(model.trustDeviceList.length).assertEqual(1);
      expect(model.unTrustDeviceList.length).assertEqual(1);
      expect(model.unTrustDeviceList[0].deviceId).assertEqual('pending-1');
    });

    it('RemoteDeviceModel_GetUnTrustDeviceList_ReturnsCurrentState_007', 0, () => {
      // 业务背景：页面层依赖该接口读取待绑定列表。
      // 这里验证返回内容与当前内部状态一致，而不是虚构占位数据。
      model.unTrustDeviceList = [
        buildDevice('pending-1', 'Pending Camera 1', 'network-1'),
        buildDevice('pending-2', 'Pending Camera 2', 'network-2')
      ];

      let result = model.getUnTrustDeviceList();

      expect(result.length).assertEqual(2);
      expect(result[1].deviceId).assertEqual('pending-2');
    });

    it('RemoteDeviceModel_GetNetWorkId_ReadsFirstTrustedDevice_008', 0, () => {
      // 业务背景：CameraModel 初始化远端拍照时会直接消费第一个可信设备 networkId。
      // 因此需要固定“取第一项”的现状契约。
      model.distributedDeviceManager = {
        getAvailableDeviceListSync: (): MockDeviceBasicInfo[] => {
          return [
            buildDevice('trusted-1', 'Trusted Camera 1', 'network-1'),
            buildDevice('trusted-2', 'Trusted Camera 2', 'network-2')
          ];
        },
        startDiscovering: (): void => {
        },
        stopDiscovering: (): void => {
        },
        on: (): void => {
        },
        off: (): void => {
        },
        bindTarget: (): void => {
        },
        unbindTarget: (): void => {
        }
      };

      expect(model.getNetWorkId()).assertEqual('network-1');
    });

    it('RemoteDeviceModel_GetDeviceId_ReadsFirstTrustedDevice_009', 0, () => {
      // 业务背景：绑定/解绑和页面联动都默认使用第一项可信设备。
      // 这里锁定 deviceId 的读取语义，防止后续改动打破调用方预期。
      model.distributedDeviceManager = {
        getAvailableDeviceListSync: (): MockDeviceBasicInfo[] => {
          return [buildDevice('trusted-1', 'Trusted Camera 1', 'network-1')];
        },
        startDiscovering: (): void => {
        },
        stopDiscovering: (): void => {
        },
        on: (): void => {
        },
        off: (): void => {
        },
        bindTarget: (): void => {
        },
        unbindTarget: (): void => {
        }
      };

      expect(model.getDeviceId()).assertEqual('trusted-1');
    });

    it('RemoteDeviceModel_StartDiscovering_StartsScanAndRegistersFourHandlers_010', 0, () => {
      // 业务背景：发现流程不是单点调用，而是“启动扫描 + 注册四类监听”的组合事务。
      // 这条用例先把发现流程骨架固定下来。
      let started = 0;
      let onEvents: string[] = [];
      model.distributedDeviceManager = {
        getAvailableDeviceListSync: (): MockDeviceBasicInfo[] => {
          return [];
        },
        startDiscovering: (): void => {
          started++;
        },
        stopDiscovering: (): void => {
        },
        on: (eventName: string): void => {
          onEvents.push(eventName);
        },
        off: (): void => {
        },
        bindTarget: (): void => {
        },
        unbindTarget: (): void => {
        }
      };

      model.startDiscovering();

      expect(started).assertEqual(1);
      expect(onEvents[0]).assertEqual('discoverSuccess');
      expect(onEvents[1]).assertEqual('deviceNameChange');
      expect(onEvents[2]).assertEqual('discoverFailure');
      expect(onEvents[3]).assertEqual('serviceDie');
    });

    it('RemoteDeviceModel_StartDiscovering_DiscoverSuccessAddsNewUntrustedDevice_011', 0, () => {
      // 业务背景：新发现且未认证的设备需要立即进入待绑定列表，否则页面无法引导认证。
      // 这里手动触发 discoverSuccess 回调，验证真实列表变化。
      let handlers: Record<string, DiscoverSuccessHandler | DeviceNameChangeHandler | DiscoverFailureHandler | ServiceDieHandler> = {};
      let discovered = buildDevice('pending-1', 'Pending Camera', 'network-1');
      model.distributedDeviceManager = {
        getAvailableDeviceListSync: (): MockDeviceBasicInfo[] => {
          return [];
        },
        startDiscovering: (): void => {
        },
        stopDiscovering: (): void => {
        },
        on: (eventName: string,
          callback: DiscoverSuccessHandler | DeviceNameChangeHandler | DiscoverFailureHandler | ServiceDieHandler): void => {
          handlers[eventName] = callback;
        },
        off: (): void => {
        },
        bindTarget: (): void => {
        },
        unbindTarget: (): void => {
        }
      };

      model.startDiscovering();
      (handlers.discoverSuccess as DiscoverSuccessHandler)({ device: discovered });

      expect(model.unTrustDeviceList.length).assertEqual(1);
      expect(model.unTrustDeviceList[0].deviceId).assertEqual('pending-1');
    });

    it('RemoteDeviceModel_StartDiscovering_DiscoverSuccessSkipsDuplicateUntrustedDevice_012', 0, () => {
      // 业务背景：发现回调可能重复上报同一设备，列表若持续追加会导致 UI 重复项。
      // 这条测试锁定去重语义，确保同 deviceId 不会重复进入待绑定列表。
      let handlers: Record<string, DiscoverSuccessHandler | DeviceNameChangeHandler | DiscoverFailureHandler | ServiceDieHandler> = {};
      let discovered = buildDevice('pending-1', 'Pending Camera', 'network-1');
      model.unTrustDeviceList = [discovered];
      model.distributedDeviceManager = {
        getAvailableDeviceListSync: (): MockDeviceBasicInfo[] => {
          return [];
        },
        startDiscovering: (): void => {
        },
        stopDiscovering: (): void => {
        },
        on: (eventName: string,
          callback: DiscoverSuccessHandler | DeviceNameChangeHandler | DiscoverFailureHandler | ServiceDieHandler): void => {
          handlers[eventName] = callback;
        },
        off: (): void => {
        },
        bindTarget: (): void => {
        },
        unbindTarget: (): void => {
        }
      };

      model.startDiscovering();
      (handlers.discoverSuccess as DiscoverSuccessHandler)({ device: discovered });

      expect(model.unTrustDeviceList.length).assertEqual(1);
    });

    it('RemoteDeviceModel_StartDiscovering_DiscoverSuccessSkipsTrustedDevice_013', 0, () => {
      // 业务背景：已认证设备重新被发现时，应继续留在可信列表，而不是回退成待绑定状态。
      // 这里验证 trust 列表具有更高优先级。
      let handlers: Record<string, DiscoverSuccessHandler | DeviceNameChangeHandler | DiscoverFailureHandler | ServiceDieHandler> = {};
      let trusted = buildDevice('trusted-1', 'Trusted Camera', 'network-1');
      model.trustDeviceList = [trusted];
      model.distributedDeviceManager = {
        getAvailableDeviceListSync: (): MockDeviceBasicInfo[] => {
          return [trusted];
        },
        startDiscovering: (): void => {
        },
        stopDiscovering: (): void => {
        },
        on: (eventName: string,
          callback: DiscoverSuccessHandler | DeviceNameChangeHandler | DiscoverFailureHandler | ServiceDieHandler): void => {
          handlers[eventName] = callback;
        },
        off: (): void => {
        },
        bindTarget: (): void => {
        },
        unbindTarget: (): void => {
        }
      };

      model.startDiscovering();
      (handlers.discoverSuccess as DiscoverSuccessHandler)({ device: trusted });

      expect(model.unTrustDeviceList.length).assertEqual(0);
      expect(model.trustDeviceList.length).assertEqual(1);
    });

    it('RemoteDeviceModel_StopDiscovering_StopsScanAndUnregistersFourHandlers_014', 0, () => {
      // 业务背景：离开页面后如果不解绑监听，旧页面仍会继续接收发现事件。
      // 因此 stopDiscovering 必须同时停止扫描和注销四类回调。
      let stopped = 0;
      let offEvents: string[] = [];
      model.distributedDeviceManager = {
        getAvailableDeviceListSync: (): MockDeviceBasicInfo[] => {
          return [];
        },
        startDiscovering: (): void => {
        },
        stopDiscovering: (): void => {
          stopped++;
        },
        on: (): void => {
        },
        off: (eventName: string): void => {
          offEvents.push(eventName);
        },
        bindTarget: (): void => {
        },
        unbindTarget: (): void => {
        }
      };

      model.stopDiscovering();

      expect(stopped).assertEqual(1);
      expect(offEvents[0]).assertEqual('discoverSuccess');
      expect(offEvents[1]).assertEqual('deviceNameChange');
      expect(offEvents[2]).assertEqual('discoverFailure');
      expect(offEvents[3]).assertEqual('serviceDie');
    });

    it('RemoteDeviceModel_BindTarget_DelegatesDeviceIdToManager_015', 0, () => {
      // 业务背景：认证入口最终要把目标 deviceId 交给底层管理器。
      // 这里验证 bindTarget 会把页面选择的设备原样透传出去。
      let receivedDeviceId = '';
      let callbackCount = 0;
      model.distributedDeviceManager = {
        getAvailableDeviceListSync: (): MockDeviceBasicInfo[] => {
          return [];
        },
        startDiscovering: (): void => {
        },
        stopDiscovering: (): void => {
        },
        on: (): void => {
        },
        off: (): void => {
        },
        bindTarget: (deviceId: string, _bindParam: object,
          callback: (err: object | undefined, data: MockBindTargetResult) => Promise<void> | void): void => {
          receivedDeviceId = deviceId;
          callbackCount++;
          let result: MockBindTargetResult = { deviceId: deviceId };
          callback(undefined, result);
        },
        unbindTarget: (): void => {
        }
      };

      model.bindTarget('trusted-1');

      expect(receivedDeviceId).assertEqual('trusted-1');
      expect(callbackCount).assertEqual(1);
    });

    it('RemoteDeviceModel_UnbindTarget_DelegatesDeviceIdToManager_016', 0, () => {
      // 业务背景：解绑是用户主动断开设备的唯一入口。
      // 因此需要锁定 deviceId 透传行为，避免误解绑其他设备。
      let receivedDeviceId = '';
      model.distributedDeviceManager = {
        getAvailableDeviceListSync: (): MockDeviceBasicInfo[] => {
          return [];
        },
        startDiscovering: (): void => {
        },
        stopDiscovering: (): void => {
        },
        on: (): void => {
        },
        off: (): void => {
        },
        bindTarget: (): void => {
        },
        unbindTarget: (deviceId: string): void => {
          receivedDeviceId = deviceId;
        }
      };

      model.unbindTarget('trusted-2');

      expect(receivedDeviceId).assertEqual('trusted-2');
    });

    it('RemoteDeviceModel_GetNetWorkIdAndDeviceId_ReturnEmptyStringWithoutManager_017', 0, () => {
      // 业务背景：页面在未初始化阶段也可能先访问 networkId 或 deviceId。
      // 当前实现以空字符串兜底，这里将该契约固定下来。
      expect(model.getNetWorkId()).assertEqual('');
      expect(model.getDeviceId()).assertEqual('');
    });
  });
}
