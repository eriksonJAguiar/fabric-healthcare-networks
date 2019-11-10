
const { FileSystemWallet, Gateway } = require('fabric-network');
const path = require('path');

const ccpPath = path.resolve(__dirname, '..', 'hyperledger-BCShield', 'connection-profile.json');

async function hrecords() {
    try {
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);

        const userExists = await wallet.exists('user1');

        if (!userExists) {

            console.log('An identity for the user "user1" does not exist in the wallet');

            console.log('Run the registerUser.js application before retrying');

            return;

        }

        const gateway = new Gateway();
        await gateway.connect(ccpPath, { wallet, identity: 'user1', discovery: { enabled: true, asLocalhost: true } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('ch1');

        // Get the contract from the network.
        const contract = network.getContract('hchaincode');

        const result = await contract.evaluateTransaction('initRecord', '1111', '8129819821', 'running', '100', '-18212819 01209120');
        console.log('Transaction has been evaluated, result is: ${result.toString()}');

        await gateway.disconnect();

    }catch (error) {
        console.error('Failed to evaluate transaction: ${error}');
        process.exit(1);
    }
}

hrecords();