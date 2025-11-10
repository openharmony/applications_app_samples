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
// [Start persistence_v2_global_connect]
import { PersistenceV2, Type, ConnectOptions } from '@kit.ArkUI';
import { contextConstant } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
// 接受序列化失败的回调
PersistenceV2.notifyOnError((key: string, reason: string, msg: string) => {
  hilog.error(DOMAIN, 'testTag', '%{public}s', `error key: ${key}, reason: ${reason}, message: ${msg}`);
});

@ObservedV2
class SampleChild {
  @Trace public childId: number = 0;
  public groupId: number = 1;
}

@ObservedV2
export class SampleGlobalConnect {
  // 对于复杂对象需要@Type修饰，确保序列化成功
  @Type(SampleChild)
  @Trace public father: SampleChild = new SampleChild();
}

@Entry
@ComponentV2
struct Page1 {
  @Local refresh: number = 0;
  // key不传入尝试用为type的name作为key，加密参数不传入默认加密等级为EL2
  @Local p: SampleGlobalConnect =
    PersistenceV2.globalConnect({ type: SampleGlobalConnect, defaultCreator: () => new SampleGlobalConnect() })!;
  // 使用key:global1连接，传入加密等级为EL1
  @Local p1: SampleGlobalConnect = PersistenceV2.globalConnect({
    type: SampleGlobalConnect,
    key: 'global1',
    defaultCreator: () => new SampleGlobalConnect(),
    areaMode: contextConstant.AreaMode.EL1
  })!;
  // 使用key:global2连接，使用构造函数形式，加密参数不传入默认加密等级为EL2
  options: ConnectOptions<SampleGlobalConnect> =
    { type: SampleGlobalConnect, key: 'global2', defaultCreator: () => new SampleGlobalConnect() };
  @Local p2: SampleGlobalConnect = PersistenceV2.globalConnect(this.options)!;
  // 使用key:global3连接，直接写加密数值，范围只能在0-4，否则运行会crash,例如加密设置为EL3
  @Local p3: SampleGlobalConnect = PersistenceV2.globalConnect({
    type: SampleGlobalConnect,
    key: 'global3',
    defaultCreator: () => new SampleGlobalConnect(),
    areaMode: 3
  })!;

  build() {
    Column() {
      /**************************** 显示数据 **************************/
      // 被@Trace修饰的数据可以自动持久化进磁盘
      Text('Key SampleGlobalConnect: ' + this.p.father.childId.toString())
        .onClick(() => {
          this.p.father.childId += 1;
        })
        .fontSize(25)
        .fontColor(Color.Red)
      Text('Key global1: ' + this.p1.father.childId.toString())
        .onClick(() => {
          this.p1.father.childId += 1;
        })
        .fontSize(25)
        .fontColor(Color.Red)
      Text('Key global2: ' + this.p2.father.childId.toString())
        .onClick(() => {
          this.p2.father.childId += 1;
        })
        .fontSize(25)
        .fontColor(Color.Red)
      Text('Key global3: ' + this.p3.father.childId.toString())
        .onClick(() => {
          this.p3.father.childId += 1;
        })
        .fontSize(25)
        .fontColor(Color.Red)
      /**************************** keys接口 **************************/
      // keys 本身不会刷新，需要借助状态变量刷新
      Text('Persist keys: ' + PersistenceV2.keys().toString() + ' refresh: ' + this.refresh)
        .onClick(() => {
          this.refresh += 1;
        })
        .fontSize(25)

      /**************************** remove接口 **************************/
      Text('Remove key SampleGlobalConnect: ' + 'refresh: ' + this.refresh)
        .onClick(() => {
          // 删除这个key，会导致和p失去联系，之后p无法存储，即使reconnect
          PersistenceV2.remove(SampleGlobalConnect);
          this.refresh += 1;
        })
        .fontSize(25)
      Text('Remove key global1: ' + 'refresh: ' + this.refresh)
        .onClick(() => {
          // 删除这个key，会导致和p失去联系，之后p无法存储，即使reconnect
          PersistenceV2.remove('global1');
          this.refresh += 1;
        })
        .fontSize(25)
      Text('Remove key global2: ' + 'refresh: ' + this.refresh)
        .onClick(() => {
          // 删除这个key，会导致和p失去联系，之后p无法存储，即使reconnect
          PersistenceV2.remove('global2');
          this.refresh += 1;
        })
        .fontSize(25)
      Text('Remove key global3: ' + 'refresh: ' + this.refresh)
        .onClick(() => {
          // 删除这个key，会导致和p失去联系，之后p无法存储，即使reconnect
          PersistenceV2.remove('global3');
          this.refresh += 1;
        })
        .fontSize(25)
      /**************************** reConnect **************************/
      // 重新连接也无法和之前的状态变量建立联系，因此无法保存数据
      Text('ReConnect key global2: ' + 'refresh: ' + this.refresh)
        .onClick(() => {
          // 删除这个key，会导致和p失去联系，之后p无法存储，即使reconnect
          PersistenceV2.globalConnect(this.options);
          this.refresh += 1;
        })
        .fontSize(25)

      /**************************** save接口 **************************/
      Text('not save key SampleGlobalConnect: ' + this.p.father.groupId.toString() + ' refresh: ' + this.refresh)
        .onClick(() => {
          // 未被@Trace保存的对象无法自动存储
          this.p.father.groupId += 1;
          this.refresh += 1;
        })
        .fontSize(25)
      Text('save key SampleGlobalConnect: ' + this.p.father.groupId.toString() + ' refresh: ' + this.refresh)
        .onClick(() => {
          // 未被@Trace保存的对象无法自动存储，需要调用save存储
          this.p.father.groupId += 1;
          PersistenceV2.save(SampleGlobalConnect);
          this.refresh += 1;
        })
        .fontSize(25)
    }
    .width('100%')
  }
}
// [End persistence_v2_global_connect]

@Component
export struct PersistenceV2GlobalConnectDecorator {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Page1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.persistence_v2_global_connect'))
  }
}