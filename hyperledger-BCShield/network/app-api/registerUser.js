/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Gateway, FileSystemWallet } = require('fabric-network');
const path = require('path');

const ccpPath = path.resolve(__dirname, './', 'Config','connection-profile.json');

async function main() {
    try {

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join('./', '_idwallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        var user = 'erikson'
        const userIdentity = wallet.exists(user);
        if (userIdentity) {
            console.log(`An identity for the user "${user}" already exists in the wallet`);
            return;
        }

        // Check to see if we've already enrolled the admin user.
        const adminIdentity = await wallet.exists('admin');
        if (!adminIdentity) {
            console.log('An identity for the admin user "admin" does not exist in the wallet');
            console.log('Run the enrollAdmin.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccpPath, { wallet, identity: 'admin', discovery: { enabled: true, asLocalhost: true } });

        // Get the CA client object from the gateway for interacting with the CA.
        const client = gateway.getClient();
        const ca = client.getCertificateAuthority();
        const adminUser = await client.getUserContext('admin', false);

        // Register the user, enroll the user, and import the new identity into the wallet.
        const secret = await ca.register({ affiliation: 'hprovider.healthcare.com', enrollmentID: user, role: 'client' }, adminUser);
        const enrollment = await ca.enroll({ enrollmentID: user, enrollmentSecret: secret });
        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: 'HProviderMSP',
            type: 'X.509',
        };
        await wallet.put(user, x509Identity);
        console.log(`Successfully registered and enrolled admin user ${user} and imported it into the wallet`);

    } catch (error) {
        console.error(`Failed to register user ${user}: ${error}`);
        process.exit(1);
    }
}

main();
