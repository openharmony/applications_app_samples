import abilityTest from './Ability.test';
import AudioCapturerTest from './AudioCapturerTest.test';
import AudioLoopbackDemoTest from './AudioLoopbackTest.test';
import AudioStreamManagerTest from './AudioStreamManager.test';
import AudioVolumeGroupManagerTest from './MacManager.test';

export default function testsuite() {
  abilityTest();
  AudioCapturerTest();
  AudioLoopbackDemoTest();
  AudioVolumeGroupManagerTest();
  AudioStreamManagerTest();
}
