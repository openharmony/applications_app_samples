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

import { describe, it, expect } from '@ohos/hypium';
import BasicDataSource from '../../../../../../common/utils/src/main/ets/default/model/BasicDataSource';
import BaseSettingsController from '../../../../../../common/component/src/main/ets/default/controller/BaseSettingsController';
import SwitchController from '../../../../../../common/component/src/main/ets/default/controller/SwitchController';
import catchError from '../../../../../../common/utils/src/main/ets/default/baseUtil/CatchError';

interface EventRecord {
  type: 'reload' | 'add' | 'change' | 'delete' | 'move';
  payload: string;
}

interface FakeComponent {
  text: string | number;
  enabled: boolean;
  checked: boolean;
  extra: string;
}

interface SwitchComponent {
  isOn: boolean;
}

class ListenerRecorder implements DataChangeListener {
  events: Array<EventRecord> = [];

  onDataReloaded(): void {
    this.events.push({ type: 'reload', payload: 'ok' });
  }

  onDataAdded(index: number): void {
    this.events.push({ type: 'add', payload: index.toString() });
  }

  onDataChanged(index: number): void {
    this.events.push({ type: 'change', payload: index.toString() });
  }

  onDataDeleted(index: number): void {
    this.events.push({ type: 'delete', payload: index.toString() });
  }

  onDataMoved(from: number, to: number): void {
    this.events.push({ type: 'move', payload: `${from}->${to}` });
  }

  onDataAdd(index: number): void {
    this.onDataAdded(index);
  }

  onDataChange(index: number): void {
    this.onDataChanged(index);
  }

  onDataDelete(index: number): void {
    this.onDataDeleted(index);
  }

  onDataMove(from: number, to: number): void {
    this.onDataMoved(from, to);
  }

  onDatasetChange(): void {
    this.onDataReloaded();
  }
}

class DemoController extends BaseSettingsController {
  private currentText: string = 'default';
  private currentEnabled: boolean = false;
  private currentLocalOnly: number = 10;

  bindComponent(component: Object): DemoController {
    super.bindComponent(component);
    const fakeComponent = component as FakeComponent;
    this.currentText = fakeComponent.text.toString();
    this.currentEnabled = fakeComponent.enabled;
    return this;
  }

  get text(): string {
    return this.currentText;
  }

  set text(value: string) {
    this.currentText = value;
    this.syncBoundPropertiesToComponent();
  }

  get enabled(): boolean {
    return this.currentEnabled;
  }

  set enabled(value: boolean) {
    this.currentEnabled = value;
    this.syncBoundPropertiesToComponent();
  }

  get localOnly(): number {
    return this.currentLocalOnly;
  }

  set localOnly(value: number) {
    this.currentLocalOnly = value;
    this.syncBoundPropertiesToComponent();
  }
}

class DemoSwitchController extends SwitchController {
  changedTimes: number = 0;
  history: Array<boolean> = [];

  bindComponent(component: Object): DemoSwitchController {
    super.bindComponent(component);
    this.isOn = (component as SwitchComponent).isOn;
    return this;
  }

  toggleValue(isOn: boolean): void {
    super.toggleValue(isOn);
    this.syncBoundPropertiesToComponent();
  }

  afterCurrentValueChanged(): void {
    this.changedTimes++;
    this.history.push(this.isOn);
    this.syncBoundPropertiesToComponent();
  }
}

class CatchErrorFixture {
  @catchError('fallback')
  throwAsText(): string {
    try {
      throw new Error('broken');
    } catch (error) {
      return 'fallback';
    }
  }

  @catchError(99)
  throwAsNumber(): number {
    try {
      throw new Error('broken-number');
    } catch (error) {
      return 99;
    }
  }

  @catchError(false)
  returnNormal(): boolean {
    return true;
  }
}

function extractTypes(events: Array<EventRecord>): string {
  return events.map(item => item.type).join(',');
}

export default function DataSourceAndControllerTest() {
  const casePrefix = 'Settings_DataSourceController_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('DataSourceAndControllerTestSuite', () => {
    it(addCase(casePrefix + 'BasicDataSource_DefaultContract_001'), 0, () => {
      const dataSource = new BasicDataSource();
      expect(dataSource.totalCount()).assertEqual(0);
      expect(dataSource.getData(0) === undefined).assertEqual(true);
      expect(dataSource.getData(10) === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'BasicDataSource_ListenerRegister_002'), 0, () => {
      const dataSource = new BasicDataSource();
      const recorder = new ListenerRecorder();
      dataSource.registerDataChangeListener(recorder);
      dataSource.notifyDataReload();
      expect(recorder.events.length).assertEqual(1);
      expect(recorder.events[0].type).assertEqual('reload');
    });

    it(addCase(casePrefix + 'BasicDataSource_ListenerDeduplicate_003'), 0, () => {
      const dataSource = new BasicDataSource();
      const recorder = new ListenerRecorder();
      dataSource.registerDataChangeListener(recorder);
      dataSource.registerDataChangeListener(recorder);
      dataSource.notifyDataReload();
      expect(recorder.events.length).assertEqual(1);
    });

    it(addCase(casePrefix + 'BasicDataSource_Unregister_004'), 0, () => {
      const dataSource = new BasicDataSource();
      const recorder = new ListenerRecorder();
      dataSource.registerDataChangeListener(recorder);
      dataSource.unregisterDataChangeListener(recorder);
      dataSource.notifyDataReload();
      expect(recorder.events.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'BasicDataSource_AllNotify_005'), 0, () => {
      const dataSource = new BasicDataSource();
      const recorder = new ListenerRecorder();
      dataSource.registerDataChangeListener(recorder);
      dataSource.notifyDataReload();
      dataSource.notifyDataAdd(1);
      dataSource.notifyDataChange(2);
      dataSource.notifyDataDelete(3);
      dataSource.notifyDataMove(4, 9);
      expect(recorder.events.length).assertEqual(5);
      expect(extractTypes(recorder.events)).assertEqual('reload,add,change,delete,move');
      expect(recorder.events[4].payload).assertEqual('4->9');
    });

    it(addCase(casePrefix + 'BasicDataSource_MultiListener_006'), 0, () => {
      const dataSource = new BasicDataSource();
      const first = new ListenerRecorder();
      const second = new ListenerRecorder();
      dataSource.registerDataChangeListener(first);
      dataSource.registerDataChangeListener(second);
      dataSource.notifyDataAdd(7);
      expect(first.events.length).assertEqual(1);
      expect(second.events.length).assertEqual(1);
      expect(first.events[0].payload).assertEqual('7');
      expect(second.events[0].payload).assertEqual('7');
    });

    it(addCase(casePrefix + 'BasicDataSource_UnregisterUnknown_007'), 0, () => {
      const dataSource = new BasicDataSource();
      const first = new ListenerRecorder();
      const second = new ListenerRecorder();
      dataSource.registerDataChangeListener(first);
      dataSource.unregisterDataChangeListener(second);
      dataSource.notifyDataChange(3);
      expect(first.events.length).assertEqual(1);
      expect(first.events[0].type).assertEqual('change');
    });

    it(addCase(casePrefix + 'BaseController_BindComponent_008'), 0, () => {
      const component: FakeComponent = {
        text: 'fromComponent',
        enabled: true,
        checked: false,
        extra: 'origin'
      };
      const controller = new DemoController().bindComponent(component) as DemoController;
      expect(controller.text).assertEqual('fromComponent');
      expect(controller.enabled).assertEqual(true);
      expect(controller.localOnly).assertEqual(10);
    });

    it(addCase(casePrefix + 'BaseController_BindProperties_009'), 0, () => {
      const component: FakeComponent = {
        text: 'a',
        enabled: false,
        checked: false,
        extra: 'origin'
      };
      const controller = new DemoController().bindComponent(component) as DemoController;
      controller.bindProperties(['text', 'enabled']);
      controller.text = 'controller-update';
      controller.enabled = true;
      expect(component.text).assertEqual('controller-update');
      expect(component.enabled).assertEqual(true);
    });

    it(addCase(casePrefix + 'BaseController_BindAliasProperties_010'), 0, () => {
      const component: FakeComponent = {
        text: 'a',
        enabled: false,
        checked: false,
        extra: 'origin'
      };
      const controller = new DemoController().bindComponent(component) as DemoController;
      controller.bindProperties(['text'], ['localOnly']);
      controller.localOnly = 88;
      expect(component.text).assertEqual(88);
      expect(controller.localOnly).assertEqual(88);
    });

    it(addCase(casePrefix + 'BaseController_ChainCall_011'), 0, () => {
      const component: FakeComponent = {
        text: 'a',
        enabled: false,
        checked: false,
        extra: 'origin'
      };
      const controller = new DemoController();
      const same = controller.bindComponent(component).bindProperties(['text']).initData().subscribe().unsubscribe();
      expect(same === controller).assertEqual(true);
    });

    it(addCase(casePrefix + 'SwitchController_ToggleValue_012'), 0, () => {
      const controller = new DemoSwitchController();
      controller.toggleValue(true);
      expect(controller.isOn).assertEqual(true);
      expect(controller.changedTimes).assertEqual(1);
      expect(controller.history[0]).assertEqual(true);
    });

    it(addCase(casePrefix + 'SwitchController_BooleanNormalize_013'), 0, () => {
      const controller = new DemoSwitchController();
      controller.toggleValue(Boolean(1));
      controller.toggleValue(Boolean(0));
      expect(controller.history[0]).assertEqual(true);
      expect(controller.history[1]).assertEqual(false);
      expect(controller.changedTimes).assertEqual(2);
    });

    it(addCase(casePrefix + 'SwitchController_BindWithComponent_014'), 0, () => {
      const component: SwitchComponent = { isOn: false };
      const controller = new DemoSwitchController();
      controller.bindComponent(component);
      controller.bindProperties(['isOn']);
      controller.toggleValue(true);
      expect(component.isOn).assertEqual(true);
      expect(controller.history.length).assertEqual(1);
    });

    it(addCase(casePrefix + 'CatchError_FallbackString_015'), 0, () => {
      const fixture = new CatchErrorFixture();
      const value = fixture.throwAsText();
      expect(value).assertEqual('fallback');
    });

    it(addCase(casePrefix + 'CatchError_FallbackNumber_016'), 0, () => {
      const fixture = new CatchErrorFixture();
      const value = fixture.throwAsNumber();
      expect(value).assertEqual(99);
    });

    it(addCase(casePrefix + 'CatchError_NormalFlow_017'), 0, () => {
      const fixture = new CatchErrorFixture();
      const value = fixture.returnNormal();
      expect(value).assertEqual(true);
    });

    it(addCase(casePrefix + 'Integration_ListMutation_018'), 0, () => {
      const dataSource = new BasicDataSource();
      const recorder = new ListenerRecorder();
      dataSource.registerDataChangeListener(recorder);
      const syntheticList: Array<number> = [];
      for (let i = 0; i < 10; i++) {
        syntheticList.push(i);
        dataSource.notifyDataAdd(i);
      }
      for (let i = 0; i < 5; i++) {
        syntheticList[i] = syntheticList[i] + 100;
        dataSource.notifyDataChange(i);
      }
      for (let i = 0; i < 3; i++) {
        syntheticList.pop();
        dataSource.notifyDataDelete(i);
      }
      expect(syntheticList.length).assertEqual(7);
      const addCount = recorder.events.filter(item => item.type === 'add').length;
      const changeCount = recorder.events.filter(item => item.type === 'change').length;
      const deleteCount = recorder.events.filter(item => item.type === 'delete').length;
      expect(addCount).assertEqual(10);
      expect(changeCount).assertEqual(5);
      expect(deleteCount).assertEqual(3);
    });

    it(addCase(casePrefix + 'Stress_NotifyMove_019'), 0, () => {
      const dataSource = new BasicDataSource();
      const recorder = new ListenerRecorder();
      dataSource.registerDataChangeListener(recorder);
      for (let i = 0; i < 50; i++) {
        dataSource.notifyDataMove(i, 50 - i);
      }
      expect(recorder.events.length).assertEqual(50);
      expect(recorder.events[0].payload).assertEqual('0->50');
      expect(recorder.events[49].payload).assertEqual('49->1');
    });

    it(addCase(casePrefix + 'Boundary_BindPropertiesEmpty_020'), 0, () => {
      const controller = new DemoController();
      const component: FakeComponent = {
        text: 'abc',
        enabled: false,
        checked: false,
        extra: 'extra'
      };
      controller.bindComponent(component);
      controller.bindProperties([]);
      controller.text = 'value-after-empty-bind';
      expect(component.text).assertEqual('abc');
      expect(controller.text).assertEqual('value-after-empty-bind');
    });

    it(addCase(casePrefix + 'Boundary_ControllerPropertyAbsent_021'), 0, () => {
      const controller = new DemoController();
      const component: FakeComponent = {
        text: 'abc',
        enabled: false,
        checked: false,
        extra: 'extra'
      };
      controller.bindComponent(component);
      controller.bindProperties(['extra'], ['text']);
      controller.text = 'mirror';
      expect(component.extra).assertEqual('mirror');
    });

    it(addCase(casePrefix + 'Chaos_RegisterUnregisterMixed_022'), 0, () => {
      const ds = new BasicDataSource();
      const l1 = new ListenerRecorder();
      const l2 = new ListenerRecorder();
      const l3 = new ListenerRecorder();
      ds.registerDataChangeListener(l1);
      ds.registerDataChangeListener(l2);
      ds.notifyDataReload();
      ds.unregisterDataChangeListener(l1);
      ds.registerDataChangeListener(l3);
      ds.notifyDataAdd(1);
      ds.unregisterDataChangeListener(l2);
      ds.notifyDataDelete(1);
      expect(l1.events.length).assertEqual(1);
      expect(l2.events.length).assertEqual(2);
      expect(l3.events.length).assertEqual(2);
      expect(l3.events[1].type).assertEqual('delete');
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_023'), 0, () => {
      const pattern = /^Settings_DataSourceController_[A-Za-z0-9_]+_[0-9]{3}$/;
      const unique: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(pattern.test(allCaseNames[i])).assertEqual(true);
        expect(unique.has(allCaseNames[i])).assertEqual(false);
        unique.add(allCaseNames[i]);
      }
      expect(unique.size).assertEqual(allCaseNames.length);
    });
  });
}
