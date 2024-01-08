#!/bin/bash

CUR_PATH=$(cd $(dirname $0) && pwd)
BASE_PATH=$(dirname ${CUR_PATH})

#时间统计
startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`

#npm
npm config set @ohos:registry=https://repo.harmonyos.com/npm/

#ohpm
#ohpm config set @ohos:registry=https://repo.harmonyos.com/ohpm/

TEST_HAP_PATH=entry/build/default/outputs/ohosTest/entry-ohosTest-unsigned.hap
HAP_PATH=entry/build/default/outputs/default/entry-default-unsigned.hap
STAGE_TEST_HAP_PATH=product/build/default/outputs/ohosTest/product-ohosTest-unsigned.hap
STAGE_HAP_PATH=product/build/default/outputs/default/product-default-unsigned.hap
TIME=16
RESOLVE=0

arg_sign="true"
arg_sdk_path=${BASE_PATH}/sdk
arg_full_sdk_path=${BASE_PATH}/sdk-full
arg_help="0"
arg_compile_dir=""
arg_jdk=""
arg_node=""
arg_ohpm="false"
arg_p=""

url=""
tag_url='url='
name=""
tag_name='name='
branch=""
tag_branch='branch='
tag_full_list='fullSdkAssembleList='
tag_basic_list='basicSignList='
basic_list=()
full_list=()
core_list=()
tag_core_list='coreSignList='
system_app_list=()
tag_system_app_list='systemAppList='
normal_list=()
public_list=()
#没测试用例
simple_list=() 

function print_help() {
  cat <<EOF
  use assembleHap [options] <mainclass> [args...]

    --p=config path
    --sign=true/false - Whether the signature (default:$arg_sign)
    --sdk_path=[public sdk absolute address] (default:$arg_sdk_path)
    --full_sdk_path=[full sdk absolute address] (default:$arg_full_sdk_path)
    --ohpm=true/false -whether use ohpm (default:$arg_ohpm)  
    --help  - prints help screen

EOF
}

function parse_arguments() {
        local helperKey="";
        local helperValue="";
        local current="";

        while [ "$1" != "" ]; do
                current=$1;
                helperKey=${current#*--};
                helperKey=${helperKey%%=*};
                helperKey=$(echo "$helperKey" | tr '-' '_');
                helperValue=${current#*=};
                if [ "$helperValue" == "$current" ]; then
                        helperValue="1";
                fi
                # echo "eval arg_$helperKey=\"$helperValue\"";

                eval "arg_$helperKey=\"$helperValue\"";
                shift
        done
}

parse_arguments ${@};

if [ "$arg_help" != "0" ]; then
        print_help;
        exit 1;
fi

if [ "$arg_p" == "" ]; then
        echo "--p cannot be empty"
        exit 1
fi

if [ "$arg_jdk" != "" ]; then
        export JAVA_HOME=${arg_jdk}
        export PATH=$JAVA_HOME/bin:$PATH
fi

if [ "$arg_node" != "" ]; then
        export NODE_HOME=${arg_node}
        export PATH=$NODE_HOME:$PATH
fi

function clear_dir(){
        if [ ! -d "$1" ]; then
                mkdir -p $1
        else
                rm -rf $1/*
        fi
}
function clear_file(){
        if [ -f "$1" ]; then
                rm $1
        fi
        touch $1
}

function del_dir(){
        if [ -d "$1" ]; then
                rm -rf $1/*
        fi
}
function del_file(){
        if [ -f "$1" ]; then
                rm $1
        fi
}

function is_project_root(){
        if [[ -f $1"/build-profile.json5" && -f $1"/hvigorfile.js" ]] || [[ -f $1"/build-profile.json5" && -f $1"/hvigorfile.ts" ]]; then
                while read line
                do
                        if [[ ${line} =~ "srcPath" ]]; then
                                pa=${line%\"*}
                                pa=${pa##*\".}
                                if [ -d "$1/AppScope" ]; then
                                        is_entry=`cat $1${pa}/src/main/module.json5 | sed 's/ //g' | grep "\"type\":\"entry\""`
                                        is_feature=`cat $1${pa}/src/main/module.json5 | sed 's/ //g' | grep "\"type\":\"feature\""`
                                        if [[ "${is_entry}" != "" || "${is_feature}" != "" ]]; then
                                                if [[ -d $1${pa}"/src/ohosTest" ]]; then
                                                        return 0
                                                fi
                                        fi
                                else
                                        is_entry=`cat $1${pa}/src/main/config.json | sed 's/ //g' | grep "\"moduleType\":\"entry\""`
                                        is_feature=`cat $1${pa}/src/main/config.json | sed 's/ //g' | grep "\"moduleType\":\"feature\""`
                                        if [[ "${is_entry}" != "" || "${is_feature}" != "" ]]; then
                                                if [[ -d $1${pa}"/src/ohosTest" ]]; then
                                                        return 0
                                                fi
                                        fi
                                fi
                        fi
                done < $1"/build-profile.json5"
                return 1
        else
                return 2
        fi
}

function read_project(){
        if [ -d "$1" ]
        then
                # 是项目工程根目录则记录当前路径 否则递归判断
                is_project_root $1
		res=$?
                if [ ${res} -eq 0 ]; then
			public_list[${#public_list[*]}]=${1#*compile-tool/projects/${name}/}
                elif [ ${res} -eq 1 ]; then
                        simple_list[${#simple_list[*]}]=${1#*compile-tool/projects/${name}/}
		elif [ ${res} -eq 2 ]; then
                        for file in `ls $1`
                        do
                                read_project "${1}/${file}"
                        done
                fi
        fi
}

function exclude_full_project(){
	if [ ${#full_list[*]} -eq 0 ]; then
		return
	fi
	diff_list=()
	full_true_list=()
	f=0
	t=0
	flag=0
	for item1 in "${public_list[@]}"; do
		for item2 in "${full_list[@]}"; do
			if [[ "${item1}" == "${item2}" ]]; then
				full_true_list[f]=${item2}
				f=$((f+1))
				flag=1
				break
			fi
		done
		if [ ${flag} -eq 0 ]; then
			diff_list[t]=${item1}
			t=$((t+1))
		else
			flag=0
		fi
	done
	public_list=(${diff_list[@]})
	full_list=(${full_true_list[@]})
	echo "use public sdk project numbers =  "${#public_list[@]}
	echo "use full sdk project numbers =  "${#full_list[@]}
}

function del_module_name(){
        local name=${1}
        for i in "${!module_name[@]}"
        do
                if [[ "${module_name[i]}" == "${name}" ]]; then
                        unset module_name[i]
                        echo "移除"${name}" , 剩余 : "${module_name[@]} >> ${compile_result_error}/${hap}".log" 2>&1
                        return 0
                fi
        done
        return 1
}

function load_dep(){
        local cur_m_n=${1}
	local cur_module
        for cur_module in ${module_list[@]}
        do
                if [[ "${cur_module}" =~ "${cur_m_n}" ]]; then
                        del_module_name ${cur_m_n}
                        for m_n_1 in ${module_name[@]}
                        do
                                rr=$(cat ${cur_module}"/package.json" | grep "${m_n_1}")
                                if [[ "${rr}" != "" ]]; then
                                        load_dep ${m_n_1}
                                fi
                        done
                        cd ${cur_module}
                        echo ${cur_module}" 执行npm install" >> ${compile_result_error}/${hap}".log" 2>&1
                        npm i >> ${compile_result_error}/${hap}".log" 2>&1
                fi
        done
}

function load_oh_dep(){
        local cur_m_n=${1}
	local cur_module
        for cur_module in ${module_list[@]}
        do
                if [[ "${cur_module}" =~ "${cur_m_n}" ]]; then
                        del_module_name ${cur_m_n}
                        for m_n_1 in ${module_name[@]}
                        do
                                rr=$(cat ${cur_module}"/oh-package.json5" | grep "${m_n_1}")
                                if [[ "${rr}" != "" ]]; then
                                        load_oh_dep ${m_n_1}
                                fi
                        done
                        cd ${cur_module}
                        echo ${cur_module}" 执行ohpm install" >> ${compile_result_error}/${hap}".log" 2>&1
                        if [[ -e "oh-package.json5" ]]; then
                                ohpm i >> ${compile_result_error}/${hap}".log" 2>&1
                        else   
                                ohpm init >> ${compile_result_error}/${hap}".log" 2>&1
                                ohpm install >> ${compile_result_error}/${hap}".log" 2>&1
                        fi      
                fi
        done
}


function compile(){
        # echo "compile $1"
        hap=${1////_}
        project_path=${BASE_PATH}/projects/${name}/${1}
	compile_result=${2}
	compile_result_error=${3}
	nosign_hap_result=${4}
        compile_result_success=${5}
        if [ ! -d "${project_path}" ]; then
                echo "${project_path} 路径不存在"
                return
        fi
        
        if [ -e "${project_path}/local.properties" ]; then
                rm ${project_path}"/local.properties"
        fi
        
        # echo "sdk.dir="${arg_full_sdk_path} >> ${project_path}"/local.properties" 2>&1
        cd ${project_path}
        if [[ -e "${project_path}/package.json" ]]; then
                sed -i 's/\"@ohos\/hypium\".*\.[0-9]*\"/\"@ohos\/hypium\": \"1.0.3\"/g' ./package.json
                sed -i 's/\"@ohos\/hvigor-ohos-plugin\".*\.[0-9]*\"/\"@ohos\/hvigor-ohos-plugin\": \"1.3.1\"/g' ./package.json
                sed -i 's/\"@ohos\/hvigor\".*\.[0-9]*\"/\"@ohos\/hvigor\": \"1.3.1\"/g' ./package.json
        fi
	module_list=()
        module_name=()
        out_module=()
	bundle_name=""
        while read line
        do
                if [[ ${line} =~ "srcPath" ]]; then
                        pa=${line%\"*}
                        pa=${pa##*\".}
                        module_list[${#module_list[*]}]=${project_path}${pa}
			del_dir ${project_path}${pa}/node_modules
                        del_file ${project_path}${pa}/package-lock.json
                        del_dir ${project_path}${pa}/oh_modules
                        del_file ${project_path}${pa}/oh-package-lock.json5
                        module_name[${#module_name[*]}]=${pa}
                        if [ -d "${project_path}/AppScope" ]; then
				cur_bundle_line=`cat ${project_path}/AppScope/app.json5 | grep "\"bundleName\""`
                                bundle_name=${cur_bundle_line%\"*}
                                bundle_name=${bundle_name##*\"}
                                # echo "bundleName : "${bundle_name}
                                is_entry=`cat ${project_path}${pa}/src/main/module.json5 | sed 's/ //g' | grep "\"type\":\"entry\""`
                                is_feature=`cat ${project_path}${pa}/src/main/module.json5 | sed 's/ //g' | grep "\"type\":\"feature\""`
                                if [[ "${is_entry}" != "" || "${is_feature}" != "" ]]; then
                                        echo "hap输出module: "${project_path}${pa} >> ${compile_result_error}/${hap}".log" 2>&1
                                        out_module[${#out_module[*]}]=${project_path}${pa}
                                fi
                        else
				cur_bundle_line=`cat ${project_path}${pa}/src/main/config.json | grep "\"bundleName\""`
                                bundle_name=${cur_bundle_line%\"*}
                                bundle_name=${bundle_name##*\"}
                                # echo "bundleName : "${bundle_name}
                                is_entry=`cat ${project_path}${pa}/src/main/config.json | sed 's/ //g' | grep "\"moduleType\":\"entry\""`
                                is_feature=`cat ${project_path}${pa}/src/main/config.json | sed 's/ //g' | grep "\"moduleType\":\"feature\""`
                                if [[ "${is_entry}" != "" || "${is_feature}" != "" ]]; then
                                        echo "hap输出module: "${project_path}${pa} >> ${compile_result_error}/${hap}".log" 2>&1
                                        out_module[${#out_module[*]}]=${project_path}${pa}
                                fi
                        fi
                fi
        done < ${project_path}"/build-profile.json5"

        if [[ -e "${project_path}/oh-package.json5" ]]; then #如果是ohpm包管理方式
                for module in ${module_list[@]}
                do
                        del_module_name ${module##${project_path}}
                        if [ $? -eq 0 ]; then
                                for m_n in ${module_name[@]}
                                do
                                        echo "查找 ${m_n} 是否是${module} 的依赖" >> ${compile_result_error}/${hap}".log" 2>&1
                                        rr=$(cat ${module}"/oh-package.json5" | grep "${m_n}")
                                        if [[ "${rr}" != "" ]]; then
                                                echo "处理循环依赖 : "${m_n} >> ${compile_result_error}/${hap}".log" 2>&1
                                                load_oh_dep ${m_n}
                                        fi
                                        
                                done
                                cd ${module}
                                echo ${module}" 执行ohpm install" >> ${compile_result_error}/${hap}".log" 2>&1

                                if [[ -e "oh-package.json5" ]]; then
                                        ohpm i >> ${compile_result_error}/${hap}".log" 2>&1
                                else   
                                        ohpm init >> ${compile_result_error}/${hap}".log" 2>&1
                                        ohpm install >> ${compile_result_error}/${hap}".log" 2>&1
                                fi    

                        fi
                done
        else 
                for module in ${module_list[@]}
                do
                        del_module_name ${module##${project_path}}
                        if [ $? -eq 0 ]; then
                                for m_n in ${module_name[@]}
                                do
                                        echo "查找 ${m_n} 是否是${module} 的依赖" >> ${compile_result_error}/${hap}".log" 2>&1
                                        rr=$(cat ${module}"/package.json" | grep "${m_n}")
                                        if [[ "${rr}" != "" ]]; then
                                                echo "处理循环依赖 : "${m_n} >> ${compile_result_error}/${hap}".log" 2>&1
                                                load_dep ${m_n}
                                        fi
                                        
                                done
                                cd ${module}
                                echo ${module}" 执行npm install" >> ${compile_result_error}/${hap}".log" 2>&1
                                npm i >> ${compile_result_error}/${hap}".log" 2>&1
                        fi
                done
                
        fi


	cd ${project_path}
	del_dir ${project_path}/node_modules
        del_dir ${project_path}/oh_modules
        del_file ${project_path}/package-lock.json
        del_file ${project_path}/oh-package-lock.json5
        echo ${project_path}" 执行npm install" >> ${compile_result_error}/${hap}".log" 2>&1

        if [[ -e "${project_path}/oh-package.json5" ]]; then
                ohpm i >> ${compile_result_error}/${hap}".log" 2>&1
                chmod +x hvigorw 
                ./hvigorw clean --no-daemon >> ${compile_result_error}/${hap}".log" 2>&1
        else 
                npm install >> ${compile_result_error}/${hap}".log" 2>&1
                node ./node_modules/@ohos/hvigor/bin/hvigor.js clean --no-daemon >> ${compile_result_error}/${hap}".log" 2>&1
        fi



        rm -rf ${project_path}/sign_tool
        cp -r ${BASE_PATH}/tool/sign_tool ${project_path}

	cd ${project_path}/sign_tool
	if [[ $(echo ${basic_list[@]} | grep "${hap//_//}") != "" ]]; then
                echo "${hap} 使用basic签名" >> ${compile_result_error}/${hap}".log" 2>&1
		sed -i "s/\"normal\"/\"system_basic\"/g" ./UnsgnedReleasedProfileTemplate.json >> ${compile_result_error}/${hap}".log" 2>&1
	elif [[ $(echo ${core_list[@]} | grep "${hap//_//}") != "" ]]; then
                echo "${hap} 使用core签名" >> ${compile_result_error}/${hap}".log" 2>&1
		sed -i "s/\"normal\"/\"system_core\"/g" ./UnsgnedReleasedProfileTemplate.json >> ${compile_result_error}/${hap}".log" 2>&1
	fi
	if [[ $(echo ${system_app_list[@]} | grep "${hap//_//}") != "" ]]; then
                echo "${hap} 系统应用" >> ${compile_result_error}/${hap}".log" 2>&1
		sed -i "s/\"hos_normal_app\"/\"hos_system_app\"/g" ./UnsgnedReleasedProfileTemplate.json >> ${compile_result_error}/${hap}".log" 2>&1
	fi
	if [ "${bundle_name}" != "" ]; then
                echo "bundleName = ${bundle_name}" >> ${compile_result_error}/${hap}".log" 2>&1
                sed -i "s/\"com.OpenHarmony.app.test\"/\"${bundle_name}\"/g" ./UnsgnedReleasedProfileTemplate.json >> ${compile_result_error}/${hap}".log" 2>&1
        fi


	sign_hap_num=0
        for module in ${out_module[@]}
        do
		cd ${project_path}
                cur_out_module_name=${module##*/}
                if [[ -e "${project_path}/oh-package.json5" ]]; then
                        chmod +x hvigorw
		        ./hvigorw --mode module -p module=${cur_out_module_name} assembleHap --no-daemon >> ${compile_result_error}/${hap}".log" 2>&1
                        if [[ -d ${module}"/src/ohosTest" ]]; then
		                ./hvigorw --mode module -p module=${cur_out_module_name}@ohosTest assembleHap --no-daemon >> ${compile_result_error}/${hap}".log" 2>&1
                        fi
                else 
		        node ./node_modules/@ohos/hvigor/bin/hvigor.js --mode module -p module=${cur_out_module_name} assembleHap  --no-daemon>> ${compile_result_error}/${hap}".log" 2>&1
                        if [[ -d ${module}"/src/ohosTest" ]]; then
		                node ./node_modules/@ohos/hvigor/bin/hvigor.js --mode module -p module=${cur_out_module_name}@ohosTest assembleHap  --no-daemon>> ${compile_result_error}/${hap}".log" 2>&1
                        fi
                fi

                is_sign=false
                echo "module = ${module} , cur_out_module_name=${cur_out_module_name}" >> ${compile_result_error}/${hap}".log" 2>&1
                if [ ! -d ${module}/build/default/outputs/default/ -o ! -d ${module}/build/default/outputs/ohosTest/ -a -d ${module}"/src/ohosTest" ]; then
                        echo "module = ${module}, assembleHap error !!!" >> ${compile_result_error}/${hap}".log" 2>&1
                        continue
                fi
		sign_hap_path=""
		test_sign_hap_path=""
		nosign_hap_path=""
		test_nosign_hap_path=""
		for out_file in `ls ${module}/build/default/outputs/default/`
		do
			if [[ "${out_file}" =~ "-unsigned.hap" ]]; then
				echo "发现unsigned包 : "${out_file}",开始使用签名工具签名" >> ${compile_result_error}/${hap}".log" 2>&1
				nosign_hap_path=${module}/build/default/outputs/default/${out_file}
				sign_hap_path=${module}/build/default/outputs/default/${out_file/unsigned/signed}
				cd ${project_path}/sign_tool
				java -jar ${BASE_PATH}/tool/hap-sign-tool.jar sign-profile -keyAlias "openharmony application profile release" -signAlg "SHA256withECDSA" -mode "localSign" -profileCertFile "OpenHarmonyProfileRelease.pem" -inFile "UnsgnedReleasedProfileTemplate.json" -keystoreFile "OpenHarmony.p12" -outFile "openharmony_sx.p7b" -keyPwd "123456" -keystorePwd "123456" >> ${compile_result_error}/${hap}".log" 2>&1
				java -jar ${BASE_PATH}/tool/hap-sign-tool.jar sign-app -keyAlias "openharmony application release" -signAlg "SHA256withECDSA" -mode "localSign" -appCertFile "OpenHarmonyApplication.pem" -profileFile "openharmony_sx.p7b" -inFile "${nosign_hap_path}" -keystoreFile "OpenHarmony.p12" -outFile "${sign_hap_path}" -keyPwd "123456" -keystorePwd "123456" >> ${compile_result_error}/${hap}".log" 2>&1
			fi
		done

                if [[ -d ${module}"/src/ohosTest" ]]; then
                        for out_file in `ls ${module}/build/default/outputs/ohosTest/`
                        do
                                if [[ "${out_file}" =~ "-unsigned.hap" ]]; then
                                        echo "发现unsigned包 : "${out_file}",开始使用签名工具签名" >> ${compile_result_error}/${hap}".log" 2>&1
                                        test_nosign_hap_path=${module}/build/default/outputs/ohosTest/${out_file}
                                        test_sign_hap_path=${module}/build/default/outputs/ohosTest/${out_file/unsigned/signed}
                                        cd ${project_path}/sign_tool
                                        java -jar ${BASE_PATH}/tool/hap-sign-tool.jar sign-profile -keyAlias "openharmony application profile release" -signAlg "SHA256withECDSA" -mode "localSign" -profileCertFile "OpenHarmonyProfileRelease.pem" -inFile "UnsgnedReleasedProfileTemplate.json" -keystoreFile "OpenHarmony.p12" -outFile "openharmony_sx.p7b" -keyPwd "123456" -keystorePwd "123456" >> ${compile_result_error}/${hap}".log" 2>&1
                                        java -jar ${BASE_PATH}/tool/hap-sign-tool.jar sign-app -keyAlias "openharmony application release" -signAlg "SHA256withECDSA" -mode "localSign" -appCertFile "OpenHarmonyApplication.pem" -profileFile "openharmony_sx.p7b" -inFile "${test_nosign_hap_path}" -keystoreFile "OpenHarmony.p12" -outFile "${test_sign_hap_path}" -keyPwd "123456" -keystorePwd "123456" >> ${compile_result_error}/${hap}".log" 2>&1
                                fi
                        done
                fi

		if [[ ${sign_hap_path} != "" && -f ${sign_hap_path} && ( -f ${test_sign_hap_path} || ! -d ${module}"/src/ohosTest") ]]; then
			cp ${sign_hap_path} ${compile_result}/${hap}_${cur_out_module_name}_signed.hap
			cp ${nosign_hap_path} ${nosign_hap_result}/${hap}_${cur_out_module_name}_signed.hap
                        
                        if [[ -d ${module}"/src/ohosTest" ]]; then
                                cp ${test_sign_hap_path} ${compile_result}/${hap}_${cur_out_module_name}_ohosTest_signed.hap
                                cp ${test_nosign_hap_path} ${nosign_hap_result}/${hap}_${cur_out_module_name}_ohosTest_signed.hap
                        fi
			sign_hap_num=$(expr ${sign_hap_num} + 1)
			echo "${module} assembleHap success !!!" >> ${compile_result_error}/${hap}".log" 2>&1
		else
			echo "${module} assembleHap error !!!" >> ${compile_result_error}/${hap}".log" 2>&1
		fi
        done
        if [[ ${#out_module[@]} == ${sign_hap_num} ]]; then
                #rm ${compile_result_error}/${hap}".log"
                mv ${compile_result_error}/${hap}.log ${compile_result_success}/${hap}.log
                echo "success compile ${hap} !!! "
	else
		echo "error   compile ${hap} QwQ ,log at ${compile_result_error}/${hap}.log"
	fi
}


function compile_project(){
        echo "use public sdk compile..."
        project_path=${1}
        project_name=${2}
        COMPILE_RESULT=${BASE_PATH}/out/${project_name}/public-sdk/hap-out-with-nosigned
        COMPILE_RESULT_ERROR=${BASE_PATH}/out/${project_name}/public-sdk/compile-error-log
        COMPILE_RESULT_SUCCESS=${BASE_PATH}/out/${project_name}/public-sdk/compile-success-log
        SIGN_RESULT=${BASE_PATH}/out/${project_name}/public-sdk/hap-out-with-signed

        clear_dir $COMPILE_RESULT
        clear_dir $COMPILE_RESULT_ERROR
        clear_dir $COMPILE_RESULT_SUCCESS
        clear_dir $SIGN_RESULT


        export OHOS_SDK_HOME=${arg_sdk_path}
        export OHOS_BASE_SDK_HOME=${arg_sdk_path}
        echo "OHOS_SDK_HOME="${OHOS_SDK_HOME}
        echo "OHOS_BASE_SDK_HOME="${OHOS_BASE_SDK_HOME}
        
	EOF=0
        curr=0
        while [ $EOF -ne 1 ]; do
                for ((i=1; i<=$TIME; i++)); do
                        if  [ ${curr} -eq ${#public_list[@]} ]; then
                                EOF=1
                                break
                        fi
                        compile ${public_list[$curr]} ${SIGN_RESULT} ${COMPILE_RESULT_ERROR} ${COMPILE_RESULT} ${COMPILE_RESULT_SUCCESS} &
                        curr=$((curr+1))
                done
                wait
        done
}

function compile_project_full(){
        echo "use full sdk compile..."
        project_path=${1}
        project_name=${2}
        COMPILE_RESULT=${BASE_PATH}/out/${project_name}/full-sdk/hap-out-with-nosigned
        COMPILE_RESULT_ERROR=${BASE_PATH}/out/${project_name}/full-sdk/compile-error-log
        COMPILE_RESULT_SUCCESS=${BASE_PATH}/out/${project_name}/full-sdk/compile-success-log
        SIGN_RESULT=${BASE_PATH}/out/${project_name}/full-sdk/hap-out-with-signed

        clear_dir $COMPILE_RESULT
        clear_dir $COMPILE_RESULT_ERROR
        clear_dir $COMPILE_RESULT_SUCCESS
        clear_dir $SIGN_RESULT

        export OHOS_SDK_HOME=${arg_full_sdk_path}
        export OHOS_BASE_SDK_HOME=${arg_full_sdk_path}
        echo "OHOS_SDK_HOME="${OHOS_SDK_HOME}
        echo "OHOS_BASE_SDK_HOME="${OHOS_BASE_SDK_HOME}

	EOF=0
        curr=0
        while [ $EOF -ne 1 ]; do
                for ((i=1; i<=$TIME; i++)); do
                        if  [ ${curr} -eq ${#full_list[@]} ]; then
                                EOF=1
                                break
                        fi
                        compile ${full_list[$curr]} ${SIGN_RESULT} ${COMPILE_RESULT_ERROR} ${COMPILE_RESULT} ${COMPILE_RESULT_SUCCESS} &
                        curr=$((curr+1))
                done
                wait
        done
}

function load(){
	project_url=${1}
	project_branch=${2}
	project_name=${3}
	# if test -d ${BASE_PATH}/projects/${project_name}
 	# then
        #         echo "${project_name} exists,ready for update..."
        #         cd ${BASE_PATH}/projects/${project_name}
        #         git reset --hard origin/${project_branch}
        #         git checkout -b ${project_branch} origin/${project_branch}
        #         git checkout ${project_branch}
        #         git lfs fetch origin ${project_branch}
	# 	git pull
        # else
        #         echo "${project_name} dose not exist,ready to download..."
        #         if [ ! -d ${BASE_PATH}/projects ]; then
	# 		mkdir -p ${BASE_PATH}/projects
	# 	fi
        #         cd ${BASE_PATH}/projects
        #         git lfs clone -b ${project_branch} ${project_url} ${project_name}
        #         git checkout -b ${project_branch} origin/${project_branch}
        # fi
        if [ -d "${BASE_PATH}/projects/${project_name}/${arg_compile_dir}" ]; then
                read_project ${BASE_PATH}/projects/${project_name}/${arg_compile_dir}
                exclude_full_project
		compile_project ${BASE_PATH}/projects/${project_name} ${project_name}
		compile_project_full ${BASE_PATH}/projects/${project_name} ${project_name}
        fi
}


while read line
do
        if [[ ${line} == ${tag_url}* ]]; then
                url=${line##*${tag_url}}
        elif [[ ${line} == ${tag_branch}* ]]; then
                branch=${line##*${tag_branch}}
        elif [[ ${line} == ${tag_name}* ]]; then
                name=${line##*${tag_name}}
        elif [[ ${line} == ${tag_full_list}* ]]; then
                temp_string=${line##*${tag_full_list}}
                full_list=(${temp_string//;/ })
        elif [[ ${line} == ${tag_basic_list}* ]]; then
                temp_string=${line##*${tag_basic_list}}
                basic_list=(${temp_string//;/ })
        elif [[ ${line} == ${tag_core_list}* ]]; then
                temp_string=${line##*${tag_core_list}}
                core_list=(${temp_string//;/ })
	elif [[ ${line} == ${tag_system_app_list}* ]]; then
                temp_string=${line##*${tag_system_app_list}}
                system_app_list=(${temp_string//;/ })
        fi
done < ${arg_p}

load ${url} ${branch} ${name}

endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`
sumTime=$[ $endTime_s - $startTime_s ]

# echo "$startTime ---> $endTime" "耗时:$sumTime seconds"
# echo "| public-sdk--|-------------|-------------|-------------|-------------|-------------"
# echo "| 仓库        | 项目数量    | 成功数量    | 失败数量    | Hap数量    | 签名成功    "
# echo "|-------------|-------------|-------------|-------------|-------------"
# echo "| ${name} | ${#public_list[@]}         | $(ls -l ${BASE_PATH}/out/${name}/public-sdk/compile-success-log|grep "^-"|wc -l)           | $(ls -l ${BASE_PATH}/out/${name}/public-sdk/compile-error-log|grep "^-"|wc -l)           | "`expr $(ls -l ${BASE_PATH}/out/${name}/public-sdk/hap-out-with-nosigned|grep "^-"|wc -l) / 2`"         | "`expr $(ls -l ${BASE_PATH}/out/${name}/public-sdk/hap-out-with-signed|grep "^-"|wc -l) / 2`
# if (( $(ls -l ${BASE_PATH}/out/${name}/public-sdk/compile-error-log|grep "^-"|wc -l) > 0 )); then
#         echo "| 失败项目列表|-------------|-------------|-------------|-------------|-------------"
# 	for z in `ls ${BASE_PATH}/out/${name}/public-sdk/compile-error-log`
#         do
#                 z=${z//_//}
#                 z=${z%.log}
#                 echo "| "${z}" |"
#         done
# fi
# echo "| 失败项目日志汇总地址|-------------|-------------|-------------|-------------------"
# echo "| ${BASE_PATH}/out/${name}/public-sdk/compile-error-log"
# echo "| full-sdk----|-------------|-------------|-------------|-------------|-------------"
# echo "| 仓库        | 项目数量    | 成功数量    | 失败数量    | Hap数量    | 签名成功    "
# echo "|-------------|-------------|-------------|-------------|-------------|-------------"
# echo "| ${name} | ${#full_list[@]}          | $(ls -l ${BASE_PATH}/out/${name}/full-sdk/compile-success-log|grep "^-"|wc -l)           | $(ls -l ${BASE_PATH}/out/${name}/full-sdk/compile-error-log|grep "^-"|wc -l)           | "`expr $(ls -l ${BASE_PATH}/out/${name}/full-sdk/hap-out-with-nosigned|grep "^-"|wc -l) / 2`"          | "`expr $(ls -l ${BASE_PATH}/out/${name}/full-sdk/hap-out-with-signed|grep "^-"|wc -l) / 2`
# if (( $(ls -l ${BASE_PATH}/out/${name}/full-sdk/compile-error-log|grep "^-"|wc -l) > 0 )); then
#         echo "| 失败项目列表|-------------|-------------|-------------|-------------|-------------"
# 	for z in `ls ${BASE_PATH}/out/${name}/full-sdk/compile-error-log`
#         do
#                 z=${z//_//}
#                 z=${z%.log}
#                 echo "| "${z}" |"
#         done
# fi
# echo "| 失败项目日志汇总地址|-------------|-------------|-------------------"
# echo "| ${BASE_PATH}/out/${name}/full-sdk/compile-error-log"
# echo "|-------------|-------------|-------------|-------------|-------------"
# echo "| 成功项目日志汇总地址|-------------|-------------|-------------------"
# echo "| ${BASE_PATH}/out/${name}/full-sdk/compile-success-log"
# echo "| 不含测试用例项目|-------------|-------------|-------------------"
#         for simple in ${simple_list[@]};do
#         echo "| "${simple}" |"
#         done
# echo "|-------------|-------------|-------------|-------------|-------------"
# echo "compile completed..."
if [[ $(ls -l ${BASE_PATH}/out/${name}/public-sdk/compile-error-log|grep "^-"|wc -l) -gt 0 ]] || [[ $(ls -l ${BASE_PATH}/out/${name}/full-sdk/compile-error-log|grep "^-"|wc -l) -gt 0 ]];then
        echo  "hap_build fail"
else
        echo "hap_build success"
fi