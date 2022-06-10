const Adoption = artifacts.require("Adoption");

// Utils
const ether = (n) => {
  return new web3.utils.BN(
    web3.utils.toWei(n.toString(), 'ether')
  )
}

module.exports = async function(callback) {
  try {
    // Fetch accounts from wallet - these are unlocked
    const accounts = await web3.eth.getAccounts()

    // Fetch the deployed exchange
    const adoption = await Adoption.deployed()
    //console.log('Exchange fetched', exchange.address)

    const adopters = await adoption.getAdopters();

    console.log(adopters);

  }
  catch(error) {
    console.log(error)
  }

  callback()
}
