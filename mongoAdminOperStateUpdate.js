//###############################################################################
//# Copyright 2017 Dell Inc.
//#
//# Licensed under the Apache License, Version 2.0 (the "License");
//# you may not use this file except in compliance with the License.
//# You may obtain a copy of the License at
//#
//# http://www.apache.org/licenses/LICENSE-2.0
//#
//# Unless required by applicable law or agreed to in writing, software
//# distributed under the License is distributed on an "AS IS" BASIS,
//# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//# See the License for the specific language governing permissions and
//# limitations under the License.
//#
//###############################################################################
//EdgeX Mongo DB California AdminState and OperatingState migration script
//version 1
//author:  Tyler Cox
db=db.getSiblingDB('metadata')
db.getCollectionNames().forEach(function(collname) {
    db[collname].find({ adminState: { $exists: true }}).forEach(function (doc) {
        db[collname].updateMany(
            { "_id": doc._id },
            { $set: { "adminState" : doc.adminState.toUpperCase() } }
        );
    });
    db[collname].find({ operatingState: { $exists: true }}).forEach(function (doc) {
        db[collname].updateMany(
            { "_id": doc._id },
            { $set: { "operatingState" : doc.operatingState.toUpperCase() } }
        );
    });
});