/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start net_firewall_case_import_module]
// 从@kit.NetworkKit中导入netFirewall命名空间。
import { netFirewall } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End net_firewall_case_import_module]
import { ComponentId } from '../common/CommonConstant';
import { promptAction } from '@kit.ArkUI';

// [Start net_firewall_set_net_firewall_policy]
// IP类型
interface IpType{
  family:number;
  type:number;
  address?:string;
  mask?:number;
  startIp?:string;
  endIp?:string;
}
// IP端口
interface IpPort{
  startPort:number;
  endPort:number;
}
// [StartExclude net_firewall_set_net_firewall_policy]

// [Start net_firewall_set_net_firewall_policy_domain_names]
interface domain{
  isWildcard: boolean;
  domain: string;
}
// [StartExclude net_firewall_set_net_firewall_policy_domain_names]
// 常量定义
const LOG_TAG: string = '[Sample_FirewallRequestDemo]';

@Entry
@Component
struct Index {
  @State specificIPReqResult: ResourceStr = '';
  @State domainNameNetworkReqResult: ResourceStr = '';

  build() {
    Column () {
      Text($r('app.string.network_firewall'))
        .fontSize($r('app.float.size50'))
        .id(ComponentId.FIREWALL_BUTTON)
        .margin({ bottom: $r('app.float.margin20') })

      // 第一个按钮：针对特定IP联网访问控制
      Button($r('app.string.for_specific_IP'))
        .onClick(() => {
          this.specificIP();
        })
        .width('80%')
        .height($r('app.float.height50'))
        .margin({ top: $r('app.float.margin20') })
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .fontSize($r('app.float.size30'))
        .borderRadius($r('app.float.borderRadius'))
        .id(ComponentId.SPECIFIC_IP)

      // 第二个按钮：针对域名联网访问控制支持拦截
      Button($r('app.string.networking_for_domain_names'))
        .onClick(() => {
          this.domainNameNetworking();
        })
        .width('80%')
        .height($r('app.float.height50'))
        .margin({ top: $r('app.float.margin20') })
        .backgroundColor(Color.Green)
        .fontColor(Color.White)
        .fontSize($r('app.float.size30'))
        .borderRadius($r('app.float.borderRadius'))
        .id(ComponentId.DOMAIN_NAME_NETWORKING)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  // 针对特定IP联网访问控制
  private specificIP(): void {
    // [EndExclude net_firewall_set_net_firewall_policy]
    // 定义防火墙策略：打开，入站阻止，出站允许。
    let policy: netFirewall.NetFirewallPolicy = {
      isOpen: true,
      inAction: netFirewall.FirewallRuleAction.RULE_DENY,
      outAction: netFirewall.FirewallRuleAction.RULE_ALLOW
    };

    // 给用户100设置防火墙策略。
    netFirewall.setNetFirewallPolicy(100, policy).then(() => {
      hilog.info(0x0000, 'testTag', `set firewall policy success.`);
    }).catch((error : BusinessError) => {
      hilog.error(0x0000, 'testTag', `error: set firewall policy failed: ${JSON.stringify(error)}`);
    });
    // [End net_firewall_set_net_firewall_policy]

    // [Start net_firewall_add_net_firewall_rule]
    // 初始化具体的防火墙ip类型规则。
    let ipRule: netFirewall.NetFirewallRule = {
      name: 'rule1',
      description: 'rule1 description',
      direction: netFirewall.NetFirewallRuleDirection.RULE_IN,
      action: netFirewall.FirewallRuleAction.RULE_DENY,
      type: netFirewall.NetFirewallRuleType.RULE_IP,
      isEnabled: true,
      appUid: 20001,
      localIps: [
        {
          family: 1,
          type: 1,
          address: '10.10.1.1',
          mask: 32
        },{
        family: 1,
        type: 2,
        startIp: '10.20.1.1',
        endIp: '10.20.1.10'
      }] as IpType[],
      remoteIps:[
        {
          family: 1,
          type: 1,
          address: '20.10.1.1',
          mask: 32
        },{
        family: 1,
        type: 2,
        startIp: '20.20.1.1',
        endIp: '20.20.1.10'
      }] as IpType[],
      protocol: 6,
      localPorts: [
        {
          startPort: 1000,
          endPort: 1000
        },{
        startPort: 2000,
        endPort: 2001
      }] as IpPort[],
      remotePorts: [
        {
          startPort: 443,
          endPort: 443
        }] as IpPort[],
      userId: 100
    };
    // 添加防火墙规则。
    netFirewall.addNetFirewallRule(ipRule).then((result: number) => {
      // [StartExclude net_firewall_add_net_firewall_rule]
      // 请求成功，处理响应结果
      this.specificIPReqResult = $r('app.string.specific_IP_success');
      promptAction.showToast({
        message: this.specificIPReqResult,
        duration: 4000, // 持续时间
        bottom: 300 // 与底间隔
      });
      // [EndExclude net_firewall_add_net_firewall_rule]
      hilog.info(0x0000, 'testTag', `rule Id: ${result}`);
    }, (reason: BusinessError) => {
      // [StartExclude net_firewall_add_net_firewall_rule]
      this.specificIPReqResult = 'error:' + JSON.stringify(reason);
      promptAction.showToast({
        message: this.specificIPReqResult,
        duration: 4000, // 持续时间
        bottom: 300 // 与底间隔
      });
      // [EndExclude net_firewall_add_net_firewall_rule]
      hilog.error(0x0000, 'testTag', `error: add firewall rule failed:  ${JSON.stringify(reason)}`);
    });
    // [End net_firewall_add_net_firewall_rule]
  }

  // 针对域名联网访问控制支持拦截
  private domainNameNetworking(): void {
    // [EndExclude net_firewall_set_net_firewall_policy_domain_names]
    // 定义防火墙策略：打开，入站阻止，出站允许。
    let policy: netFirewall.NetFirewallPolicy = {
      isOpen: true,
      inAction: netFirewall.FirewallRuleAction.RULE_DENY,
      outAction: netFirewall.FirewallRuleAction.RULE_ALLOW
    };

    // 给用户100设置防火墙策略
    netFirewall.setNetFirewallPolicy(100, policy).then(() => {
      hilog.info(0x0000, 'testTag', `set firewall policy success.`);
    }).catch((error : BusinessError) => {
      hilog.error(0x0000, 'testTag', `error: set firewall policy failed: ${JSON.stringify(error)}`);
    });
    // [End net_firewall_set_net_firewall_policy_domain_names]

    // [Start net_firewall_add_net_firewall_rule_domain_names]
    // 初始化具体的防火墙域名类型规则。
    let domainRule: netFirewall.NetFirewallRule = {
      name: 'rule2',
      description: 'rule2 description',
      direction: netFirewall.NetFirewallRuleDirection.RULE_IN,
      action: netFirewall.FirewallRuleAction.RULE_DENY,
      type: netFirewall.NetFirewallRuleType.RULE_DOMAIN,
      isEnabled: true,
      appUid: 20002,
      domains: [
        {
          isWildcard: false,
          domain: 'www.HarmonyOS.cn'
        },{
        isWildcard: true,
        domain: '*.HarmonyOS.cn'
      }] as domain[],
      userId: 100
    };

    // 添加防火墙规则。
    netFirewall.addNetFirewallRule(domainRule).then((result: number) => {
      // [StartExclude net_firewall_add_net_firewall_rule_domain_names]
      this.domainNameNetworkReqResult = $r('app.string.domain_names_networking_success');
      promptAction.showToast({
        message: this.domainNameNetworkReqResult,
        duration: 4000, // 持续时间
        bottom: 300 // 与底间隔
      });
      // [EndExclude net_firewall_add_net_firewall_rule_domain_names]
      hilog.info(0x0000, 'testTag', `rule Id: ${result}`);
    }, (reason: BusinessError) => {
      // [StartExclude net_firewall_add_net_firewall_rule_domain_names]
      this.domainNameNetworkReqResult = 'error:' + JSON.stringify(reason);
      promptAction.showToast({
        message: this.domainNameNetworkReqResult,
        duration: 4000, // 持续时间
        bottom: 300 // 与底间隔
      });
      // [EndExclude net_firewall_add_net_firewall_rule_domain_names]
      hilog.error(0x0000, 'testTag', `error: add firewall rule failed:  ${JSON.stringify(reason)}`);
    });
    // [End net_firewall_add_net_firewall_rule_domain_names]
  }

}
