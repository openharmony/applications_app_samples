import abilityTest from './Ability.test';
import AudioRoutingDemoTest from './FindAndListenAudioInputDevice.test';
import VoIPOutputDeviceDemoTest from './FindAndListenAudioOutputDevice.test';
import MediaInputDeviceDemoTest from './InputDeviceRoutingSwitching.test';
import SessionOutputDeviceDemoTest from './ListenDeviceByAudioSession.test';
import AudioRendererOutputDeviceDemoTest from './OutputDeviceChangePause.test';
import VoIPAudioCapturerDemoTest from './VoIpDemoForAudioCapturer.test';
import VoIPAudioRendererDemoTest from './VoIpDemoForAudioRenderer.test';

export default function testsuite() {
  abilityTest();
  AudioRoutingDemoTest();
  VoIPOutputDeviceDemoTest();
  MediaInputDeviceDemoTest();
  SessionOutputDeviceDemoTest();
  AudioRendererOutputDeviceDemoTest();
  VoIPAudioCapturerDemoTest();
  VoIPAudioRendererDemoTest();
}