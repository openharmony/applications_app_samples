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

// [Start persistence_v2_module_connect_storage_one]
// 模块1
import { PersistenceV2, Type } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { contextConstant } from '@kit.AbilityKit';

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
export class Sample {
  // 对于复杂对象需要@Type修饰，确保序列化成功
  @Type(SampleChild)
  @Trace public father: SampleChild = new SampleChild();
}

@Entry
@ComponentV2
struct Page1 {
  @Local refresh: number = 0;
  // 使用key:globalConnect1连接，传入加密等级为EL1
  @Local p1: Sample =
    PersistenceV2.globalConnect({ type: Sample, key: 'globalConnect1', defaultCreator: () => new Sample(), areaMode: contextConstant.AreaMode.EL1 })!;
  // 使用key:connect2连接，使用构造函数形式，加密参数不传入默认加密等级为EL2
  @Local p2: Sample = PersistenceV2.connect(Sample, 'connect2', () => new Sample())!;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Column() {
      /**************************** 显示数据 **************************/
      Text('Key globalConnect1: ' + this.p1.father.childId.toString())
        .onClick(() => {
          this.p1.father.childId += 1;
        })
        .fontSize(25)
        .fontColor(Color.Red)
      Text('Key connect2: ' + this.p2.father.childId.toString())
        .onClick(() => {
          this.p2.father.childId += 1;
        })
        .fontSize(25)
        .fontColor(Color.Red)

      /**************************** 跳转 **************************/
      Button('Jump to newModule')
        .onClick(() => { // 不同module之间使用，建议使用globalConnect
          let want: Want = {
            deviceId: '', // deviceId为空代表本设备
            bundleName: 'com.samples.paradigmstatemanagement', // 在app.json5中查看
            moduleName: 'demo', // 在需要跳转的module的module.json5中查看，非必选参数
            abilityName: 'NewModuleAbility', // 跳转启动的ability，在跳转模块对应的ability.ets文件中查看
            uri: 'src/main/ets/pages/Index'
          }
          // context为调用方UIAbility的UIAbilityContext
          this.context.startAbility(want).then(() => {
            hilog.info(DOMAIN, 'testTag', '%{public}s', 'start ability success');
          }).catch((err: Error) => {
            hilog.error(DOMAIN, 'testTag', '%{public}s',
              `start ability failed. code is ${err.name}, message is ${err.message}`);
          })
        })
    }
    .width('100%')
    .borderWidth(3)
    .borderColor(Color.Blue)
    .margin({ top: 5, bottom: 5 })
  }
}
// [End persistence_v2_module_connect_storage_one]

@Component
export struct PersistenceV2ModuleConnectStorage1Decorator {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Page1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.persistence_v2_module_connect_storage1'))
  }
}