/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { CommonItemTwoRowSlider, CommonItemSelect, CommonItemColorSelectDef } from '../../../../common/AttributeModificationTool';
import { WATER_FLOW_SCROLL_EDGE_SELECT_DATA, LIST_SCROLLBAR_SELECT_DATA,WATER_FLOW_EDGE_EFFECT_SELECT_DATA, LIST_ALIGN_LIST_ITEM_SELECT_DATA } from '../../ComponentData';
import { getStringArrayData } from '../../../../data/ResourceDataHandle';

@Component
export struct WaterFlowScrollByControlPanel {
  @Link scrollBy : number;
  build() {
    Column() {
      CommonItemTwoRowSlider(
        {
          changeValue: $scrollBy,
          min: -200,
          max: 200,
          name: $r('app.string.water_flow_controller_scrollBy'),
          testId: `waterFlow_001`
        }
      )
    }
    .backgroundColor(Color.White)
    .height(96)
    .margin({bottom:12})
    .padding({left:12,right:12, top:17, bottom:17})
    .borderRadius(16)
  }
}

@Component
export struct WaterFlowScrollEdgeControlPanel {
  @Link scrollEdge : Edge;

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.water_flow_controller_scrollEdge'),
        selects : getStringArrayData(WATER_FLOW_SCROLL_EDGE_SELECT_DATA),
        callback : (index)=>{
          switch (index) {
            case 0:
              this.scrollEdge = Edge.Top;
              break;
            default:
              this.scrollEdge = Edge.Bottom;
              break;
          }
        },
        testId: `waterFlow_002`
      })
    }.height(56)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .padding({left:12,right:12})
    .margin({bottom:12})
  }
}

@Component
export struct WaterFlowPropertiesControlPanel {
  @Link scrollBar : BarState;
  @Link scrollBarColor : Color;
  @Link scrollBarWidth : number;
  @Link edgeEffect : EdgeEffect;

  build(){
    Column(){

      CommonItemSelect({
        name: $r('app.string.water_flow_properties_scroll_bar'),
        selects : getStringArrayData(LIST_SCROLLBAR_SELECT_DATA),
        callback : (index)=>{
          switch (index) {
            case 1:
              this.scrollBar = BarState.On
              break;
            case 2:
              this.scrollBar = BarState.Auto
              break;
            default:
              this.scrollBar = BarState.Off
              break;
          }
        },
        testId: `waterFlow_003`
      })

      CommonItemColorSelectDef({
        name: $r('app.string.water_flow_properties_scroll_bar_color'),
        selectColor: $scrollBarColor,
        testId: 'waterFlow_004'
      })

      CommonItemTwoRowSlider({
        changeValue: $scrollBarWidth,
        min: 0,
        max: 15,
        name: $r('app.string.water_flow_properties_scroll_bar_width'),
        testId: `waterFlow_005`
      })

      CommonItemSelect({
        name: $r('app.string.water_flow_properties_edge_effect'),
        selects : getStringArrayData(WATER_FLOW_EDGE_EFFECT_SELECT_DATA),
        callback : (index)=>{
          switch (index) {
            case 0:
              this.edgeEffect = EdgeEffect.Spring;
              break;
            case 1:
              this.edgeEffect = EdgeEffect.Fade;
              break;
            default:
              this.edgeEffect = EdgeEffect.None;
              break;
          }
        },
        testId: `waterFlow_006`
      })
    }
  }
}

@Component
export struct WaterFlowPropertiesScrollBarControlPanel {
  @Link scrollBar : BarState;
  build(){
    Column(){
      CommonItemSelect({
        name: $r('app.string.water_flow_properties_scroll_bar'),
        selects : getStringArrayData(LIST_SCROLLBAR_SELECT_DATA),
        callback : (index)=>{
          switch (index) {
            case 1:
              this.scrollBar = BarState.On
              break;
            case 2:
              this.scrollBar = BarState.Auto
              break;
            default:
              this.scrollBar = BarState.Off
              break;
          }
        },
        testId: `waterFlow_003`
      })
    }
  }
}

@Component
export struct WaterFlowPropertiesScrollBarColorControlPanel {
  @Link scrollBarColor : Color;

  build(){
    Column(){
      CommonItemColorSelectDef({
        name: $r('app.string.water_flow_properties_scroll_bar_color'),
        selectColor: $scrollBarColor,
        testId: 'waterFlow_004'
      })
    }
  }
}

@Component
export struct WaterFlowPropertiesScrollBarWidthControlPanel {
  @Link scrollBarWidth : number;

  build(){
    Column(){
      CommonItemTwoRowSlider({
        changeValue: $scrollBarWidth,
        min: 0,
        max: 15,
        name: $r('app.string.water_flow_properties_scroll_bar_width'),
        testId: `waterFlow_005`
      })
    }
  }
}

@Component
export struct WaterFlowPropertiesEdgeEffectControlPanel {
  @Link edgeEffect : EdgeEffect;

  build(){
    Column(){
      CommonItemSelect({
        name: $r('app.string.water_flow_properties_edge_effect'),
        selects : getStringArrayData(WATER_FLOW_EDGE_EFFECT_SELECT_DATA),
        callback : (index)=>{
          switch (index) {
            case 0:
              this.edgeEffect = EdgeEffect.Spring;
              break;
            case 1:
              this.edgeEffect = EdgeEffect.Fade;
              break;
            default:
              this.edgeEffect = EdgeEffect.None;
              break;
          }
        },
        testId: `waterFlow_006`
      })
    }
  }
}

// 实现IDataSource接口的对象，用于瀑布流组件加载数据
export class WaterFlowDataSource implements IDataSource {
  private dataArray: number[] = []
  private listeners: DataChangeListener[] = []

  constructor() {
    for (let i = 0; i < 28; i++) {
      this.dataArray.push(i)
    }
  }

  // 获取索引对应的数据
  public getData(index: number): number {
    return this.dataArray[index]
  }

  // 通知控制器数据重新加载
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  // 通知控制器数据增加
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  // 通知控制器数据变化
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index)
    })
  }

  // 通知控制器数据删除
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }

  // 通知控制器数据位置变化
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to)
    })
  }

  // 获取数据总数
  public totalCount(): number {
    return this.dataArray.length
  }

  // 注册改变数据的控制器
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  // 注销改变数据的控制器
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  // 增加数据
  public add1stItem(): void {
    this.dataArray.splice(0, 0, this.dataArray.length)
    this.notifyDataAdd(0)
  }

  // 在数据尾部增加一个元素
  public addLastItem(): void {
    this.dataArray.splice(this.dataArray.length, 0, this.dataArray.length)
    this.notifyDataAdd(this.dataArray.length - 1)
  }

  // 在指定索引位置增加一个元素
  public addItem(index: number): void {
    this.dataArray.splice(index, 0, this.dataArray.length)
    this.notifyDataAdd(index)
  }

  // 删除第一个元素
  public delete1stItem(): void {
    this.dataArray.splice(0, 1)
    this.notifyDataDelete(0)
  }

  // 删除第二个元素
  public delete2ndItem(): void {
    this.dataArray.splice(1, 1)
    this.notifyDataDelete(1)
  }

  // 删除最后一个元素
  public deleteLastItem(): void {
    this.dataArray.splice(-1, 1)
    this.notifyDataDelete(this.dataArray.length)
  }

  // 重新加载数据
  public reload(): void {
    this.dataArray.splice(1, 1)
    this.dataArray.splice(3, 2)
    this.notifyDataReload()
  }
}