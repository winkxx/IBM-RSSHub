#!/bin/bash
echo
echo "============== <<部署之前先满足以下条件>> =============="
echo "1.你的应用名称"
echo "2.你的应用内存大小"
echo "------------------------------------------------"
read -s -n1 -p "已做好准备请按任意键开始"
echo
echo "------------------------------------------------"

SH_PATH=$(cd "$(dirname "$0")";pwd)
cd ${SH_PATH}

create_mainfest_file(){
    echo "进行配置。。。"
    read -p "请输入你的应用名称：" IBM_APP_NAME
    echo "应用名称：${IBM_APP_NAME}"
    read -p "请输入你的应用内存大小(默认256)：" IBM_MEM_SIZE
    if [ -z "${IBM_MEM_SIZE}" ];then
    IBM_MEM_SIZE=256
    fi
    echo "内存大小：${IBM_MEM_SIZE}"


    cd ~ &&
    sed -i "s/cloud_fonudray_name/${IBM_APP_NAME}/g" ${SH_PATH}/IBM-RSSHub/manifest.yml &&
    sed -i "s/cloud_fonudray_mem/${IBM_MEM_SIZE}/g" ${SH_PATH}/IBM-RSSHub/manifest.yml && 
    echo "配置完成。"
}

clone_repo(){
    echo "进行初始化。。。"
    git clone https://github.com/artxia/IBM-RSSHub
    cd IBM-RSSHub
    git submodule update --init --recursive
    sleep 10s
    echo "初始化完成。"
}

install(){
    echo "进行安装。。。"
# 解除sudu权限限制
    mkdir ~/.npm-global
    npm config set prefix '~/.npm-global'
    sed -i '$a\export PATH=~/.npm-global/bin:$PATH' ~/.profile
    source ~/.profile
#
    cd IBM-RSSHub/RSSHub
    npm i
    cd ..
    ibmcloud target --cf
    ibmcloud cf push
    echo "安装完成。"
    sleep 3s
    echo
}

clone_repo
create_mainfest_file
install
exit 0