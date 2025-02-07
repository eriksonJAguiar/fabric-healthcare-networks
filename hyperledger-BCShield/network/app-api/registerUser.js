/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { FileSystemWallet, Gateway, X509WalletMixin } = require('fabric-network');
const path = require('path');

const ccpPath = path.resolve(__dirname, '.', 'Config', 'connection-profile.json');

async function main() {
    try {

        if(process.argv.length < 2){
            console('Input the parameter admin and user');
            return;
        }

        
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        const admin = process.argv[2];
        const user = process.argv[3];

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(user);
        if (userExists) {
            console.log('An identity for the user ' + user + ' already exists in the wallet');
            return;
        }

        // Check to see if we've already enrolled the admin user.
        const adminExists = await wallet.exists(admin);
        if (!adminExists) {
            console.log('An identity for the admin user "admin" does not exist in the wallet');
            console.log('Run the enrollAdmin.js application before retrying');
            return;
        }

        // // Create a new gateway for connecting to our peer node.
        // const gateway = new Gateway();
        // await gateway.connect(ccpPath, { wallet, identity: 'admin', discovery: { enabled: true, asLocalhost: true } });

        // // Get the CA client object from the gateway for interacting with the CA.
        // const ca = gateway.getClient().getCertificateAuthority();
        // const adminIdentity = gateway.getCurrentIdentity();

        // // Register the user, enroll the user, and import the new identity into the wallet.
        // const secret = await ca.register({ affiliation: 'hprovider.healthcare.com', enrollmentID: user, role: 'client' }, adminIdentity);
        // console.log('Successfully registered user ' + user + ' and the secret is ' + secret );

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccpPath, { wallet, identity: admin, discovery: { enabled: true, asLocalhost: true } });
	
        // Get the CA client object from the gateway for interacting with the CA.
        const client = gateway.getClient();
        const ca = client.getCertificateAuthority();
        const adminUser = await client.getUserContext(admin, false);

        // Register the user, enroll the user, and import the new identity into the wallet.
        const secret = await ca.register({ affiliation: 'org1.department1', enrollmentID: user, role: 'client' }, adminUser);
        const enrollment = await ca.enroll({ enrollmentID: user, enrollmentSecret: secret });
        const userIdentity = X509WalletMixin.createIdentity('HProviderMSP', enrollment.certificate, enrollment.key.toBytes());
        await wallet.import(user, userIdentity);
        console.log('Successfully registered and enrolled admin user '+ user +' and imported it into the wallet');


    } catch (error) {
        console.error(`Failed to register user user1: ${error}`);
        process.exit(1);
    }
}

main();
