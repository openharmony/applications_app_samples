import { RouterTest } from './Router.test';
import { NavigationTest } from './Navigation.test';
import { NavDestinationTest } from './NavDestination.test';
import { SideBarContainerTest } from './SideBarContainer.test';
import { StepperTest } from './Stepper.test';
import { UiObserverTest } from './UiObserver.test';
import { QueryNavDestinationInfoTest } from './QueryNavDestinationInfo.test';

export default function testsuite() {
  RouterTest();
  NavigationTest();
  NavDestinationTest();
  SideBarContainerTest();
  StepperTest();
  UiObserverTest();
  QueryNavDestinationInfoTest();
}