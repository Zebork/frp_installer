#!/bin/bash

HELP="Usage: frp_installer.sh install/uninstall"

get_latest_version(){
    ver=$(wget --no-check-certificate -qO- https://api.github.com/repos/fatedier/frp/releases/latest | grep 'tag_name' | cut -d\" -f4)
    [ -z ${ver} ] && echo "Error: Get frp latest version failed" && exit 1
    frp_ver="frp_$(echo ${ver} | sed -e 's/^[a-zA-Z]//g')_linux_amd64"
    frp_file="$frp_ver.tar.gz"
    download_link="https://github.com/fatedier/frp/releases/download/$ver/$frp_file"
    init_script_link="https://raw.githubusercontent.com/zebork/frp_installer/master/init_script/frp"
    echo "Got latest_verison"
}

download_files(){
    wget --no-check-certificate -qO "/tmp/$frp_file" $download_link
    wget --no-check-certificate -qO "/tmp/frp_init_script" $init_script_link
    echo "Download files completed"
}

extract_files(){
    cd /tmp
    rm -rf "/tmp/$frp_ver"
    tar zxvf $frp_file -C /tmp
    echo "Extract files completed"
}

drop_files(){
    cp /tmp/$frp_ver/frpc /usr/local/bin/
    #cp /tmp/$frp_ver/frps /usr/local/bin/
    if [ ! -f /etc/frp/frpc.ini ]; then
        mkdir -p /etc/frp/
        cp /tmp/$frp_ver/frpc.ini /etc/frp/
    fi

    if [ ! -f /etc/frp/frpc_full.ini ]; then
        cp /tmp/$frp_ver/frpc_full.ini /etc/frp/
    fi

    chmod 755 /usr/local/bin/frpc
    #chmod 755 /usr/local/bin/frps
    cp /tmp/frp_init_script /etc/init.d/frp
    chmod 755 /etc/init.d/frp
    echo "Installed frp"
    rm -rf /tmp/$frp_ver/
    rm /tmp/$frp_file
}

update_rc(){
    update-rc.d frp defaults 99
    echo "Startup OK!"
}

install() {
    get_latest_version
    download_files
    extract_files
    drop_files
    update_rc
}

uninstall(){
    pkill frpc
    update-rc.d frp remove
    rm /etc/init.d/frp
    #rm -rf /etc/frp
    rm /usr/local/bin/frp*
    echo "Uninstall Completed"
}

arg_len=$#
if [ $arg_len -ne 1 ]; then
    echo $HELP
    exit 0
fi

arg_order=$1

if [ $arg_order == "install" ]; then
    install
elif [ $arg_order == "uninstall" ]; then
    uninstall
else
    echo $HELP
    exit 0
fi
