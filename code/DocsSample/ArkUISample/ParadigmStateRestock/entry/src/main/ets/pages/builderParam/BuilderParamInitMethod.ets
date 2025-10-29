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
// [Start builder_param_init_method]
@Builder
function overBuilder() {
}

@Component
struct Child {
  @Builder
  doNothingBuilder() {
  }

  // 使用自定义组件的自定义构建函数初始化@BuilderParam装饰的方法
  @BuilderParam customBuilderParam: () => void = this.doNothingBuilder;
  // 使用全局自定义构建函数初始化@BuilderParam装饰的方法
  @BuilderParam customOverBuilderParam: () => void = overBuilder;

  build() {
  }
}
// [End builder_param_init_method]