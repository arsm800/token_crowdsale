pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        // Fill in the constructor parameters!
        uint rate,
        address payable wallet,
        PupperCoin token,
        uint goal,
        uint cap,
        uint openingTime,
        uint closingTime
    )
    
        MintedCrowdsale()
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
        RefundablePostDeliveryCrowdsale()
        
        // Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate, wallet, token)
        public
    {
        // constructor can stay empty
    }
    
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        //Fill in the constructor parameters
        string memory name,
        string memory symbol,
        address payable wallet //will receive ETH raised by sale
        
    )
        public
    {
        //create the PupperCoin and keep its address handy
       PupperCoin token = new PupperCoin(name, symbol, 0);
       token_address = address(token);

        //create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale PupperCoin_sale = new PupperCoinSale(1, wallet, token);
        //How does it know to expect 7 arguments?
        token_sale_address = address(PupperCoin_sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
