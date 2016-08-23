
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("createUser", function(request, response)
{  
  var creatingUser = request.user; 
  var email = request.params.email; // string required
	var tempPass = request.params.password; // string
	var firstName = request.params.firstName;
	var lastName = request.params.lastName;
	var group = request.params.group;
	var supervisorId = request.params.supervisorId;
    var beacon = request.params.beacon;

    var createjs = require("cloud/createUser.js");
    createjs.createUser(creatingUser,email,tempPass,firstName,lastName,group,supervisorId,beacon,response);
});
