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
 *
 **/
import { TreeNode } from './TreeNode';

export const ARTICLE_DATA1: TreeNode[] = [
  {
    expand: true,
    type: 1,
    title: '应用开发性能优化入门引导',
    url: 'README.md',
  },
  {
    expand: false,
    type: 1,
    title: '性能优化实操宝典',
    url: 'performance-optimization-practical-guidance.md',
  },
  {
    expand: false,
    type: 2,
    title: 'ArkTS高性能编程',
    children: [
      {
        expand: false,
        type: 1,
        title: '高性能编程规范',
        url: 'high-performance-programming.md'
      },
      {
        expand: false,
        type: 1,
        title: '高效并发编程',
        url: 'efficient-concurrent-programming.md'
      },
      {
        expand: false,
        type: 1,
        title: '避免开发过程中的冗余操作',
        url: 'avoiding-redundant-operations.md'
      }
    ]
  },
  {
    expand: false,
    type: 2,
    title: '减少卡顿丢帧',
    children: [
      {
        expand: false,
        type: 1,
        title: '正确使用LazyForEach优化',
        url: 'lazyforeach_optimization.md'
      },
      {
        expand: false,
        type: 1,
        title: '组件复用使用指导',
        url: 'component-recycle.md'
      }
    ]
  },
  {
    expand: false,
    type: 2,
    title: '提升应用启动和响应速度',
    children: [
      {
        expand: false,
        type: 1,
        title: '提升应用冷启动速度',
        url: 'improve-application-cold-start-speed.md'
      },
      {
        expand: false,
        type: 1,
        title: '提升应用响应速度',
        url: 'improve-application-response.md'
      },
      {
        expand: false,
        type: 1,
        title: 'Flex布局性能提升使用指导',
        url: 'flex-development-performance-boost.md'
      }
    ]
  },
  {
    expand: false,
    type: 2,
    title: '性能工具',
    children: [
      {
        expand: false,
        type: 1,
        title: '性能分析工具CPU Profiler',
        url: 'application-performance-analysis.md'
      },
      {
        expand: false,
        type: 1,
        title: '页面布局检查器ArkUI Inspector',
        url: 'arkUI-inspector.md'
      },
      {
        expand: false,
        type: 1,
        title: '内存分析器Allocation Profiler',
        url: 'profiler-allocation.md'
      },
      {
        expand: false,
        type: 1,
        title: '性能测试工具SmartPerf Editor',
        url: 'smartperf-editor.md'
      }
    ]
  }

]