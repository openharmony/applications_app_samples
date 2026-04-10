import { describe, expect, it } from '@ohos/hypium';
import { LaunchChainCatalog } from './base/LaunchChainCatalog';

class DomainMatrixScenario {
  domain: string;
  expectedCount: number;
  firstId: string;
  lastId: string;

  constructor(domain: string, expectedCount: number, firstId: string, lastId: string) {
    this.domain = domain;
    this.expectedCount = expectedCount;
    this.firstId = firstId;
    this.lastId = lastId;
  }
}

class LaunchItemScenario {
  id: string;
  expectedState: string;
  expectedStorageKey: string;

  constructor(id: string, expectedState: string, expectedStorageKey: string) {
    this.id = id;
    this.expectedState = expectedState;
    this.expectedStorageKey = expectedStorageKey;
  }
}

class AbilityMappingScenario {
  domain: string;
  ability: string;

  constructor(domain: string, ability: string) {
    this.domain = domain;
    this.ability = ability;
  }
}

const DOMAIN_MATRIX_SCENARIOS: DomainMatrixScenario[] = [
  new DomainMatrixScenario('主能力创建', 55, 'main_001', 'main_055'),
  new DomainMatrixScenario('选择器能力', 55, 'picker_001', 'picker_055'),
  new DomainMatrixScenario('入口清理', 55, 'entry_001', 'entry_055'),
  new DomainMatrixScenario('加载器回调', 55, 'loader_001', 'loader_055')
];

const LAUNCH_ITEM_SCENARIOS: LaunchItemScenario[] = [
  new LaunchItemScenario('main_001', 'file_manager_ready', 'directUri'),
  new LaunchItemScenario('picker_015', 'terminate_called', 'none'),
  new LaunchItemScenario('entry_009', 'want_ready', 'bundleName'),
  new LaunchItemScenario('loader_027', 'delay_scheduled', 'callbackTimers')
];

const CLONE_STEP_IDS: string[] = [
  'main_001',
  'main_055',
  'picker_001',
  'picker_055',
  'entry_001',
  'entry_055',
  'loader_001',
  'loader_055'
];

const ABILITY_MAPPING_SCENARIOS: AbilityMappingScenario[] = [
  new AbilityMappingScenario('主能力创建', 'MainAbility'),
  new AbilityMappingScenario('选择器能力', 'PickerAbility'),
  new AbilityMappingScenario('入口清理', 'EntryAbility'),
  new AbilityMappingScenario('加载器回调', 'BasePhotoLoader')
];

const TRIGGERS: string[] = [
  'onCreate',
  'onNewWant',
  'handleWant',
  'onDestroy',
  'registerDelayCallback'
];

export default function launchChainCatalogTest() {
  describe('LaunchChainCatalogTest', () => {
    it('should expose complete launch chain matrix and domains', 0, () => {
      const allCases = LaunchChainCatalog.getAll();
      const domains = LaunchChainCatalog.getDomains();

      expect(allCases.length).assertEqual(220);
      expect(domains.length).assertEqual(4);
      expect(domains[0]).assertEqual('主能力创建');
      expect(domains[1]).assertEqual('选择器能力');
      expect(domains[2]).assertEqual('入口清理');
      expect(domains[3]).assertEqual('加载器回调');
    });

    DOMAIN_MATRIX_SCENARIOS.forEach((scenario) => {
      it(`should expose launch domain matrix for ${scenario.domain}`, 0, () => {
        const cases = LaunchChainCatalog.getByDomain(scenario.domain);

        expect(cases.length).assertEqual(scenario.expectedCount);
        expect(cases[0].id).assertEqual(scenario.firstId);
        expect(cases[cases.length - 1].id).assertEqual(scenario.lastId);
      });
    });

    LAUNCH_ITEM_SCENARIOS.forEach((scenario) => {
      it(`should find launch scenario ${scenario.id}`, 0, () => {
        const item = LaunchChainCatalog.findById(scenario.id);

        expect(item?.id).assertEqual(scenario.id);
        expect(item?.expectedState).assertEqual(scenario.expectedState);
        expect(item?.expectedStorageKey).assertEqual(scenario.expectedStorageKey);
        expect((item?.steps.length ?? 0) >= 3).assertTrue();
      });
    });

    CLONE_STEP_IDS.forEach((id) => {
      it(`should clone step lists for ${id}`, 0, () => {
        const first = LaunchChainCatalog.findById(id);
        const second = LaunchChainCatalog.findById(id);
        if (first === undefined || second === undefined) {
          expect(false).assertTrue();
          return;
        }

        second.steps[0] = 'changed_step';

        expect(first.steps[0] === 'changed_step').assertFalse();
      });
    });

    ABILITY_MAPPING_SCENARIOS.forEach((scenario) => {
      it(`should keep ability mapping for ${scenario.domain}`, 0, () => {
        const items = LaunchChainCatalog.getByDomain(scenario.domain);
        expect(items.every((item) => item.ability === scenario.ability)).assertTrue();
      });
    });

    TRIGGERS.forEach((trigger) => {
      it(`should expose trigger ${trigger}`, 0, () => {
        const matches = LaunchChainCatalog.getAll().filter((item) => item.trigger === trigger);
        expect(matches.length > 0).assertTrue();
      });
    });
  });
}
