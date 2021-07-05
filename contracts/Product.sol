pragma solidity ^0.4.24;

import "./lib/Ownable.sol";
import "./lib/set.sol";
import "./interfaces/IProduct.sol";
import "./interfaces/IProductManager.sol";

contract Product is IProductManager, Ownable{
    using Set for Set.Data;

    // coins
    struct Coin {
        address erc20;
        uint id;
        bool removed;
        bool existed;
        bool disabled;
    }
    uint private _coin_seq = 0;
    mapping(uint => Coin) _coins;
    Set.Data _coins_addr;

    // products

    constructor() public {}

    /**
     * Add new ERC20, returns a generated ID.
     * Emits a {AddNewERC20} event.
     */
    function addERC20(address erc20) external onlyOwner onlyEnabled returns (uint) {
        require(!_coins_addr.contains(erc20), "This ERC-20 already exists!");
        _coin_seq += 1;
        _coins_addr.insert(erc20);
        _coins[_coin_seq] = Coin({erc20: erc20, id: _coin_seq, removed: false, existed: true, disabled: false});
        emit AddNewERC20(_coin_seq, erc20);
        return 0;
    }

    /**
     * Get ERC20 address by ID
     */
    function getERC20(uint id) external view returns (address) {
        return _coins[id].erc20;
    }

    /**
     * Remove a ERC20
     * Emits a {RemoveERC20} event
     */
    function removeERC20(uint id) external onlyOwner onlyEnabled {
        require(_coins[id].existed, "This coin not exists");
        require(!_coins[id].removed, "This coin have been removed");
        _coins[id].removed = true;
        emit RemoveERC20(id, _coins[id].erc20);
    }

    /**
     * Disable a ERC20
     * Emits a {DisableERC20} event.
     */
    function disableERC20(uint id) external onlyOwner onlyEnabled {
        require(_coins[id].existed, "This coin not exists");
        require(!_coins[id].removed, "This coin have been removed");
        require(!_coins[id].disabled, "This coin have been disabled");
        _coins[id].disabled = true;
        emit DisableERC20(id, _coins[id].erc20);
    }

    /**
     * Enable a ERC20
     * Emits a {EnableERC20} event.
     */
    function enableERC20(uint id) external onlyOwner onlyEnabled {
        require(_coins[id].existed, "This coin not exists");
        require(!_coins[id].removed, "This coin have been removed");
        require(_coins[id].disabled, "This coin haven't been disabled");
        _coins[id].disabled = false;
        emit EnableERC20(id, _coins[id].erc20);
    }

    /**
     * Disable product by admin
     * Emits a {AdminDisableProduct} event.
     */
    function disableProduct(uint256 id) external onlyOwner onlyEnabled {

    }
}