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

    console.log(`I am ${accounts[a-ad]}`)

    //console.log('Exchange fetched', exchange.address)


    while (true){
      var startTime = performance.now()
      const r_n = getRandomInt(total-number)
      const adoption = await Adoption.deployed()

      const free = await adoption.isExisting(r_n)

      if (free) {
        //const adopters = await adoption.getAdopters();
        await adoption.adopt(r_n, {from: accounts[a-ad]})
        console.log(`Pet ${r_n} has been adopted`)
        var endTime = performance.now()
        console.log(`Execution time of a transaction: ${endTime - startTime} ms`)
        break
      }else {
        var endTime = performance.now()
        console.log(`Execution time of a transaction: ${endTime - startTime} ms`)
        console.log(`Pet ${r_n} already adopted`)
      }
    }

  }
  catch(error) {
    console.log(error)
  }

  callback()
}
