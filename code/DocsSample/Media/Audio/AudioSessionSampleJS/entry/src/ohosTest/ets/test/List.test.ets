import abilityTest from './Ability.test';
import AudioSessionManagerTest from './avsession.test';

export default function testsuite() {
  abilityTest();
  AudioSessionManagerTest()
}