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
import curves from '@ohos.curves';
import { Route, RouteGroup } from './common/Index';
import { KeyboardAvoidMode } from '@kit.ArkUI';

@Styles
function cardPressedStyle() {
  .backgroundColor('rgba(0,0,0,0.1)')
  .opacity(1)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
}

@Styles
function cardNormalStyle() {
  .backgroundColor('rgba(0,0,0,0)')
  .opacity(1)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
}

@Styles
function cardDisabledStyle() {
  .backgroundColor('rgba(0,0,0,0)')
  .opacity(0.5)
  .animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 })
}

@Entry
@Component
struct renderingControl {
  @State routes: RouteGroup[] = [
    {
      name: 'RenderingRepeat',
      label: $r('app.string.RenderingRepeat'),
      children: [
        { name: 'DemoGrid', label: $r('app.string.RenderingRepeat_label1') },
        { name: 'DemoList', label: $r('app.string.RenderingRepeat_label2') },
        { name: 'DemoSwiper', label: $r('app.string.RenderingRepeat_label3') },
        { name: 'EntryCompSucc', label: $r('app.string.RenderingRepeat_label4') },
        { name: 'NodeUpdateMechanism', label: $r('app.string.RenderingRepeat_label5') },
        { name: 'PreInsert', label: $r('app.string.RenderingRepeat_label6') },
        { name: 'RepeatBuilderPage', label: $r('app.string.RenderingRepeat_label7') },
        { name: 'RepeatExample', label: $r('app.string.RenderingRepeat_label8') },
        { name: 'RepeatExample2', label: $r('app.string.RenderingRepeat_label9') },
        { name: 'RepeatLazyLoading1', label: $r('app.string.RenderingRepeat_label10') },
        { name: 'RepeatLazyLoading2', label: $r('app.string.RenderingRepeat_label11') },
        { name: 'RepeatLazyLoading3', label: $r('app.string.RenderingRepeat_label12') },
        { name: 'NestedRepeat', label: $r('app.string.RenderingRepeat_label13') },
        { name: 'RepeatTemplateSingle', label: $r('app.string.RenderingRepeat_label14') },
        { name: 'RepeatTemplateSingle1', label: $r('app.string.RenderingRepeat_label15') },
        { name: 'RepeatVirtualScroll2T', label: $r('app.string.RenderingRepeat_label16') },
        { name: 'RepeatVirtualScrollOnMove', label: $r('app.string.RenderingRepeat_label17') },
      ]
    },
    {
      name: 'RenderingForeach',
      label: $r('app.string.RenderingForeach'),
      children: [
        { name: 'AbnormalExample', label: $r('app.string.RenderingForeach_label1') },
        { name: 'ArticleListView', label: $r('app.string.RenderingForeach_label2') },
        { name: 'ArticleListView2', label: $r('app.string.RenderingForeach_label3') },
        { name: 'ArticleListView3', label: $r('app.string.RenderingForeach_label4') },
        { name: 'ArticleSkeletonView', label: $r('app.string.RenderingForeach_label5') },
        { name: 'BadPerformance', label: $r('app.string.RenderingForeach_label6') },
        { name: 'CrashNormalExample', label: $r('app.string.RenderingForeach_label7') },
        { name: 'ForEach1', label: $r('app.string.RenderingForeach_label8') },
        { name: 'ForEach2', label: $r('app.string.RenderingForeach_label9') },
        { name: 'ForEach3', label: $r('app.string.RenderingForeach_label10') },
        { name: 'ForEachSort', label: $r('app.string.RenderingForeach_label11') },
        { name: 'NonNecessaryMem', label: $r('app.string.RenderingForeach_label12') },
      ]
    },
    {
      name: 'RenderingIf',
      label: $r('app.string.RenderingIf'),
      children: [
        { name: 'IfElseRendering', label: $r('app.string.RenderingIf_label1') },
        { name: 'IfRendering', label: $r('app.string.RenderingIf_label2') },
        { name: 'KeepCounter', label: $r('app.string.RenderingIf_label3') },
        { name: 'NestedIf', label: $r('app.string.RenderingIf_label4') },
      ]
    },
    {
      name: 'RenderingLazyForeach',
      label: $r('app.string.RenderingLazyForeach'),
      children: [
        { name: 'AddingData', label: $r('app.string.RenderingLazyForeach_label1') },
        { name: 'ChangingDataSubproperties', label: $r('app.string.RenderingLazyForeach_label2') },
        { name: 'ComponentRerenderingFailure', label: $r('app.string.RenderingLazyForeach_label3') },
        { name: 'DataDeletion', label: $r('app.string.RenderingLazyForeach_label4') },
        { name: 'DragandDropSorting', label: $r('app.string.RenderingLazyForeach_label5') },
        { name: 'ImageFlickeringDuringRerenders', label: $r('app.string.RenderingLazyForeach_label6') },
        { name: 'InitialRendering', label: $r('app.string.RenderingLazyForeach_label7') },
        { name: 'InitialRendering2', label: $r('app.string.RenderingLazyForeach_label8') },
        { name: 'LazyLoadingFailure', label: $r('app.string.RenderingLazyForeach_label9') },
        { name: 'ModifyingIndividualDataItems', label: $r('app.string.RenderingLazyForeach_label10') },
        { name: 'ModifyingMultipleDataItems', label: $r('app.string.RenderingLazyForeach_label11') },
        { name: 'ObservingComponentInternalState', label: $r('app.string.RenderingLazyForeach_label12') },
        { name: 'ObservingNestedClassProperties', label: $r('app.string.RenderingLazyForeach_label13') },
        { name: 'PreciselyModifyingData', label: $r('app.string.RenderingLazyForeach_label14') },
        { name: 'PreciselyModifyingData2', label: $r('app.string.RenderingLazyForeach_label15') },
        { name: 'ReceivingExternalInput', label: $r('app.string.RenderingLazyForeach_label16') },
        { name: 'ScreenFlickeringInList', label: $r('app.string.RenderingLazyForeach_label17') },
        { name: 'SwappingData', label: $r('app.string.RenderingLazyForeach_label18') },
        { name: 'UINotRerenderedWhenObjectLinkIsChanged', label: $r('app.string.RenderingLazyForeach_label19') },
        { name: 'UnexpectedRenderingResults', label: $r('app.string.RenderingLazyForeach_label20') },
      ]
    },
  ];

  @State selection: string | null = null;

  @Builder
  ListItemGroupHeader(route: RouteGroup) {
    Row() {
      Text(route.label)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)

      Blank()

      Text(`${route.children.length}`)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .opacity(this.selection === route.name ? 0 : 1)

      Image($r('sys.media.ohos_ic_public_arrow_right'))
        .fillColor($r('sys.color.ohos_id_color_fourth'))
        .height(24)
        .width(24)
        .rotate({ angle: this.selection === route.name ? 90 : 0 })
        .animation({ curve: curves.interpolatingSpring(0, 1, 228, 30) })
    }
    .borderRadius(20)
    .width('100%')
    .padding(8)
    .enabled(!!route.children.length)
    .stateStyles({
      pressed: cardPressedStyle,
      normal: cardNormalStyle,
      disabled: cardDisabledStyle,
    })
    .onClick(() => {
      animateTo(
        { curve: curves.interpolatingSpring(0, 1, 228, 25) },
        () => {
          if (this.selection === route.name) {
            this.selection = null;
          } else {
            this.selection = route.name;
          }
        });
    })
  }

  aboutToAppear(): void{
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
  }

  build() {
    Column() {
      Text('ComponentExtension')
      List() {
        ForEach(this.routes, (routeGroup: RouteGroup) => {
          ListItemGroup({
            header: this.ListItemGroupHeader(routeGroup),
            style: ListItemGroupStyle.CARD,
          }) {
            if (routeGroup.name === this.selection) {
              ForEach(routeGroup.children, (route: Route) => {
                ListItem() {
                  Row() {
                    Text(route.label).fontSize(16)
                    Blank()
                    Image($r('sys.media.ohos_ic_public_arrow_right'))
                      .fillColor($r('sys.color.ohos_id_color_fourth'))
                      .height(24)
                      .width(24)
                  }
                  .stateStyles({
                    pressed: cardPressedStyle,
                    normal: cardNormalStyle,
                    disabled: cardDisabledStyle,
                  })
                  .borderRadius(20)
                  .padding(8)
                  .transition(
                    TransitionEffect.OPACITY.animation({
                      curve: curves.interpolatingSpring(0, 1, 228, 30)
                    })
                  )
                  .width('100%')
                  .onClick(() => {
                    const name = `pages/${routeGroup.name}/${route.name}`;
                    this.getUIContext().getRouter().pushUrl({url:name})
                  })
                }
                .width('100%')
              })
            }
          }
          .padding(2)
          .divider({ strokeWidth: 0.5 })
        })
      }.padding({bottom: 10})
    }
  }
}