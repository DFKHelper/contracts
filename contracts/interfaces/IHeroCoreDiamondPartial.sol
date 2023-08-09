// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IHeroCoreDiamondPartial {
  function transferHeroAndEquipmentFrom(address _from, address _newOwner, uint256 _heroId) external;
}
