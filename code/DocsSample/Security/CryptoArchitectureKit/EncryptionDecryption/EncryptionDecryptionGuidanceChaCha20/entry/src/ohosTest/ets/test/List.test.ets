import abilityTest from './Ability.test';
import encryptionDecryptionGuidanceChaCha20ArkTsTest from './ChaCha20ArkTs.test';

export default function testsuite() {
  abilityTest();
  encryptionDecryptionGuidanceChaCha20ArkTsTest();
}