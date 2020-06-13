// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;

contract ProductManagement {
    struct part {
        string type_part;
        string serial_num;
        address owner;
        string time_stamp;
    }

    mapping(bytes32 => part) public parts;

    function buildpart(
        string memory SerialNumber,
        string memory part_type,
        string memory ProductionDate,
        address manufacturer
    ) public returns (bytes32) {
        //Owner ID initializes the part to be owned by factory
        //Part Factory = 1
        //Car Manufacturer = 2
        //Dealer = 3

        //to avoid excess memory we can make a new fucntion to concatenate strings or we can also have the frontend send concatenated strings.
         bytes memory string_to_hash = bytes(string(
            abi.encodePacked(
                SerialNumber,
                part_type,
                ProductionDate,
                msg.sender
            )
        ));
        bytes32 part_hash = keccak256(abi.encodePacked(string_to_hash));
        require(parts[part_hash].owner == address(0), "Part ID already In Chain");

        part memory new_part = part(
            part_type,
            SerialNumber,
            manufacturer,
            ProductionDate
        );
        parts[part_hash] = new_part;
        return part_hash;
    }

    struct product {
        string serial_num;
        string type_prod;
        string time_stamp;
        //assuming that a maximum of 4 parts can build a product, this value is changeable acc to req.
        bytes32[4] parts;
        address owner;
    }

    mapping(bytes32 => product) public products;

    //'contructor () public{} // we will initiazlize with our own data
    function getParts(bytes32 product_hash) public returns (bytes32[4] memory) {
        //The automatic getter does not return arrays, so lets create a function for that
        require(
            products[product_hash].owner != address(0),
            "Product inexistent"
        );
        return products[product_hash].parts;
    }

    function buildProduct(
        string memory SerialNumber,
        string memory product_type,
        string memory ProductionDate,
        bytes32[4] memory PartsUsed
    ) public returns (bytes32) {
        //Check if all the parts exist, hash values and add to product mapping.
        uint256 count;
        for (count = 0; count < PartsUsed.length; count++) {
            require(
                parts[PartsUsed[count]].owner != address(0),
                "Inexistent part used on product"
            );
        }

        //Create hash for data and check if exists. If it doesn't, create the part and return the ID to the user
        bytes memory string_to_hash = bytes(string(
            abi.encodePacked(
                SerialNumber,
                product_type,
                ProductionDate,
                msg.sender
            )
        ));
        bytes32 product_hash = keccak256(abi.encodePacked(string_to_hash));
        require(
            products[product_hash].owner == address(0),
            "Product ID already used"
        );

        product memory new_product = product(
            SerialNumber,
            product_type,
            ProductionDate,
            PartsUsed,
            msg.sender
        );
        products[product_hash] = new_product;
        return product_hash;
    }
}
