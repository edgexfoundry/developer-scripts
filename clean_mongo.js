//###############################################################################
//# Copyright 2016-2017 Dell Inc.
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
//EdgeX Mongo DB reset script
//version 1
//author:  Jim White
//Create user for security service in Mongo
db=db.getSiblingDB('metadata')
db.auth('meta','password');
db.addressable.remove({});
db.command.remove({});
db.device.remove({});
db.deviceProfile.remove({});
db.deviceReport.remove({});
db.deviceService.remove({});
db.provisionWatcher.remove({});
db.schedule.remove({});
db.scheduleEvent.remove({});
db=db.getSiblingDB('coredata')
db.auth('core','password');
db.valueDescriptor.remove({});
db.reading.remove({});
db.event.remove({});
db=db.getSiblingDB('logging')
db.auth('logging','password');
db.logEntry.remove({});
