#!/bin/bash

source "/vagrant/scripts/common.sh"


while getopts t:r: option; do
    case $option in
        t) TOTAL_NODES=$OPTARG;;
    esac
done


function installFlink {
    downloadApacheFile flink ${FLINK_VERSION} "${FLINK_VERSION}-bin-hadoop2-scala_2.11.tgz"

    tar -oxzf $TARBALL -C /opt
    safeSymLink "/opt/${FLINK_VERSION}" /opt/flink

    mkdir -p /var/log/flink

}

function configureFlink {
    echo "Configuring Flink"

    sed -i 's/jobmanager.rpc.address.*/jobmanager.rpc.address: 10.0.0.101/' /opt/flink/conf/flink-conf.yaml 

    rm /opt/flink/conf/slaves


    for i in $(seq 2 $TOTAL_NODES); do
        echo "node${i}" >> /opt/flink/conf/slaves
    done




}



echo "Setting up Flink"
installFlink
configureFlink



