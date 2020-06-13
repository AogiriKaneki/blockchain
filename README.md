# blockchain

Frontend based on https://github.com/daitan-innovation/ethereum-supply-chain
added and update functionality


Setup and Running
The contract logic, migrations and tests use Truffle and Ganache as basic environment, so first and foremost:

launch a terminal

$ npm install -g ganache-cli truffle

We will be using a simple http server to interface with frontend, so :
$ npm install --global http-server <FOR UBUNTU>
$ brew install http-server <OSX>

Install Metamask to enable interactions using the web interface : https://metamask.io/

Run
$ganache-cli

and use same mnemonic to setup MetaMask. After running ganache-cli you will see localhost:8545 in the MetaMask Network Menu, connect to it and import a new account using one of the private keys given in Ganache-cli.

Whenever you want to run the interface again, make sure ganache-cli is using the same mnemonic as the first time, or reconfigure metamask. With ganache running, we need to deploy our contracts. Go to the project folder and run:

$ truffle migrate --reset

go to the utils.js and replace
window.pm.options.address = '0xE5987169978243A040fba66245E982D884108A70'

with your own address as you see in the terminal given by ganache.

With that ready, go to the "web" folder and run http-server to start a web server on port 8080. Open your browser and go to "localhost:8080" to check the interface.

<h3>
As of now, due to incompatibility and conflict between ethereum F.E and Middleware,and constrains of my local env there are some unresolved issues, will be fixing them and taking this forward regardless of the outcome of the assignment.
  </h3>
  
  below are links to the issues:
  https://github.com/MetaMask/metamask-extension/issues/7710
  https://github.com/MetaMask/eth-json-rpc-middleware
