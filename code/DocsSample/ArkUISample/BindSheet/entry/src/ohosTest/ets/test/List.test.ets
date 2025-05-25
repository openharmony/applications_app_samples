
import { BindSheetTest } from './BindSheet.test';
import { BindContentCoverTest } from './BindContentCover.test';
import { OpenSheetTest } from './OpenSheet.test';

export default function testsuite() {
  BindSheetTest();
  BindContentCoverTest();
  OpenSheetTest();
}