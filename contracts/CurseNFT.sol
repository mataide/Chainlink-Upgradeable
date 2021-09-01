// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "hardhat/console.sol";

interface KeeperCompatibleInterface {
    function checkUpkeep(bytes calldata checkData)
    external
    returns (bool upkeepNeeded, bytes memory performData);

    function performUpkeep(bytes calldata performData) external;
}

contract CurseNFT is Initializable, ERC721Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    using StringsUpgradeable for uint256;

    enum Status {
        Up1,            // 0
        Up2,            // 1
        Up5,            // 2
        Down1,          // 3
        Down2,          // 4
        Down5,          // 5
        twentyThousand  // 6
    }

    AggregatorV3Interface private priceFeed;
    Status private _status; // used for token URI
    string private _base;

    int256 public latestPrice;
    uint256 public latestDateChecked;

    int16 public trend; // consecutive days price appreciated/depreciated (unchanged if price remains same)

    function initialize(string memory baseURI, address priceFeedOracle) initializer public {
        __ERC721_init("CurseNFT", "NFT");
        __Ownable_init();
        __UUPSUpgradeable_init();

        priceFeed = AggregatorV3Interface(priceFeedOracle);
        (int256 price, uint256 timestamp) = _getLatestPrice();
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    function _getLatestPrice() private view returns (int256, uint256) {
        (
        uint80 roundID,
        int256 price,
        uint256 startedAt,
        uint256 timestamp,
        uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return (price, timestamp);
    }

    function checkUpkeep(bytes calldata checkData)
    external
    view
    returns (bool upkeepNeeded, bytes memory performData)
    {
        uint32 secondsInDay = 86_400;

        (, uint256 timestamp) = _getLatestPrice();

        timestamp >= latestDateChecked + secondsInDay
        ? upkeepNeeded = true
        : upkeepNeeded = false;
        performData = checkData;
    }

    function performUpkeep(bytes calldata performData) external {

    }
}
