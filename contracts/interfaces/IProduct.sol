pragma solidity ^0.4.24;


interface IProduct {

    // CreateProduct event
    event CreateProduct(uint256 id, string name, string extend, uint256 price, address creator);

    // EditProduct event
    event EditProduct(uint256 id, string name, string extend, uint256 price, address creator);

    // RemoveProduct event
    event RemoveProduct(uint256 id);

    // AddPaymentWay event
    event AddPayment(uint256 id, uint coinID, uint256 productID, uint256 price);

    // SetPaymentWayPrice event
    event SetPaymentWayPrice(uint256 id, uint256 price);

    // RemovePaymentWay event
    event RemovePaymentWay(uint256 id);

    /**
     * Create product, returns a generated product id.
     * Emits a {CreateProduct} event.
     */
    function createProduct(string name, string extend, uint256 price) external returns (uint256);

    /**
     * Edit Product
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
     * Get the name of a product
     */
    function getNameOfProduct(uint256 id) external view returns (string);

    /**
     * Get the extend information of a product
     */
    function getExtendOfProduct(uint256 id) external view returns (string);

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
    function setPaymentWayPrice(uint256 id, uint256 price) external;

    /**
     * Remove a payment.
     * Emits a {RemovePayment} event.
     */
    function removePaymentWayPrice(uint256 id) external;

    /**
     * List all payment's ID of a product
     */
    function listPaymentWaysOfProduct(uint256 productID) external view returns (uint256[]);

    /**
     * Get the ERC20 address of a payment.
     */
    function getPaymentWayAddressByID(uint256 id) external view returns (address);

    /**
     * Get the price of a payment
     */
    function getPaymentWayPriceByID(uint256 id) external view returns (uint256);

}
