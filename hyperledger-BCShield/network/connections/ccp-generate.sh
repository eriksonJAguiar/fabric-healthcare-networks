#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${ORGMSP}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ./ccp-template.json 
}


ORG=hprovider
ORGMSP=HPRovider
P0PORT=7051
CAPORT=7054
PEERPEM=../crypto-config/peerOrganizations/hprovider.healthcare.com/tlsca/tlsca.hprovider.healthcare.com-cert.pem
CAPEM=../crypto-config/peerOrganizations/hprovider.healthcare.com/ca/ca.hprovider.healthcare.com-cert.pem

echo "$(json_ccp $ORG $ORGMSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > ./connection-hprovider.json

ORG=research
ORGMSP=Research
P0PORT=11051
CAPORT=8054
PEERPEM=../crypto-config/peerOrganizations/research.healthcare.com/tlsca/tlsca.research.healthcare.com-cert.pem
CAPEM=../crypto-config/peerOrganizations/research.healthcare.com/ca/ca.research.healthcare.com-cert.pem

echo "$(json_ccp $ORG $ORGMSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > ./connection-research.json

