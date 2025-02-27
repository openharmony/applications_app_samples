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

/**
 * 通过实现AttributeModifier接口，自定义属性修改器
 * 将拖拽排序相关样式封装成属性修改器，可以方便移植
 */
export class ListItemModifier implements AttributeModifier<ListItemAttribute> {
  // 阴影
  public hasShadow: boolean = false;
  // 缩放
  public scale: number = 1;
  // 纵轴偏移量
  public offsetY: number = 0;
  // 横轴偏移量
  public offsetX: number = 0;
  // 透明度
  public opacity: number = 1;
  // 是否被删除
  public isDeleted: boolean = false;
  public static instance: ListItemModifier | null = null;

  public static getInstance(): ListItemModifier {
    if (!ListItemModifier.instance) {
      ListItemModifier.instance = new ListItemModifier();
    }
    return ListItemModifier.instance;
  }

  /**
   * 定义组件普通状态时的样式
   * @param instance: ListItem属性
   */
  applyNormalAttribute(instance: ListItemAttribute): void {
    if (this.hasShadow) {
      instance.shadow({ radius: $r('app.integer.list_exchange_shadow_radius'), color: $r('app.color.list_exchange_box_shadow') });
      instance.zIndex(1);
      instance.opacity(0.5);
    } else {
      instance.opacity(this.opacity);
    }
    instance.translate({ x: this.offsetX, y: this.offsetY });
    instance.scale({ x: this.scale, y: this.scale });
  }
}