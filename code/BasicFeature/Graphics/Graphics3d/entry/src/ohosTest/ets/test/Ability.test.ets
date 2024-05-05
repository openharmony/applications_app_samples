import hilog from '@ohos.hilog';
import { Driver, ON } from '@ohos.UiTest';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

let LOG_TAG: string  = 'Sample_Graphics3D'
const DELAYMS_1S = 1000;
const DELAYMS_2S = 2000;
const DELAYMS_5S = 5000;

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      console.log(LOG_TAG + 'beforeAll')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.graphics3d',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        console.log(LOG_TAG + `beforeAll exception = ${JSON.stringify(err)}`)
      }
      console.log(LOG_TAG + 'beforeAll end');
    })
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.

    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    async function step(driver: Driver, id: string): Promise<void> {
      console.log(LOG_TAG + ' ' + id + ' E');
      await driver.assertComponentExist(ON.id(id));
      let component = await driver.findComponent(ON.id(id));
      if (component) {
        console.log(LOG_TAG + " find");
      } else {
        console.log(LOG_TAG + "do not find");
        return;
      }
      await component.click();
      console.log(LOG_TAG + ' ' + id + ' X');
    }

    it('Container_001',0, async function () {
      try {
        console.log(LOG_TAG + 'container test begin');
        let driver = Driver.create();
        await step(driver, 'index_container');
        await driver.delayMs(DELAYMS_5S);
        await step(driver, 'remove_node');
        await step(driver, 'append_node');
        await step(driver, 'remove_node');
        await step(driver, 'insert_node');
        await step(driver, 'clear_node');
        await step(driver, 'container_back');
        console.log(LOG_TAG + 'container test end');
      } catch(error) {
        console.log(LOG_TAG + `beforeAll exception = ${JSON.stringify(error)}` + error);
      };
    });

    it('NodeBase_002',0, async function () {
      try {
        console.log(LOG_TAG + 'nodeBase test begin');
        let driver = Driver.create();
        await step(driver, 'index_node');
        await driver.delayMs(DELAYMS_5S);
        await step(driver, 'scale_helmet');
        await step(driver, 'rotate_helmet');
        await step(driver, 'rotate_parent');
        await step(driver, 'root_visible');
        await step(driver, 'layer_mask');
        await step(driver, 'node_back');
        console.log(LOG_TAG + 'nodeBase test end');
      } catch(error) {
        console.log(LOG_TAG + `beforeAll exception = ${JSON.stringify(error)}` + error);
      };
    });

    it('NodeCamera_003',0, async function () {
      try {
        console.log(LOG_TAG + 'nodeCamera test begin');
        let driver = Driver.create();
        await step(driver, 'index_camera');
        await driver.delayMs(DELAYMS_5S);
        await step(driver, 'change_fov');
        await step(driver, 'camera_enabled');
        await step(driver, 'change_tonemapping');
        await step(driver, 'clear_color');
        await step(driver, 'camera_back');
        console.log(LOG_TAG + 'nodeCamera test end');
      } catch(error) {
        console.log(LOG_TAG + `beforeAll exception = ${JSON.stringify(error)}` + error);
      };
    });

    it('NodeLight_004',0, async function () {
      try {
        console.log(LOG_TAG + 'nodeCamera test begin');
        let driver = Driver.create();
        await step(driver, 'index_light');
        await driver.delayMs(DELAYMS_5S);
        await step(driver, 'switch_light');
        await step(driver, 'change_color');
        await step(driver, 'change_intensity');
        console.log(LOG_TAG + 'nodeCamera test end');
        await step(driver, 'light_back');
      } catch(error) {
        console.log(LOG_TAG + `beforeAll exception = ${JSON.stringify(error)}` + error);
      };
    });

    it('SceneAnimation_005',0, async function () {
      try {
        console.log(LOG_TAG + 'nodeAnimation test begin');
        let driver = Driver.create();
        await step(driver, 'index_animation');
        await step(driver, 'enable_animation');
        await step(driver, 'start_animation');
        await step(driver, 'pause_animation');
        await step(driver, 'stop_animation');
        await step(driver, 'finish_animation');
        await step(driver, 'restart_animation');
        await step(driver, 'seek_animation');

        await step(driver, 'back_animation');
        console.log(LOG_TAG + 'nodeCamera test end');
      } catch(error) {
        console.log(LOG_TAG + `beforeAll exception = ${JSON.stringify(error)}` + error);
      };
    });

    it('SceneEnvironment_006',0, async function () {
      try {
        console.log(LOG_TAG + 'sceneEnvironment test begin');
        let driver = Driver.create();
        await step(driver, 'index_environment');
        await driver.delayMs(DELAYMS_5S);
        await step(driver, 'change_type_environment');
        await step(driver, 'change_radiance');
        await step(driver, 'change_indirectDiffuseFactor');
        await step(driver, 'change_indirectSpecularFactor');
        await step(driver, 'change_environmentMapFactor');
        await step(driver, 'change_irradianceCoefficients');
        console.log(LOG_TAG + 'sceneEnvironment test end');
        await step(driver, 'back_environment');
      } catch(error) {
        console.log(LOG_TAG + `beforeAll exception = ${JSON.stringify(error)}` + error);
      };
    });


    it('SceneShader_007',0, async function () {
      try {
        console.log(LOG_TAG + 'sceneShader test begin');
        let driver = Driver.create();
        await step(driver, 'index_shader');
        await driver.delayMs(DELAYMS_5S);
        await step(driver, 'create_shader_change_material');
        await step(driver, 'recovery_original');
        await step(driver, 'material_override');
        console.log(LOG_TAG + 'sceneShader test end');
      } catch(error) {
        console.log(LOG_TAG + `beforeAll exception = ${JSON.stringify(error)}` + error);
      };
    });
  })
}