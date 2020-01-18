/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class HealthcareLabsContract extends Contract {


    async healthcareLabsExists(ctx, labsId) {
        const buffer = await ctx.stub.getState(labsId);
        return (!!buffer && buffer.length > 0);
    }

    async createHealthcareLabs(ctx, labsId, refDocument, refIFPS, owner, documentType, timestamp) {
        const exists = await this.healthcareLabsExists(ctx, labsId);
        if (exists) {
            throw new Error(`The healthcare logs ${labsId} already exists`);
        }
        const labs = { 
            refDocument,
            refIFPS,
            owner,
            documentType,
            timestamp
        };
        const buffer = Buffer.from(JSON.stringify(labs));
        await ctx.stub.putState(labsId, buffer);
    }

    async readHealthcareLabs(ctx, labsId) {
        const exists = await this.healthcareLabsExists(ctx, labsId);
        if (!exists) {
            throw new Error(`The healthcare logs ${labsId} does not exist`);
        }
        const buffer = await ctx.stub.getState(labsId);
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

module.exports = HealthcareLabsContract;
