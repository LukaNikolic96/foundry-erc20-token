// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "lib/forge-std/src/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    // dodajemo ourtoken i deployourtoken contracte koje cemo da iskoristimo u setup
    OurToken public ourToken;
    DeployOurToken public deployer;

    // fejk adrese koje koristimo za testiranje
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    // pocetni balans
    uint256 public constant STARTING_BALANCE = 100 ether;

    // uvek prvo pisemo setup od nje krecu testovi
    function setUp() public {
        // kreiramo novu instancu deploy contracta
        deployer = new DeployOurToken();
        // zatim uz nas token pokrecemo deploy contract
        ourToken = deployer.run();

        // prenkujemo ownera tj da dajemo pocetni balans nekoj adresi(bobu u ovom slucaju)
        vm.prank(msg.sender);
        // nas ourtoken contract salje adresi bob pocetni balans koji smo vec odredili
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    // testiramo dal se poklapa vrednost pocetnog balansa s vrednost balansa na adresi bob
    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    // tetiramo funkciju koja dozvoljava prenos(manipulaciju) tokena uz nasu dozvolu
    // to uglavnom radimo ako ocemo da contract keep track of how much tokens is sent npr
    function testAllownacesWorks() public {
        // dozvoljena suma za prenosenje
        uint256 initialAllowance = 1000;

        // bob approvojue (dozvoljava) alice da prenosi tokene
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        // kolicina koju bi alice htela da prenese
        uint256 requestAmout = 500;

        // posto je dobila dozvolu alice prenosi tokene sa bobove adrese na alice adresu
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, requestAmout);
        /* ne koristimo obicnu transfer funkciju jer ko poziva tu funkciju automatski je onaj koji salje
        npr ako stavimo alice i request amount to je kao da ona sama sebi salje , dok u transferfrom
        kaze moze da pozove to bilo ko koje odobren*/

        // proveravamo da li je balans adrese alice isti sa vrednosti kolicine u zahtevu prenosenja
        assertEq(ourToken.balanceOf(alice), requestAmout);
        // proveravamo stanje bobovog racuna da li je isti kad od pocetnog balansa koji je dobio u setup
        // oduzmemo kolicinu koju bi alice htela da prenese
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - requestAmout);
    }
    function testApproveAndAllowance() public {
   uint256 approveAmount = 100;
   address spender = address(this);
   
   vm.prank(msg.sender);
   // Approve 'spender' to spend 'approveAmount' on behalf of msg.sender
   ourToken.approve(spender, approveAmount);

   // Check allowance
   assertEq(ourToken.allowance(msg.sender, spender), approveAmount);
}
function testTransferr() public {
  uint256 transferAmount = 50;
  address recipient = address(this);

 

  // Print balances before transfer
  console.log("Sender balance before transfer: ", ourToken.balanceOf(msg.sender));
  console.log("Recipient balance before transfer: ", ourToken.balanceOf(recipient));
    vm.prank(bob);
  // Transfer 'transferAmount' tokens to 'recipient'
  ourToken.transfer(recipient, transferAmount);

  // Print balances after transfer
  console.log("Sender balance after transfer: ", ourToken.balanceOf(msg.sender));
  console.log("Recipient balance after transfer: ", ourToken.balanceOf(recipient));

  // Check balance of sender and recipient
  assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
  assertEq(ourToken.balanceOf(recipient), transferAmount);
}

function testTransferFrom() public {
   uint256 transferAmount = 50;
   address recipient = address(this);

    vm.prank(bob);
   // Approve 'recipient' to spend 'transferAmount' on behalf of 'sender'
   ourToken.approve(recipient, transferAmount);

   // Transfer 'transferAmount' tokens from 'sender' to 'recipient'
   ourToken.transferFrom(bob, recipient, transferAmount);

   // Check balance of sender and recipient
   assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
   assertEq(ourToken.balanceOf(recipient), transferAmount);
}



}
