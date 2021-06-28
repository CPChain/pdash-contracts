pragma solidity ^0.4.24;

import "./lib/Ownable.sol";
import "./interfaces/IProduct.sol";
import "./interfaces/IProductManager.sol";

contract Product is IProductManager, Ownable{
    
    constructor() public {
        
    }

    /**
     * Add new ERC20, returns a generated ID.
     * Emits a {AddNewERC20} event.
     */
    function addERC20(address erc20) external returns (uint) {
        return 0;
    }

    /**
     * Get ERC20 address by ID
     */
    function getERC20(uint id) external view returns (address) {
        return 0x00;
    }

    /**
     * Remove a ERC20
     * Emits a {RemoveERC20} event
     */
    function removeERC20(uint id) external {
    }

    /**
     * Disable a ERC20
     * Emits a {DisableERC20} event.
     */
    function disableERC20(uint id) external {
    }

    /**
     * Enable a ERC20
     * Emits a {EnableERC20} event.
     */
    function enableERC20(uint id) external {
    }

    /**
     * Disable product by admin
     * Emits a {AdminDisableProduct} event.
     */
    function disableProduct(uint256 id) external {
    }
}