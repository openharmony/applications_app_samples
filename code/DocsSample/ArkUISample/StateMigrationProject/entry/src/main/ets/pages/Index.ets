/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
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

interface listItem {
  router?: string;
  name: string;
  description?: string;
}

let demandList: listItem[] = [
  {
    name: 'StateEasyV1',
    router: 'pages/componentstatemigration/StateEasyV1',
  },
  {
    name: 'StateEasyV2',
    router: 'pages/componentstatemigration/StateEasyV2',
  },
  {
    name: 'StateComplexV1',
    router: 'pages/componentstatemigration/StateComplexV1',
  },
  {
    name: 'StateComplexV2',
    router: 'pages/componentstatemigration/StateComplexV2',
  },
  {
    name: 'StateExternalInitializationV1',
    router: 'pages/componentstatemigration/StateExternalInitializationV1',
  },
  {
    name: 'StateExternalInitializationV2',
    router: 'pages/componentstatemigration/StateExternalInitializationV2',
  },
  {
    name: 'LinkMiigrationV1',
    router: 'pages/componentstatemigration/LinkMiigrationV1',
  },
  {
    name: 'LinkMiigrationV2',
    router: 'pages/componentstatemigration/LinkMiigrationV2',
  },
  {
    name: 'PropEasyV1',
    router: 'pages/componentstatemigration/PropEasyV1',
  },
  {
    name: 'PropEasyV2',
    router: 'pages/componentstatemigration/PropEasyV2',
  },
  {
    name: 'PropComplexV1',
    router: 'pages/componentstatemigration/PropComplexV1',
  },
  {
    name: 'PropComplexV2',
    router: 'pages/componentstatemigration/PropComplexV2',
  },
  {
    name: 'PropSubComponentUpdateVarV1',
    router: 'pages/componentstatemigration/PropSubComponentUpdateVarV1',
  },
  {
    name: 'PropSubComponentUpdateVarV2',
    router: 'pages/componentstatemigration/PropSubComponentUpdateVarV2',
  },
  {
    name: 'PropSubComponentUpdateVarLocalV1',
    router: 'pages/componentstatemigration/PropSubComponentUpdateVarLocalV1',
  },
  {
    name: 'PropSubComponentUpdateVarLocalV2',
    router: 'pages/componentstatemigration/PropSubComponentUpdateVarLocalV2',
  },
  {
    name: 'ProvideAliasV1',
    router: 'pages/componentstatemigration/ProvideAliasV1',
  },
  {
    name: 'ProvideAliasV2',
    router: 'pages/componentstatemigration/ProvideAliasV2',
  },
  {
    name: 'ProvideConsumeNoInitV1',
    router: 'pages/componentstatemigration/ProvideConsumeNoInitV1',
  },
  {
    name: 'ProvideConsumeInitV2',
    router: 'pages/componentstatemigration/ProvideConsumeInitV2',
  },
  {
    name: 'ProvideParentInitV1',
    router: 'pages/componentstatemigration/ProvideParentInitV1',
  },
  {
    name: 'ProvideParentNoInitV2',
    router: 'pages/componentstatemigration/ProvideParentNoInitV2',
  },
  {
    name: 'ProvideNoAllowOverrideV1',
    router: 'pages/componentstatemigration/ProvideNoAllowOverrideV1',
  },
  {
    name: 'ProvideAllowOverrideV2',
    router: 'pages/componentstatemigration/ProvideAllowOverrideV2',
  },
  {
    name: 'WatchSingleVarV1',
    router: 'pages/componentstatemigration/WatchSingleVarV1',
  },
  {
    name: 'WatchSingleVarV2',
    router: 'pages/componentstatemigration/WatchSingleVarV2',
  },
  {
    name: 'WatchMoreVarV1',
    router: 'pages/componentstatemigration/WatchMoreVarV1',
  },
  {
    name: 'WatchMoreVarV2',
    router: 'pages/componentstatemigration/WatchMoreVarV2',
  },
  {
    name: 'ComputedV1',
    router: 'pages/componentstatemigration/ComputedV1',
  },
  {
    name: 'ComputedV2',
    router: 'pages/componentstatemigration/ComputedV2',
  }
]

@Entry
@Component
struct Index {
  @State bgColor: ResourceColor = '#39b5fa';

  build() {
    Column() {
      Text($r('app.string.state_migration'))
        .height('5%')
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.bgColor)
        .fontColor(Color.White)

      Column() {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(demandList, (listitem: listItem, index: number) => {
            ListItem() {
              Column() {
                Text(listitem.name)
                  .fontSize(15)
                  .fontColor(this.bgColor)
                  .maxLines(1)
              }
              .onClick(() => {
                if (!!listitem.router) {
                  this.getUIContext().getRouter().pushUrl({ url: listitem.router })
                }
              })
            }
          })
        }
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .friction(0.6)
        .divider({
          strokeWidth: 2,
          color: 0xFFFFFF,
          startMargin: 20,
          endMargin: 20
        })
        .edgeEffect(EdgeEffect.Spring)
        .contentEndOffset(50)
        .width('90%')
      }
      .width('100%')
      //  .height('100%')
      .backgroundColor('#fff4f3f3')
      .padding({ top: 5 })
    }
  }
}