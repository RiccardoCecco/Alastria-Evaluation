pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Adoption.sol";

contract cnt-name {
  // The address of the adoption contract to be tested
  Adoption adoption = Adoption(DeployedAddresses.Adoption());

  // The id of the pet that will be used for testing
  //uint expectedPetId = adopt-pet;
  uint[total-number] expectedPetId = adopt-pet;

  // The expected owner of adopted pet is this contract
  address expectedAdopter = address(this);

  address adopter_address = a-ad;

  // Testing the adopt() function
function testUserCanAdoptPet() public {
  for (uint256 i; i < total-number; i++) {
      uint returnedId = adoption.adopt(expectedPetId[i], adopter_address);
  }
  //Assert.equal(returnedId, expectedPetId, "Adoption of the expected pet should match what is returned.");
}

// Testing retrieval of all pet owners
function testGetAdopters() public {
  // Store adopters in memory rather than contract's storage
  address[total-adopters] memory adopters = adoption.getAdopters();
  //Assert.equal(adopters[expectedPetId], expectedAdopter, "Owner of the expected pet should be this contract");
  //for (uint256 i; i < total-adopters; i++) {
    //emit Adopters(msg.sender, adopters[i]);
  //}
  emit Adopters(adoption.getAdopters());
}

event Adopters(address[total-adopters] adopter);

}
