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
class CreateRouter {
  public pageName: string;
  public routerName: string;

  constructor(pageName: string, routerName: string) {
    this.pageName = pageName;
    this.routerName = routerName;
  }
}

const createRouterList: CreateRouter[] = [
  new CreateRouter('ParentComponentPage', 'component/ParentComponent'),
  new CreateRouter('ParameterSpecificationPage', 'component/ParameterSpecification'),
  new CreateRouter('ParentFunctionPage', 'component/ParentFunction'),
  new CreateRouter('MyComponentBuildPage', 'component/MyComponentBuild'),
  new CreateRouter('MyComponentStylePage', 'component/MyComponentStyle'),
  new CreateRouter('StaticCodeV1Page', 'component/StaticCodeV1'),
  new CreateRouter('StaticCodeV2Page', 'component/StaticCodeV2'),
  new CreateRouter('stateManagementOverviewPage', 'managementoverview/stateManagementOverview'),
  new CreateRouter('ComponentPage', 'component/Component'),
  new CreateRouter('FreezeWhenInactivePage', 'component/FreezeWhenInactive'),
  new CreateRouter('BuildFunctionPage', 'component/BuildFunction'),
  new CreateRouter('EntryPage', 'component/Entry'),
  new CreateRouter('RouteNamePage', 'component/RouteName'),
  new CreateRouter('ReusablePage', 'component/Reusable'),
  new CreateRouter('BuilderMethodPage', 'component/BuilderMethod'),
  new CreateRouter('IfPage', 'component/If'),
  new CreateRouter('ModuleComponentPage', 'component/ModuleComponent'),
  new CreateRouter('ForEachFilterPage', 'component/ForEachFilter'),
];

@Entry
@Component
struct Index {
  @State createNavigationListIndex: CreateRouter[] = createRouterList;

  build() {
    List({ space: 3 }) {
      ForEach(this.createNavigationListIndex, (item: CreateRouter) => {
        ListItem() {
          Text(item.pageName)
            .textAlign(TextAlign.Center)
            .width('90%')
            .height(30)
            .borderRadius(5)
            .backgroundColor('#f5f5f5')
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: `${item.routerName}`
              })
            })
        }
      }, (item: CreateRouter, index: number) => JSON.stringify(item))
    }
    .alignListItem(ListItemAlign.Center)
    .height('auto')
    .width('auto')
  }
}