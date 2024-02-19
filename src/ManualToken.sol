// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ManualToken {

    // dodajemo mapping da bi skladistili i mapirali neciji balans
    // adresu skladistimo u uint256
    // ako ja imam 10 tokena moja adresa ce biti signovana na 10 tokena (my_address -> 10 tokens)
    mapping(address => uint256) private s_balance;

    // ovo su obavezne funkcije koje se mora nadju da bi nastao ERC20 token
    function name() public pure returns (string memory){
        return "Manual Token";
    }
    // kazemo da ovaj token je velik tj vredi 100 ethera
    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    // kazemo da ima 18 decimale zato sto 100 ethera je jednako 100 * e18
    function decimals() public pure returns (uint8){
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256){
        return s_balance[_owner];
    }
    function transfer(address _to, uint256 _value) public {
       uint256 previousBalance =  balanceOf(msg.sender) + balanceOf(_to);
       s_balance[msg.sender] -= _value;
       s_balance[_to] += _value;
       require(previousBalance == balanceOf(msg.sender) + balanceOf(_to));
    }
}

// ako oces manuelno da napravis token idi na ovaj sajt za requirements da vidis
// https://eips.ethereum.org/EIPS/eip-20