const Product = artifacts.require("Product");

contract("Product", (accounts) => {
  it("Product", async () => {
    const instance = await Product.deployed();
    console.log(accounts[0], await instance.owner())
  })
})
