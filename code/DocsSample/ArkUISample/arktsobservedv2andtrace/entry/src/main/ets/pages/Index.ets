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
class CreateRouter{
  public  pageName:string;
  public  routerName:string;
  constructor(pageName:string,routerName:string){
    this.pageName = pageName;
    this.routerName = routerName;
  };
};
const createRouterList: CreateRouter[] = [
  new CreateRouter('LimitationsPage', 'pages/overview/Limitations'),
  new CreateRouter('RealizeObservationPage', 'pages/overview/RealizeObservation'),
  new CreateRouter('ObserveChangesPage', 'pages/overview/ObserveChanges'),
  new CreateRouter('InheritedChangesPage', 'pages/overview/InheritedChanges'),
  new CreateRouter('StaticAttributePage', 'pages/overview/StaticAttribute'),
  new CreateRouter('UiRefreshCannotTriggeredPage', 'pages/usagerestrictions/UiRefreshCannotTriggered'),
  new CreateRouter('UseMixturePage', 'pages/usagerestrictions/UseMixture'),
  new CreateRouter('InheritanceMixturePage', 'pages/usagerestrictions/InheritanceMixture'),
  new CreateRouter('NestedClassPage', 'pages/usagescenarios/NestedClass'),
  new CreateRouter('InheritanceClassPage', 'pages/usagescenarios/InheritanceClass'),
  new CreateRouter('DecorationFoundationPage', 'pages/usagescenarios/DecorationFoundation'),
  new CreateRouter('DecorativeObjectPage', 'pages/usagescenarios/DecorativeObject'),
  new CreateRouter('DecorationMapPage', 'pages/usagescenarios/DecorationMap'),
  new CreateRouter('DecorationSetPage', 'pages/usagescenarios/DecorationSet'),
  new CreateRouter('DecorateDatePage', 'pages/usagescenarios/DecorateDate')
];
@Entry
@Component
struct Index {
  @State createRouterListIndex:CreateRouter[] = createRouterList;
  build() {
    List({space:8}){
      ForEach(this.createRouterListIndex, (item:CreateRouter) => {
        ListItem(){
          Text(item.pageName)
            .textAlign(TextAlign.Center)
            .width('90%')
            .height(30)
            .borderRadius(5)
            .backgroundColor('#f5f5f5')
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: `${item.routerName}`,
              });
            });
        }
      }, (item:CreateRouter, index:number) => JSON.stringify(item));
    }
    .alignListItem(ListItemAlign.Center)
    .height('auto')
    .width('auto')
  }
}