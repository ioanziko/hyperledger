/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');
var fs = require('fs'), path = require('path');

var result = {             
    folders: [],
    files: [],
    content: []
};
var contents = "";
function crawl(dir){
  
  result.folders.push(dir.replace('/usr/local/source/',''));
  var files = fs.readdirSync(dir);
  for(var x in files){
    var next = path.join(dir,files[x]);
    if(fs.lstatSync(next).isDirectory()==true){
      crawl(next);
    }
    else {
      contents = "";
      contents = fs.readFileSync(next, 'utf8');
      result.files.push(next.replace('/usr/local/source/',''));
      result.content.push(contents);
    }
  }

}

class Chaincode extends Contract {

    async initLedger(ctx) {

        console.info('============= END : Initialize Ledger ===========');
    }

    async queryChain(ctx, id) {
        const idAsBytes = await ctx.stub.getState(id); // get the car from chaincode state
        if (!idAsBytes || idAsBytes.length === 0) {
            throw new Error(`${id} does not exist`);
        }
        console.log(idAsBytes.toString());
        return idAsBytes.toString();
    }

    async createIdent(ctx, id, lang, timestamp, descr, owner) {
        console.info('============= START : Create Car ===========');

        result.folders = []; 
        result.files = [];
        result.content = [];
        const mypath = path.join('/usr/local/source', id);
        crawl(mypath);
        console.info(result);
        const data = {
            lang,
            timestamp,
            descr,
            result,
            owner
        };

        await ctx.stub.putState(id, Buffer.from(JSON.stringify(data)));
        console.info('============= END : Create Car ===========');
    }

    async queryAllIdent(ctx) {
        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push(key);
        }
        console.info(allResults);
        return JSON.stringify(allResults);
    }



}

module.exports = Chaincode;
