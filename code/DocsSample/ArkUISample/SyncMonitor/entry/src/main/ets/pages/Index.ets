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

interface ListItemObject {
  router?: string;
  name: string;
  description?: string;
}

let  demandList: ListItemObject[] = [
  {
    name: 'Compare SyncMonitor With Monitor',
    description: 'This is comparing SyncMonitor with Monitor scene',
    router: 'pages/CompareSyncMonitorWithMonitor',
  },
  {
    name: 'Monitor multiple variables',
    description: 'This is monitoring multiple variables scene',
    router: 'pages/MonitorMultipleVariables',
  },
  {
    name: 'Monitor object variable',
    description: 'This is monitoring multiple object variable scene',
    router: 'pages/MonitorObjectVariable',
  },
  {
    name: 'Monitor variables in ObservedV2 class',
    description: 'This is monitoring multiple variables in ObservedV2 class scene',
    router: 'pages/MonitorVariablesInObservedV2Class',
  },
  {
    name: 'Monitor two layer variables in ObservedV2 class',
    description: 'This is monitoring two-layer variable in ObservedV2 class scene',
    router: 'pages/MonitorTwoLayerVariablesInObservedV2Class',
  },
  {
    name: 'Monitor variable in base and derived class',
    description: 'This is monitoring variable in base and derived class scene',
    router: 'pages/MonitorVariableInBaseDerivedClass',
  },
  {
    name: 'Monitor entire object change but property no change',
    description: 'This is entire object change but property no change scene',
    router: 'pages/MonitorEntireObjectChangeButPropertyNoChange',
  },
  {
    name: 'SyncMonitor behaves differently from Monitor',
    description: 'This is scene that SyncMonitor behaves differently from Monitor',
    router: 'pages/SyncMonitorBehavesDifferentlyFromMonitor',
  },
  {
    name: 'Wildcard monitor object property change',
    description: 'This is wildcard monitor object property change scene',
    router: 'pages/WildcardMonitorObjectPropertyChange',
  },
  {
    name: 'Wildcard monitor array item change',
    description: 'This is wildcard monitor array item change scene',
    router: 'pages/WildcardMonitorArrayItemChange',
  },
  {
    name: 'Wildcard monitor nested object property change',
    description: 'This is wildcard monitor nested object property change scene',
    router: 'pages/WildcardMonitorNestedObjectPropertyChange',
  },
  {
    name: 'Wildcard monitor array first item change',
    description: 'This is wildcard monitor array first item change scene',
    router: 'pages/WildcardMonitorArrayFirstItemChange',
  },
  {
    name: 'Monitor the same variable two times',
    description: 'This is monitoring the same variable two times scene',
    router: 'pages/MonitorTheSameVariableTwoTimes',
  },
  {
    name: 'Effective and ineffective times of variable monitoring',
    description: 'This is effective and ineffective times of variable monitoring scene',
    router: 'pages/EffectiveAndIneffectiveTimesOfVariableMonitoring',
  },
  {
    name: 'Monitor computed variable',
    description: 'This is monitoring computed variable scene',
    router: 'pages/MonitorComputedVariable',
  },
  {
    name: 'Monitor variable from accessible to inaccessible',
    description: 'This is monitoring variable from accessible to inaccessible scene',
    router: 'pages/MonitorVariableFromAccessibleToInaccessible',
  },
];

@Entry
@Component
struct Index {
  @State bgColor: ResourceColor = '#39b5fa';

  build() {
    Column() {
      Text(`PersistenceV2 test case`)
        .height('8%')
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.bgColor)
        .fontColor(Color.White)

      Column() {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(demandList, (listitem: ListItemObject, index: number) => {
            ListItem() {
              Column({ space: 10 }) {
                Text(listitem.name)
                  .fontSize(20)
                  .fontColor(this.bgColor)
                  .maxLines(1)

                Text(listitem.description)
                  .width('100%')
              }
              .margin({ bottom: index >= demandList.length - 1 ? 100 : 0 })
              .padding({
                top: '3%',
                right: '10%',
                bottom: '5%',
                left: '10%'
              })
              .width('100%')
              .constraintSize({ minHeight: 100 })
              .borderRadius(10)
              .backgroundColor(0xffffff)
              .onClick(() => {
                if (!!listitem.router) {
                  this.getUIContext().getRouter().pushUrl({ url: listitem.router });
                }
              })
            }
          })
        }
        .listDirection(Axis.Vertical) // 排列方向
        .scrollBar(BarState.Off)
        .friction(0.6)
        .divider({
          strokeWidth: 2,
          color: 0xffffff,
          startMargin: 20,
          endMargin: 20
        }) // 每行之间的分界线
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .width('90%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff4f3f3')
      .padding({ top: 5 })
    }
  }
}