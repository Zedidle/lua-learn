local model = require("moduletest");
print(model.a, model.b)
require("moduletest2")
print(model.a, model.b)