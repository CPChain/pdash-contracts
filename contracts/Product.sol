pragma solidity ^0.4.24;

import "./lib/Ownable.sol";
import "./lib/set.sol";
import "./interfaces/IProduct.sol";
import "./interfaces/IProductManager.sol";

library Library {
  struct Data {
     string val;
     bool existed;
   }
}

contract Product is IProductManager, Ownable, IProduct {
    using Set for Set.Data;
    using Library for Library.Data;

    // coins
    struct Coin {
        uint id;
        address erc20;
        bool disabled;
    }
    uint private _coin_seq = 0;
    mapping(uint => Coin) _coins;
    Set.Data _coins_addr;

    // products
    struct ProductItem {
        uint256 id;
        string name;
        string extend;
        uint256 price; // CPC price
        address creator;
        string file_uri;
        string file_hash;
        bool removed;
        bool disabled;
        bool enabled_cpc; // If enable the CPC payment way
    }
    uint256 private _product_seq = 0;
    uint256 private _product_cnt = 0;
    mapping(uint256 => ProductItem) _products;
    mapping(string => bool) _product_names;
    mapping(string => Library.Data) _files; // file_uri => file_hash

    // Payment way of a products
    struct ProductPaymentWay {
        uint256 id;
        uint256 productID;
        uint coinID;
        uint256 price;
    }
    uint256 private _payment_ways_seq = 0;
    mapping(uint256 => ProductPaymentWay[]) _payment_ways; // product_id => Payments of this product
    uint payment_ways_limit; // The upper limit of payment ways' count

    constructor() public {}

    /**
     * Add new ERC20, returns a generated ID.
     * Emits a {AddNewERC20} event.
     */
    function addERC20(address erc20) external onlyOwner onlyEnabled returns (uint) {
        require(!_coins_addr.contains(erc20), "This ERC-20 already exists!");
        _coin_seq += 1;
        _coins_addr.insert(erc20);
        _coins[_coin_seq] = Coin({erc20: erc20, id: _coin_seq, disabled: false});
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
        require(_coins[id].id > 0, "This coin not exists");
        emit RemoveERC20(id, _coins[id].erc20);
        _coins_addr.remove(_coins[id].erc20);
        delete _coins[id];
    }

    /**
     * Disable a ERC20
     * Emits a {DisableERC20} event.
     */
    function disableERC20(uint id) external onlyOwner onlyEnabled {
        require(_coins[id].id > 0, "This coin not exists");
        require(!_coins[id].disabled, "This coin have been disabled");
        _coins[id].disabled = true;
        emit DisableERC20(id, _coins[id].erc20);
    }

    /**
     * Enable a ERC20
     * Emits a {EnableERC20} event.
     */
    function enableERC20(uint id) external onlyOwner onlyEnabled {
        require(_coins[id].id > 0, "This coin not exists");
        require(_coins[id].disabled, "This coin haven't been disabled");
        _coins[id].disabled = false;
        emit EnableERC20(id, _coins[id].erc20);
    }

    /**
     * Check if disabled
     */
    function isERC20Disabled(uint id) external view returns (bool) {
        return _coins[id].disabled;
    }

    /**
     * Disable product by admin
     * Emits a {AdminDisableProduct} event.
     */
    function disableProduct(uint256 id) external onlyOwner onlyEnabled {
        require(_products[id].id > 0, "This product not exists!");
        require(!_products[id].removed, "This product have been removed");
        require(!_products[id].disabled, "This product have been disabled");
        _products[id].disabled = true;
        emit AdminDisableProduct(id);
    }

    /**
     * Enable product by admin
     * Emits a {AdminEnableProduct} event.
     */
    function enableProduct(uint256 id) external onlyOwner onlyEnabled {
        require(_products[id].id > 0, "This product not exists!");
        require(!_products[id].removed, "This product have been removed");
        require(_products[id].disabled, "This product haven't been disabled");
        _products[id].disabled = false;
        emit AdminEnableProduct(id);
    }

    /**
     * Check if product have been disabled
     */
    function isProductDisabled(uint256 id) external view returns (bool) {
        return _products[id].disabled;
    }

    /**
     * Create product, returns a generated product id.
     * Emits a {CreateProduct} event.
     */
    function createProduct(string name, string extend, uint256 price, string file_uri, string file_hash) external onlyEnabled returns (uint256) {
        require(!_product_names[name], "This name already exists!");
        require(!_files[file_uri].existed, "This file_uri already exists!");
        _product_seq += 1;
        _product_names[name] = true;
        _products[_product_seq] = ProductItem({
            id: _product_seq,
            name: name,
            extend: extend,
            creator: msg.sender,
            file_uri: file_uri,
            file_hash: file_hash,
            price: price,
            disabled: false,
            enabled_cpc: true,
            removed: false
        });
        _product_cnt += 1;
        _files[file_uri] = Library.Data({val: file_hash, existed: true});
        emit CreateProduct(_product_seq, name, extend, price, msg.sender, file_uri, file_hash);
        return _product_seq;
    }

    function equals(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    /**
     * If the file exists
     */
    function isFileExists(string file_uri, string file_hash) external view returns (bool) {
        return _files[file_uri].existed && equals(_files[file_uri].val, file_hash);
    }

    /**
     * Edit Product
     * Emits a {EditProduct} event.
     */
    function editProduct(uint256 id, string name, string extend, uint256 price) external onlyEnabled {
        require(_products[id].id > 0, "This product not exists!");
        require(_products[id].creator == msg.sender, "You're not the creator of this product");
        require(!_products[id].removed, "This product have been removed");
        // if changed the product name
        if (!equals(_products[id].name, name)) {
            require(!_product_names[name], "This name already exists!");
        }
        delete _product_names[_products[id].name];
        _product_names[name] = true;
        _products[id].name = name;
        _products[id].extend = extend;
        _products[id].price = price;
        emit EditProduct(id, name, extend, price, msg.sender);
    }

    /**
     * Remove Product
     * Emits a {RemoveProduct} event.
     */
    function removeProduct(uint256 id) external onlyEnabled {
        require(_products[id].id > 0, "This product not exists!");
        require(_products[id].creator == msg.sender, "You're not the creator of this product");
        delete _product_names[_products[id].name];
        _products[id].removed = true;
        _product_cnt -= 1;
        emit RemoveProduct(id);
    }

    /**
     * Count of products
     */
    function countOfProducts() external view returns (uint256) {
        return _product_cnt;
    }

    /**
     * Get the name of a product
     */
    function getNameOfProduct(uint256 id) external view returns (string) {
        return _products[id].name;
    }

    /**
     * Get the extend information of a product
     */
    function getExtendOfProduct(uint256 id) external view returns (string) {
        return _products[id].extend;
    }

    /**
     * Get the price of a product
     */
    function getPriceOfProduct(uint256 id) external view returns (uint256) {
        return _products[id].price;
    }

    /**
     * Get file uri
     */
    function getFileUri(uint256 id) external view returns (string) {
        return _products[id].file_uri;
    }

    /**
     * Get file hash
     */
    function getFileHash(uint256 id) external view returns (string) {
        return _products[id].file_hash;
    }

    /**
     * Get the information of a product
     * Returns {name extend, price}
     */
    function getProduct(uint256 id) external view returns (string, string, uint256) {
        return (_products[id].name, _products[id].extend, _products[id].price);
    }

    /**
     * Add a payment method of Product
     * Emits a {AddPaymentWay} event.
     */
    function addPaymentWay(uint coinID, uint256 productID, uint256 price) external onlyEnabled returns (uint256) {
        require(_coins[coinID].id > 0, "This token not exists");
        require(!_coins[coinID].disabled, "This token have been disabled");
        require(_products[productID].id > 0, "This product not exists");
        require(!_products[productID].removed, "This product have been removed");
        require(!_products[productID].disabled, "This product have been disabled");
        ProductPaymentWay[] storage ways = _payment_ways[productID];
        for(uint i = 0; i < ways.length; i++) {
            require(ways[i].coinID != coinID, "This payment way exists!");
        }
        _payment_ways_seq += 1;
        _payment_ways[_payment_ways_seq].push(ProductPaymentWay({
            id: _payment_ways_seq,
            coinID: coinID,
            productID: productID,
            price: price
        }));
        emit AddPayment(_payment_ways_seq, coinID, productID, price);
    }

    /**
     * Set the price of a payment of a product
     * Emits a {SetPaymentWayPrice} event.
     */
    function setPaymentWayPrice(uint coinID, uint256 productID, uint256 price) external onlyEnabled {
        require(_coins[coinID].id > 0, "This token not exists");
        require(_products[productID].id > 0, "This product not exists");
        ProductPaymentWay[] storage ways = _payment_ways[productID];
        for(uint i = 0; i < ways.length; i++) {
            if(ways[i].coinID == coinID) {
                ways[i].price = price;
                emit SetPaymentWayPrice(coinID, productID, price);
                return;
            }
        }
    }

    /**
     * Remove a payment.
     * Emits a {RemovePayment} event.
     */
    function removePaymentWay(uint coinID, uint256 productID) external onlyEnabled {
        require(_coins[coinID].id > 0, "This token not exists");
        require(_products[productID].id > 0, "This product not exists");
        ProductPaymentWay[] storage ways = _payment_ways[productID];
        for(uint i = 0; i < ways.length; i++) {
            if(ways[i].coinID == coinID) {
                delete ways[i];
                emit RemovePaymentWay(coinID, productID);
                return;
            }
        }
        require(false, "Payment way not exists");
    }

    /**
     * Get price
     */
    function getPaymentWayPrice(uint coinID, uint256 productID) external view returns (uint256) {
        require(_coins[coinID].id > 0, "This token not exists");
        require(_products[productID].id > 0, "This product not exists");
        ProductPaymentWay[] storage ways = _payment_ways[productID];
        for(uint i = 0; i < ways.length; i++) {
            if(ways[i].coinID == coinID) {
                return ways[i].price;
            }
        }
    }
}