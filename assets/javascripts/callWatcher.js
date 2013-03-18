callLog = [];

function myCall() {
  Function.prototype.call = oldCall;

  var entry = {this:this, name:this.name, args:{}};
  for (var key in arguments) {
    if (arguments.hasOwnProperty(key)) {
      entry.args[key] = arguments[key];
    }
  }
  callLog.push(entry);

  this(arguments);

  Function.prototype.call = myCall;
}

function registerFunctionWatcher() {
  oldCall = Function.prototype.call;
  Function.prototype.call = myCall;
}

function removeFunctionWatcher() {
  Function.prototype.call = oldCall;
}
