pragma solidity ^0.5.0;

contract Adoption {
	address[total-adopters] public adopters;

	function isExisting(uint petId) public view returns (bool) {
				 require(petId >= 0 && petId <= total-one);
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
		require(petId >= 0 && petId <= total-one);
		if(adopters[petId] == address(0)) {
			adopters[petId] = msg.sender;
			return true;
		}else {
			return false;
		}
	}

	// Retrieving the adopters
	function getAdopters() public view returns (address[total-adopters] memory) {
  		return adopters;
	}


}
