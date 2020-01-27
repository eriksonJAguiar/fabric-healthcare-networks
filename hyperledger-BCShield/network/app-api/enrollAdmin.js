/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const FabricCAServices = require('fabric-ca-client');
const { FileSystemWallet, X509WalletMixin } = require('fabric-network');
const fs = require('fs');
const path = require('path');

const ccpPath = path.resolve(__dirname, '.', 'Config', 'connection-profile.json');
const ccpJSON = fs.readFileSync(ccpPath, 'utf8');
const ccp = JSON.parse(ccpJSON);

async function main() {
    try {

        if(process.argv.length < 2){
            console('Digite the parameter user and password');
            return;
        }
        
        // Create a new CA client for interacting with the CA.
        const caInfo = ccp.certificateAuthorities['ca.hprovider.healthcare.com'];
        const caTLSCACerts = caInfo.tlsCACerts.path;
        const cert = fs.readFileSync(caTLSCACerts,'utf8')

	const ca = new FabricCAServices(caInfo.url, { trustedRoots: cert, verify: false }, caInfo.caName);

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        const user = process.argv[2];
        const secret = process.argv[3];

        // Check to see if we've already enrolled the admin user.
        const userExists = await wallet.exists(user);
        if (userExists) {
            console.log('An identity for this user already exists in the wallet');
            return;
        }

        // Enroll the admin user, and import the new identity into the wallet.
        const enrollment = await ca.enroll({ enrollmentID: user, enrollmentSecret: secret });
	console.log(enrollment.key.toBytes());
	const identity = X509WalletMixin.createIdentity('HProviderMSP', enrollment.certificate, enrollment.key.toBytes());
	
	await wallet.import(user, identity);
        console.log(`Successfully enrolled user ${user} and imported it into the wallet`);

    } catch (error) {
        console.error(`Failed to enroll admin user "admin": ${error}`);
        process.exit(1);
    }
}

main();
