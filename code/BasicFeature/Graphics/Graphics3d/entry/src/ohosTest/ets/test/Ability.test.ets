import hilog from '@ohos.hilog';
import { Driver, ON } from '@ohos.UiTest';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const LOG_TAG: string  = '[Sample_Graphics3D]'
const DOMAIN = 0xF811
const BUNDLE = 'Graphics3d'
const DELAY_MS_5S = 5000;

export default function abilityTest() {
  describe('ActsAbilityTest',  () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async  () => {
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
    beforeEach( () => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.

    })
    afterEach( () => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll( () => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    let step: Function = async (driver: Driver, id: string): Promise<void> => {
      hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' ' + id + ' begin');
      await driver.assertComponentExist(ON.id(id));
      let component = await driver.findComponent(ON.id(id));
      if (component) {
        console.log(LOG_TAG + " find");
      } else {
        console.log(LOG_TAG + "do not find");
        return;
      }
      await component.click();
      hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' ' + id + ' end');
    }
    /**
     *  This test case tests the container functionality of 3D, including adding, deleting, inserting,
     *  and clearing
     */
    it('Graphics3d_container_function_001',0, async () => {
      try {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_Container_Function_001' + ' begin');
        let driver = Driver.create();
        // enter into container function test page
        await step(driver, 'index_container');
        await driver.delayMs(DELAY_MS_5S);
        // test remove a node
        await step(driver, 'remove_node');
        // test append a node
        await step(driver, 'append_node');
        await step(driver, 'remove_node');
        // test insert a node
        await step(driver, 'insert_node');
        // test clear the node
        await step(driver, 'clear_node');
        // return to test main page
        await step(driver, 'container_back');
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_Container_Function_001' + ' end');
      } catch(error) {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_Container_Function_001' +
          `exception = ${JSON.stringify(error)}` + error);
      };
    });

    /**
     * This test case tests the basic functions of 3D nodes, including scaling rotation visible and transform etc
     */
    it('Graphics3d_node_base_function_002',0, async  () => {
      try {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_node_base_function_002' + ' begin');
        let driver = Driver.create();
        // enter into node base function test page
        await step(driver, 'index_node');
        await driver.delayMs(DELAY_MS_5S);
        // scale the node
        await step(driver, 'scale_helmet');
        // rotate the node
        await step(driver, 'rotate_helmet');
        // rotate the parent of the node
        await step(driver, 'rotate_parent');
        // toggle the node's visible
        await step(driver, 'root_visible');
        // change the node's layer mask
        await step(driver, 'layer_mask');
        // return to the test main page
        await step(driver, 'node_back');
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_node_base_function_002' + ' end');
      } catch(error) {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_node_base_function_002' +
          `exception = ${JSON.stringify(error)}` + error);
      };
    });

    /**
     * This test case tests the camera function in 3d scene, including fov ,tone mapping, clear color etc
     */
    it('Graphics3d_camera_function_003',0, async  () => {
      try {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_camera_function_003' + ' begin');
        let driver = Driver.create();
        // enter into camera function test page
        await step(driver, 'index_camera');
        await driver.delayMs(DELAY_MS_5S);
        // change camera's fov
        await step(driver, 'change_fov');
        // change camera's tone mapping
        await step(driver, 'change_tonemapping');
        // change camera's clear color
        await step(driver, 'clear_color');
        // toggle camera's enable
        await step(driver, 'camera_enabled');
        // return to the test main page
        await step(driver, 'camera_back');
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_camera_function_003' + ' end');
      } catch(error) {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_camera_function_003' +
          `exception = ${JSON.stringify(error)}` + error);
      };
    });

    /**
     * This test case tests the light function in 3d scene, including light type , intensity, etc
     */
    it('Graphics3d_light_function_004',0, async  () => {
      try {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_light_function_004' + ' begin');
        let driver = Driver.create();
        // enter into light function test page
        await step(driver, 'index_light');
        await driver.delayMs(DELAY_MS_5S);
        // change light's type
        await step(driver, 'switch_light');
        // change light's color
        await step(driver, 'change_color');
        // change light's intensity
        await step(driver, 'change_intensity');
        // return to the test main page
        await step(driver, 'light_back');
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_light_function_004' + ' end');
      } catch(error) {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_light_function_004' +
          `exception = ${JSON.stringify(error)}` + error);
      };
    });

    /**
     * This test case tests the 3d animation function, including enable, start, stop, pause etc
     */
    it('Graphics3d_animation_function_005',0, async () => {
      try {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_animation_function_005' + ' begin');
        let driver = Driver.create();
        // enter into animation test page
        await step(driver, 'index_animation');
        // enable the animation
        await step(driver, 'enable_animation');
        // start the animation
        await step(driver, 'start_animation');
        // pause the animation
        await step(driver, 'pause_animation');
        // stop the animation
        await step(driver, 'stop_animation');
        // finish the animation
        await step(driver, 'finish_animation');
        // restart the animation
        await step(driver, 'restart_animation');
        // seek the animation
        await step(driver, 'seek_animation');
        // return to the test main page
        await step(driver, 'back_animation');
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_animation_function_005' + ' end');
      } catch(error) {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_animation_function_005' +
          `exception = ${JSON.stringify(error)}` + error);
      };
    });

    /**
     * This test case tests the 3d environment function, including environment type, effect factor etc
     */
    it('Graphics3d_environment_function_006',0, async () => {
      try {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_environment_function_006' + ' begin');
        let driver = Driver.create();
        // enter into environment test page
        await step(driver, 'index_environment');
        await driver.delayMs(DELAY_MS_5S);
        // change environment type
        await step(driver, 'change_type_environment');
        // change the radiance of environment
        await step(driver, 'change_radiance');
        // change indirect diffuse factor
        await step(driver, 'change_indirectDiffuseFactor');
        // change indirect specular factor
        await step(driver, 'change_indirectSpecularFactor');
        // change environment map factor
        await step(driver, 'change_environmentMapFactor');
        // change irradiance coefficient
        await step(driver, 'change_irradianceCoefficients');
        // return to the test main page
        await step(driver, 'back_environment');
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_environment_function_006' + ' end');
      } catch(error) {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_environment_function_006' +
          `exception = ${JSON.stringify(error)}` + error);
      };
    });

    /**
     * This test case tests the 3d shader function, including creating shader, replace the material's shader
     */
    it('Graphics3d_shader_function_007',0, async () => {
      try {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_shader_function_007' + ' begin');
        let driver = Driver.create();
        // enter into shader function test page
        await step(driver, 'index_shader');
        await driver.delayMs(DELAY_MS_5S);
        // create a shader and replace the material's shader
        await step(driver, 'create_shader_change_material');
        // recovery the original shader
        await step(driver, 'recovery_original');
        // set the material's override shader
        await step(driver, 'material_override');
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_shader_function_007' + ' begin');
      } catch(error) {
        hilog.info(DOMAIN, LOG_TAG, BUNDLE + ' Graphics3d_shader_function_007' +
          `exception = ${JSON.stringify(error)}` + error);
      };
    });
  })
}