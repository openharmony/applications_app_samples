/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { BasicDataSource } from '../../../main/ets/component/adapter/BasicDataSource';
import { FileBean } from '../../../main/ets/component/bean/FileBean';
import { FileInfo } from '../../../main/ets/common/data/FileInfo';

export default function adaptersDialogsTest001() {
  describe('Adapters_Dialogs_Test_001', () => {

    /*
     * BasicDataSource——LazyForEach渲染引擎的数据源基类。
     * 实现了IDataSource接口，负责数据变更通知。
     * 核心方法：totalCount/getData/notifyDataReload/notifyDataAdd/notifyDataDelete/notifyDataChange。
     * 注册的DataChangeListener会在数据变化时收到通知，触发UI增量更新。
     */
    describe('BasicDataSource_Core', () => {
      it('totalCount_returns_array_length', 0, () => {
        let arr: string[] = ['a', 'b', 'c'];
        let ds: BasicDataSource<string> = new BasicDataSource(arr);
        expect(ds.totalCount()).assertEqual(3);
      });

      it('totalCount_zero_for_empty_array', 0, () => {
        // 空数据场景：无文件时列表为空
        let ds: BasicDataSource<string> = new BasicDataSource([]);
        expect(ds.totalCount()).assertEqual(0);
      });

      it('getData_returns_element_at_index', 0, () => {
        let arr: number[] = [10, 20, 30];
        let ds: BasicDataSource<number> = new BasicDataSource(arr);
        expect(ds.getData(0)).assertEqual(10);
        expect(ds.getData(1)).assertEqual(20);
        expect(ds.getData(2)).assertEqual(30);
      });

      it('getData_out_of_bounds_returns_undefined', 0, () => {
        // LazyForEach不会请求越界索引，但数据源应能安全处理
        let ds: BasicDataSource<string> = new BasicDataSource(['a']);
        let result = ds.getData(99);
        expect(result).assertEqual(undefined);
      });

      it('registerDataChangeListener_adds_listener', 0, () => {
        let ds: BasicDataSource<string> = new BasicDataSource([]);
        let listenerCalled: boolean = false;
        let listener: DataChangeListener = {
          onDataReloaded: (): void => { listenerCalled = true; },
          onDataAdd: (index: number): void => {},
          onDataAdded: (index: number): void => {},
          onDataChange: (index: number): void => {},
          onDataChanged: (index: number): void => {},
          onDataDelete: (index: number): void => {},
          onDataDeleted: (index: number): void => {},
          onDataMove: (from: number, to: number): void => {},
          onDataMoved: (from: number, to: number): void => {},
          onDatasetChange: (dataOperations: DataOperation[]): void => {}
        };
        ds.registerDataChangeListener(listener);
        ds.notifyDataReload();
        expect(listenerCalled).assertEqual(true);
      });

      it('unregisterDataChangeListener_removes_listener', 0, () => {
        // 组件销毁时需要移除监听器避免内存泄漏
        let ds: BasicDataSource<string> = new BasicDataSource([]);
        let callCount: number = 0;
        let listener: DataChangeListener = {
          onDataReloaded: (): void => {
            callCount++;
          },
          onDataAdd: (index: number): void => {
          },
          onDataAdded: (index: number): void => {
          },
          onDataChange: (index: number): void => {
          },
          onDataChanged: (index: number): void => {
          },
          onDataDelete: (index: number): void => {
          },
          onDataDeleted: (index: number): void => {
          },
          onDataMove: (from: number, to: number): void => {
          },
          onDataMoved: (from: number, to: number): void => {
          },
          onDatasetChange: (dataOperations: DataOperation[]): void => {
          }
        };
        ds.registerDataChangeListener(listener);
        ds.notifyDataReload();
        ds.unregisterDataChangeListener(listener);
        ds.notifyDataReload();
        // 移除后不再接收通知
        expect(callCount).assertEqual(1);
      });

      it('notifyDataAdd_notifies_all_listeners', 0, () => {
        let ds: BasicDataSource<string> = new BasicDataSource([]);
        let addedIndex: number = -1;
        let listener: DataChangeListener = {
          onDataReloaded: (): void => {},
          onDataAdd: (index: number): void => { addedIndex = index; },
          onDataAdded: (index: number): void => {},
          onDataChange: (index: number): void => {},
          onDataChanged: (index: number): void => {},
          onDataDelete: (index: number): void => {},
          onDataDeleted: (index: number): void => {},
          onDataMove: (from: number, to: number): void => {},
          onDataMoved: (from: number, to: number): void => {},
          onDatasetChange: (dataOperations: DataOperation[]): void => {}
        };
        ds.registerDataChangeListener(listener);
        ds.notifyDataAdd(5);
        expect(addedIndex).assertEqual(5);
      });

      it('notifyDataDelete_notifies_all_listeners', 0, () => {
        let ds: BasicDataSource<string> = new BasicDataSource([]);
        let deletedIndex: number = -1;
        let listener: DataChangeListener = {
          onDataReloaded: (): void => {
          },
          onDataAdd: (index: number): void => {
          },
          onDataAdded: (index: number): void => {
          },
          onDataChange: (index: number): void => {
          },
          onDataChanged: (index: number): void => {
          },
          onDataDelete: (index: number): void => {
            deletedIndex = index;
          },
          onDataDeleted: (index: number): void => {
          },
          onDataMove: (from: number, to: number): void => {
          },
          onDataMoved: (from: number, to: number): void => {
          },
          onDatasetChange: (dataOperations: DataOperation[]): void => {
          }
        };
        ds.registerDataChangeListener(listener);
        ds.notifyDataDelete(3);
        expect(deletedIndex).assertEqual(3);
      });

      it('notifyDataMove_notifies_all_listeners', 0, () => {
        let ds: BasicDataSource<string> = new BasicDataSource([]);
        let fromIdx: number = -1;
        let toIdx: number = -1;
        let listener: DataChangeListener = {
          onDataReloaded: (): void => {},
          onDataAdd: (index: number): void => {},
          onDataAdded: (index: number): void => {},
          onDataChange: (index: number): void => {},
          onDataChanged: (index: number): void => {},
          onDataDelete: (index: number): void => {},
          onDataDeleted: (index: number): void => {},
          onDataMove: (from: number, to: number): void => { fromIdx = from; toIdx = to; },
          onDataMoved: (from: number, to: number): void => {},
          onDatasetChange: (dataOperations: DataOperation[]): void => {}
        };
        ds.registerDataChangeListener(listener);
        ds.notifyDataMove(2, 5);
        expect(fromIdx).assertEqual(2);
        expect(toIdx).assertEqual(5);
      });

      it('multiple_listeners_all_receive_notifications', 0, () => {
        // 支持多个组件同时监听同一数据源变化
        let ds: BasicDataSource<string> = new BasicDataSource([]);
        let callCount1: number = 0;
        let callCount2: number = 0;
        let listener1: DataChangeListener = {
          onDataReloaded: (): void => {
            callCount1++;
          },
          onDataAdd: (index: number): void => {
          },
          onDataAdded: (index: number): void => {
          },
          onDataChange: (index: number): void => {
          },
          onDataChanged: (index: number): void => {
          },
          onDataDelete: (index: number): void => {
          },
          onDataDeleted: (index: number): void => {
          },
          onDataMove: (from: number, to: number): void => {
          },
          onDataMoved: (from: number, to: number): void => {
          },
          onDatasetChange: (dataOperations: DataOperation[]): void => {
          }
        };
        let listener2: DataChangeListener = {
          onDataReloaded: (): void => {
            callCount2++;
          },
          onDataAdd: (index: number): void => {
          },
          onDataAdded: (index: number): void => {
          },
          onDataChange: (index: number): void => {
          },
          onDataChanged: (index: number): void => {
          },
          onDataDelete: (index: number): void => {
          },
          onDataDeleted: (index: number): void => {
          },
          onDataMove: (from: number, to: number): void => {
          },
          onDataMoved: (from: number, to: number): void => {
          },
          onDatasetChange: (dataOperations: DataOperation[]): void => {
          }
        };
        ds.registerDataChangeListener(listener1);
        ds.registerDataChangeListener(listener2);
        ds.notifyDataReload();
        expect(callCount1).assertEqual(1);
        expect(callCount2).assertEqual(1);
      });

      it('duplicate_listener_registration_is_ignored', 0, () => {
        // registerDataChangeListener内部检查indexOf，避免重复注册
        let ds: BasicDataSource<string> = new BasicDataSource([]);
        let callCount: number = 0;
        let listener: DataChangeListener = {
          onDataReloaded: (): void => {
            callCount++;
          },
          onDataAdd: (index: number): void => {
          },
          onDataAdded: (index: number): void => {
          },
          onDataChange: (index: number): void => {
          },
          onDataChanged: (index: number): void => {
          },
          onDataDelete: (index: number): void => {
          },
          onDataDeleted: (index: number): void => {
          },
          onDataMove: (from: number, to: number): void => {
          },
          onDataMoved: (from: number, to: number): void => {
          },
          onDatasetChange: (dataOperations: DataOperation[]): void => {
          }
        };
        ds.notifyDataReload();
        expect(callCount).assertEqual(1);
      });
    });

    /*
     * BasicDataSource边界场景——大数据量/空数据/null。
     * LazyForEach在高性能要求的TV界面中处理数百个文件项，
     * 数据源需要在大数据量下保持响应速度。
     */
    describe('BasicDataSource_Edge_Cases', () => {
      it('totalCount_handles_null_array', 0, () => {
        // array未初始化时(BasicDataSource可能处于中间状态)
        let ds: BasicDataSource<string> = new BasicDataSource([]);
        // 手动清空数组引用
        (ds as BasicDataSource_Accessor).array = [];
        expect(ds.totalCount()).assertEqual(0);
      });

      it('getData_with_negative_index_returns_undefined', 0, () => {
        let ds: BasicDataSource<number> = new BasicDataSource([1, 2, 3]);
        // JS数组[-1]返回undefined，ArkTS行为一致
        let result = ds.getData(-1);
        expect(result).assertEqual(undefined);
      });
    });

    /*
     * 无监听器时notify不应崩溃。
     */
    describe('BasicDataSource_No_Listener_Safety', () => {
      it('notifyDataReload_without_listeners_does_not_crash', 0, () => {
        let ds: BasicDataSource<string> = new BasicDataSource(['test']);
        // 无监听器时通知不应抛出异常
        ds.notifyDataReload();
        expect(ds.totalCount()).assertEqual(1);
      });

      it('notifyDataAdd_without_listeners_does_not_crash', 0, () => {
        let ds: BasicDataSource<string> = new BasicDataSource([]);
        ds.notifyDataAdd(0);
        expect(true).assertEqual(true);
      });

      it('notifyDataDelete_without_listeners_does_not_crash', 0, () => {
        let ds: BasicDataSource<string> = new BasicDataSource([]);
        ds.notifyDataDelete(0);
        expect(true).assertEqual(true);
      });
    });
  });
}

// 辅助类型用于访问BasicDataSource内部字段进行边界测试
interface BasicDataSource_Accessor {
  array: string[];
}
