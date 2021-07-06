pragma solidity ^0.4.24;

interface IProductManager {
    // AddNewERC20 event
    event AddNewERC20(uint id, address erc20);

    // RemoveERC20 event
    event RemoveERC20(uint id, address erc20);

    // DisableERC20 event
    event DisableERC20(uint id, address erc20);

    // EnableERC20 event
    event EnableERC20(uint id, address erc20);

    // AdminDisableProduct event
    event AdminDisableProduct(uint256 id);

    // AdminEnableProduct event
    event AdminEnableProduct(uint256 id);

    /**
     * Add new ERC20, returns a generated ID.
     * Emits a {AddNewERC20} event.
     */
    function addERC20(address erc20) external returns (uint);

    /**
     * Get ERC20 address by ID
     */
    function getERC20(uint id) external view returns (address);

    /**
     * Remove a ERC20
     * Emits a {RemoveERC20} event
     */
    function removeERC20(uint id) external; 

    /**
     * Disable a ERC20
     * Emits a {DisableERC20} event.
     */
    function disableERC20(uint id) external;

    /**
     * Enable a ERC20
     * Emits a {EnableERC20} event.
     */
    function enableERC20(uint id) external;

    /**
     * Check if disabled
     */
    function isERC20Disabled(uint id) external view returns (bool);

    /**
     * Disable product by admin
     * Emits a {AdminDisableProduct} event.
     */
    function disableProduct(uint256 id) external;

    /**
     * Enable product by admin
     * Emits a {AdminEnableProduct} event.
     */
    function EnableProduct(uint256 id) external;

}
