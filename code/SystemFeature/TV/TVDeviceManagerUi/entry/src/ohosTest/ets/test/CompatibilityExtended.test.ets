/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it } from '@ohos/hypium';
import { TestAsserts } from './base/TestAsserts';

interface CompatibilityResult {
  deviceModel: string;
  isSupported: boolean;
  compatibilityScore: number;
  issues: string[];
}

interface CompatibilityReport {
  totalDevicesTested: number;
  supportedDevices: number;
  overallCompatibilityScore: number;
  deviceResults: CompatibilityResult[];
}

interface VersionCompatibility {
  version: string;
  isSupported: boolean;
  minSupported: string;
  maxSupported: string;
  compatibilityLevel: 'FULL' | 'PARTIAL' | 'NONE';
  migrationRequired: boolean;
}

interface APICallValidation {
  totalAPICalls: number;
  deprecatedCalls: string[];
  unsupportedCalls: string[];
  hasCompatibilityIssues: boolean;
}

// 兼容性扩展测试套件

class DeviceCompatibilityTester {
  private supportedDevices: string[] = [
    'Huawei Vision', 'Huawei Smart Screen', 'TCL Smart TV', 'Hisense TV', 'Sony Bravia'
  ];
  private testedDevices: Set<string> = new Set();

  testDeviceCompatibility(deviceModel: string): CompatibilityResult {
    this.testedDevices.add(deviceModel);
    
    const isSupported = this.supportedDevices.some(device => {
      const deviceLower = device.toLowerCase();
      const modelLower = deviceModel.toLowerCase();
      // Use more precise matching: check if device name is a substring of model name
      // but also ensure it's not matching too broadly (e.g., 'Smart TV' in both Samsung and TCL)
      return modelLower.includes(deviceLower) && 
             (modelLower.startsWith(deviceLower) || 
              modelLower.includes(' ' + deviceLower) ||
              deviceLower.includes(modelLower.split(' ')[0])); // Match brand name
    });
    
    const result: CompatibilityResult = {
      deviceModel,
      isSupported,
      compatibilityScore: isSupported ? 100 : 0,
      issues: isSupported ? [] : ['Device not in supported list']
    };
    return result;
  }

  getTestedDevices(): string[] {
    return Array.from(this.testedDevices);
  }

  getCompatibilityReport(): CompatibilityReport {
    const devices = Array.from(this.testedDevices);
    const results: CompatibilityResult[] = [];
    for (let i = 0; i < devices.length; i++) {
      results.push(this.testDeviceCompatibility(devices[i]));
    }
    
    let supportedCount = 0;
    for (let i = 0; i < results.length; i++) {
      if (results[i].isSupported) {
        supportedCount++;
      }
    }
    const totalCount = results.length;
    const overallScore = totalCount > 0 ? (supportedCount / totalCount) * 100 : 0;
    
    const report: CompatibilityReport = {
      totalDevicesTested: totalCount,
      supportedDevices: supportedCount,
      overallCompatibilityScore: overallScore,
      deviceResults: results
    };
    return report;
  }
}

class SystemVersionCompatibility {
  private minSupportedVersion: string = '3.0.0';
  private maxSupportedVersion: string = '5.0.0';

  isVersionSupported(version: string): boolean {
    const parts = version.split('.').map(Number);
    const major = parts[0];
    const minor = parts[1];
    const patch = parts[2];
    
    const minParts = this.minSupportedVersion.split('.').map(Number);
    const minMajor = minParts[0];
    const minMinor = minParts[1];
    const minPatch = minParts[2];
    
    const maxParts = this.maxSupportedVersion.split('.').map(Number);
    const maxMajor = maxParts[0];
    const maxMinor = maxParts[1];
    const maxPatch = maxParts[2];
    
    if (major < minMajor) return false;
    if (major > maxMajor) return false;
    
    if (major === minMajor) {
      if (minor < minMinor) return false;
      if (minor === minMinor && patch < minPatch) return false;
    }
    
    if (major === maxMajor) {
      if (minor > maxMinor) return false;
      if (minor === maxMinor && patch > maxPatch) return false;
    }
    
    return true;
  }

  getVersionCompatibility(version: string): VersionCompatibility {
    const isSupported = this.isVersionSupported(version);
    
    const result: VersionCompatibility = {
      version,
      isSupported,
      minSupported: this.minSupportedVersion,
      maxSupported: this.maxSupportedVersion,
      compatibilityLevel: isSupported ? 'FULL' : 'NONE',
      migrationRequired: !isSupported
    };
    return result;
  }

  validateAPICalls(apiCalls: string[]): APICallValidation {
    const deprecatedAPIs = ['old_api_v1', 'legacy_function'];
    const unsupportedAPIs = ['experimental_api', 'beta_feature'];
    
    const deprecatedUsed: string[] = [];
    for (let i = 0; i < apiCalls.length; i++) {
      if (deprecatedAPIs.includes(apiCalls[i])) {
        deprecatedUsed.push(apiCalls[i]);
      }
    }
    
    const unsupportedUsed: string[] = [];
    for (let i = 0; i < apiCalls.length; i++) {
      if (unsupportedAPIs.includes(apiCalls[i])) {
        unsupportedUsed.push(apiCalls[i]);
      }
    }
    
    const validation: APICallValidation = {
      totalAPICalls: apiCalls.length,
      deprecatedCalls: deprecatedUsed,
      unsupportedCalls: unsupportedUsed,
      hasCompatibilityIssues: deprecatedUsed.length > 0 || unsupportedUsed.length > 0
    };
    return validation;
  }
}

class ThirdPartyIntegrationTester {
  private integratedServices: Map<string, IntegrationStatus> = new Map();

  testServiceIntegration(serviceName: string, serviceConfig: ServiceConfig): IntegrationResult {
    const status: IntegrationStatus = {
      serviceName,
      isConnected: serviceConfig.enabled,
      connectionTime: Date.now(),
      lastSync: Date.now(),
      errorCount: 0
    };
    
    this.integratedServices.set(serviceName, status);
    
    return {
      serviceName,
      integrationSuccessful: serviceConfig.enabled,
      responseTime: serviceConfig.responseTime || 0,
      dataSynced: serviceConfig.dataToSync || 0,
      issues: serviceConfig.enabled ? [] : ['Service not enabled']
    };
  }

  getIntegrationStatus(serviceName: string): IntegrationStatus | undefined {
    return this.integratedServices.get(serviceName);
  }

  getAllIntegrations(): IntegrationReport {
    const services = Array.from(this.integratedServices.values());
    const connectedServices = services.filter(s => s.isConnected);
    
    return {
      totalServices: services.length,
      connectedServices: connectedServices.length,
      connectionRate: services.length > 0 ? connectedServices.length / services.length : 0,
      services: services
    };
  }
}

interface ServiceConfig {
  enabled: boolean;
  responseTime?: number;
  dataToSync?: number;
}

interface IntegrationStatus {
  serviceName: string;
  isConnected: boolean;
  connectionTime: number;
  lastSync: number;
  errorCount: number;
}

interface IntegrationResult {
  serviceName: string;
  integrationSuccessful: boolean;
  responseTime: number;
  dataSynced: number;
  issues: string[];
}

interface IntegrationReport {
  totalServices: number;
  connectedServices: number;
  connectionRate: number;
  services: IntegrationStatus[];
}

export default function compatibilityExtendedTest(): void {
  describe('TVDeviceManagerUiCompatibilityExtendedTest', () => {
    // 设备兼容性测试
    it('should test device compatibility', 0, () => {
      const compatibilityTester = new DeviceCompatibilityTester();
      
      const result1 = compatibilityTester.testDeviceCompatibility('Huawei Vision 75\"');
      const result2 = compatibilityTester.testDeviceCompatibility('Samsung Smart TV');
      const result3 = compatibilityTester.testDeviceCompatibility('TCL 65\" Smart Screen');
      
      TestAsserts.assertBooleanEquals(result1.isSupported, true);
      TestAsserts.assertBooleanEquals(result2.isSupported, false);
      TestAsserts.assertBooleanEquals(result3.isSupported, false);
      
      TestAsserts.assertNumberEquals(result1.compatibilityScore, 100);
      TestAsserts.assertNumberEquals(result2.compatibilityScore, 0);
      
      const testedDevices = compatibilityTester.getTestedDevices();
      TestAsserts.assertArrayLength(testedDevices, 3);
      
      const report = compatibilityTester.getCompatibilityReport();
      TestAsserts.assertNumberEquals(report.totalDevicesTested, 3);
      TestAsserts.assertNumberEquals(report.supportedDevices, 1);
      TestAsserts.assertNumberEquals(report.overallCompatibilityScore, 33.33333333333333);
    });

    // 系统版本兼容性测试
    it('should validate system version compatibility', 0, () => {
      const versionCompatibility = new SystemVersionCompatibility();
      
      const result1 = versionCompatibility.getVersionCompatibility('3.1.0');
      const result2 = versionCompatibility.getVersionCompatibility('2.9.0');
      const result3 = versionCompatibility.getVersionCompatibility('5.1.0');
      const result4 = versionCompatibility.getVersionCompatibility('4.2.1');
      
      TestAsserts.assertBooleanEquals(result1.isSupported, true);
      TestAsserts.assertBooleanEquals(result2.isSupported, false);
      TestAsserts.assertBooleanEquals(result3.isSupported, false);
      TestAsserts.assertBooleanEquals(result4.isSupported, true);
      
      TestAsserts.assertStringEquals(result1.compatibilityLevel, 'FULL');
      TestAsserts.assertBooleanEquals(result2.migrationRequired, true);
      
      // API调用验证
      const apiValidation = versionCompatibility.validateAPICalls([
        'standard_api', 'old_api_v1', 'new_function'
      ]);
      
      TestAsserts.assertNumberEquals(apiValidation.totalAPICalls, 3);
      TestAsserts.assertArrayLength(apiValidation.deprecatedCalls, 1);
      TestAsserts.assertStringEquals(apiValidation.deprecatedCalls[0], 'old_api_v1');
      TestAsserts.assertBooleanEquals(apiValidation.hasCompatibilityIssues, true);
    });

    // 第三方集成测试
    it('should test third-party integrations', 0, () => {
      const integrationTester = new ThirdPartyIntegrationTester();
      
      const result1 = integrationTester.testServiceIntegration('CloudStorage', {
        enabled: true,
        responseTime: 150,
        dataToSync: 1000
      });
      
      const result2 = integrationTester.testServiceIntegration('Analytics', {
        enabled: false
      });
      
      TestAsserts.assertBooleanEquals(result1.integrationSuccessful, true);
      TestAsserts.assertBooleanEquals(result2.integrationSuccessful, false);
      TestAsserts.assertNumberEquals(result1.responseTime, 150);
      TestAsserts.assertNumberEquals(result1.dataSynced, 1000);
      TestAsserts.assertArrayLength(result2.issues, 1);
      
      const status = integrationTester.getIntegrationStatus('CloudStorage');
      TestAsserts.assertBooleanEquals(status!.isConnected, true);
      
      const report = integrationTester.getAllIntegrations();
      TestAsserts.assertNumberEquals(report.totalServices, 2);
      TestAsserts.assertNumberEquals(report.connectedServices, 1);
      TestAsserts.assertNumberEquals(report.connectionRate, 0.5);
    });

class ResolutionTester {
  testResolution(resolution: string): boolean {
    const supportedResolutions: string[] = ['1920x1080', '3840x2160', '1280x720'];
    return supportedResolutions.includes(resolution);
  }
  
  getOptimalLayout(resolution: string): LayoutConfig {
    const parts: string[] = resolution.split('x');
    const width: number = Number(parts[0]);
    const height: number = Number(parts[1]);
    return {
      buttonSize: Math.max(40, Math.min(width, height) / 30),
      fontSize: Math.max(14, Math.min(width, height) / 80),
      spacing: Math.max(8, Math.min(width, height) / 120)
    };
  }
}

class InputDeviceTester {
  private supportedDevices: string[] = ['remote', 'keyboard', 'touch', 'voice', 'gamepad'];
  
  testInputDevice(device: string): boolean {
    return this.supportedDevices.includes(device);
  }
  
  getDeviceCapabilities(device: string): DeviceCapabilities {
    if (device === 'remote') {
      return { navigation: true, selection: true, textInput: false };
    } else if (device === 'keyboard') {
      return { navigation: true, selection: true, textInput: true };
    } else if (device === 'touch') {
      return { navigation: true, selection: true, textInput: false };
    } else if (device === 'voice') {
      return { navigation: false, selection: false, textInput: true };
    } else if (device === 'gamepad') {
      return { navigation: true, selection: true, textInput: false };
    }
    return { navigation: false, selection: false, textInput: false };
  }
}

    // 分辨率兼容性测试
    it('should handle different screen resolutions', 0, () => {
      const resolutionTester: ResolutionTester = new ResolutionTester();
      
      const supported1: boolean = resolutionTester.testResolution('1920x1080');
      const supported2: boolean = resolutionTester.testResolution('800x600');
      
      TestAsserts.assertBooleanEquals(supported1, true);
      TestAsserts.assertBooleanEquals(supported2, false);
      
      const layout: LayoutConfig = resolutionTester.getOptimalLayout('3840x2160');
      TestAsserts.assertNumberAtLeast(layout.buttonSize, 40);
      TestAsserts.assertNumberAtLeast(layout.fontSize, 14);
      TestAsserts.assertNumberAtLeast(layout.spacing, 8);
    });

    // 输入设备兼容性测试
    it('should support various input devices', 0, () => {
      const inputDeviceTester: InputDeviceTester = new InputDeviceTester();
      
      const supported1: boolean = inputDeviceTester.testInputDevice('remote');
      const supported2: boolean = inputDeviceTester.testInputDevice('mouse');
      
      TestAsserts.assertBooleanEquals(supported1, true);
      TestAsserts.assertBooleanEquals(supported2, false);
      
      const capabilities: DeviceCapabilities = inputDeviceTester.getDeviceCapabilities('keyboard');
      TestAsserts.assertBooleanEquals(capabilities.navigation, true);
      TestAsserts.assertBooleanEquals(capabilities.selection, true);
      TestAsserts.assertBooleanEquals(capabilities.textInput, true);
    });
  });
}

interface LayoutConfig {
  buttonSize: number;
  fontSize: number;
  spacing: number;
}

interface DeviceCapabilities {
  navigation: boolean;
  selection: boolean;
  textInput: boolean;
}