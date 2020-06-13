import { init_web3, getOwnedItemsFromEvent, dealerPartListManager, dealerProductListManager, addItemToList } from "./utils.js";

window.onload = async function () {

    var x = await init_web3()
    //First, get all the parts and products that belong to this dealer
    getOwnedItemsFromEvent(window.accounts[0], 'TransferOwnership_part').then((parts) => {
        console.log("part Events")
        console.log(parts)
        for (var i = 0; i < parts.length; i++) {
            addItemToList(parts[i], "parts-history", dealerPartListManager);
        }
    })

    //Then, get products
    getOwnedItemsFromEvent(window.accounts[0], 'TransferOwnership_product').then((products) => {
        console.log("prod Events");
        console.log(products);
        for (var i = 0; i < products.length; i++) {
            addItemToList(products[i], "car-history", dealerProductListManager);
        }
    })

    document.getElementById("get-history").addEventListener("click", function () {
        console.log("Get Car History")
        var addr = document.getElementById("part-addr").value;
        if (addr != "") {
            addItemToList(addr, "car-part-list", carPartListManager);
        }
    })
}