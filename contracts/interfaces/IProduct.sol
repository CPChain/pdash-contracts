pragma solidity ^0.4.24;


interface IProduct {

    // CreateProduct event
    event CreateProduct(uint256 id, string name, string extend, uint256 price, address creator, string file_uri, string file_hash);

    // EditProduct event
    event EditProduct(uint256 id, string name, string extend, uint256 price, address creator);

    // RemoveProduct event
    event RemoveProduct(uint256 id);

    // AddPaymentWay event
    event AddPayment(uint256 id, uint coinID, uint256 productID, uint256 price);

    // SetPaymentWayPrice event
    event SetPaymentWayPrice(uint coinID, uint256 productID, uint256 price);

    // RemovePaymentWay event
    event RemovePaymentWay(uint coinID, uint256 productID);

    /**
     * Create product, returns a generated product id.
     * Emits a {CreateProduct} event.
     */
    function createProduct(string name, string extend, uint256 price, string file_uri, string file_hash) external returns (uint256);

    /**
     * If the file exists
     */
    function isFileHashExists(string file_uri, string file_hash) external view returns (bool);

    /**
     * Edit Product, but can not update the file_uri and file_hash
     * Emits a {EditProduct} event.
     */
    function editProduct(uint256 id, string name, string extend, uint256 price) external;

    /**
     * Remove Product
     * Emits a {RemoveProduct} event.
     */
    function removeProduct(uint256 id) external;

    /**
     * Count of products
     */
    function countOfProducts() external view returns (uint256);

    /**
     * Get the information of a product
     * Returns {name extend, price}
     */
    function getProduct(uint256 id) external view returns (string, string, uint256);

    /**
     * Get the name of a product
     */
    function getNameOfProduct(uint256 id) external view returns (string);

    /**
     * Get the extend information of a product
     */
    function getExtendOfProduct(uint256 id) external view returns (string);

    /**
     * Get file uri
     */
    function getFileUri(uint256 id) external view returns (string);

    /**
     * Get file hash
     */
    function getFileHash(uint256 id) external view returns (string);

    /**
     * Check if product have been disabled
     */
    function isProductDisabled(uint256 id) external view returns (bool);

    /**
     * Get the price of a product
     */
    function getPriceOfProduct(uint256 id) external view returns (uint256);

    /**
     * Add a payment method of Product
     * Emits a {AddPaymentWay} event.
     */
    function addPaymentWay(uint coinID, uint256 productID, uint256 price) external returns (uint256);

    /**
     * Set the price of a payment of a product
     * Emits a {SetPaymentWayPrice} event.
     */
    function setPaymentWayPrice(uint coinID, uint256 productID, uint256 price) external;

    /**
     * Remove a payment.
     * Emits a {RemovePayment} event.
     */
    function removePaymentWay(uint coinID, uint256 productID) external;

    /**
     * Get price
     */
    function getPaymentWayPrice(uint coinID, uint256 productID) external view returns (uint256);
}
