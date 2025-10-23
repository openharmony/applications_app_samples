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
import router from '@ohos.router';

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
struct AnimateIndex {
  @Provide('router') router: NavPathStack = new NavPathStack();
  @State routes: RouteGroup[] = [
    {
      name: "animateTo",
      label: $r('app.string.animate_to_label'),  // $r('app.string.animate_to_label')需要替换为开发者所需的资源文件
      children: [
        { name: 'template1/Index', label: $r('app.string.animate_to_temp_label1') }, // $r('app.string.animate_to_temp_label1')需要替换为开发者所需的资源文件
        { name: 'template2/Index', label: $r('app.string.animate_to_temp_label2') }, // $r('app.string.animate_to_temp_label2')需要替换为开发者所需的资源文件
        { name: 'template3/Index', label: $r('app.string.animate_to_temp_label3') }  // $r('app.string.animate_to_temp_label3')需要替换为开发者所需的资源文件
      ]
    },{
    name: "animation",
    label: $r("app.string.animation_label"),    // $r("app.string.animation_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.temp1") },    // $r("app.string.temp1")需要替换为开发者所需的资源文件
      { name: 'template2/Index', label: $r("app.string.animation_temp_label2") },    // $r("app.string.animation_temp_label2")需要替换为开发者所需的资源文件
      { name: 'template3/Index', label: $r("app.string.animation_temp_label3") },    //  $r("app.string.animation_temp_label3")需要替换为开发者所需的资源文件
      { name: 'template4/Index', label: $r("app.string.animation_temp_label4") }    // $r("app.string.animation_temp_label4")需要替换为开发者所需的资源文件

    ]
  }, {
    name: "cohesion",
    label: $r("app.string.cohesion_label"),// $r("app.string.cohesion_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.cohesion_temp_label1") },  //  $r("app.string.cohesion_temp_label1")需要替换为开发者所需的资源文件
      { name: 'template2/Index', label: $r("app.string.cohesion_temp_label2") }   //  $r("app.string.cohesion_temp_label2")需要替换为开发者所需的资源文件
    ]
  }, {
    name: "keyframeAnimateTo",
    label: $r("app.string.keyframeAnimateTo_label"),  //  $r("app.string.keyframeAnimateTo_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.temp1") }  // $r("app.string.temp1") 需要替换为开发者所需的资源文件
    ]
  }, {
    name: "pageTransition",
    label: $r("app.string.pageTransition_label"), // $r("app.string.pageTransition_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.pageTransition_temp_label1") },  //  $r("app.string.pageTransition_temp_label1")需要替换为开发者所需的资源文件
      { name: 'template2/Index', label: $r("app.string.pageTransition_temp_label2") },  //  $r("app.string.pageTransition_temp_label2")需要替换为开发者所需的资源文件
      { name: 'template3/pageTransitionSrc1', label: $r("app.string.pageTransition_temp_label3") }, //  $r("app.string.pageTransition_temp_label3")需要替换为开发者所需的资源文件
      { name: 'template4/pageTransitionSrc2', label: $r("app.string.pageTransition_temp_label4") }  //  $r("app.string.pageTransition_temp_label4")需要替换为开发者所需的资源文件
    ]
  }, {
    name: "compTransition",
    label: $r("app.string.compTransition_label"),  // $r("app.string.compTransition_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.compTransition_temp_label1") },  // $r("app.string.compTransition_temp_label1")需要替换为开发者所需的资源文件
      { name: 'template2/Index', label: $r("app.string.compTransition_temp_label2") },  //  $r("app.string.compTransition_temp_label2")需要替换为开发者所需的资源文件
      { name: 'template3/Index', label: $r("app.string.compTransition_temp_label3") },  //  $r("app.string.compTransition_temp_label3")需要替换为开发者所需的资源文件
      { name: 'template4/Index', label: $r("app.string.compTransition_temp_label4") },  // $r("app.string.compTransition_temp_label14)需要替换为开发者所需的资源文件
      { name: 'template5/Index', label: $r("app.string.compTransition_temp_label5") }   //  $r("app.string.compTransition_temp_label5")需要替换为开发者所需的资源文件
    ]
  }, {
    name: "shareTransition",
    label: $r("app.string.shareTransition_label"),  // $r("app.string.shareTransition_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.temp1") }  // $r("app.string.temp1") 需要替换为开发者所需的资源文件
    ]
  }, {
    name: "motionPath",
    label: $r("app.string.motionPath_label"),  // $r("app.string.motionPath_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.temp1") }  // $r("app.string.temp1")需要替换为开发者所需的资源文件
    ]
  }, {
    name: "particle",
    label: $r("app.string.particle_label"),  // $r("app.string.particle_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.particle_temp_label1") },  // $r("app.string.particle_temp_label1")需要替换为开发者所需的资源文件
      { name: 'template2/Index', label: $r("app.string.particle_temp_label2") },  // $r("app.string.particle_temp_label2")需要替换为开发者所需的资源文件
      { name: 'template3/Index', label: $r("app.string.particle_temp_label3") },  // $r("app.string.particle_temp_label3)需要替换为开发者所需的资源文件
      { name: 'template4/Index', label: $r("app.string.particle_temp_label4") },  // $r("app.string.particle_temp_label4")需要替换为开发者所需的资源文件
      { name: 'template5/Index', label: $r("app.string.particle_temp_label5") },  // $r("app.string.particle_temp_label5")需要替换为开发者所需的资源文件
      { name: 'template6/Index', label: $r("app.string.particle_temp_label6") }   // $r("app.string.particle_temp_label6")需要替换为开发者所需的资源文件
    ]
  }, {
    name: "animator",
    label: $r("app.string.animator_label"),  // $r("app.string.animator_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.animator_temp_label1") },  // $r("app.string.animator_temp_label1")需要替换为开发者所需的资源文件
      { name: 'template2/Index', label: $r("app.string.animator_temp_label2") },  // $r("app.string.animator_temp_label2")需要替换为开发者所需的资源文件
      { name: 'template3/Index', label: $r("app.string.animator_temp_label3") }   // $r("app.string.animator_temp_label3")需要替换为开发者所需的资源文件
    ]
  }, {
    name: "animateToImmediately",
    label: $r("app.string.animateToImmediately_label"),  // $r("app.string.animateToImmediately_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.temp1") }  // $r("app.string.temp1")需要替换为开发者所需的资源文件
    ]
  }, {
    name: "rotation",
    label: $r("app.string.rotation_label"),  // $r("app.string.rotation_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.rotation_temp_label1") },  // $r("app.string.rotation_temp_label1")需要替换为开发者所需的资源文件
      { name: 'template2/Index', label: $r("app.string.rotation_temp_label2") }  // $r("app.string.rotation_temp_label2")需要替换为开发者所需的资源文件
    ]
  }, {
    name: "component",
    label: $r("app.string.component_label"),  // $r("app.string.component_label")需要替换为开发者所需的资源文件
    children:[
      { name: 'template1/Index', label: $r("app.string.component_temp_label1") },  // $r("app.string.component_temp_label1")需要替换为开发者所需的资源文件
      { name: 'template2/Index', label: $r("app.string.component_temp_label2") },  // $r("app.string.component_temp_label2")需要替换为开发者所需的资源文件
    ]
  }
  ];
  @State selection: string | null = null;

  @Builder
  ListItemGroupHeader(route: RouteGroup) {
    Row() {
      Text(route.label)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))  // $r("app.string.ohos_id_color_text_primary")需要替换为开发者所需的资源文件
        .fontWeight(FontWeight.Medium)

      Blank()

      Text(`${route.children.length}`)  // ${route.children.length}需要替换为开发者所需的资源文件
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))  // $r('sys.color.ohos_id_color_text_secondary')需要替换为开发者所需的资源文件
        .opacity(this.selection === route.name ? 0 : 1)

      Image($r('sys.media.ohos_ic_public_arrow_right'))  // $r('sys.media.ohos_ic_public_arrow_right')需要替换为开发者所需的资源文件
        .fillColor($r('sys.color.ohos_id_color_fourth'))  // $r('sys.color.ohos_id_color_fourth')需要替换为开发者所需的资源文件
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
      Text("AnimateIndex")
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
                    Image($r('sys.media.ohos_ic_public_arrow_right'))  // $r('sys.media.ohos_ic_public_arrow_right')需要替换为开发者所需的资源文件
                      .fillColor($r('sys.color.ohos_id_color_fourth'))  // $r('sys.color.ohos_id_color_fourth')需要替换为开发者所需的资源文件
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
                    // router.pushUrl({url: name})
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