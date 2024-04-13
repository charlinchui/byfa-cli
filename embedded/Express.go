package embedded

import (
 "fmt"
  "log"
  "os"
  "os/exec"
)

func ExpressScript(name string, path string){
sh := fmt.Sprintf(`const #!/bin/sh

name=%s
path=%s
path=$path"/"$name
shift
shift
echo "creating new express API project..."
mkdir $path
cd $path
npm init -y
touch services.js
#Create index.js
[ -e index.js ] && rm index.js
[ -e router.js ] && rm router.js
[ -e services.js ] && rm services.js
[ -e .env ] && rm .env
echo "const express = require('express');
const router = require('./router');
require('dotenv').config();
const app = express();
const PORT = process.env.PORT || 8080;

app.use(express.json());
app.use(router);
app.listen(PORT, () => {
    console.log('APP LISTENING ON PORT 8080');
});" >>index.js
#Create router
echo "const express = require('express');
const services = require('./services');

const router = express.Router();

router.get('/', (req, res) => {
  services.helloService(req,res);
});

module.exports = router" >>router.js
#Create services
echo "
module.exports = {
  helloService : (req, res) => {
    res.status(200).json({
      message: 'I will build an awesome API!'
    })
  }
}" >>services.js
echo "PORT=8080" >>.env
rm package.json
echo '{
      "name":"'$name'",
      "version": "1.0.0",
      "description": "",
      "main": "index.js",
      "scripts": {
        "start": "node index.js",
        "start:dev": "nodemon index.js"
      },
      "keywords": [],
      "author": "",
      "license": "ISC",
      "dependencies": {
      }
    }' >>package.json
npm i express dotenv
`, name, path) 
runner := exec.Command("/bin/bash", "-c", sh)
runner.Stdout = os.Stdout
runner.Stderr = os.Stderr
if err := runner.Run(); err != nil {
log.Fatalln("ERROR CREATING THE PROJECT", err)
}
}