/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { mdns } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';
import { serviceOperateStatus } from '../common/ServiceOperateStatus';
import { ComponentId } from '../common/ComponentId';

// 创建Context对象
let context = getContext(this) as Context;

// 定义设备信息的接口
interface DeviceInfo {
  id: string; // 唯一标识符
  text: string; // 设备信息文本
}

export function resourceToString(resource: Resource): string {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct MdnsServiceDemo {
  @State addServiceStatus: string = resourceToString($r('app.string.not_added')); // 添加本地服务状态展示
  @State resolveServiceStatus: string = resourceToString($r('app.string.not_resolved')); // 解析本地服务状态展示
  @State removeServiceStatus: string = resourceToString($r('app.string.not_removed')); // 移除本地服务状态展示
  @State discoveryStatus: string = resourceToString($r('app.string.not_started')); // mDNS服务发现状态展示
  @State discoveredDevices: Array<DeviceInfo> = []; // 保存发现的设备信息
  private localServiceInfo: mdns.LocalServiceInfo = {
    serviceType: '_print._tcp',
    serviceName: 'servicename',
    port: 5555,
    host: {
      address: '127.0.0.1'
    },
    serviceAttribute: [{ key: '111', value: [1] }]
  };

  private onDiscoveryStart(data: mdns.DiscoveryEventInfo): void {
    Logger.info(`Discovery Started: ${JSON.stringify(data)}`);
  }

  private onDiscoveryStop(data: mdns.DiscoveryEventInfo): void {
    Logger.info(`Discovery Stopped: ${JSON.stringify(data)}`);
  }

  private onServiceFound(data: mdns.LocalServiceInfo): void {
    Logger.info(`Service Found: ${JSON.stringify(data)}`);
    // 检查设备是否已经存在于列表中，避免重复推送
    const deviceExists = this.discoveredDevices.some((device) => device.text === JSON.stringify(data));
    if (!deviceExists) {
      // 只有在设备未存在的情况下，才会推送
      mdns.resolveLocalService(context, data).then((resolvedData) => {
        Logger.info(`Resolved Service: ${JSON.stringify(resolvedData)}`);
        // 推送新的设备信息到列表
        this.discoveredDevices.push({ id: Date.now().toString(), text: JSON.stringify(resolvedData) });
      }).catch((err: BusinessError) => {
        Logger.error(`Error resolving service: ${JSON.stringify(err)}`);
      });
    } else {
      Logger.info('Service already exists, skipping push.');
    }
  }

  private onServiceLost(data: mdns.LocalServiceInfo): void {
    Logger.info(`Service Lost: ${JSON.stringify(data)}`);
    const index = this.discoveredDevices.findIndex(
      (device) => device.text === JSON.stringify(data)
    );
    if (index !== -1) {
      this.discoveredDevices.splice(index, 1);
    }
  }

  build() {
    Column() {
      Text($r('app.string.mDNS_Service_Example'))
        .fontSize($r('app.float.size20'))
        .margin({ bottom: $r('app.float.margin20') })

      // 显示当前发现的设备
      Text($r('app.string.Device_Discovered'))
        .fontSize($r('app.float.size18'))
        .fontColor(Color.Black)
        .margin({ top: $r('app.float.margin10') })

      // 遍历设备信息并显示
      ForEach(this.discoveredDevices, (device: DeviceInfo) => {
        Text(device.text)
          .fontSize($r('app.float.size16'))
          .fontColor(Color.Gray)
          .margin({ top: $r('app.float.margin5'), bottom: $r('app.float.margin5') })
      });


      // 显示添加本地服务状态的文本
      Text(resourceToString($r('app.string.Add_Local_Service')) + ': ' + this.addServiceStatus)
        .fontSize($r('app.float.size18'))
        .fontColor(Color.Black)
        .margin({ top: $r('app.float.margin10') })
        .id(ComponentId.SERVICE_ADD_STATUS)

      // 显示解析本地服务状态的文本
      Text(resourceToString($r('app.string.Resolve_Local_Service')) + ': ' + this.resolveServiceStatus)
        .fontSize($r('app.float.size18'))
        .fontColor(Color.Black)
        .margin({ top: $r('app.float.margin10') })
        .id(ComponentId.SERVICE_RESOLVE_STATUS)

      // 显示移除本地服务状态的文本
      Text(resourceToString($r('app.string.remove_Local_Service')) + ': ' + this.removeServiceStatus)
        .fontSize($r('app.float.size18'))
        .fontColor(Color.Black)
        .margin({ top: $r('app.float.margin10') })
        .id(ComponentId.SERVICE_REMOVE_STATUS)

      // 显示mDNS服务发现状态的文本
      Text(resourceToString($r('app.string.Start_mDNS_Service_Discovery')) + ': ' + this.discoveryStatus)
        .fontSize($r('app.float.size18'))
        .fontColor(Color.Black)
        .margin({ top: $r('app.float.margin10') })
        .id(ComponentId.SERVICE_DISCOVERY_STATUS)

      // 第一个按钮：添加本地服务
      Button($r('app.string.Add_Local_Service'))
        .onClick(() => {
          this.addLocalService();
        })
        .width('80%')
        .height($r('app.float.height50'))
        .margin({ top: $r('app.float.margin20') })
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .fontSize($r('app.float.size20'))
        .borderRadius($r('app.float.borderRadius'))
        .id(ComponentId.ADD_SERVICE_BTN)

      // 第二个按钮：解析本地服务
      Button($r('app.string.Resolve_Local_Service'))
        .onClick(() => {
          this.resolveLocalService();
        })
        .width('80%')
        .height($r('app.float.height50'))
        .margin({ top: $r('app.float.margin20') })
        .backgroundColor(Color.Green)
        .fontColor(Color.White)
        .fontSize($r('app.float.size20'))
        .borderRadius($r('app.float.borderRadius'))
        .id(ComponentId.RESOLVE_SERVICE_BTN)

      // 第三个按钮：移除本地服务
      Button($r('app.string.remove_Local_Service'))
        .onClick(() => {
          this.removeLocalService();
        })
        .width('80%')
        .height($r('app.float.height50'))
        .margin({ top: $r('app.float.margin20') })
        .backgroundColor(Color.Red)
        .fontColor(Color.White)
        .fontSize($r('app.float.size20'))
        .borderRadius($r('app.float.borderRadius'))
        .id(ComponentId.REMOVE_SERVICE_BTN)

      // 第四个按钮：启动 mDNS 服务发现
      Button($r('app.string.Start_mDNS_Service_Discovery'))
        .onClick(() => {
          this.startServiceDiscovery();
        })
        .width('80%')
        .height($r('app.float.height50'))
        .margin({ top: $r('app.float.margin20') })
        .backgroundColor(Color.Orange)
        .fontColor(Color.White)
        .fontSize($r('app.float.size20'))
        .borderRadius($r('app.float.borderRadius'))
        .id(ComponentId.START_DISCOVERY_SERVICE_BTN)

      // 第五个按钮：停止 mDNS 服务发现
      Button($r('app.string.Stop_mDNS_Service_Discovery'))
        .onClick(() => {
          this.stopServiceDiscovery();
        })
        .width('80%')
        .height($r('app.float.height50'))
        .margin({ top: $r('app.float.margin20') })
        .fontColor(Color.White)
        .fontSize($r('app.float.size20'))
        .borderRadius($r('app.float.borderRadius'))
        .id(ComponentId.STOP_DISCOVERY_SERVICE_BTN)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center);
  }

  // [Start manage_local_services]
  private addLocalService(): void {
    this.addServiceStatus = serviceOperateStatus.ADDING;
    mdns.addLocalService(context, this.localServiceInfo).then((data) => {
      this.addServiceStatus = serviceOperateStatus.ADD_SUCCESS;
      Logger.info(`Local Service Added: ${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      this.addServiceStatus = serviceOperateStatus.ADD_FAIL;
      Logger.error(`Error adding local service: ${JSON.stringify(err)}`);
    });
  }

  private resolveLocalService(): void {
    this.resolveServiceStatus = serviceOperateStatus.RESOLVING;
    mdns.resolveLocalService(context, this.localServiceInfo).then((data) => {
      this.resolveServiceStatus = serviceOperateStatus.RESOLVE_SUCCESS;
      Logger.info(`Resolved Local Service: ${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      this.resolveServiceStatus = serviceOperateStatus.RESOLVE_FAIL;
      Logger.error(`Error resolving local service: ${JSON.stringify(err)}`);
    });
  }

  private removeLocalService(): void {
    this.removeServiceStatus = serviceOperateStatus.REMOVING;
    mdns.removeLocalService(context, this.localServiceInfo).then((data) => {
      this.removeServiceStatus = serviceOperateStatus.REMOVE_SUCCESS;
      Logger.info(`Local Service Removed: ${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      this.removeServiceStatus = serviceOperateStatus.REMOVE_FAIL;
      Logger.error(`Error removing local service: ${JSON.stringify(err)}`);
    });
  }
  // [End manage_local_services]

  // [Start discover_local_services]
  private async startServiceDiscovery(): Promise<void> {
    this.discoveryStatus = serviceOperateStatus.DISCOVERY_STARTING;
    if (!context) {
      this.discoveryStatus = serviceOperateStatus.DISCOVERY_FAIL3;
      Logger.error('Context is undefined or null.');
      return;
    }

    let serviceType = '_print._tcp';
    let discoveryService = mdns.createDiscoveryService(context, serviceType);
    if (!discoveryService) {
      this.discoveryStatus = serviceOperateStatus.DISCOVERY_FAIL2;
      Logger.error('Failed to create discovery service.');
      return;
    }

    discoveryService.on('discoveryStart', (data) => this.onDiscoveryStart(data));
    discoveryService.on('discoveryStop', (data) => this.onDiscoveryStop(data));
    discoveryService.on('serviceFound', (data) => this.onServiceFound(data));
    discoveryService.on('serviceLost', (data) => this.onServiceLost(data));

    try {
      discoveryService.startSearchingMDNS();
      this.discoveryStatus = serviceOperateStatus.DISCOVERY_STARTED;
    } catch (error) {
      this.discoveryStatus = serviceOperateStatus.DISCOVERY_FAIL1;
      Logger.error(`Error starting mDNS service discovery: ${JSON.stringify(error)}`);
    }
  }

  private async stopServiceDiscovery(): Promise<void> {
    this.discoveryStatus = serviceOperateStatus.STOPPING;
    let serviceType = '_print._tcp';
    let discoveryService = mdns.createDiscoveryService(context, serviceType);

    try {
      discoveryService.stopSearchingMDNS();
      discoveryService.off('discoveryStart', (data) => this.onDiscoveryStart(data));
      discoveryService.off('discoveryStop', (data) => this.onDiscoveryStop(data));
      discoveryService.off('serviceFound', (data) => this.onServiceFound(data));
      discoveryService.off('serviceLost', (data) => this.onServiceLost(data));
      this.discoveryStatus = serviceOperateStatus.STOPPED;
    } catch (err) {
      this.discoveryStatus = serviceOperateStatus.STOP_FAIL;
      Logger.info(`Error stopping mDNS service discovery: ${JSON.stringify(err)}`);
    }
  }
  // [End discover_local_services]
}
