const Adoption = artifacts.require("Adoption");
const { performance } = require('perf_hooks');

// Utils
const ether = (n) => {
  return new web3.utils.BN(
    web3.utils.toWei(n.toString(), 'ether')
  )
}

function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

module.exports = async function(callback) {
  try {
    // Fetch accounts from wallet - these are unlocked
    const accounts = await web3.eth.getAccounts()

    console.log(`I am ${accounts[19]}`)

    //console.log('Exchange fetched', exchange.address)

    var initialTime = performance.now()
    var endTime
    var startTime

    while (true){
      startTime = performance.now()
      const r_n = getRandomInt(50)
      const adoption = await Adoption.deployed()

      const free = await adoption.isExisting(r_n)

      if (free) {
        //const adopters = await adoption.getAdopters();
        await adoption.adopt(r_n, {from: accounts[19]})
        console.log(`Pet ${r_n} has been adopted`)
        endTime = performance.now()
        console.log(`TimeTransaction: ${endTime - startTime} ms`)
        break
      }else {
        console.log(`Pet ${r_n} already adopted`)
        endTime = performance.now()
        console.log(`TimeTransaction: ${endTime - startTime} ms`)
      }
    }
    console.log(`TotalTime ${endTime - initialTime} ms`)
  }
  catch(error) {
    console.log(error)
  }

  callback()
}
