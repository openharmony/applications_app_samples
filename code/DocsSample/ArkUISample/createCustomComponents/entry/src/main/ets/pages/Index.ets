import { router } from '@kit.ArkUI'

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
class createRouter{
  pageName:string
  routerName:string
  constructor(pageName:string,routerName:string){
    this.pageName = pageName
    this.routerName = routerName
  }
};
const createRouterList:createRouter[] = [
  new createRouter('ParentComponentPage','component/ParentComponent'),
  new createRouter('ParameterSpecificationPage','component/ParameterSpecification'),
  new createRouter('ParentFunctionPage','component/ParentFunction'),
  new createRouter('MyComponentBuildPage','component/MyComponentBuild'),
  new createRouter('MyComponentStylePage','component/MyComponentStyle'),
  new createRouter('StaticCodeV1Page','component/StaticCodeV1'),
  new createRouter('StaticCodeV2Page','component/StaticCodeV2'),
  new createRouter('stateManagementOverviewPage','managementoverview/stateManagementOverview'),
  new createRouter('OnePage','component/One'),
  new createRouter('TwoPage','component/Two'),
  new createRouter('ThreePage','component/Three'),
  new createRouter('FourPage','component/Four'),
  new createRouter('FivePage','component/Five'),
  new createRouter('SixPage','component/Six'),
  new createRouter('SevenPage','component/Seven'),
  new createRouter('EightPage','component/Eight'),
  new createRouter('NinePage','component/Nine'),
  new createRouter('TenPage','component/Ten'),
];
@Entry
@Component
struct Index {
  @State createNavigationListIndex:createRouter[] = createRouterList;
  build() {
      List({space:3}){
        ForEach(this.createNavigationListIndex, (item:createRouter) => {
          ListItem(){
            Text(item.pageName)
              .textAlign(TextAlign.Center)
              .width('90%')
              .height(30)
              .borderRadius(5)
              .backgroundColor('#f5f5f5')
              .onClick(() => {
              router.pushUrl({
                url: `${item.routerName}`,
              })
              })
          }
        }, (item:createRouter, index:number) => JSON.stringify(item))
      }
      .alignListItem(ListItemAlign.Center)
      .height('auto')
      .width('auto')
  }
}