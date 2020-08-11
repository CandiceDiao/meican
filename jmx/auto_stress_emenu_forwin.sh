#!/usr/bin/env bash

# 压测脚本模板中设定的压测时间应为60秒
export jmx_template="D:\\AutoCode\\meican\\jmx\\emenu"
export suffix=".jmx"
export jmx_template_filename="${jmx_template}${suffix}"

export os_type=`uname`


# 需要在系统变量中定义jmeter根目录的位置，如下
export jmeter_path="D:\\apache-jmeter-5.1.1\\"

echo "美餐网自动化压测全部开始"
# 压测并发数列表
 thread_number_array=(10 20 30 40 50 60 70)

for num in "${thread_number_array[@]}"
do
    # 生成对应压测线程的jmx文件
    # 当次压测的jmx 文件名
    export jmx_filename="${jmx_template}_${num}${suffix}"
    export jtl_filename="test_${num}.jtl"
    export web_report_path_name="D:\\AutoCode\\meican\\jmx\\web_${num}"

    #删除文件
    rm -f ${jmx_filename} ${jtl_filename}
    #删除文件夹
    rm -rf ${web_report_path_name}

    cp ${jmx_template_filename} ${jmx_filename}
    echo "生成jmx压测脚本 ${jmx_filename}"

    if [[ "${os_type}" == "Darwin" ]]; then
        #将jmx文件中的thread_num 替换为 并发数
        #mac 系统" "
        sed -i "" "s/thread_num/${num}/g" ${jmx_filename}
    else
        # liunx系统
        sed -i "s/thread_num/${num}/g" ${jmx_filename}
    fi

    # JMeter 静默压测
    ${jmeter_path}\bin\\jmeter -n -t ${jmx_filename} -l ${jtl_filename}

    # 生成Web压测报告
    ${jmeter_path}\bin\\jmeter -g ${jtl_filename} -e -o ${web_report_path_name}
done
echo "美餐网自动化压测全部结束"

