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
  public pageName:string;
  public routerName:string;
  constructor(pageName:string,routerName:string){
    this.pageName = pageName;
    this.routerName = routerName;
  };
};
const createRouterList: CreateRouter[] = [
  new CreateRouter('DecoratorDescriptionPage', 'pages/overview/DecoratorDescription'),
  new CreateRouter('ObservationChangeInheritancePage', 'pages/overview/ObservationChangeInheritance'),
  new CreateRouter('RestrictiveConditionsObservedPage', 'pages/restrictiveconditions/RestrictiveConditionsObserved'),
  new CreateRouter('ReadOnlyVariablePage', 'pages/restrictiveconditions/ReadOnlyVariable'),
  new CreateRouter('NestedObjectPage', 'pages/objectLinkusagescenarios/NestedObject'),
  new CreateRouter('ObjectArrayPage', 'pages/objectLinkusagescenarios/ObjectArray'),
  new CreateRouter('TwoDimensionalArrayPage', 'pages/objectLinkusagescenarios/TwoDimensionalArray'),
  new CreateRouter('CompleteExampleTwoDimensionalArrayPage', 'pages/objectLinkusagescenarios/CompleteExampleTwoDimensionalArray'),
  new CreateRouter('InheritFromMapClassPage', 'pages/objectLinkusagescenarios/InheritFromMapClass'),
  new CreateRouter('InheritFromSetClassPage', 'pages/objectLinkusagescenarios/InheritFromSetClass'),
  new CreateRouter('ObjectLinkSupportsUnionTypesPage', 'pages/objectLinkusagescenarios/ObjectLinkSupportsUnionTypes'),
  new CreateRouter('BasicNestingPage', 'pages/ObservedAndObjectLinkFAQs/BasicNesting'),
  new CreateRouter('ComplexMethodsNestingPage', 'pages/ObservedAndObjectLinkFAQs/ComplexMethodsNesting'),
  new CreateRouter('ComplexNestingCompletePage', 'pages/ObservedAndObjectLinkFAQs/ComplexNestingComplete'),
  new CreateRouter('DifferencesPropObjectLinkPage', 'pages/ObservedAndObjectLinkFAQs/DifferencesPropObjectLink'),
  new CreateRouter('DelayedChangePage', 'pages/ObservedAndObjectLinkFAQs/DelayedChange'),
  new CreateRouter('ObjectLinkDataSourceUpdatePage', 'pages/ObservedAndObjectLinkFAQs/ObjectLinkDataSourceUpdate'),
  new CreateRouter('ClickEventJackPage', 'pages/ObservedAndObjectLinkFAQs/ClickEventJack'),
  new CreateRouter('NotTriggerUIRefreshPage', 'pages/ObservedAndObjectLinkFAQs/NotTriggerUIRefresh')
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