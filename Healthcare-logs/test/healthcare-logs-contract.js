/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { ChaincodeStub, ClientIdentity } = require('fabric-shim');
const { HealthcareLogsContract } = require('../lib/healthcare-logs-contract');
const winston = require('winston');

const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');
const sinon = require('sinon');
const sinonChai = require('sinon-chai');

chai.should();
chai.use(chaiAsPromised);
chai.use(sinonChai);

class TestContext {

    constructor() {
        this.stub = sinon.createStubInstance(ChaincodeStub);
        this.clientIdentity = sinon.createStubInstance(ClientIdentity);
        this.logging = {
            getLogger: sinon.stub().returns(sinon.createStubInstance(winston.createLogger().constructor)),
            setLevel: sinon.stub(),
        };
    }

}

describe('HealthcareLogsContract', () => {

    let contract;
    let ctx;

    beforeEach(() => {
        contract = new HealthcareLogsContract();
        ctx = new TestContext();
        ctx.stub.getState.withArgs('1001').resolves(Buffer.from('{"value":"healthcare logs 1001 value"}'));
        ctx.stub.getState.withArgs('1002').resolves(Buffer.from('{"value":"healthcare logs 1002 value"}'));
    });

    describe('#healthcareLogsExists', () => {

        it('should return true for a healthcare logs', async () => {
            await contract.healthcareLogsExists(ctx, '1001').should.eventually.be.true;
        });

        it('should return false for a healthcare logs that does not exist', async () => {
            await contract.healthcareLogsExists(ctx, '1003').should.eventually.be.false;
        });

    });

    describe('#createHealthcareLogs', () => {

        it('should create a healthcare logs', async () => {
            await contract.createHealthcareLogs(ctx, '1003', 'healthcare logs 1003 value');
            ctx.stub.putState.should.have.been.calledOnceWithExactly('1003', Buffer.from('{"value":"healthcare logs 1003 value"}'));
        });

        it('should throw an error for a healthcare logs that already exists', async () => {
            await contract.createHealthcareLogs(ctx, '1001', 'myvalue').should.be.rejectedWith(/The healthcare logs 1001 already exists/);
        });

    });

    describe('#readHealthcareLogs', () => {

        it('should return a healthcare logs', async () => {
            await contract.readHealthcareLogs(ctx, '1001').should.eventually.deep.equal({ value: 'healthcare logs 1001 value' });
        });

        it('should throw an error for a healthcare logs that does not exist', async () => {
            await contract.readHealthcareLogs(ctx, '1003').should.be.rejectedWith(/The healthcare logs 1003 does not exist/);
        });

    });

    describe('#updateHealthcareLogs', () => {

        it('should update a healthcare logs', async () => {
            await contract.updateHealthcareLogs(ctx, '1001', 'healthcare logs 1001 new value');
            ctx.stub.putState.should.have.been.calledOnceWithExactly('1001', Buffer.from('{"value":"healthcare logs 1001 new value"}'));
        });

        it('should throw an error for a healthcare logs that does not exist', async () => {
            await contract.updateHealthcareLogs(ctx, '1003', 'healthcare logs 1003 new value').should.be.rejectedWith(/The healthcare logs 1003 does not exist/);
        });

    });

    describe('#deleteHealthcareLogs', () => {

        it('should delete a healthcare logs', async () => {
            await contract.deleteHealthcareLogs(ctx, '1001');
            ctx.stub.deleteState.should.have.been.calledOnceWithExactly('1001');
        });

        it('should throw an error for a healthcare logs that does not exist', async () => {
            await contract.deleteHealthcareLogs(ctx, '1003').should.be.rejectedWith(/The healthcare logs 1003 does not exist/);
        });

    });

});