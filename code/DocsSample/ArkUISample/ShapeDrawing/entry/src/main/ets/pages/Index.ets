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

interface Ary {
  path:string,
  name:string
}
@Entry
@Component
struct Index {
  ary:Ary[]=[
    {
      name:'AntiAlias',
      path:'pages/AntiAlias'
    },
    {
      name:'CircleExample',
      path:'pages/CircleExample'
    },
    {
      name:'Fill',
      path:'pages/Fill'
    },
    {
      name:'Mesh',
      path:'pages/Mesh'
    },
    {
      name:'Shape',
      path:'pages/Shape'
    },
    {
      name:'ShapeExample',
      path:'pages/ShapeExample'
    },
    {
      name:'Stroke',
      path:'pages/Stroke'
    },
    {
      name:'StrokeLineJoin',
      path:'pages/StrokeLineJoin'
    },
    {
      name:'StrokeMiterLimit',
      path:'pages/StrokeMiterLimit'
    },
    {
      name:'StrokeOpacity',
      path:'pages/StrokeOpacity'
    },
    {
      name:'ViewPort1',
      path:'pages/ViewPort1'
    },
    {
      name:'ViewPort2',
      path:'pages/ViewPort2'
    },
    {
      name:'ViewPort3',
      path:'pages/ViewPort3'
    },
  ]
  build() {
    Scroll() {
      Column({ space: 10 }) {
        ForEach(this.ary,(item:Ary)=>{
          Button(item.name)
            .onClick(() => this.getUIContext().getRouter().pushUrl({ url: item.path }))
        },(item:Ary)=>item.name)
      }
      .width('100%')
    }
  }
}
