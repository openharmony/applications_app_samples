import abilityTest from './Ability.test';
import AudioHapticManagerTest from './Haptic.test';
import AudioRendererDemoTest from './Renderer.test';

export default function testsuite() {
  abilityTest();
  AudioHapticManagerTest();
  AudioRendererDemoTest();
}