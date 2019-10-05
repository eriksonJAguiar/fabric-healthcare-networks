/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class HealthcareLogsContract extends Contract {


    async healthcareLogsExists(ctx, healthcareLogsId) {
        const buffer = await ctx.stub.getState(healthcareLogsId);
        return (!!buffer && buffer.length > 0);
    }

    async createHealthcareLogs(ctx, healthcareLogsId, acessUser, owner, documentId, documentType, timeAccess) {
        const exists = await this.healthcareLogsExists(ctx, healthcareLogsId);
        if (exists) {
            throw new Error(`The healthcare logs ${healthcareLogsId} already exists`);
        }
        const dicomLogs = { 
            acessUser,  
            owner,
            documentId,
            documentType,
            timeAccess
        };
        const buffer = Buffer.from(JSON.stringify(dicomLogs));
        await ctx.stub.putState(healthcareLogsId, buffer);
    }

    async readHealthcareLogs(ctx, healthcareLogsId) {
        const exists = await this.healthcareLogsExists(ctx, healthcareLogsId);
        if (!exists) {
            throw new Error(`The healthcare logs ${healthcareLogsId} does not exist`);
        }
        const buffer = await ctx.stub.getState(healthcareLogsId);
        const asset = JSON.parse(buffer.toString());
        return asset;
    }

    /*async updateHealthcareLogs(ctx, healthcareLogsId, newValue) {
        const exists = await this.healthcareLogsExists(ctx, healthcareLogsId);
        if (!exists) {
            throw new Error(`The healthcare logs ${healthcareLogsId} does not exist`);
        }
        const asset = { value: newValue };
        const buffer = Buffer.from(JSON.stringify(asset));
        await ctx.stub.putState(healthcareLogsId, buffer);
    }*/


    /*async deleteHealthcareLogs(ctx, healthcareLogsId) {
        const exists = await this.healthcareLogsExists(ctx, healthcareLogsId);
        if (!exists) {
            throw new Error(`The healthcare logs ${healthcareLogsId} does not exist`);
        }
        await ctx.stub.deleteState(healthcareLogsId);
    }*/

}

module.exports = HealthcareLogsContract;
