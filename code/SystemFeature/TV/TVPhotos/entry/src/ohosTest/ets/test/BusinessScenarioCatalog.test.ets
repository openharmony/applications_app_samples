import { describe, expect, it } from '@ohos/hypium';
import { BusinessScenarioCatalog } from './base/BusinessScenarioCatalog';

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

class FindScenario {
  id: string;
  expectedState: string;
  expectedFocus: string;

  constructor(id: string, expectedState: string, expectedFocus: string) {
    this.id = id;
    this.expectedState = expectedState;
    this.expectedFocus = expectedFocus;
  }
}

class AbilityContractScenario {
  domain: string;
  ability: string;
  entryPrefix: string;

  constructor(domain: string, ability: string, entryPrefix: string) {
    this.domain = domain;
    this.ability = ability;
    this.entryPrefix = entryPrefix;
  }
}

class StepHeadScenario {
  id: string;
  expectedStepHead: string;

  constructor(id: string, expectedStepHead: string) {
    this.id = id;
    this.expectedStepHead = expectedStepHead;
  }
}

const DOMAIN_MATRIX_SCENARIOS: DomainMatrixScenario[] = [
  new DomainMatrixScenario('首页流程', 75, 'home_001', 'home_075'),
  new DomainMatrixScenario('相册导航', 75, 'album_001', 'album_075'),
  new DomainMatrixScenario('分布式流程', 75, 'distributed_001', 'distributed_075'),
  new DomainMatrixScenario('NAS 流程', 75, 'nas_001', 'nas_075')
];

const FIND_SCENARIOS: FindScenario[] = [
  new FindScenario('home_010', 'picture_grid_ready', 'photo_0_0'),
  new FindScenario('album_005', 'nas_session_ready', 'album4'),
  new FindScenario('distributed_027', 'wifi_closed', 'menu0'),
  new FindScenario('nas_016', 'route_back', 'client_0')
];

const IMMUTABLE_STEP_IDS: string[] = [
  'home_001',
  'home_020',
  'home_075',
  'album_001',
  'album_020',
  'album_075',
  'distributed_001',
  'distributed_020',
  'distributed_075',
  'nas_001',
  'nas_020',
  'nas_075'
];

const ABILITY_CONTRACT_SCENARIOS: AbilityContractScenario[] = [
  new AbilityContractScenario('首页流程', 'EntryAbility', 'menu'),
  new AbilityContractScenario('相册导航', 'EntryAbility', 'album'),
  new AbilityContractScenario('分布式流程', 'EntryAbility', 'menu'),
  new AbilityContractScenario('NAS 流程', 'EntryAbility', 'client')
];

const UNIQUE_ACTIONS: string[] = [
  'open_picture_tab',
  'open_nas_session_album',
  'mount_dfs_success',
  'confirm_login_success'
];

const STEP_HEAD_SCENARIOS: StepHeadScenario[] = [
  new StepHeadScenario('home_001', 'launch_entry'),
  new StepHeadScenario('home_075', 'load_home_focus_matrix'),
  new StepHeadScenario('album_001', 'focus_album0'),
  new StepHeadScenario('album_075', 'load_album_navigation_matrix'),
  new StepHeadScenario('distributed_001', 'open_distributed_tab'),
  new StepHeadScenario('distributed_075', 'load_receive_matrix'),
  new StepHeadScenario('nas_001', 'find_nas_clients'),
  new StepHeadScenario('nas_075', 'load_nas_client_matrix')
];

export default function businessScenarioCatalogTest() {
  describe('BusinessScenarioCatalogTest', () => {
    it('should expose complete business scenario count and domains', 0, () => {
      const allScenarios = BusinessScenarioCatalog.getAll();
      const domains = BusinessScenarioCatalog.getDomains();

      expect(allScenarios.length).assertEqual(300);
      expect(domains.length).assertEqual(4);
      expect(domains[0]).assertEqual('首页流程');
      expect(domains[1]).assertEqual('相册导航');
      expect(domains[2]).assertEqual('分布式流程');
      expect(domains[3]).assertEqual('NAS 流程');
    });

    DOMAIN_MATRIX_SCENARIOS.forEach((scenario: DomainMatrixScenario) => {
      it(`should expose domain matrix for ${scenario.domain}`, 0, () => {
        const cases = BusinessScenarioCatalog.getByDomain(scenario.domain);

        expect(cases.length).assertEqual(scenario.expectedCount);
        expect(cases[0].id).assertEqual(scenario.firstId);
        expect(cases[cases.length - 1].id).assertEqual(scenario.lastId);
      });
    });

    FIND_SCENARIOS.forEach((scenario: FindScenario) => {
      it(`should find scenario by id ${scenario.id}`, 0, () => {
        const item = BusinessScenarioCatalog.findById(scenario.id);

        expect(item?.id).assertEqual(scenario.id);
        expect(item?.expectedState).assertEqual(scenario.expectedState);
        expect(item?.expectedFocus).assertEqual(scenario.expectedFocus);
        expect((item?.steps.length ?? 0) >= 3).assertTrue();
      });
    });

    IMMUTABLE_STEP_IDS.forEach((id: string) => {
      it(`should keep immutable step list for ${id}`, 0, () => {
        const before = BusinessScenarioCatalog.findById(id);
        const copied = BusinessScenarioCatalog.findById(id);
        if (before === undefined || copied === undefined) {
          expect(false).assertTrue();
          return;
        }

        copied.steps[0] = 'changed_step';

        expect(before.steps[0] === 'changed_step').assertFalse();
      });
    });

    ABILITY_CONTRACT_SCENARIOS.forEach((scenario: AbilityContractScenario) => {
      it(`should keep ability contract for ${scenario.domain}`, 0, () => {
        const items = BusinessScenarioCatalog.getByDomain(scenario.domain);

        expect(items.every((item) => item.ability === scenario.ability)).assertTrue();
        expect(items.some((item) => item.entry.startsWith(scenario.entryPrefix))).assertTrue();
      });
    });

    UNIQUE_ACTIONS.forEach((action: string) => {
      it(`should expose unique action ${action}`, 0, () => {
        const matches = BusinessScenarioCatalog.getAll().filter((item) => item.action === action);
        expect(matches.length).assertEqual(1);
      });
    });

    STEP_HEAD_SCENARIOS.forEach((scenario: StepHeadScenario) => {
      it(`should keep ordered step head for ${scenario.id}`, 0, () => {
        const item = BusinessScenarioCatalog.findById(scenario.id);
        expect(item?.steps[0]).assertEqual(scenario.expectedStepHead);
      });
    });
  });
}
