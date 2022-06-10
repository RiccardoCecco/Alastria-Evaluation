pragma solidity ^0.5.0;

contract Adoption {
	address[20] public adopters;

	function isExisting(uint petId) public view returns (bool) {
				 require(petId >= 0 && petId <= 19);
	       if(adopters[petId] == address(0)) {
	            return true;
	        }
	        else{
	            return false;
	        }
	        return false;
	    }
	// Adopting a pet
	function adopt(uint petId) public returns (bool) {
		require(petId >= 0 && petId <= 19);
		if(adopters[petId] == address(0)) {
			adopters[petId] = msg.sender;
			return true;
		}else {
			return false;
		}
	}

	// Retrieving the adopters
	function getAdopters() public view returns (address[20] memory) {
  		return adopters;
	}


}
