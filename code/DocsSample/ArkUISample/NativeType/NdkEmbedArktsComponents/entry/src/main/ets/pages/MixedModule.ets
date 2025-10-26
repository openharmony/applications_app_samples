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
// [Start mixed_module]

// 使用ComponentContent能力创建ArkTS组件

import { NodeContent, UIContext, RefreshModifier, ComponentContent } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

// 定义Native侧和ArkTS进行交互的数据对象。
interface NativeRefreshAttribute {
  isRefreshing: boolean;
  width?: number;
  height?: number;
  backgroundColor?: number;
  refreshOffset?: number;
  pullToRefresh?: boolean;
  onRefreshing?: () => void;
  onOffsetChange?: (offset: number) => void;
}

// 定义@Builder函数的入参格式。
interface RefreshAttribute {
  isRefreshing: boolean;
  // 属性设置通过Modifier优化性能
  modifier?: RefreshModifier;
  slot?: NodeContent;
  onRefreshing?: () => void;
  onOffsetChange?: (offset: number) => void;
}

// ComponentContent封装ArkTS组件依赖全局@Builder函数，涉及复杂自定义组件场景，可以在@Builder函数中嵌套@Component自定义组件。
// @Builder函数提供入参方式，方便后续通过ComponentContent的update接口进行参数更新。
@Builder
function mixedRefresh(attribute: RefreshAttribute) {
  Refresh({ refreshing: attribute.isRefreshing }) {
    // Refresh作为容器组件，需要使用ContentSlot机制预留子组件占位
    ContentSlot(attribute.slot);
  }.attributeModifier(attribute.modifier)
  .onRefreshing(() => {
    hilog.info(DOMAIN, 'testTag', 'on onRefreshing');
    if (attribute.onRefreshing) {
      hilog.info(DOMAIN, 'testTag', 'on native onRefreshing');
      attribute.onRefreshing();
    }
  })
  .onOffsetChange((value: number) => {
    hilog.info(DOMAIN, 'testTag', 'on offset change: ' + value);
    if (attribute.onOffsetChange) {
      hilog.info(DOMAIN, 'testTag', 'on native onOffsetChange');
      attribute.onOffsetChange(value);
    }
  });
}

// 定义创建函数的返回值，用于ArkTS侧和Native侧的交互。
interface MixedModuleResult {
  // 定义针对Refresh构建函数的封装对象，用于Native侧转化为ArkUI_NodeHandle对象。
  content?: ComponentContent<RefreshAttribute>;
  // Refresh作为容器组件，需要使用ContentSlot机制挂载Native侧的子组件。
  childSlot?: NodeContent;
}

// 提供创建ArkTS组件的入口函数。
export function createMixedRefresh(value: NativeRefreshAttribute): MixedModuleResult {
  hilog.info(DOMAIN, 'testTag', 'createMixedRefresh');
  // 通过AppStorage对象在Ability启动的时候保持UI上下文对象。
  let uiContent = AppStorage.get<UIContext>('context');
  let modifier = new RefreshModifier();
  if (value.width) {
    modifier.width(value.width);
  }
  if (value.height) {
    modifier.height(value.height);
  }
  if (value.backgroundColor) {
    modifier.backgroundColor(value.backgroundColor);
  }
  if (value.pullToRefresh) {
    modifier.pullToRefresh(value.pullToRefresh);
  }
  if (value.refreshOffset) {
    modifier.refreshOffset(value.refreshOffset);
  }
  // 创建NodeContent插槽对象用于Refresh子组件挂载。
  let nodeSlot = new NodeContent();
  // 通过ComponentContent创建Refresh组件并将它封装起来。
  let content = new ComponentContent<RefreshAttribute>(uiContent!, wrapBuilder<[RefreshAttribute]>(mixedRefresh),
    {
      isRefreshing: value.isRefreshing,
      modifier: modifier,
      slot: nodeSlot,
      onRefreshing: value.onRefreshing,
      onOffsetChange: value.onOffsetChange
    });
  // 将Refresh组件的封装对象及其子组件插槽对象传递给Native侧。
  return { content: content, childSlot: nodeSlot };
}

// 定义Refresh组件的更新函数，用于Native侧更新。
// 在更新场景下，需要将Refresh组件的封装对象及其子组件插槽对象返回，防止组件重新创建。
export function updateMixedRefresh(refresh: ComponentContent<RefreshAttribute>, childSlot: NodeContent,
  value: NativeRefreshAttribute): void {
  let modifier = new RefreshModifier();
  if (value.width) {
    modifier.width(value.width);
  }
  if (value.height) {
    modifier.height(value.height);
  }
  if (value.backgroundColor) {
    modifier.backgroundColor(value.backgroundColor);
  }
  if (value.pullToRefresh) {
    modifier.pullToRefresh(value.pullToRefresh);
  }
  if (value.refreshOffset) {
    modifier.refreshOffset(value.refreshOffset);
  }
  // 调用ComponentContent的update接口进行更新。
  refresh.update({
    isRefreshing: value.isRefreshing,
    modifier: modifier,
    slot: childSlot,
    onRefreshing: value.onRefreshing,
    onOffsetChange: value.onOffsetChange
  });
}

// [End mixed_module]