'use static';
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
import { ArticleNode } from './ArticleNode';

export const ARTICLE_DATA: ArticleNode[] = [
  {
    type: 1,
    title: '应用开发性能优化入门引导',
    url: 'README.md',
  },
  {
    type: 1,
    title: '性能优化实操宝典',
    url: 'performance-optimization-practical-guidance.md',
  },
  {
    type: 2,
    title: 'ArkTS高性能编程',
    children: [
      {
        type: 1,
        title: '高性能编程规范',
        url: 'high-performance-programming.md'
      },
      {
        type: 1,
        title: '高效并发编程',
        url: 'efficient-concurrent-programming.md'
      },
      {
        type: 1,
        title: 'N-API高效开发指导',
        url: 'develop-Native-modules-using-NAPI-safely-and-efficiently.md'
      },
      {
        type: 1,
        title: '多线程能力场景化',
        url: 'multi_thread_capability.md'
      },
      {
        type: 1,
        title: '利用native的方式实现跨线程调用',
        url: 'native-threads-call-js.md'
      },
      {
        type: 1,
        title: '避免开发过程中的冗余操作',
        url: 'avoiding-redundant-operations.md'
      }
    ]
  },
  {
    type: 2,
    title: '减少卡顿丢帧',
    children: [
      {
        type: 1,
        title: '正确使用LazyForEach优化',
        url: 'lazyforeach_optimization.md'
      },
      {
        type: 1,
        title: '组件复用使用指导',
        url: 'component-recycle.md'
      },
      {
        type: 1,
        title: '组件复用四板斧',
        url: 'component_recycle_case.md'
      },
      {
        type: 1,
        title: '组件复用总览',
        url: 'component-reuse-overview.md'
      },
      {
        type: 1,
        title: 'WaterFlow高性能开发指导',
        url: 'waterflow_optimization.md'
      },
      {
        type: 1,
        title: 'Swiper高性能开发指导',
        url: 'swiper_optimization.md'
      },
      {
        type: 1,
        title: '合理进行状态管理',
        url: 'proper_state_management.md'
      },
      {
        type: 1,
        title: '精准控制组件的更新范围',
        url: 'precisely-control-render-scope.md'
      },
      {
        type: 1,
        title: '合理使用renderGroup',
        url: 'reasonable-using-renderGroup.md'
      },
      {
        type: 1,
        title: '合理使用多线程共享内存',
        url: 'thread_memory_shared.md'
      },
      {
        type: 1,
        title: 'Grid高性能开发指导',
        url: 'grid_optimization.md'
      },
      {
        type: 1,
        title: '状态管理优秀实践',
        url: 'arkts-state-management-best-practices.md'
      },
      {
        type: 1,
        title: '合理使用renderGroup',
        url: 'reasonable-using-renderGroup.md'
      },
      {
        type: 1,
        title: '合理处理高负载组件的渲染',
        url: 'reasonably-dispose-highly-loaded-component-render.md'
      },
      {
        type: 1,
        title: '合理使用自定义组件冻结功能',
        url: 'custom_component_freeze.md'
      },
      {
        type: 1,
        title: '避免在滑动场景的高频回调接口中处理耗时操作',
        url: 'avoid_high_frequency_callback_execute_lengthy_operation.md'
      },
      {
        type: 1,
        title: '合理使用renderGroup',
        url: 'reasonable-using-renderGroup.md'
      },
      {
        type: 1,
        title: '避免在主线程中执行耗时操作',
        url: 'avoid_time_consuming_operations_in_mainthread.md'
      },
      {
        type: 1,
        title: '避免在主线程中执行耗时操作',
        url: 'avoid_time_consuming_operations_in_mainthread.md'
      },
      {
        type: 1,
        title: '合理使用系统接口',
        url: 'reasonable_using_system_interfaces.md'
      }
    ]
  },
  {
    type: 2,
    title: '提升应用启动和响应速度',
    children: [
      {
        type: 1,
        title: '提升应用冷启动速度',
        url: 'improve-application-cold-start-speed.md'
      },
      {
        type: 1,
        title: '提升应用响应速度',
        url: 'improve-application-response.md'
      },
      {
        type: 1,
        title: 'Flex布局性能提升使用指导',
        url: 'flex-development-performance-boost.md'
      },
      {
        type: 1,
        title: '优化布局性能',
        url: 'reduce-view-nesting-levels.md'
      },
      {
        type: 1,
        title: '合理选择条件渲染和显隐控制',
        url: 'proper-choice-between-if-and-visibility.md'
      },
      {
        type: 1,
        title: '合理使用IPC通信',
        url: 'reasonable-using-ipc.md'
      },
      {
        type: 1,
        title: '合理进行状态管理',
        url: 'reasonable-using-ipc.md'
      },
      {
        type: 1,
        title: '文件上传下载性能提升指导',
        url: 'improve-file-upload-and-download-performance.md'
      },
      {
        type: 1,
        title: '减少首帧绘制时的冗余操作',
        url: 'reduce-redundant-operations-when-render-first-frame.md'
      },
      {
        type: 1,
        title: '合理使用多线程共享内存',
        url: 'thread_memory_shared.md'
      },
      {
        type: 1,
        title: '动效能力实践',
        url: 'animation_practice.md'
      },
      {
        type: 1,
        title: '性能提升的其他方法',
        url: 'arkts-performance-improvement-recommendation.md'
      },
      {
        type: 1,
        title: '合理使用renderGroup',
        url: 'reasonable-using-renderGroup.md'
      },
      {
        type: 1,
        title: '运行时动态加载页面提升性能',
        url: 'performance-dynamic-import.md'
      },
      {
        type: 1,
        title: '合理运行后台任务',
        url: 'reasonable-running-backgroundTask.md'
      },
      {
        type: 1,
        title: 'Web组件开发性能提升指导',
        url: 'performance-web-import.md'
      },
      {
        type: 1,
        title: '使用同层渲染在Web上渲染原生组件',
        url: 'webview-render-app-components.md'
      },
      {
        type: 1,
        title: '全局自定义组件复用实现',
        url: 'node_custom_component_reusable_pool.md'
      }
    ]
  },
  {
    type: 2,
    title: '性能工具',
    children: [
      {
        type: 1,
        title: '性能分析工具CPU Profiler',
        url: 'application-performance-analysis.md'
      },
      {
        type: 1,
        title: '页面布局检查器ArkUI Inspector',
        url: 'arkUI-inspector.md'
      },
      {
        type: 1,
        title: '内存分析器Allocation Profiler',
        url: 'profiler-allocation.md'
      },
      {
        type: 1,
        title: '帧率分析工具 Frame Profiler',
        url: 'profiler-frame.md'
      },
      {
        type: 1,
        title: '启动分析工具Launch Profiler',
        url: 'profiler-launch.md'
      },
      {
        type: 1,
        title: '内存快照Snapshot Profiler',
        url: 'profiler-snapshot.md'
      },
      {
        type: 1,
        title: '耗时分析器Time Profiler',
        url: 'profiler-time.md'
      },
      {
        type: 1,
        title: '性能测试工具SmartPerf Editor',
        url: 'smartperf-editor.md'
      },
      {
        type: 1,
        title: '性能优化工具HiDumper',
        url: 'performance-optimization-using-hidumper.md'
      },
      {
        type: 1,
        title: '性能优化工具SmartPerf-Host',
        url: 'performance-optimization-using-smartperf-host.md'
      },
      {
        type: 1,
        title: '常用trace使用指导',
        url: 'common-trace-using-instructions.md'
      },
      {
        type: 1,
        title: '性能提升的其他方法',
        url: 'arkts-performance-improvement-recommendation.md'
      },
      {
        type: 1,
        title: '合理使用renderGroup',
        url: 'reasonable-using-renderGroup.md'
      },
      {
        type: 1,
        title: '状态变量组件定位工具实践',
        url:'state_variable_dfx_pratice.md'
      },
      {
        type: 1,
        title: '应用滑动场景帧率问题分析实践',
        url: 'long-frame-optimization.md'
      },
      {
        type: 1,
        title: 'Web性能问题分析案例',
        url: 'web-analyse.md'
      },
      {
        type: 1,
        title: '时延类性能问题分析实践',
        url: 'delay_related_performance.md'
      }
    ]
  }
]